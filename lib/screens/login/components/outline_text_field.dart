import 'package:flutter/material.dart';

class OutlineTextFeield extends StatelessWidget {
  final hintText;
  final ValueChanged<String> onChanged;

  const OutlineTextFeield({Key key, this.hintText, this.onChanged}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.85,
      height: 60,
      child:               TextField(
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white, fontSize: 25),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white, width: 1),
          ),
        ),
      ),
    );
  }
}