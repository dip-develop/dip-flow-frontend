import 'grpc_client.dart'
    if (dart.library.io) 'grpc_client.dart'
    if (dart.library.html) 'web_grpc_client.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:grpc/grpc_connection_interface.dart';
import 'package:injectable/injectable.dart';

@module
abstract class GRPCApiRepositoryModule {
  @lazySingleton
  ClientChannelBase clientChannel() => getClientChannel(
      FlavorConfig.instance.variables['baseUrl'],
      FlavorConfig.instance.variables.containsKey('basePort')
          ? FlavorConfig.instance.variables['basePort']
          : 443);
}
