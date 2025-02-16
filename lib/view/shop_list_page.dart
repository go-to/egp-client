import 'dart:async';
import 'dart:core';
import 'dart:ui' as ui;

import 'package:egp_client/grpc_gen/egp.pb.dart';
import 'package:egp_client/provider/search_condition_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../const/config.dart';
import '../provider/marker_provider.dart';
import '../provider/shop_provider.dart';
import '../service/auth_service.dart';
import '../view/shop_detail_page.dart';

class CustomMarker {
  final String id;
  final int no;
  final CategoryType categoryId;
  final LatLng position;
  final double zIndex;
  final bool inCurrentSales;
  final bool isStamped;
  final bool isIrregularHoliday;
  final bool needsReservation;
  final String imageUrl;
  BitmapDescriptor? icon;

  CustomMarker({
    required this.id,
    required this.no,
    required this.categoryId,
    required this.position,
    required this.zIndex,
    required this.inCurrentSales,
    required this.isStamped,
    required this.isIrregularHoliday,
    required this.needsReservation,
    required this.imageUrl,
    this.icon,
  });
}

class ShopListPage extends ConsumerStatefulWidget {
  const ShopListPage({super.key});

  @override
  ConsumerState<ShopListPage> createState() => _ShopListPageState();
}

class _ShopListPageState extends ConsumerState<ShopListPage> {
  bool _locationPermissionGranted = false;
  bool _mapCreated = false;
  late GoogleMapController _mapController;
  late StreamSubscription<Position>? _positionStream;
  late Map<String, Marker> _markers;
  late List<CustomMarker> _customMarkers;
  Position? currentPosition;

  final _pageController = PageController(
    viewportFraction: 0.85,
  );

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: Config.locationDistanceFilter,
  );

  // 初期位置
  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(Config.defaultMapLatitude, Config.defaultMapLongitude),
    zoom: Config.defaultMapZoom,
  );

  // 店舗の営業中か否かを識別するためのアイコン
  final shopDefaultIcon = AssetMapBitmap(
    Config.shopDefaultImagePath,
    width: Config.shopImageWidth,
    height: Config.shopImageHeight,
  );
  final shopOpenIcon = AssetMapBitmap(
    Config.shopOpenImagePath,
    width: Config.shopImageWidth,
    height: Config.shopImageHeight,
  );
  final shopCloseIcon = AssetMapBitmap(
    Config.shopCloseImagePath,
    width: Config.shopImageWidth,
    height: Config.shopImageHeight,
  );
  final shopSelectedIcon = AssetMapBitmap(
    Config.shopSelectedImagePath,
    width: Config.shopSelectedImageWidth,
    height: Config.shopSelectedImageHeight,
  );

  @override
  void initState() {
    super.initState();
    _startPositionStream();
    _markers = {};
    _customMarkers = [];
    _loadMarkers();
  }

  void _loadMarkers() async {
    final shops = await ref.read(shopProvider.notifier).getShops();
    if (shops != null) {
      _setMarkers(shops);
    }
  }

  void _setMarkers(ShopsResponse shops) async {
    resetCustomMarkers();
    for (var shop in shops.shops) {
      _customMarkers.add(
        CustomMarker(
          id: shop.iD.toString(),
          no: shop.no,
          categoryId: shop.categoryID,
          position: LatLng(shop.latitude, shop.longitude),
          zIndex: 0.0,
          inCurrentSales: shop.inCurrentSales,
          isStamped: shop.isStamped,
          isIrregularHoliday: shop.isIrregularHoliday,
          needsReservation: shop.normalizedNeedsReservation,
          imageUrl: shop.menuImageUrl,
          icon: shopDefaultIcon,
        ),
      );
    }
    _updateMarkers();
  }

  void _updateMarkers() {
    setState(() {
      _markers = Map.fromEntries(_customMarkers.map((customMarker) {
        return MapEntry(
          customMarker.id,
          Marker(
            markerId: MarkerId(customMarker.id),
            position: customMarker.position,
            icon: customMarker.icon ?? BitmapDescriptor.defaultMarker,
          ),
        );
      }));
    });
  }

  Future<void> _loadCustomIcons([MarkerId? selectedMarkerId]) async {
    List<Future<MapEntry<String, Marker>>> futures = _customMarkers
        .map((marker) => _createCustomMarker(marker, selectedMarkerId)
            .then((m) => MapEntry(marker.id, m)))
        .toList();

    List<MapEntry<String, Marker>> markerEntries = await Future.wait(futures);

    setState(() {
      _markers = Map.fromEntries(markerEntries);
    });
  }

  Future<Marker> _createCustomMarker(CustomMarker marker,
      [MarkerId? selectedMarkerId]) async {
    double zIndex = marker.inCurrentSales ? 2.0 : 1.0;
    if (selectedMarkerId != null && selectedMarkerId.value == marker.id) {
      zIndex = 3.0;
    } else if (marker.isStamped) {
      zIndex = 0.0;
    }
    final icon = await _createCustomMarkerBitmap(marker, selectedMarkerId);
    return Marker(
      markerId: MarkerId(marker.id),
      position: marker.position,
      icon: icon,
      zIndex: zIndex,
      onTap: () {
        final markerId = MarkerId(marker.id);
        ref.read(selectedMarkerProvider.notifier).selectMarker(markerId);
        _loadCustomIcons(markerId);
      },
    );
  }

  Future<BitmapDescriptor> _createCustomMarkerBitmap(CustomMarker marker,
      [MarkerId? selectedMarkerId]) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    // 各種変数定義（デフォルトは営業時間外）
    double fontSize = 14;
    double size = 50;
    String iconPath = Config.shopOpenImagePath;
    String textLabel = Config.notInCurrentSalesText;
    Color textColor = Colors.white;
    int displayTextPositionCoefficient = 16; // テキスト表示位置調整用の係数
    var isStampedIconPath = Config.isStampedImagePath;
    // 店舗選択時の拡大表示
    if (selectedMarkerId != null && selectedMarkerId.value == marker.id) {
      size = 80;
      iconPath = Config.shopSelectedImagePath;
      isStampedIconPath = Config.isStampedSelectedImagePath;
      fontSize = 22;
      displayTextPositionCoefficient = 26;
      // 営業時間内
      if (marker.inCurrentSales) {
        textColor = Colors.black;
        // 不定休
        if (marker.isIrregularHoliday) {
          textLabel = Config.irregularHoliday;
          // 要予約
        } else if (marker.needsReservation) {
          textLabel = Config.needsReservation;
        }
      }
      // 営業時間内
    } else if (marker.inCurrentSales) {
      textColor = Colors.black;
      // 不定休
      if (marker.isIrregularHoliday) {
        textLabel = Config.irregularHoliday;
        // 要予約
      } else if (marker.needsReservation) {
        textLabel = Config.needsReservation;
      }
    }

    // 背景の円を描画
    final bgPaint = Paint()..color = Color(0xFFF3EEDA).withAlpha(200);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, bgPaint);

    // アセットから画像を読み込み
    final ByteData data = await rootBundle.load(iconPath);
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ui.Image image = fi.image;

    // 画像をそのまま描画
    canvas.drawImage(image,
        Offset((size - image.width) / 2, (size - image.height) / 2), Paint());

    // 背景の円を描画（暗くする用）
    if (marker.isStamped) {
      final bgPaint2 = Paint()
        ..color = Color(0xFFF3EEDA).withAlpha(200).withAlpha(255);
      canvas.drawCircle(Offset(size / 2, size / 2), size / 2, bgPaint2);
    } else if (!marker.inCurrentSales) {
      final bgPaint3 = Paint()..color = Colors.black.withAlpha(150);
      canvas.drawCircle(Offset(size / 2, size / 2), size / 2, bgPaint3);
    }

    // スタンプ獲得済み
    if (marker.isStamped) {
      final ByteData isStampedData = await rootBundle.load(isStampedIconPath);
      final Uint8List isStampedBytes = isStampedData.buffer.asUint8List();
      final ui.Codec isStampedCodec =
          await ui.instantiateImageCodec(isStampedBytes);
      final ui.FrameInfo isStampedFi = await isStampedCodec.getNextFrame();
      final ui.Image isStampedImage = isStampedFi.image;

      final imageSize = size;
      final imageOffset = Offset(0, 0);
      final imageRect =
          Rect.fromLTWH(imageOffset.dx, imageOffset.dy, imageSize, imageSize);
      canvas.drawImageRect(
          isStampedImage,
          Rect.fromLTWH(0, 0, isStampedImage.width.toDouble(),
              isStampedImage.height.toDouble()),
          imageRect,
          Paint());
    } else {
      // 店舗No.を描画
      final textPainterNo = TextPainter(
        text: TextSpan(
          text: marker.no.toString(),
          style: TextStyle(
            color: textColor,
            fontSize: fontSize * 0.8,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainterNo.layout();
      textPainterNo.paint(
        canvas,
        Offset(size / 2 - textPainterNo.width / 2,
            size / 8 - (textPainterNo.height) / 8),
      );

      // 通常営業以外の場合は情報を描画
      if (!marker.inCurrentSales ||
          marker.isIrregularHoliday ||
          marker.needsReservation) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: textLabel,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(size / 2 - textPainter.width / 2,
              size - textPainter.height - displayTextPositionCoefficient),
        );
      }
    }

    // 枠線にカテゴリの色を表示
    Color borderColor = Colors.black;
    switch (marker.categoryId) {
      case CategoryType.CATEGORY_TYPE_BEER_COCKTAIL:
        borderColor = Color(0xFF494967);
        break;
      case CategoryType.CATEGORY_TYPE_EBISU_1:
        borderColor = Color(0xFF7456D9);
        break;
      case CategoryType.CATEGORY_TYPE_EBISU_2:
        borderColor = Color(0xFF8BC0F0);
        break;
      case CategoryType.CATEGORY_TYPE_EBISU_SOUTH:
        borderColor = Color(0xFFD59B60);
        break;
      case CategoryType.CATEGORY_TYPE_EBISU_WEST:
        borderColor = Color(0xFFF0E157);
        break;
      case CategoryType.CATEGORY_TYPE_NONE:
        borderColor = Color(0xFF454545);
        break;
    }
    // 枠線を描画
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2 - 1.5, borderPaint);

    final img = await pictureRecorder
        .endRecording()
        .toImage(size.toInt(), size.toInt());
    final data2 = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(data2!.buffer.asUint8List());
  }

  void updateMarkerIcon(
      CustomMarker marker, BitmapDescriptor newIcon, double newZIndex) {
    if (_markers.containsKey(marker.id)) {
      setState(() {
        _markers[marker.id] = _markers[marker.id]!.copyWith(
          iconParam: newIcon,
          zIndexParam: newZIndex,
          onTapParam: () {
            final markerId = MarkerId(marker.id);
            ref.read(selectedMarkerProvider.notifier).selectMarker(markerId);
            _loadCustomIcons(markerId);
          },
        );
      });
    }
  }

  void resetCustomMarkers() {
    setState(() {
      _customMarkers = [];
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _pageController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  // 現在地ストリームを開始
  void _startPositionStream() async {
    final permissionGranted = await _checkLocationPermission();
    if (!permissionGranted) return;

    // 権限が許可された場合にGoogleMapを再ビルド
    if (permissionGranted) {
      setState(() {
        _locationPermissionGranted = true;
      });
      _positionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen(
        (Position position) {
          // カメラを現在地に移動
          if (!_mapCreated) {
            CircularProgressIndicator();
          } else {
            _mapController.animateCamera(
              CameraUpdate.newLatLng(_kGooglePlex.target),
            );
          }
          setState(() {});
        },
        onError: (e) {
          print('位置情報取得エラー: $e');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // マーカーリストを取得
    final selectedMarkerId = ref.watch(selectedMarkerProvider);
    // 選択中のマーカーID
    final shopListAsync = ref.watch(shopProvider);
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // マップ表示
        shopListAsync.when(
          data: (shops) {
            if (_locationPermissionGranted) {
              return Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                      _loadCustomIcons(selectedMarkerId);
                      setState(() {
                        _mapCreated = true;
                      });
                    },
                    onTap: (LatLng position) async {
                      ref
                          .read(selectedMarkerProvider.notifier)
                          .clearSelection();
                      _loadCustomIcons();
                    },
                    markers: Set<Marker>.of(_markers.values),
                  ),
                  if (!_mapCreated)
                    const Center(child: CircularProgressIndicator()),
                ],
              );
            } else {
              return Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final permissionGranted = await _checkLocationPermission();

                    // 権限が許可された場合にGoogleMapを再ビルド
                    if (permissionGranted) {
                      setState(() {
                        _locationPermissionGranted = true;
                      });
                    }
                  },
                  child: Text('位置情報を許可する'),
                ),
              );
            }
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object error, StackTrace stackTrace) => Center(
            child: Text('Error: $error'),
          ),
        ),

        // 検索条件
        shopListAsync.when(
          data: (shops) {
            final searchCondition = ref.watch(searchConditionProvider);
            final searchItemList =
                ref.read(searchConditionProvider.notifier).getSearchItemList();
            return Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 8.0,
                    runSpacing: 0.0,
                    children: [
                      for (final MapEntry(:key, :value)
                          in searchItemList.entries) ...{
                        _buildSearchTypeButton(
                            ref, key, value, searchCondition),
                      },
                    ],
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object error, StackTrace stackTrace) => Center(
            child: Text('Error: $error'),
          ),
        ),

        // カード表示
        shopListAsync.when(
          data: (shops) {
            if (_locationPermissionGranted) {
              // マーカー未選択の場合は非表示
              if (selectedMarkerId == null) {
                return const SizedBox.shrink();
              }

              // 選択中のマーカーに該当するIndexを取得
              final selectedIndex = _markers.values
                  .toList()
                  .indexWhere((m) => m.markerId == selectedMarkerId);
              if (selectedIndex != -1) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // PageViewがビルドされた後にジャンプ
                  if (_pageController.hasClients) {
                    _pageController.jumpToPage(selectedIndex);
                  }
                });
              }

              return Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                height: 160,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _markers.length,
                  onPageChanged: (index) async {
                    final markerId = _markers.values.toList()[index].markerId;
                    if (index != selectedIndex) {
                      // 選択状態のマーカーを更新
                      ref
                          .read(selectedMarkerProvider.notifier)
                          .selectMarker(markerId);
                      // 選択した店舗のマーカーを変更
                      _loadCustomIcons(markerId);
                    }
                    //スワイプ後のお店の座標までカメラを移動
                    final shop = shops!.shops[index];
                    _mapController.animateCamera(CameraUpdate.newLatLng(
                        LatLng(shop.latitude, shop.longitude)));
                  },
                  itemBuilder: (context, index) {
                    final shop = shops!.shops[index];
                    final attributes = {
                      'メニュー名': shop.menuName,
                      '住所': shop.address,
                      '提供時間': shop.businessHours,
                    };
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                final shop = shops.shops.elementAt(index);
                                return ShopDetailPage(
                                    year: shop.year,
                                    no: shop.no,
                                    shopName: shop.shopName,
                                    address: shop.address);
                              },
                            ),
                          );
                        },
                        child: Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  '${shop.no}: ${shop.shopName}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 8),
                                  Expanded(
                                    flex: 1,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 100,
                                        maxHeight: 100,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          shop.menuImageUrl,
                                          fit: BoxFit.contain,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Icon(Icons.error);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children:
                                            attributes.entries.map((entry) {
                                          return Padding(
                                            padding: EdgeInsets.only(bottom: 4),
                                            child: Text(
                                              '${entry.key}: ${entry.value}',
                                              // style: TextStyle(fontSize: 14),
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ));
                  },
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object error, StackTrace stackTrace) => Center(
            child: Text('Error: $error'),
          ),
        ),

        // 現在地ボタン
        _locationPermissionGranted
            ? Positioned(
                right: Config.currentPositionButtonPositionRight,
                bottom: Config.currentPositionButtonPositionBottom,
                child: _goToCurrentPositionButton(),
              )
            : Container(),
      ],
    );
  }

  // 検索条件更新Widget
  Widget _buildSearchTypeButton(
      WidgetRef ref, int searchKey, String label, Set<int> selectedKeys) {
    return ElevatedButton(
      onPressed: () async {
        // ボタンの状態を更新
        final searchCondition = ref
            .read(searchConditionProvider.notifier)
            .setSearchCondition(searchKey);
        // 店舗情報を取得
        final shops =
            await ref.read(shopProvider.notifier).getShops(searchCondition);
        if (shops != null) {
          // マーカー情報を更新
          Future.sync(() => _setMarkers(shops));
          final selectedMarkerId =
              ref.read(selectedMarkerProvider.notifier).getSelectedMarker();
          _loadCustomIcons(selectedMarkerId);
        }
        // マーカーの選択状態を解除
        ref.read(selectedMarkerProvider.notifier).clearSelection();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            selectedKeys.contains(searchKey) ? Colors.yellow : null,
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight:
                  selectedKeys.contains(searchKey) ? FontWeight.bold : null)),
    );
  }

  // 現在値ボタンWidget
  Widget _goToCurrentPositionButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(Config.currentPositionButtonWidth,
            Config.currentPositionButtonHeight),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: const CircleBorder(),
      ),
      onPressed: () async {
        final permissionGranted = await _checkLocationPermission();
        if (!permissionGranted) return;

        // 権限が許可された場合にGoogleMapを再ビルド
        if (permissionGranted) {
          setState(() {
            _locationPermissionGranted = true;
          });
        }

        // 現在位置に移動
        final position = await Geolocator.getCurrentPosition(
            locationSettings: locationSettings);
        final currentLatLng = LatLng(position.latitude, position.longitude);
        _mapController.animateCamera(
          CameraUpdate.newLatLngZoom(currentLatLng, Config.defaultMapZoom),
        );
      },
      child: const Icon(Icons.my_location_outlined),
    );
  }

  // 位置情報の権限を確認
  Future<bool> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 位置情報サービスが有効か確認
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('位置情報サービスを有効にしてください。')),
      );
      return false;
    }

    // 位置情報の権限を確認
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('位置情報の権限が拒否されました。')),
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('位置情報の権限が永久に拒否されています。')),
      );
      return false;
    }

    return true;
  }
}
