import 'package:grpc/grpc_connection_interface.dart';
import 'package:grpc/grpc_web.dart';

ClientChannelBase getClientChannel(String url, int port) =>
    GrpcWebClientChannel.xhr(Uri(host: url, port: port));
