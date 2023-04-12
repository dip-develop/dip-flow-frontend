import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';

@module
abstract class GRPCApiRepositoryModule {
  @lazySingleton
  ClientChannel clientChannel() => ClientChannel(
      FlavorConfig.instance.variables['baseUrl'] ?? 'musmula.dipdev.studio',
      port: 8080,
      options:
          const ChannelOptions(credentials: ChannelCredentials.insecure()));
}
