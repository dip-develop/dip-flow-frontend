import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';

@module
abstract class GRPCApiRepositoryModule {
  @lazySingleton
  ClientChannel clientChannel() =>
      ClientChannel(FlavorConfig.instance.variables['baseUrl'],
          port: FlavorConfig.instance.variables.containsKey('basePort')
              ? FlavorConfig.instance.variables['basePort']
              : 443,
          options: const ChannelOptions(
            credentials: ChannelCredentials.insecure(),
            /* codecRegistry: CodecRegistry(codecs: const [GzipCodec()]), */
          ));
}
