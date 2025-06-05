import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'main.dart';
import 'package:http/http.dart' as http;

class MessageDialog extends StatefulWidget {
  const MessageDialog({Key? key}) : super(key: key);

  @override
  State<MessageDialog> createState() => _MessageDialogState();
}

class _MessageDialogState extends State<MessageDialog> {
  bool enters = false;
  bool postl = false;
  String name = "",
      hall = "",
      photourl = "",
      year = "",
      dept = "";
  final writepost = TextEditingController();
  late DatabaseReference refd, refdo;
  @override
  Widget build(BuildContext context) {
    return Container(decoration: const BoxDecoration(borderRadius:  BorderRadius.all(Radius.circular(30.0)),
      color: Color(0xfff1f2f6),),
    child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min,
    children: [SizedBox(height: 15,),Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 0, horizontal: 50),
      child: TextField(
        style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontFamily: 'martel'),
        cursorColor: Colors.black,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
            hintStyle: const TextStyle(
                fontSize: 20,
                color: Color(0xffb6b4b4),
                fontFamily: 'martel'),
            filled: true,
            hintText: "Enter message...",
            enabledBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(18)),
                borderSide: BorderSide(
                    color: Color(0xff424242), width: 1)),
            focusedBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(18)),
                borderSide: BorderSide(
                    color: Color(0xff2c2c2c), width: 2))),
        controller: writepost,
      ),
    ),
      enters
          ? const Text(
        "Enter your message...",
        style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w600,
            fontFamily: 'verdana',
            fontSize: 12),
      )
          : const SizedBox(
        height: 0,
      ),
      const SizedBox(
        height: 5,
      ),
      const SizedBox(height: 10,),
      postl
          ? LoadingAnimationWidget.threeArchedCircle(
          color: const Color(0xffea8537), size: 38)
          : OutlinedButton(
          style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.black, width: 1),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          onPressed: () async {
            if(writepost.text==""){
              setState(() {
                enters = true;
              });
            }else{
              String? mymail = messagewalamail.replaceAll("@", '');
              String? minemail = mymail.replaceAll(".", "");
              String? jh = EmailIdp.replaceAll("@", '');
              String? ail = jh.replaceAll(".", "");
              setState(() {
                postl = true;
              });

              refd = FirebaseDatabase.instance.ref("Messages/$minemail");
              String key = refd.push().key!;
              final jsona = {
                "Name": Namep,
                "PhotoUrl": PhotoUrlp,
                "Email_ID": EmailIdp,
                "Hall": Hallp,
                "Year": Yearp,
                "Department": Departmentp,
                "Post": writepost.text,
                "ID": key,
              };



              refdo = FirebaseDatabase.instance.ref("OutMessages/$ail");
              final jsonk = {
                "Name": name,
                "PhotoUrl": photourl,
                "Email_ID": messagewalamail,
                "Hall": hall,
                "Year": year,
                "Department": dept,
                "Post": writepost.text,
                "ID": key,
              };

              await refd.child(key).set(jsona);
              await refdo.child(key).set(jsonk);


              DatabaseReference get =
              FirebaseDatabase.instance.ref("Unread/$minemail");
              get.once().then((value) async {
                DataSnapshot snap = value.snapshot;
                if (snap.exists) {
                  Map<dynamic, dynamic> map = snap.value as Map;
                  int yu = map["number"];
                  final json = {
                    "number": yu + 1
                  };
                  DatabaseReference ge =
                  FirebaseDatabase.instance.ref("Unread/$minemail");
                  await ge.set(json);
                } else {
                  final json = {
                    "number": 1
                  };
                  DatabaseReference ge =
                  FirebaseDatabase.instance.ref("Unread/$minemail");
                  await ge.set(json);
                }
              });

              String? mymails = messagewalamail.replaceAll("@", '');
              String? minemails = mymails.replaceAll(".", "");
              String toParams = '/topics/'+minemails;
              var data = {
                'to': '${toParams}',
                'priority': 'high',
                'notification':{
                  'title': 'Message - $Namep',
                  'body': writepost.text,

                }
              };
              await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'), body: jsonEncode(data ), headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'key=AAAAvYftPK8:APA91bH9CqoAbmH7pLUZI5CpHKVB-K_1AmUV13Ic1FQnASqd8WJ4yYPkCGCXFeMOzzisMXH8Md9maDGsbrgJRua8qp0lVq5HClGUzqpUteB0de9qYFR8D7U94ZtNFjYs8qNaM-TBRZB7'
              });




              writepost.clear();


              postl = false;
              Navigator.pop(context);
            }
          },
          child: const Text(
            "Message",
            style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),
          )),
      const SizedBox(height: 10,)
    ]),),);
  }

  @override
  void initState() {
    String? mymail = messagewalamail.replaceAll("@", '');
    String? minemail = mymail.replaceAll(".", "");
    DatabaseReference geto =
    FirebaseDatabase.instance.ref("UserData/$minemail");
    geto.once().then((value) {
      DataSnapshot snap = value.snapshot;
      Map<dynamic, dynamic> map = snap.value as Map;
      setState(() {
        dept = map["Department"];
        name = map["Name"];
        hall = map["Hall"];
        photourl = map["PhotoUrl"];
        year = map["Year"];
      });
    });
  }
}
