import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'main.dart';
import 'splash.dart';
import 'user_details.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GoogleSignInAccount? user;
  String eligible = "";
  bool showban = false;
  bool showload = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xfff1f2f6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [const SizedBox(
            height: 100,
          ),
            ClipRRect(borderRadius: BorderRadius.circular(100),child: Image.asset('images/logo.jpg', height: 120,)),
            SizedBox(height: 65,),
            Image.asset('images/well.png', height: 170,),

            const SizedBox(
              height: 65,
            ),
            Center(
              child: SignInButton(
                Buttons.Google,
                text: "Continue with Google",
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                onPressed: () async {
                  user = await GoogleSignIn().signIn();

                  String? mail = user?.email;
                  if (mail != null) {
                    setState(() {
                      showload = true;
                    });
                    final GoogleSignInAuthentication? googleauth =
                    await user?.authentication;
                    final credential = GoogleAuthProvider.credential(
                        accessToken: googleauth?.accessToken,
                        idToken: googleauth?.idToken);

                    await FirebaseAuth.instance
                        .signInWithCredential(credential).catchError((e){
                      if(e.code == 'user-disabled'){
                        GoogleSignIn().signOut();
                        try {
                          GoogleSignIn().disconnect();
                        } catch (e) {}
                        FirebaseAuth.instance.signOut();
                        setState(() {
                          showban = true;
                        });
                      }else{
                        Fluttertoast.showToast(msg: e.toString());
                      }

                    });
                    if (FirebaseAuth.instance.currentUser != null) {
                      String? email =
                          FirebaseAuth.instance.currentUser?.email;
                      String? mymail = email?.replaceAll("@", '');
                      String? minemail = mymail?.replaceAll(".", "");

                      DatabaseReference refee = await FirebaseDatabase
                          .instance
                          .ref("UserData/${minemail!}");
                      final event = await refee.once();
                      if (event.snapshot.exists) {
                        open = true;
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Splash()),
                            ModalRoute.withName("/Temp"));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) {
                              return const UserData();
                            }));
                      }
                    } else {}
                  }
                },
              ),
            ),
            const SizedBox(height: 2,),
            showban ? const Text(
              "Your account has been disabled.\nFor further details contact\njdcodekgp@gmail.com",textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'chivo',
                  color: Color(0xffef6565)),
            ) : const SizedBox(height: 0,),
            showload
                ? Column(
                  children: [SizedBox(height: 25,),LoadingAnimationWidget.threeArchedCircle(
                  color: const Color(0xffea8537), size: 38),
                ])
                : const SizedBox(height: 0,),
            Text(
              eligible,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'chivo',
                  color: Color(0xffef6565)),
            ),
            const Spacer(),
            const Text(
              "KGP ka apna discussion platform",
              style: TextStyle(
                  fontSize: 22, color: Colors.black, fontFamily: 'kaushan'),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}

