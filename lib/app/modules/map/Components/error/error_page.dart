import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ErrorPage extends StatefulWidget {
  final String title;
  const ErrorPage({Key key, this.title = "Error"}) : super(key: key);

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Modular.to.pushReplacementNamed('/map');
        }, 
        label: Row(
          children: <Widget>[
            Icon(Icons.arrow_back),
            Text("Voltar")
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
        )
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Icon(
              Icons.error, 
              color: Colors.red,
              size: 80,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Algo deu errado, verifique se a localização do seu smartphone não está desativada.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  backgroundColor: Colors.white
                ),
              ),
            )
            
          ],
        ),
      )
    );
  }
}
