import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  final String title;
  const LoginPage({Key key, this.title = "Login"}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ModularState<LoginPage, LoginController> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[700],
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/icon.png'),
            SizedBox(height: 10),
            Image.asset('images/bike_logo_actionbar.png'),
            SizedBox(height: 100),
            _signInButton(),
          ],
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        controller.loginWithGoogle();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("images/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('Sign in with Google',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
