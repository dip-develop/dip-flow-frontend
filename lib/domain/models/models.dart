library serializers;

import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import 'auth_status_enum.dart';
import 'token_model.dart';

export 'auth_status_enum.dart';
export 'token_model.dart';

part 'models.g.dart';

@SerializersFor([
  TokenModel,
  AuthState,
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
