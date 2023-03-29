import '../models/models.dart';

abstract class ApiRepository {
  Future<TokenModel> signInWithEmail(
      {required String email, required String password});
  Future<TokenModel> signUpWithEmail(
      {required String email, required String password, required String name});
  Future<TokenModel> refreshToken(String token);
}
