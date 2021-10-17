import 'package:flutter/material.dart';
import 'package:tekko/screens/root/root.dart';
import 'package:tekko/states/currentUser.dart';
import 'package:tekko/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CurrentUser(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: OurTheme().buildTheme(),
          home: LoginRoot(),
        ));
  }
}
