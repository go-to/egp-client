import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grpc/grpc.dart';
import 'package:egp_client/grpc_gen/egp.pbgrpc.dart';

class GrpcService {
  static ClientChannel getChannel() {
    return ClientChannel(
      dotenv.get('GRPC_SERVER_HOST'),
      port: int.parse(dotenv.get('GRPC_SERVER_PORT')),
      // default: secure()
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
  }

  static Future<ShopsResponse> getShops(String userId,
      [List<int>? searchParams]) async {
    final channel = getChannel();
    final client = EgpServiceClient(channel);
    List<SearchType> searchTypes = [];

    for (final searchType in searchParams!) {
      final value = SearchType.valueOf(searchType);
      if (value == null) {
        continue;
      }
      searchTypes.add(value);
    }
    final res = await client.getShops(
      ShopsRequest(searchTypes: searchTypes, userId: userId),
    );
    return res;
  }
}
