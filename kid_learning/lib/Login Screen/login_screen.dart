import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Home_Screen/home_screen.dart';
import 'check_fb_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoggedIn = false;
  Map userObj = {};

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>['email']).signIn();
    if (googleUser == null) return;

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the userCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: ListView(
            children: [
              Image.asset('images/Welcome.png',
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.4,
                  fit: BoxFit.fill),
              Column(
                children: const <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Welcome to Kids Learning',

                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'More Play, More Learning',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      letterSpacing: 3.0,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 40.0,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(300.0),
                      ),
                      tileColor: Colors.grey[200],
                      leading: CircleAvatar(
                        // backgroundColor: Colors.white,
                        radius: 40.0,
                        child: Image.asset('images/Facebook.png'),
                      ),
                      title: const Text('Login with Facebook'),
                      onTap: () async {
                        final LoginResult loginResult =
                            await FacebookAuth.instance.login(
                              permissions: ['email','public_profile']
                            );
                        // print(loginResult.message);
                        final OAuthCredential facebookAuthCredential =
                            await FacebookAuthProvider.credential(
                                loginResult.accessToken!.token);
                        print(facebookAuthCredential);
                        FirebaseAuth.instance
                            .signInWithCredential(facebookAuthCredential)
                            .then((value) {
                              print(value);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 40.0,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(300.0),
                      ),
                      tileColor: Colors.grey[200],
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 40.0,
                        child: Image.asset('images/Google.png'),
                      ),
                      title: const Text('Login with Google'),
                      onTap: () async {
                        await signInWithGoogle().then((value) => {
                          CheckFBLogin.isFBLogin = false,
                              if (value != null)
                                {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                  ),
                                }
                              else
                                {
                                  print('something went wrong'),
                                }
                            });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
