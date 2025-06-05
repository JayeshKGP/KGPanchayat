import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';
import 'package:http/http.dart' as http;

class StudyiDialog extends StatefulWidget {
  const StudyiDialog({Key? key}) : super(key: key);

  @override
  State<StudyiDialog> createState() => _StudyiDialogState();
}

class _StudyiDialogState extends State<StudyiDialog> {
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
    children: [SizedBox(height: 15,),
      Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: Text("If you want to contribute to study material, click the button below.", style: TextStyle(fontFamily: 'glory', fontWeight: FontWeight.bold, fontSize: 20),)),
      const SizedBox(
        height: 5,
      ),
      const SizedBox(height: 10,),
      OutlinedButton(
          style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.black, width: 1),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          onPressed: () {
            Navigator.of(context).pop();
            String link = "mailto:jdcodekgp@gmail.com?subject=Regarding Study Material&body=Name: $Namep\nEmail ID: $EmailIdp\n";
            launchUrl(Uri.parse(link),
                mode: LaunchMode.externalApplication);
          },
          child: const Text(
            "Contact Us",
            style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),
          )),
      const SizedBox(height: 10,)
    ]),),);
  }

}
