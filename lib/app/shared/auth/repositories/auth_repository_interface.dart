import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthRepository {
  Future<User> getUser();
  Future<User> getGoogleLogin();
  Future getLogout();
}
