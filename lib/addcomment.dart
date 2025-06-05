import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'getterc.dart';
import 'main.dart';
import 'package:http/http.dart' as http;

class AddComment extends StatefulWidget {
  const AddComment({Key? key}) : super(key: key);

  @override
  State<AddComment> createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  final writepost = TextEditingController();
  bool showi = false;
  bool showd = false;
  String imageUrl = "";
  String filesurl = "";
  int prog = 101;
  bool postl = false;
  bool showtempi = false;
  bool enters = false;
  bool showt = false;
  bool showp = false;
  File? file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: const Color(0xffffdfaf),
        titleSpacing: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: true,
        iconTheme:IconThemeData(color: Colors.black),
        title: const Text(
          "New Comment",
          style: TextStyle(color: Colors.black, fontFamily: 'courgette'),
        ),
      ),
      body: Container(
        color: Color(0xfff1f2f6),
        height: double.maxFinite,
        child: SingleChildScrollView(child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
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
                final firebaseStorage = FirebaseStorage.instance;
                final imagePicker = ImagePicker();
                XFile? image;
                //Check Permissions
                await Permission.photos.request();

                var permissionStatus = await Permission.photos.status;

                if (permissionStatus.isGranted) {
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
                    var snapshot = firebaseStorage
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
                final firebaseStorage0 = FirebaseStorage.instance;
                FilePickerResult? result;
                await Permission.mediaLibrary.request();

                var permissionStatus = await Permission.mediaLibrary.status;

                if (permissionStatus.isGranted) {
                  //Select Image
                  result = await FilePicker.platform.pickFiles(withData: true);
                  if (result != null) {
                    Uint8List? fileBytes = result.files.first.bytes;
                    //Upload to Firebase
                    String? hj = FirebaseDatabase.instance
                        .ref("Storage")
                        .push()
                        .key;
                    var snapshot = firebaseStorage0
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
                    color: const Color(0xffea8537), size: 60),
                ])
                : const SizedBox(
              height: 0,
            ),

            showt
                ? Column(children: [const SizedBox(
              height: 10,
            ),Text("$prog% Uploaded", style: const TextStyle(fontFamily: 'chivo',color: Color(0xff8a8989)))])
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
                  if(writepost.text=="" && filesurl==""){
                    setState(() {
                      enters = true;
                    });
                  }else{
                    setState(() {
                      postl = true;
                    });
                    DatabaseReference refd = FirebaseDatabase
                        .instance
                        .ref("Comment/$commentId");
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
                      "FileUrl": filesurl,
                      "showi": showi,
                      "showd": showd
                    };

                    await refd.child(key).set(jsona);


                    String? mymails = postmail.replaceAll("@", '');
                    String? minemails = mymails.replaceAll(".", "");
                    String toParams = '/topics/'+minemails;
                    var data = {
                      'to': '${toParams}',
                      'priority': 'high',
                      'notification':{
                        'title': 'Comment - $Namep',
                        'body': writepost.text,

                      }
                    };
                    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'), body: jsonEncode(data ), headers: {
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Authorization': 'key=AAAAvYftPK8:APA91bH9CqoAbmH7pLUZI5CpHKVB-K_1AmUV13Ic1FQnASqd8WJ4yYPkCGCXFeMOzzisMXH8Md9maDGsbrgJRua8qp0lVq5HClGUzqpUteB0de9qYFR8D7U94ZtNFjYs8qNaM-TBRZB7'
                    });

                    switch(kc){
                      case 1:
                        DatabaseReference df = FirebaseDatabase
                            .instance
                            .ref("All/$commentId");
                        df.once().then((value) {
                          DataSnapshot sd = value.snapshot;
                          Map<dynamic, dynamic> kl = sd.value as Map;
                          int hj = kl["Comment"] + 1;
                          DatabaseReference dff = FirebaseDatabase
                              .instance
                              .ref("All/$commentId/Comment");
                          dff.set(hj);
                        });

                        String? mymail = EmailIdp.replaceAll("@", '');
                        String? minemail = mymail.replaceAll(".", "");
                        DatabaseReference dfo = FirebaseDatabase
                            .instance
                            .ref("MyPost/$minemail/All/$commentId");
                        dfo.once().then((values) {
                          DataSnapshot sdo = values.snapshot;
                          Map<dynamic, dynamic> klo =
                          sdo.value as Map;
                          int hj = klo["Comment"] + 1;
                          DatabaseReference dffo =
                          FirebaseDatabase.instance.ref(
                              "MyPost/$minemail/All/$commentId/Comment");
                          dffo.set(hj);
                        });
                        break;
                      case 2:
                        DatabaseReference df = FirebaseDatabase.instance.ref("Academic/$Departmentp/$commentId");
                        df.once().then((value) {
                          DataSnapshot sd = value.snapshot;
                          Map<dynamic,dynamic> kl = sd.value as Map;
                          int hj = kl["Comment"]+1;
                          DatabaseReference dff = FirebaseDatabase.instance.ref("Academic/$Departmentp/$commentId/Comment");
                          dff.set(hj);
                        });

                        String? mymail = EmailIdp.replaceAll("@", '');
                        String? minemail = mymail.replaceAll(".", "");
                        DatabaseReference dfo = FirebaseDatabase.instance.ref("MyPost/$minemail/Academic/$commentId");
                        dfo.once().then((values) {
                          DataSnapshot sdo = values.snapshot;
                          Map<dynamic,dynamic> klo = sdo.value as Map;
                          int hj = klo["Comment"]+1;
                          DatabaseReference dffo = FirebaseDatabase.instance.ref("MyPost/$minemail/Academic/$commentId/Comment");
                          dffo.set(hj);
                        });
                        break;
                      case 3:
                        DatabaseReference df = FirebaseDatabase.instance.ref("Hall/$Hallp/$commentId");
                        df.once().then((value) {
                          DataSnapshot sd = value.snapshot;
                          Map<dynamic,dynamic> kl = sd.value as Map;
                          int hj = kl["Comment"]+1;
                          DatabaseReference dff = FirebaseDatabase.instance.ref("Hall/$Hallp/$commentId/Comment");
                          dff.set(hj);
                        });

                        String? mymail = EmailIdp.replaceAll("@", '');
                        String? minemail = mymail.replaceAll(".", "");
                        DatabaseReference dfo = FirebaseDatabase.instance.ref("MyPost/$minemail/Hall/$commentId");
                        dfo.once().then((values) {
                          DataSnapshot sdo = values.snapshot;
                          Map<dynamic,dynamic> klo = sdo.value as Map;
                          int hj = klo["Comment"]+1;
                          DatabaseReference dffo = FirebaseDatabase.instance.ref("MyPost/$minemail/Hall/$commentId/Comment");
                          dffo.set(hj);
                        });
                        break;
                      case 4:
                        DatabaseReference df = FirebaseDatabase
                            .instance
                            .ref("Event/$commentId");
                        df.once().then((value) {
                          DataSnapshot sd = value.snapshot;
                          Map<dynamic, dynamic> kl = sd.value as Map;
                          int hj = kl["Comment"] + 1;
                          DatabaseReference dff = FirebaseDatabase
                              .instance
                              .ref("Event/$commentId/Comment");
                          dff.set(hj);
                        });

                        String? mymail = EmailIdp.replaceAll("@", '');
                        String? minemail = mymail.replaceAll(".", "");
                        DatabaseReference dfo = FirebaseDatabase
                            .instance
                            .ref("MyPost/$minemail/Event/$commentId");
                        dfo.once().then((values) {
                          DataSnapshot sdo = values.snapshot;
                          Map<dynamic, dynamic> klo =
                          sdo.value as Map;
                          int hj = klo["Comment"] + 1;
                          DatabaseReference dffo =
                          FirebaseDatabase.instance.ref(
                              "MyPost/$minemail/Event/$commentId/Comment");
                          dffo.set(hj);
                        });
                        break;
                      case 5:
                        DatabaseReference df = FirebaseDatabase
                            .instance
                            .ref("Funde/$commentId");
                        df.once().then((value) {
                          DataSnapshot sd = value.snapshot;
                          Map<dynamic, dynamic> kl = sd.value as Map;
                          int hj = kl["Comment"] + 1;
                          DatabaseReference dff = FirebaseDatabase
                              .instance
                              .ref("Funde/$commentId/Comment");
                          dff.set(hj);
                        });

                        String? mymail = EmailIdp.replaceAll("@", '');
                        String? minemail = mymail.replaceAll(".", "");
                        DatabaseReference dfo = FirebaseDatabase
                            .instance
                            .ref("MyPost/$minemail/Funde/$commentId");
                        dfo.once().then((values) {
                          DataSnapshot sdo = values.snapshot;
                          Map<dynamic, dynamic> klo =
                          sdo.value as Map;
                          int hj = klo["Comment"] + 1;
                          DatabaseReference dffo =
                          FirebaseDatabase.instance.ref(
                              "MyPost/$minemail/Funde/$commentId/Comment");
                          dffo.set(hj);
                        });
                        break;
                      case 6:
                        DatabaseReference df = FirebaseDatabase
                            .instance
                            .ref("Lost/$commentId");
                        df.once().then((value) {
                          DataSnapshot sd = value.snapshot;
                          Map<dynamic, dynamic> kl = sd.value as Map;
                          int hj = kl["Comment"] + 1;
                          DatabaseReference dff = FirebaseDatabase
                              .instance
                              .ref("Lost/$commentId/Comment");
                          dff.set(hj);
                        });

                        String? mymail = EmailIdp.replaceAll("@", '');
                        String? minemail = mymail.replaceAll(".", "");
                        DatabaseReference dfo = FirebaseDatabase
                            .instance
                            .ref("MyPost/$minemail/Lost/$commentId");
                        dfo.once().then((values) {
                          DataSnapshot sdo = values.snapshot;
                          Map<dynamic, dynamic> klo =
                          sdo.value as Map;
                          int hj = klo["Comment"] + 1;
                          DatabaseReference dffo =
                          FirebaseDatabase.instance.ref(
                              "MyPost/$minemail/Lost/$commentId/Comment");
                          dffo.set(hj);
                        });
                        break;
                    }



                    listc.clear();
                    cid.clear();

                    DatabaseReference reference = FirebaseDatabase
                        .instance
                        .ref("Comment/$commentId");
                    reference.once().then((value) {
                      DataSnapshot snap = value.snapshot;
                      Map<dynamic, dynamic> map =
                      snap.value as Map;
                      j = map.length;
                    });
                    reference
                        .orderByChild("ID")
                        .onChildAdded
                        .listen((DatabaseEvent value) {
                      DataSnapshot snapshot = value.snapshot;

                      Map<dynamic, dynamic> map =
                      snapshot.value as Map;
                      DetailsC de = DetailsC(
                          Name: map["Name"],
                          PhotoUrl: map["PhotoUrl"],
                          Email_ID: map["Email_ID"],
                          Hall: map["Hall"],
                          Year: map["Year"],
                          Department: map["Department"],
                          Post: map["Post"],
                          ID: map["ID"],
                          FileUrl: map["FileUrl"],
                          showi: map["showi"],
                          showd: map["showd"],
                        lb: false,
                        like: 0,
                        sb: false
                      );
                      setState(() {
                        if (listc.length != j) {
                          if (cid.contains(map["ID"])) {
                          } else {
                            listc.insert(0, de);
                            cid.insert(0, map["ID"]);
                          }
                        }
                      });
                    });


                    writepost.clear();

                    Navigator.pop(context);
                  }

                  },
                child: const Text(
                  "Comment",
                  style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),
                )),
            const SizedBox(height: 10,)
          ],
        ),),
      ),
    );
  }
}
