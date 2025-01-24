import 'package:egp_client/grpc_gen/egp.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../const/config.dart';
import '../service/grpc_service.dart';
import '../widget/shop_marker_widget.dart';

final markerProvider =
    StateNotifierProvider<MarkerNotifier, Map<String, Marker>>((ref) {
  return MarkerNotifier();
});

class MarkerNotifier extends StateNotifier<Map<String, Marker>> {
  MarkerNotifier() : super({});

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

  Future<ShopsResponse?> getShops() async {
    // 店舗情報を取得
    final channel = GrpcService.getChannel();
    ShopsResponse? shops;
    try {
      shops = await GrpcService.getShops();
    } catch (e) {
      print('Caught error: $e');
      return null;
    } finally {
      channel.shutdown();
    }

    return shops;
  }

  // マーカーを設定
  Future<void> setMarker(PageController pageController, Map<String, Shop> shops,
      String shopId, LatLng position, BitmapDescriptor icon, int zIndex) async {
    final marker = Marker(
      markerId: MarkerId(shopId),
      position: position,
      onTap: () {
        // タップしたマーカー(shop)のindexを取得
        final index = shops.values
            .toList()
            .indexWhere((shop) => shop.iD.toString() == shopId);
        // タップしたお店がPageViewで表示されるように飛ばす
        pageController.jumpToPage(index);
        // 店舗情報を更新
        updateMarkers(pageController, shops, shopId);
      },
      // 営業時間中か否かによって表示するアイコンを変える
      icon: icon,
      zIndex: zIndex.toDouble(),
    );
    state[shopId] = marker;
    state = {...state};
  }

  // 並列処理でデフォルトのマーカーを設定
  void addDefaultMarkers(
      PageController pageController, Map<String, Shop> shops) {
    Future(() async {
      // TODO シンプルなマーカーにする
      Map<String, Shop> adjustedShops = {};
      var latLonList = [];
      await Future.wait(shops.values.map((shop) async {
        var shopId = shop.iD.toString();
        var latitude = shop.latitude;
        var longitude = shop.longitude;
        var latLon = latitude.toString() + longitude.toString();
        // 緯度経度が同じ場合は、重なり防止のためにマーカーの位置をずらす
        if (latLonList.contains(latLon)) {
          latitude = latitude + Config.latitudeAdjustValue;
          longitude = longitude + Config.longitudeAdjustValue;
          latLon = latitude.toString() + longitude.toString();
        }
        latLonList.add(latLon);
        adjustedShops[shopId] = shop;
        adjustedShops[shopId]!.latitude = latitude;
        adjustedShops[shopId]!.longitude = longitude;

        var position = LatLng(latitude, longitude);
        var icon = shop.inCurrentSales ? shopOpenIcon : shopCloseIcon;
        var zIndex = shop.inCurrentSales ? 1 : 0;

        Future.delayed(Duration(seconds: 0), () async {
          await setMarker(
              pageController, adjustedShops, shopId, position, icon, zIndex);
        });
      }));
    });
  }

  // 並列処理で動的マーカーを追加
  void updateMarkers(PageController pageController, Map<String, Shop> shops,
      [String? activeShopId]) {
    Future(() async {
      Map<String, Shop> adjustedShops = {};
      var latLonList = [];
      await Future.wait(shops.values.map((shop) async {
        var shopId = shop.iD.toString();
        var latitude = shop.latitude;
        var longitude = shop.longitude;
        var latLon = latitude.toString() + longitude.toString();
        // 緯度経度が同じ場合は、重なり防止のためにマーカーの位置をずらす
        if (latLonList.contains(latLon)) {
          latitude = latitude + Config.latitudeAdjustValue;
          longitude = longitude + Config.longitudeAdjustValue;
          latLon = latitude.toString() + longitude.toString();
        }
        latLonList.add(latLon);
        adjustedShops[shopId] = shop;
        adjustedShops[shopId]!.latitude = latitude;
        adjustedShops[shopId]!.longitude = longitude;

        var position = LatLng(latitude, longitude);
        var zIndex = shop.inCurrentSales ? 1 : 0;
        BitmapDescriptor icon =
            shop.inCurrentSales ? shopOpenIcon : shopCloseIcon;
        if (activeShopId != null && shopId == activeShopId) {
          var shopName = '${shop.no}: ${shop.shopName}';
          icon = await createShopMarkerWidget(shopName, shop.inCurrentSales);
          zIndex = 2;
        }

        Future.delayed(Duration(seconds: 0), () async {
          await setMarker(
              pageController, adjustedShops, shopId, position, icon, zIndex);
        });
      }));
    });
  }
}
