import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

///Verifica se o usuário está online
Future<bool> isOnline() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  }
  return true;
}

///Emite um alerta do tipo dialog
alert(BuildContext context, String mensagem, String titulo) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(titulo),
          content: Text(
            mensagem,
          ),
          actions: <Widget>[
            FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
      );
    },
  );
}

alertaComEscolha(context, titulo, mensagem, String botao1text,
    Function botao1func, String botao2text, Function botao2func, {Color corTitulo = Colors.black}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(
            titulo,
            style: TextStyle(
              color: corTitulo
            ),
          ),
          content: mensagem,
          actions: <Widget>[
            FlatButton(
                child: Text(botao1text),
                onPressed: () {
                  botao1func();
                  Navigator.pop(context);
                  return;
                }),
            FlatButton(
              child: Text(botao2text),
              onPressed: botao2func,
            ),
          ],
        ),
      );
    },
  );
}

///Emite um alerta do tipo snack
snackAlert(context, text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

///Barra linear de carregamento
mostrarProgressoLinear(context, text) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(text),
          content: LinearProgressIndicator(),
        ),
      );
    },
  );
}

enum EditMode { ADD, UPDATE }
