import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tap_tournament/screens/main/main_page.dart';

import 'components/outline_text_field.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String loginVal;
  String passVal;

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
                "assets/gif/Oj0z.gif",
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlineTextFeield(
                  hintText: 'login',
                  onChanged: (val){
                    loginVal = val;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                OutlineTextFeield(
                  hintText: 'password',
                  onChanged: (val){
                    passVal = val;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  width: size.width * 0.5,
                  child: TextButton(
                    onPressed: auth,
                    child: Text('LOG IN', style: TextStyle(color: Colors.white, fontSize: 20),),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void auth() async{
    var url = 'http://10.0.2.2:12346/auth?login=$loginVal&pass=$passVal}';
    var res = await http.get(url);
    var map = jsonDecode(res.body);

    int userId = map['user_id'];
    if(userId != -1){
      var prefs = await SharedPreferences.getInstance();
      prefs.setInt("user_id", userId);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>MainPage()));
    }
  }
}

