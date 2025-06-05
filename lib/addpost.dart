import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_information/device_information.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kgppanchayat/temp.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'main.dart';
import 'package:http/http.dart' as http;

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  List<String> channellist = <String>['Select', 'All', 'Dept', 'Hall', 'Event', 'Fundae', 'Lost & Found'];
  final writepost = TextEditingController();
  String imageUrl = "";
  bool postl = false;
  late DatabaseReference refd;
  late DatabaseReference myrefd;
  bool showi = false;
  bool showd = false;
  String filesurl = "";
  File? file;
  bool showtempi = false;
  int prog = 101;
  bool showt = false;
  bool showp = false;
  bool plsel = false;
  bool enters = false;
  int jot = 0;
  int joh = 0;
  int jor = 0;
  int joe = 0;
  int jof = 0;
  String selectedValue = "Select";
  bool eventwarning = false;



  @override
  Widget build(BuildContext context) {
    setState(() {
      if(selectedValue=="Event"){
        eventwarning = true;
      }else{
        eventwarning = false;
      }
    });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black,),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Temp()),
                ModalRoute.withName("/Temp"));
          },
        ),
        toolbarHeight: 50,
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: const Color(0xffffdfaf),
        titleSpacing: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: true,
        title: const Text(
          "New Post",
          style: TextStyle(color: Colors.black, fontFamily: 'courgette'),
        ),
      ),
      body: Container(
        color: Color(0xfff1f2f6),
        height: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              Row(children: [
                const SizedBox(
                  width: 30,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text("Choose Channel:",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontFamily: 'gupter',
                          fontSize: 22)),
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  width: 158,
                  height: 60,
                  child: DropdownButtonFormField<String>(
                    value: selectedValue,
                    icon: Image.asset('images/ddrop.png'),
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder( //
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),// <-- SEE HERE
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder( //<-- SEE HERE
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    dropdownColor: Colors.white,
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                    items: channellist.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(fontSize: 18, fontFamily: 'glory',fontWeight: FontWeight.bold),),
                      );
                    }).toList(),
                  ),
                ),
              ]),
              SizedBox(height: 8,),
              plsel
                  ? const Text(
                      "Choose Channel First",
                  style: TextStyle(color: Color(0xfff87700))
                    )
                  : const SizedBox(
                      height: 0,
                    ),

              SizedBox(height: 25,),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                child: TextField(
                  style: const TextStyle(fontSize: 20, color: Colors.black,fontFamily: 'martel'),
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 5,
                  decoration:  const InputDecoration(
                      hintStyle: TextStyle(fontSize: 20, color: Color(
                        0xffb6b4b4,),fontFamily: 'martel'),
                      filled: true,
                      hintText: "Write Something...",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          borderSide: BorderSide(
                              color: Color(0xff2c2c2c), width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          borderSide: BorderSide(
                              color: Color(0xff2c2c2c), width: 2))),
                  controller: writepost,
                ),
              ),
              enters
                  ? const Text(
                "Write Something...",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'verdana',
                    fontSize: 12),
              )
                  : const SizedBox(
                height: 0,
              ),

              SizedBox(height: 80,),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                GestureDetector(onTap: () async {
                  final firebaseStorage0 = FirebaseStorage.instance;
                  final imagePicker = ImagePicker();
                  XFile? image;
                  //Check Permissions

                  await Permission.photos.request();
                  var permissionStatuss = await Permission.photos.status;
                  if (permissionStatuss.isGranted) {
                    //Select Image
                    image = await imagePicker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (image != null) {
                      //Upload to Firebase
                      XFile g = image;
                      setState(() {
                        file = File(g.path);
                        showtempi = true;
                      });
                      String? hj =
                          FirebaseDatabase.instance.ref("Storage").push().key;
                      var snapshot = firebaseStorage0
                          .ref("KGP Images/${hj!}")
                          .putData(await image.readAsBytes());

                      snapshot.snapshotEvents
                          .listen((TaskSnapshot taskSnapshot) async {
                        switch (taskSnapshot.state) {
                          case TaskState.running:
                            setState(() {
                              showt = true;
                              showp = true;
                            });
                            final progress = 100.0 *
                                (taskSnapshot.bytesTransferred /
                                    taskSnapshot.totalBytes);
                            setState(() {
                              prog = progress.toInt();
                            });
                            break;
                          case TaskState.paused:
                            break;
                          case TaskState.canceled:
                            break;
                          case TaskState.error:
                          // Handle unsuccessful uploads
                            break;
                          case TaskState.success:
                            imageUrl = await (await snapshot).ref.getDownloadURL();
                            setState(() {
                              filesurl = imageUrl;
                              showp = false;
                              showi = true;
                            });

                            // Handle successful uploads on complete
                            // ...
                            break;
                        }
                      });
                    } else {
                    }
                  } else {
                  }
                },child: Image.asset('images/imgupload.png', height: 50,),),
                const SizedBox(
                  width: 25,
                ),
                GestureDetector(onTap: () async {
                  final firebaseStorage = FirebaseStorage.instance;
                  FilePickerResult? result;
                  await Permission.mediaLibrary.request();

                  var permissionStatuss = await Permission.mediaLibrary.status;
                  if (permissionStatuss.isGranted) {
                    //Select Image
                    result = await FilePicker.platform.pickFiles(withData: true);
                    if (result != null) {
                      Uint8List? fileBytes = result.files.first.bytes;
                      //Upload to Firebase
                      String? hj = FirebaseDatabase.instance
                          .ref("Storage")
                          .push()
                          .key;
                      var snapshot = firebaseStorage
                          .ref("KGP Docs/${hj!}")
                          .putData(fileBytes!);

                      snapshot.snapshotEvents
                          .listen((TaskSnapshot taskSnapshot) async {
                        switch (taskSnapshot.state) {
                          case TaskState.running:
                            setState(() {
                              showt = true;
                              showp = true;
                            });
                            final progress = 100.0 *
                                (taskSnapshot.bytesTransferred /
                                    taskSnapshot.totalBytes);
                            setState(() {
                              prog = progress.toInt();
                            });
                            break;
                          case TaskState.paused:
                            break;
                          case TaskState.canceled:
                            break;
                          case TaskState.error:
                          // Handle unsuccessful uploads
                            break;
                          case TaskState.success:
                            imageUrl =
                            await (await snapshot).ref.getDownloadURL();
                            setState(() {
                              filesurl = imageUrl;
                              showp = false;
                              showd = true;
                            });

                            // Handle successful uploads on complete
                            // ...
                            break;
                        }
                      });
                    } else {
                    }
                  } else {

                  }

                },child: Image.asset('images/docc.png', height: 50,),),
              ]),
              showtempi
                  ? Image.file(
                file!,
                height: 250,
              )
                  : const SizedBox(
                height: 0,
              ),

              showp
                  ? Column(
                    children: [const SizedBox(
                      height: 10,
                    ),LoadingAnimationWidget.threeArchedCircle(
                    color: Color(0xffea8537), size: 60),
                  ])
                  : const SizedBox(
                height: 0,
              ),

              showt
                  ? Column(children: [const SizedBox(
                height: 10,
              ),Text("$prog% Uploaded", style: const TextStyle(fontFamily: 'gupter',color: Colors.deepOrangeAccent, fontSize: 20))])
                  : const SizedBox(
                height: 0,
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
                        if (selectedValue == "Select") {
                          setState(() {
                            plsel = true;
                          });
                        } else {
                          if(writepost.text=="" && filesurl==""){
                            setState(() {
                              enters = true;
                            });
                          }else{
                            String? mymail = EmailIdp.replaceAll("@", '');
                            String? minemail = mymail.replaceAll(".", "");
                            setState(() {
                              plsel = false;
                              postl = true;
                            });

                            switch (selectedValue) {
                              case "All":
                                refd = FirebaseDatabase.instance.ref("All");
                                myrefd = FirebaseDatabase.instance
                                    .ref("MyPost/$minemail/All");
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
                                  "Comment": 0,
                                  "FileUrl": filesurl,
                                  "showi": showi,
                                  "showd": showd
                                };

                                await refd.child(key).set(jsona);
                                await myrefd.child(key).set(jsona);

                                String toParams = '/topics/All';
                                var data = {
                                  'to': '${toParams}',
                                  'priority': 'high',
                                  'notification':{
                                  'title': 'All - $Namep',
                                  'body': writepost.text,

                                  }
                                };
                                await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'), body: jsonEncode(data ), headers: {
                                  'Content-Type': 'application/json; charset=UTF-8',
                                  'Authorization': 'key=AAAAvYftPK8:APA91bH9CqoAbmH7pLUZI5CpHKVB-K_1AmUV13Ic1FQnASqd8WJ4yYPkCGCXFeMOzzisMXH8Md9maDGsbrgJRua8qp0lVq5HClGUzqpUteB0de9qYFR8D7U94ZtNFjYs8qNaM-TBRZB7'
                                });

                                writepost.clear();
                                break;
                              case "Dept":
                                refd = FirebaseDatabase.instance
                                    .ref("Academic/$Departmentp");
                                myrefd = FirebaseDatabase.instance
                                    .ref("MyPost/$minemail/Academic");
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
                                  "Comment": 0,
                                  "FileUrl": filesurl,
                                  "showi": showi,
                                  "showd": showd
                                };

                                await refd.child(key).set(jsona);
                                await myrefd.child(key).set(jsona);

                                String toParams = '/topics/$Departmentp';
                                var data = {
                                  'to': '${toParams}',
                                  'priority': 'high',
                                  'notification':{
                                    'title': '$Departmentp - $Namep',
                                    'body': writepost.text,

                                  }
                                };
                                await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'), body: jsonEncode(data ), headers: {
                                  'Content-Type': 'application/json; charset=UTF-8',
                                  'Authorization': 'key=AAAAvYftPK8:APA91bH9CqoAbmH7pLUZI5CpHKVB-K_1AmUV13Ic1FQnASqd8WJ4yYPkCGCXFeMOzzisMXH8Md9maDGsbrgJRua8qp0lVq5HClGUzqpUteB0de9qYFR8D7U94ZtNFjYs8qNaM-TBRZB7'
                                });


                                writepost.clear();
                                break;
                              case "Hall":
                                refd = FirebaseDatabase.instance.ref("Hall/$Hallp");
                                myrefd = FirebaseDatabase.instance
                                    .ref("MyPost/$minemail/Hall");
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
                                  "Comment": 0,
                                  "FileUrl": filesurl,
                                  "showi": showi,
                                  "showd": showd
                                };

                                await refd.child(key).set(jsona);
                                await myrefd.child(key).set(jsona);

                                String toParams = '/topics/$Hallp';
                                var data = {
                                  'to': '${toParams}',
                                  'priority': 'high',
                                  'notification':{
                                    'title': '$Hallp - $Namep',
                                    'body': writepost.text,

                                  }
                                };
                                await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'), body: jsonEncode(data ), headers: {
                                  'Content-Type': 'application/json; charset=UTF-8',
                                  'Authorization': 'key=AAAAvYftPK8:APA91bH9CqoAbmH7pLUZI5CpHKVB-K_1AmUV13Ic1FQnASqd8WJ4yYPkCGCXFeMOzzisMXH8Md9maDGsbrgJRua8qp0lVq5HClGUzqpUteB0de9qYFR8D7U94ZtNFjYs8qNaM-TBRZB7'
                                });


                                writepost.clear();
                                break;
                              case "Event":
                                refd = FirebaseDatabase.instance.ref("EventApproval");
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
                                  "Comment": 0,
                                  "FileUrl": filesurl,
                                  "showi": showi,
                                  "showd": showd
                                };

                                await refd.child(key).set(jsona);
                                writepost.clear();
                                break;
                              case "Fundae":
                                refd = FirebaseDatabase.instance.ref("Funde");
                                myrefd = FirebaseDatabase.instance
                                    .ref("MyPost/$minemail/Funde");
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
                                  "Comment": 0,
                                  "FileUrl": filesurl,
                                  "showi": showi,
                                  "showd": showd
                                };

                                await refd.child(key).set(jsona);
                                await myrefd.child(key).set(jsona);

                                String toParams = '/topics/Fundae';
                                var data = {
                                  'to': '${toParams}',
                                  'priority': 'high',
                                  'notification':{
                                    'title': 'Fundae - $Namep',
                                    'body': writepost.text,

                                  }
                                };
                                await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'), body: jsonEncode(data ), headers: {
                                  'Content-Type': 'application/json; charset=UTF-8',
                                  'Authorization': 'key=AAAAvYftPK8:APA91bH9CqoAbmH7pLUZI5CpHKVB-K_1AmUV13Ic1FQnASqd8WJ4yYPkCGCXFeMOzzisMXH8Md9maDGsbrgJRua8qp0lVq5HClGUzqpUteB0de9qYFR8D7U94ZtNFjYs8qNaM-TBRZB7'
                                });


                                writepost.clear();
                                break;
                              case "Lost and Found":
                                refd = FirebaseDatabase.instance.ref("Lost");
                                myrefd = FirebaseDatabase.instance
                                    .ref("MyPost/$minemail/Lost");
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
                                  "Comment": 0,
                                  "FileUrl": filesurl,
                                  "showi": showi,
                                  "showd": showd
                                };

                                await refd.child(key).set(jsona);
                                await myrefd.child(key).set(jsona);

                                String toParams = '/topics/Lost';
                                var data = {
                                  'to': '${toParams}',
                                  'priority': 'high',
                                  'notification':{
                                    'title': 'Lost & Found - $Namep',
                                    'body': writepost.text,

                                  }
                                };
                                await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'), body: jsonEncode(data ), headers: {
                                  'Content-Type': 'application/json; charset=UTF-8',
                                  'Authorization': 'key=AAAAvYftPK8:APA91bH9CqoAbmH7pLUZI5CpHKVB-K_1AmUV13Ic1FQnASqd8WJ4yYPkCGCXFeMOzzisMXH8Md9maDGsbrgJRua8qp0lVq5HClGUzqpUteB0de9qYFR8D7U94ZtNFjYs8qNaM-TBRZB7'
                                });

                                writepost.clear();
                                break;
                            }
                            postl = false;
                            Navigator.pop(context);
                          }



                        }
                      },
                      child: const Text(
                        "Post",
                        style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),
                      )),
              eventwarning ? const Text("*Posts in event section will be verified\nbefore posting", textAlign: TextAlign.center,style: TextStyle(color: Color(0xfff87700),),) : SizedBox(height: 0,),

              const SizedBox(height: 10,)


            ],
          ),
        ),
      ),
    );
  }
}

