import 'package:BetSlipCode_Admin/uploadcode.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameControl = TextEditingController();
  final passwordControl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: 40, right: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: usernameControl,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: passwordControl,
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: () {
                  return Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CodeUpload()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
