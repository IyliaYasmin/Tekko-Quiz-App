import 'package:flutter/material.dart';

import 'loginForm.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(10.0),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Image.asset('assets/tekkoTitle.png'),
                ),
                // SizedBox(
                //   height: 1.0,
                // ),
                LoginForm(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
