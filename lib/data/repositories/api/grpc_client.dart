import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_connection_interface.dart';

ClientChannelBase getClientChannel(String url, int port) => ClientChannel(url,
    port: port,
    options: const ChannelOptions(
      credentials: ChannelCredentials.insecure(),
      /* codecRegistry: CodecRegistry(codecs: const [GzipCodec()]), */
    ));
