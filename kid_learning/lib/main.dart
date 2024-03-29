import 'package:flutter/material.dart';
import 'package:kid_learning/Google_Sign_In/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

Future main ()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GoogleSignInProvider().handleAuthState(),
      debugShowCheckedModeBanner: false,
    );
  }
}
