import 'package:biketrilhas_modular/app/shared/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'info_controller.dart';

Row _renderRowAbout(double width) {
  List<int> proportions = width > 600 ? [3, 1] : [1, 0];
  List<Widget> itens = [
    Expanded(
      flex: proportions[0],
      child: Text(
        ABOUT_US,
        style: TextStyle(fontSize: 16),
      ),
    )
  ];
  if (width > 600) {
    itens.add(
      Expanded(
          flex: proportions[1],
          child: Image.asset(
            "images/udesc_logo.jpg",
          )),
    );
  }
  return Row(
    children: itens,
  );
}

List<Widget> _renderContactRow(width) {
  List<Expanded> itens = [
    Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.open_in_browser,
            size: 50,
            color: Colors.blue,
          )
        ],
      ),
    ),
    Expanded(
      flex: 3,
      child: Column(
        children: [
          Text(
            'Website',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            APP_WEBSITE,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    ),
    Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.mail,
            size: 50,
            color: Colors.blue,
          )
        ],
      ),
    ),
    Expanded(
      flex: 3,
      child: Column(
        children: [
          Text(
            'Email',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            APP_EMAIL,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    )
  ];

  if (width > 600) {
    return [
      Row(
        children: [itens[0], itens[1], itens[2], itens[3]],
      )
    ];
  } else {
    return [
      Row(
        children: [itens[0], itens[1]],
      ),
      SizedBox(height: 24),
      Row(
        children: [itens[2], itens[3]],
      ),
    ];
  }
  // return Row(
  //   children: ,
  // );
}

class InfoPage extends StatefulWidget {
  final String title;
  const InfoPage({Key key, this.title = "Nemobis"}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends ModularState<InfoPage, InfoController> {
  //use 'controller' variable to access controller

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    // final bool isTablet = shortestSide > 600;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(fontFamily: 'Rancho', fontSize: 25),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            // adding margin

            padding: EdgeInsets.all(24.0),
            margin: EdgeInsets.all(24.0),
            // adding padding

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, offset: Offset(0, 3), blurRadius: 5)
              ],
            ),
            // SingleChildScrollView should be
            // wrapped in an Expanded Widget
            child: Expanded(
              //contains a single child which is scrollable
              child: SingleChildScrollView(
                //for horizontal scrolling
                scrollDirection: Axis.vertical,
                child: Container(
                  constraints: BoxConstraints(maxWidth: 600, maxHeight: 600),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: [
                            // IMAGE BANNER ROW
                            Row(
                              children: [
                                Expanded(
                                    child: Image.asset(
                                  "images/about_logo.png",
                                  width: 150,
                                ))
                              ],
                            ),
                            // CONTENT ROW
                            SizedBox(height: 24),
                            _renderRowAbout(shortestSide),
                            // ANOTHER ROW
                            SizedBox(height: 36),
                            ..._renderContactRow(shortestSide)
                                .map((e) => e)
                                .toList(),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Image.asset(
                            "images/h_udesc_logo.jpg",
                            width: 150,
                          ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
