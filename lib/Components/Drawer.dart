import 'package:flutter/material.dart';

import '../login_page.dart';

class DrawerClass extends StatefulWidget {
  @override
  _DrawerClassState createState() => _DrawerClassState();
}

class _DrawerClassState extends State<DrawerClass> {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue[300], Colors.blue[400], Colors.blue]
            ),

          ),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(90, 30, 90, 0),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  
                  backgroundImage: NetworkImage(imageURL),
                  radius: 60,
                ),
              ),
              Text(
                name, 
                textAlign: TextAlign.center, 
                style: TextStyle(
                  height: 1.8,
                  fontSize: 20,
                  color: Colors.grey[300],
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        )
      );
      
  }
}