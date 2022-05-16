import 'package:biketrilhas_modular/app/shared/utils/breakpoints.dart';
import 'package:biketrilhas_modular/app/shared/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

import 'info_controller.dart';

void _launchURL(String url) async {
  if (!await launch(url)) throw 'Could not launch $url';
}

void _launchMailto(String app_email_url) async {
  final mailtoLink = Mailto(
    to: ['nemobis.udesc@gmail.com'],
    // subject: 'mailto example subject',
    // body: 'mailto example body',
  );
  // Convert the Mailto instance into a string.
  // Use either Dart's string interpolation
  // or the toString() method.
  await launch('$mailtoLink');
}

Row _renderRowAbout(double width) {
  bool isTablet = width > MOBILE_BREAKPOINT;
  List<int> proportions = isTablet ? [3, 1] : [1, 0];
  List<Widget> itens = [
    Expanded(
      flex: proportions[0],
      child: Column(children: [
        Text(
          ABOUT_US_P1,
          style: TextStyle(fontSize: isTablet ? 20 : 16),
        ),
        SizedBox(height: 4),
        Text(
          ABOUT_US_P2,
          style: TextStyle(fontSize: isTablet ? 20 : 16),
        )
      ]),
    )
  ];
  if (isTablet) {
    itens.add(
      Expanded(
        flex: proportions[1],
        child: InkWell(
          child: Image.asset(
            "images/udesc_logo.jpg",
          ),
          onTap: () {
            _launchURL(APP_WEBSITE);
          },
        ),
      ),
    );
  }
  return Row(
    children: itens,
  );
}

List<Widget> _renderText(String title, String text) {
  return [
    Text(
      title,
      style: TextStyle(
          fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 4),
    Text(
      text,
      style: TextStyle(fontSize: 16),
    ),
  ];
}

Icon _renderIcon(IconData customIcon) {
  return Icon(
    customIcon,
    color: Colors.blue,
    size: 50,
  );
}

List<Widget> _renderContactRow(width) {
  bool isTablet = width > MOBILE_BREAKPOINT;
  List<Expanded> itens = [
    Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_renderIcon(FontAwesomeIcons.chrome)],
      ),
    ),
    Expanded(
      flex: 3,
      child: Column(
        children: _renderText('Website', APP_WEBSITE),
      ),
    ),
    Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_renderIcon(Icons.mail)],
      ),
    ),
    Expanded(
      flex: 3,
      child: Column(
        children: _renderText('Email', APP_EMAIL),
      ),
    ),
    Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_renderIcon(FontAwesomeIcons.instagram)],
      ),
    ),
    Expanded(
      flex: 3,
      child: Column(
        children: _renderText('Instagram', APP_INSTAGRAM),
      ),
    )
  ];

  if (isTablet) {
    return [
      Row(
        children: [
          Expanded(
            child: InkWell(
              child: Column(
                children: [
                  _renderIcon(FontAwesomeIcons.chrome),
                  ..._renderText('Website', APP_WEBSITE)
                ],
              ),
              onTap: () => _launchURL(APP_WEBSITE),
            ),
          ),
          Expanded(
            child: InkWell(
              child: Column(
                children: [
                  _renderIcon(Icons.mail),
                  ..._renderText('Email', APP_EMAIL)
                ],
              ),
              onTap: () => _launchMailto(APP_EMAIL_URL),
            ),
          ),
          Expanded(
            child: InkWell(
              child: Column(
                children: [
                  _renderIcon(FontAwesomeIcons.instagram),
                  ..._renderText('Instagram', APP_INSTAGRAM)
                ],
              ),
              onTap: () => _launchURL(APP_INSTAGRAM_URL),
            ),
          )
        ],
      ),
      SizedBox(height: 24),
    ];
  } else {
    return [
      InkWell(
        child: Row(
          children: [itens[0], itens[1]],
        ),
        onTap: () => _launchURL(APP_WEBSITE),
      ),
      SizedBox(height: 24),
      InkWell(
        child: Row(
          children: [itens[2], itens[3]],
        ),
        onTap: () => _launchMailto(APP_EMAIL_URL),
      ),
      SizedBox(height: 24),
      InkWell(
        child: Row(
          children: [itens[4], itens[5]],
        ),
        onTap: () => _launchURL(APP_INSTAGRAM_URL),
      ),
      SizedBox(height: 24),
    ];
  }
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
    bool isTablet = shortestSide > MOBILE_BREAKPOINT;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontFamily: 'Rancho', fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Scrollbar(
        isAlwaysShown: !isTablet,
        thickness: 8,
        interactive: true,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
            margin: EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, offset: Offset(0, 3), blurRadius: 5)
              ],
            ),
            child: Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: isTablet ? 650 : 600,
                      maxHeight: isTablet ? 1000 : 630),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: [
                            // IMAGE BANNER ROW
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    child: Image.asset(
                                      "images/about_logo.png",
                                      width: 150,
                                    ),
                                    onTap: () => _launchURL(APP_WEBSITE),
                                  ),
                                )
                              ],
                            ),
                            // CONTENT ROW
                            SizedBox(height: isTablet ? 42 : 24),
                            _renderRowAbout(shortestSide),
                            // CONTACT ROW
                            SizedBox(height: isTablet ? 60 : 36),
                            ..._renderContactRow(shortestSide)
                                .map((e) => e)
                                .toList(),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              child: Image.asset(
                                "images/h_udesc_logo.jpg",
                                width: 150,
                              ),
                              onTap: () => _launchURL(APP_WEBSITE),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
