import 'package:biketrilhas_modular/app/modules/map/map_controller.dart';
import 'package:flutter/material.dart';

// final auth = Modular.get<IAuthRepository>();

Widget title(String text, bool isTablet) {
  return RichText(
      text: TextSpan(
    text: text,
    style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: isTablet ? 36 : 20),
  ));
}

Widget description(String text, bool isTablet) {
  return RichText(
      text: TextSpan(
    text: text,
    style: TextStyle(
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic,
        color: Colors.black87,
        fontSize: isTablet ? 20 : 14),
  ));
}

Widget modifiedText(String titulo, String valor, bool isTablet) {
  return RichText(
      text: TextSpan(
          text: titulo,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: isTablet ? 20 : 14),
          children: <TextSpan>[
        TextSpan(text: valor, style: TextStyle(fontWeight: FontWeight.normal))
      ]));
}

ClipRRect bottomsheetSkeleton(
    MapController mapController, double heightMultiplier) {
  return ClipRRect(
    borderRadius: BorderRadius.only(
        topRight: Radius.circular(20), topLeft: Radius.circular(20)),
    child: Container(
      color: Colors.white,
      height: MediaQuery.of(mapController.scaffoldState.currentContext)
              .size
              .height *
          heightMultiplier,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ),
  );
}
