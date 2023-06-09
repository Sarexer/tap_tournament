import 'dart:async';

import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final int time;
  final Function onStop;

  const CountdownTimer({Key key, this.time, this.onStop}) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState(time: time, onStop: onStop);
}

class _CountdownTimerState extends State<CountdownTimer> {
  int time;
  Timer _timer;
  final Function onStop;

  _CountdownTimerState({this.time, this.onStop});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text(time.toString())),
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (time == 0) {
            timer.cancel();
            onStop();
          } else {
            time--;
          }
        },
      ),
    );
  }
}
