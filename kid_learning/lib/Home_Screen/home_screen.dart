import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:kid_learning/Login%20Screen/login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Laravel/helper.dart';
import '../Login Screen/check_fb_login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List itemsA;
  bool isLoading = true;

  IconData playPauseIcon = Icons.play_arrow;

  @override
  void initState() {
    // setAudio(itemsA[0]['song']);
    super.initState();
    getData();
  }

  void getData() async {
    await Helper.getAllSound().then((soundData) => {
          print(soundData),
          setState(() {
            itemsA = soundData;
            isLoading = false;
          })
        });
    print(itemsA);
    print(itemsA[0]['image']);
  }

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;

  Future setAudio(String audioA) async {
    // final player = AudioCache(prefix: 'assets/');
    // final url = await player.load(audioA);
    // audioPlayer.setSourceUrl(url.path);
    // audioPlayer.play(UrlSource('https://file.api.audio/demo.mp3'));
    // print(audioA + 'manish');
    // final audioPlayer = AudioPlayer();
    // await audioPlayer.play(UrlSource('http://10.0.2.2:8000/sound/ABCD.mp3'));
  }

  Future<void> pauseAudio() async {
    await audioPlayer.pause().then(
          (value) => setState(() {
            isPlaying = false;
          }),
        );
  }

  Future<void> resumeAudio() async {
    await audioPlayer.resume().then(
          (value) => setState(() {
            isPlaying = true;
          }),
        );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        // body: Column(
        //   children: [
        //     // isLoading == false ? FittedBox(fit: BoxFit.cover, child: Card(color: Colors.blue, child: Image.network('http://10.0.2.2:8000/image/${itemsA[0]['image']}'))) :
        //     //     Text('Loading'),
        //   ],
        // ),
        body: isLoading == false
            ? PageView.builder(
                onPageChanged: (index) async {
                  print('obj');
                  // await setAudio(itemsA[index]['songs']);
                },
                itemCount: itemsA.length,
                itemBuilder: (BuildContext context, int index) => SwipPage(
                  onPressed: () async {
                    if (isPlaying) {
                      await pauseAudio();
                      setState(() {
                        playPauseIcon = Icons.play_arrow;
                      });
                    } else {
                      await resumeAudio();
                      setState(() {
                        playPauseIcon = Icons.pause;
                      });
                    }
                  },
                  // image: 'images/${items[index]['images']}',
                  image: itemsA[index]['image'],
                  sound: itemsA[index]['sound'],
                  icon: playPauseIcon,
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class SwipPage extends StatefulWidget {
  SwipPage({
    Key? key,
    required this.onPressed,
    required this.image,
    required this.icon,
    required this.sound,
  }) : super(key: key);
  final Function() onPressed;
  final String sound;
  final String image;
  final IconData icon;

  @override
  State<SwipPage> createState() => _SwipPageState();
}

class _SwipPageState extends State<SwipPage> {
  final String baseURL = 'http://10.0.2.2:8000';

  AudioPlayer audioPlayer = AudioPlayer();
  bool isAudioPlaying = false;
  IconData playPauseIcon = Icons.play_arrow;

  void playSound() async {
    print('audio played');
    await audioPlayer
        .play(UrlSource('http://10.0.2.2:8000/sound/${widget.sound}'))
        .then((value) => {
              setState(() {
                playPauseIcon = Icons.pause;
                isAudioPlaying = true;
              })
            });
  }

  void pauseSound() async {
    print('audio paused');
    await audioPlayer.pause().then((value) => {
          isAudioPlaying = false,
          setState(() {
            playPauseIcon = Icons.play_arrow;
          })
        });
  }

  bool isLoginFromFB = false;
  late String imageA;

  void getFBImage() async {
    var ins = FirebaseAuth.instance;
    var loginProvider = ins.currentUser!.providerData;
    if (loginProvider[0].providerId == CheckFBLogin.loginProvider) {
      CheckFBLogin.isFBLogin = true;
    }

    final fb = FacebookLogin();
    var image = await fb.getProfileImageUrl(width: 100);
    setState(() {
      imageA = image!;
      isLoginFromFB = true;
    });
  }

  @override
  void initState() {
    getFBImage();
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.image);
    final user = FirebaseAuth.instance.currentUser!;
    return Container(
      color: const Color(0xFFFFFFFF),
      height: MediaQuery.of(context).size.height,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage('$baseURL/image/${widget.image}'),
              ),
            ),
          ),
          Positioned(
            bottom: 50.0,
            left: MediaQuery.of(context).size.width * 0.43,
            child: Material(
              borderRadius: BorderRadius.circular(40.0),
              elevation: 8.0,
              child: CircleAvatar(
                backgroundColor: Colors.orangeAccent,
                radius: 30.0,
                child: IconButton(
                  icon: Icon(
                    playPauseIcon,
                    size: 30.0,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    // print(widget.sound);
                    // final audioPlayer = AudioPlayer();
                    // await audioPlayer.play(UrlSource('http://10.0.2.2:8000/sound/${widget.sound}'));
                    isAudioPlaying == false ? playSound() : pauseSound();
                  },
                ),
              ),
            ),
          ),

          //Alert_Box_For_Google_Auth_Info

          Positioned(
            top: 10.0,
            right: 10.0,
            child: Material(
              borderRadius: BorderRadius.circular(40.0),
              elevation: 8.0,
              child: CircleAvatar(
                backgroundColor: Colors.orangeAccent,
                radius: 20.0,
                child: IconButton(
                  icon: const Icon(
                    (Icons.supervised_user_circle_rounded),
                    size: 20.0,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        actions: [
                          CheckFBLogin.isFBLogin == false
                              ? CircleAvatar(
                                  radius: 40.0,
                                  backgroundImage: NetworkImage(FirebaseAuth
                                      .instance.currentUser!.photoURL!),
                                )
                              : (isLoginFromFB == false
                                  ? const CircleAvatar(
                                      radius: 40.0,
                                      backgroundColor: Colors.orangeAccent,
                                    )
                                  : CircleAvatar(
                                      radius: 40.0,
                                      backgroundImage: NetworkImage(imageA),
                                    )),
                          // CircleAvatar(
                          //   radius: 40,
                          //   // backgroundImage: NetworkImage(
                          //   //     FirebaseAuth.instance.currentUser!.photoURL!),
                          // ),
                          Text(
                            FirebaseAuth.instance.currentUser!.displayName!,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                          Text(
                            FirebaseAuth.instance.currentUser!.email!,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                          //Back Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.orangeAccent),
                                ),
                                child: const Text('Back'),
                              ),

                              //Logout Button
                              const SizedBox(
                                width: 10.0,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final googleSignIn = GoogleSignIn();
                                  googleSignIn.disconnect();
                                  await FirebaseAuth.instance.signOut().then(
                                        (value) => Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen()),
                                        ),
                                      );
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.orangeAccent),
                                ),
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                        ],
                        title: const Text("Login Details"),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
