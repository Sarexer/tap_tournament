import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:confetti/confetti.dart';
import 'package:easy_udp_socket/easy_udp_socket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tap_tournament/screens/fight/components/timer_widget.dart';

class FightPage extends StatefulWidget {
  final assetsAudioPlayer = AssetsAudioPlayer();
  final int port;
  final int player;
  EasyUDPSocket socket;

  FightPage(this.port, this.player) {
    assetsAudioPlayer.open(Audio("assets/audio/music.mp3"),
        loopMode: LoopMode.single);
    initUdpClinet();
  }

  void initUdpClinet() async {
    socket = await EasyUDPSocket.bindSimple(12345);
  }

  @override
  _FightPageState createState() => _FightPageState();
}

class _FightPageState extends State<FightPage> {
  Timer _timer;
  ConfettiController _controllerCenter;

  Size size;
  int width;

  int height;
  var rand = Random();
  int score = 0;
  int enemyScore = 0;
  int gameTime = 30;

  var colors = [
    Colors.yellow,
    Colors.red,
    Colors.green,
    Colors.white,
    Colors.orange
  ];
  var currentRect = [0.0, 0.0];
  var nextRect = [0.0, 0.0];

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    widget.assetsAudioPlayer.dispose();
    super.dispose();
  }

  void restartGame() async {
    setState(() {
      score = 0;
      enemyScore = 0;
      widget.assetsAudioPlayer.seek(Duration(seconds: 0));
    });
  }

  void calcPositions(int height, int width) {
    nextRect[0] = rand.nextInt(width).toDouble();
    nextRect[1] = rand.nextInt(height).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    var size = MediaQuery.of(context).size;
    int height = size.height.toInt() - 150;
    int width = size.width.toInt() - 150;
    calcPositions(height, width);

    return Scaffold(
      resizeToAvoidBottomInset: canResizeToAvoidBottomInset(context),
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: CountdownTimer(
          time: gameTime,
          onStop: () {
            showEndGameDialog();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.black,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              score.toString(),
              style: TextStyle(color: Colors.green),
            ),
            Text(
              ':',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              enemyScore.toString(),
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Opacity(
              opacity: 0.5,
              child: Container(
                width: size.width,
                height: size.height,
                child: Image.asset(
                  "assets/gif/6zvA.gif",
                ),
              ),
            ),
            Positioned(
              top: nextRect[1],
              left: nextRect[0],
              child: Container(
                height: 50,
                width: 50,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.white)),
              ),
            ),
            Positioned(
              top: currentRect[1],
              left: currentRect[0],
              /*top: size.height-150,
              left: 0,*/
              child: GestureDetector(
                onTap: () {
                  _controllerCenter.play();
                  currentRect[0] = nextRect[0];
                  currentRect[1] = nextRect[1];
                  setState(() {
                    score++;
                  });
                  sendPacket();
                },
                child: Container(
                  height: 50,
                  width: 50,
                  color: colors[rand.nextInt(colors.length)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendPacket() async {
    var map = {'command': 'score', 'player': widget.player, 'score': score};

    widget.socket.send(ascii.encode(jsonEncode(map)), '10.0.2.2', widget.port);
    final resp = await widget.socket.receive();
    map = jsonDecode(ascii.decode(resp.data));
    enemyScore = map['score'];
  }

  bool canResizeToAvoidBottomInset(BuildContext context) {
    if (context == null) return false;
    var viewInsets = MediaQuery.of(context).viewInsets;
    var insetsBottom = viewInsets.bottom;
    var screenHeight = MediaQuery.of(context).size.height;
    return (screenHeight * 0.18) < insetsBottom;
  }

  void showEndGameDialog() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Container(
                child: Text(chooseResultText()),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
        barrierDismissible: false);
  }

  String chooseResultText() {
    if (score > enemyScore) {
      return 'Win';
    }
    if (score < enemyScore) {
      return 'Lose';
    }
    return 'Draw';
  }
}
