import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Home_Screen/home_screen.dart';
import '../Login Screen/login_screen.dart';

class GoogleSignInProvider {

  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        }
    );
  }
}