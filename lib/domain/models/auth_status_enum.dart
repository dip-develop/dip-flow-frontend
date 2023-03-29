import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_status_enum.g.dart';

class AuthState extends EnumClass {
  static Serializer<AuthState> get serializer => _$authStateSerializer;

  static const AuthState unknown = _$unknown;
  static const AuthState authorized = _$authorized;
  static const AuthState unauthorized = _$unauthorized;

  const AuthState._(String name) : super(name);

  static BuiltSet<AuthState> get values => _$values;
  static AuthState valueOf(String name) => _$valueOf(name);
}
