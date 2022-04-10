import 'package:flutter/material.dart';

// final auth = Modular.get<IAuthRepository>();

Widget title(text) {
  return RichText(
      text: TextSpan(
    text: text,
    style: TextStyle(
        fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
  ));
}

Widget description(text) {
  return RichText(
      text: TextSpan(
    text: text,
    style: TextStyle(
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        color: Colors.black87,
        fontSize: 14),
  ));
}

Widget modifiedText(titulo, valor) {
  return RichText(
      text: TextSpan(
          text: titulo,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          children: <TextSpan>[
        TextSpan(text: valor, style: TextStyle(fontWeight: FontWeight.normal))
      ]));
}
