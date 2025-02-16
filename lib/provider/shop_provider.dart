import 'package:egp_client/grpc_gen/egp.pb.dart';
import 'package:egp_client/service/auth_service.dart';
import 'package:egp_client/service/shop_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shop_provider.g.dart';

@riverpod
class Shop extends _$Shop {
  @override
  Future<ShopsResponse?> build() async {
    return await _fetchShops();
  }

  Future<ShopsResponse?> _fetchShops() {
    User? user = ref.read(authServiceProvider.notifier).getCurrentUser();
    String userId = user != null ? user.uid : '';
    return ShopService.getShops(userId);
  }

  Future<ShopsResponse?> getShops([List<int>? searchCondition]) async {
    User? user = ref.read(authServiceProvider.notifier).getCurrentUser();
    String userId = user != null ? user.uid : '';
    final shops = await ShopService.getShops(userId, searchCondition);
    state = AsyncData(shops);
    return shops;
  }
}
