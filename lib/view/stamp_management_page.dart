import 'package:egp_client/grpc_gen/egp.pb.dart';
import 'package:egp_client/service/grpc_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/auth_service.dart';
import '../widget/stamp_card_widget.dart';

class StampManagementPage extends ConsumerStatefulWidget {
  const StampManagementPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StampManagementPageState();
}

class _StampManagementPageState extends ConsumerState<StampManagementPage> {
  Future<ShopsResponse> _fetchShops(String userId) async {
    return await GrpcService.getShops(userId, []);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(authServiceProvider.notifier).getCurrentUser();
    return FutureBuilder<ShopsResponse>(
      future: _fetchShops(user!.uid),
      builder: (BuildContext context, AsyncSnapshot<ShopsResponse> snapshot) {
        final data = snapshot.data;
        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: data.shops.length, // 仮のスタンプ数
          itemBuilder: (context, index) {
            final shop = data.shops.toList()[index];
            return StampCard(shop: shop);
          },
        );
      },
    );
  }
}
