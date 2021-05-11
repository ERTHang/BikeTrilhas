import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_repository_interface.dart';

class AuthRepository implements IAuthRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Dio dio;

  AuthRepository(this.dio);

  @override
  Future<User> getGoogleLogin() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final User user = (await _auth.signInWithCredential(credential)).user;
    return user;
  }

  @override
  Future<User> getUser() async {
    return _auth.currentUser;
  }

  @override
  Future getLogout() {
    return _auth.signOut();
  }

  Future<bool> insertUser(User user) async {
    var result = await dio.post('server/usuario', data: {
      "usuEmail": user.email,
      "usuNome": user.displayName,
      "deletado": 0,
      "admin": 0
    });
    return result.data;
  }

  Future<int> isAdmin(String email) async {
    var result = await dio.get('server/admin/$email');
    return result.data as int;
  }
}
