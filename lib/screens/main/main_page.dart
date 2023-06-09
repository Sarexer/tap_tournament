import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tap_tournament/screens/fight/fight_page.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MainPage extends StatefulWidget {
  final WebSocketChannel channel =
      IOWebSocketChannel.connect('ws://10.0.2.2:12346/findGame');

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listen();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.2,
            child: Container(
              width: size.width,
              height: size.height,
              child: Image.asset(
                "assets/gif/4RNk.gif",
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: size.width,
              height: 50,
              child: ElevatedButton(
                onPressed: findEnemy,
                child: Text(
                  'FIND ENEMY',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void listen() {
    widget.channel.stream.listen((event) {
      var map = jsonDecode(event);
      switch (map['command']) {
        case 'gameFinded':
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FightPage(map['port'], map['player'])));
          break;
      }
    });
  }

  void findEnemy() async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => FightPage(123, 123),
    ));
  }
}
