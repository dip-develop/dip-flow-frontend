import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'token_model.g.dart';

abstract class TokenModel implements Built<TokenModel, TokenModelBuilder> {
  static Serializer<TokenModel> get serializer => _$tokenModelSerializer;

  String get accessToken;
  String get refreshToken;

  TokenModel._();
  factory TokenModel([void Function(TokenModelBuilder) updates]) = _$TokenModel;
}
