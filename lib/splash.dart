import 'package:animate_do/animate_do.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kgppanchayat/hall.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'login.dart';
import 'main.dart';
import 'temp.dart';
import 'user_details.dart';

bool pass = false;

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  Widget build(BuildContext context) {


    FirebaseAuth.instance.currentUser?.reload().catchError((e){
      if(e.code == 'user-disabled'){
        GoogleSignIn().signOut();
        try {
          GoogleSignIn().disconnect();
        } catch (e) {}
        FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
            ModalRoute.withName("/Temp"));
      }


    });
    String? email = FirebaseAuth.instance.currentUser?.email;
    String? mymail = email?.replaceAll("@", '');
    String? minemail = mymail?.replaceAll(".", "");
    DatabaseReference get =
    FirebaseDatabase.instance.ref("UserData/${minemail!}");
    get.once().then((value) async {
      DataSnapshot snap = value.snapshot;
      if(snap.exists){
        Map<dynamic, dynamic> map = snap.value as Map;
        Departmentp = map["Department"];
        EmailIdp = map["Email_ID"];
        Biop = map["Bio"];
        Namep = map["Name"];
        Hallp = map["Hall"];
        PhotoUrlp = map["PhotoUrl"];
        Yearp = map["Year"];

        if(Yearp!="0"){

          DatabaseReference fgjg = FirebaseDatabase.instance.ref("NotiSett/$minemail");
          fgjg.once().then((valu) async{
            DataSnapshot sna = valu.snapshot;
            if(sna.exists){
              Map<dynamic, dynamic> m = sna.value as Map;
              notiall = m['All'];
              notidept = m['Dept'];
              notihall = m['Hall'];
              notievents = m['Events'];
              notifundae = m['Fundae'];
              notilost = m['Lost'];
              noticomment = m['Comment'];
              if(notiall){
                await FirebaseMessaging.instance.subscribeToTopic("All");
              }else{
                await FirebaseMessaging.instance.unsubscribeFromTopic("All");
              }
              if(notidept){
                await FirebaseMessaging.instance.subscribeToTopic(Departmentp);
              }else{
                await FirebaseMessaging.instance.unsubscribeFromTopic(Departmentp);
              }
              if(notihall){
                await FirebaseMessaging.instance.subscribeToTopic(Hallp);
              } else{
                await FirebaseMessaging.instance.unsubscribeFromTopic(Hallp);
              }
              if(notievents){
                await FirebaseMessaging.instance.subscribeToTopic("Events");
              }else{
                await FirebaseMessaging.instance.unsubscribeFromTopic("Events");
              }
              if(notifundae){
                await FirebaseMessaging.instance.subscribeToTopic("Fundae");
              }else{
                await FirebaseMessaging.instance.unsubscribeFromTopic("Fundae");
              }
              if(notilost){
                await FirebaseMessaging.instance.subscribeToTopic("Lost");
              }else{
                await FirebaseMessaging.instance.unsubscribeFromTopic("Lost");
              }

              if(noticomment){
                await FirebaseMessaging.instance.subscribeToTopic(minemail);
              }else{
                await FirebaseMessaging.instance.unsubscribeFromTopic(minemail);
              }
            }else{
              DatabaseReference df = FirebaseDatabase.instance.ref("NotiSett/$minemail");
              final jsons = {
                'All': true,
                'Dept': true,
                'Hall': true,
                'Events' : true,
                'Fundae': true,
                'Lost': true,
                'Comment': true
              };
              df.set(jsons);
              notiall = true;
              notidept = true;
              notihall = true;
              notievents = true;
              notifundae = true;
              notilost = true;
              noticomment = true;
              await FirebaseMessaging.instance.subscribeToTopic(Hallp);
              await FirebaseMessaging.instance.subscribeToTopic(Departmentp);
              await FirebaseMessaging.instance.subscribeToTopic("All");
              await FirebaseMessaging.instance.subscribeToTopic("Events");
              await FirebaseMessaging.instance.subscribeToTopic("Fundae");
              await FirebaseMessaging.instance.subscribeToTopic("Lost");
              await FirebaseMessaging.instance.subscribeToTopic(minemail);
            }
          });


          if(open){
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const Temp()),
                ModalRoute.withName("/Temp"));
            open = false;
          }
        }
      }else{
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const UserData()),
            ModalRoute.withName("/Temp"));
      }
    });



    return Scaffold(
        body: Container(
          color: Color(0xfff1f2f6),
          width: double.maxFinite,
          child: Column(children: [SizedBox(height: 300,),ClipRRect(borderRadius: BorderRadius.circular(100),child: Image.asset('images/logo.jpg', height: 180,)), Spacer(),LoadingAnimationWidget.threeArchedCircle(
              color: const Color(0xffea8537), size: 50),SizedBox(height: 150)],)
        ));
  }
}