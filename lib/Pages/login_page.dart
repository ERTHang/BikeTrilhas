import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

import 'map_page.dart';

//dados do usuário
String name;
String email;
String imageURL;

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  
  //instância de login firebase, necessário para permitir à um usuário google ser nosso usuário
  final FirebaseAuth _auth = FirebaseAuth.instance; 
  
  //criar um objeto para efetuar o login
  final GoogleSignIn googleSignIn = GoogleSignIn();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.white,
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlutterLogo(size: 150),
                SizedBox(height: 50),
                _signInButton(),
              ],
            ))));
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        
        //Quando o usuário apertar o botão de login, vai executar a função e logo após ir para a pagina do maps
        signInWithGoogle().whenComplete(() {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return MapClass();
              }
            )
          );
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("images/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left:10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                )
              ),
            ),
          ],
        )
      ),
    );
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn(); //obtém uma conta google
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    // pega as credenciais do google para utilizar no firebase
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleSignInAuthentication.idToken, 
      accessToken: googleSignInAuthentication.accessToken
    ); 

    // faz o login no firebase e pega um usuário
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    
    //verifica se nenhum campo está vazio
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoUrl != null);
    
    //adiciona os dados do usuário às variáveis globais definidas no início
    name = user.displayName;
    email = user.email;
    imageURL = user.photoUrl;

    if (name.contains(" ")) {
      name = name.substring(0, name.indexOf(" "));
    }

    name = name.toUpperCase();

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signInWithGoogle succeeded: $user';
  }

  void signOutGoogle() async {
    //todo
    await googleSignIn.signOut();

  }
}
