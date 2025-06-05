import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kgppanchayat/personprofile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'getterc.dart';
import 'main.dart';
import 'messagedialog.dart';
import 'mypost.dart';
import 'showimage.dart';
import 'temp.dart';
import 'addcomment.dart';

class Comment extends StatefulWidget {
  const Comment({Key? key}) : super(key: key);

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  bool countbool= false;
  String? bn = "";
  @override
  Widget build(BuildContext context) {
    bn = FirebaseAuth.instance.currentUser?.displayName;
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("Comment/$commentId");
    reference.once().then((value) {
      DataSnapshot snap = value.snapshot;
      setState(() {
        if(snap.exists){
          countbool = false;
        }else{
          countbool = true;
        }
      });
      Map<dynamic, dynamic> map = snap.value as Map;
      j = map.length;
    });
    reference.orderByChild("ID").onChildAdded.listen((DatabaseEvent value) {
      DataSnapshot snapshot = value.snapshot;

      Map<dynamic, dynamic> map = snapshot.value as Map;
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
      sb: false);
      setState(() {
        if (listc.length != j) {
          if (listc.length < j) {
            if (cid.contains(map["ID"])) {
            } else {
              listc.insert(0, de);
              cid.insert(0, map["ID"]);
            }
          } else if (listc.length > j) {
            listc.clear();
            cid.clear();
            listc.insert(0, de);
            cid.insert(0, map["ID"]);
          }
        }
      });
    });


    return WillPopScope(
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => kon ? const Temp() : const MyPost()),
              ModalRoute.withName("/Temp"));

          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            kon ? const Temp() : const MyPost()),
                    ModalRoute.withName("/Temp"));
              },
            ),
            toolbarHeight: 50,
            bottomOpacity: 0.0,
            elevation: 0.0,
            backgroundColor: const Color(0xffffdfaf),
            titleSpacing: 0,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            title: const Text(
              "Comments",
              style: TextStyle(color: Colors.black, fontFamily: 'gupter'),
            ),
          ),
          body: countbool
              ? Center(child: const Text("Click on '+' to add first comment.", style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'glory', fontWeight: FontWeight.bold)))
              : Container(
              height: double.maxFinite,
              color: const Color(0xfff1f2f6),
              child: Column(
                children: [Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: listc.length,
                      itemBuilder: (_, index) {
                        String name = listc[index].Name;
                        String photoUrl = listc[index].PhotoUrl;
                        String emailId = listc[index].Email_ID;
                        String hall = listc[index].Hall;
                        String year = listc[index].Year;
                        String department = listc[index].Department;
                        String post = listc[index].Post;
                        String iD = listc[index].ID;
                        String fileUrl = listc[index].FileUrl;
                        bool showi = listc[index].showi;
                        bool showd = listc[index].showd;

                        String? mymail = EmailIdp.replaceAll("@", '');
                        String? minemail = mymail.replaceAll(".", "");

                        late String firstHalf;
                        late String secondHalf;

                        if (post.length > 85) {
                          firstHalf = post.substring(0, 85);
                          secondHalf = post.substring(85, post.length);
                        } else {
                          firstHalf = post;
                          secondHalf = "";
                        }

                        DatabaseReference get =
                        FirebaseDatabase.instance.ref("Likes/$iD");
                        get.once().then((value) async {
                          DataSnapshot snap = value.snapshot;
                          if (snap.exists) {
                            Map<dynamic, dynamic> map = snap.value as Map;
                            setState(() {
                              listc[index].like = map["like"];
                            });
                          }
                        });

                        DatabaseReference geta =
                        FirebaseDatabase.instance.ref("Liked/$iD/$minemail/");
                        geta.once().then((value) async {
                          DataSnapshot snap = value.snapshot;
                          if (snap.exists) {
                            listc[index].lb = true;
                          } else {
                            listc[index].lb = false;
                          }
                        });

                        String? je = emailId.replaceAll("@", '');
                        String? postmail = je.replaceAll(".", "");

                        DatabaseReference bad =
                        FirebaseDatabase.instance.ref("Badge/$postmail/");
                        bad.once().then((value) async {
                          DataSnapshot snap = value.snapshot;
                          if (snap.exists) {
                            listc[index].sb = true;
                          } else {
                            listc[index].sb = false;
                          }
                        });


                        return Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(7),
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (BuildContext context) {
                                              personmail = emailId;
                                              return const PersonProfile();
                                            }));
                                      },
                                      child: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: CachedNetworkImage(
                                          imageUrl: photoUrl,
                                          progressIndicatorBuilder: (_, url,
                                              download) {
                                            if (download.progress != null) {
                                              final percent = download.progress! * 100;
                                              return Center(
                                                child: CircularProgressIndicator(
                                                    color: const Color(0xff8a8989),
                                                    value: percent
                                                ),
                                              );
                                            }

                                            return const Text("");
                                          },
                                          imageBuilder: (context, imageProvider) =>
                                              Container(
                                                width: 42.0,
                                                height: 42.0,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: imageProvider, fit: BoxFit.cover),
                                                ),
                                              ),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                                personmail = emailId;
                                                return const PersonProfile();
                                              }));
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 0),
                                          child: Row(
                                              children: [SizedBox(
                                                width: 200,
                                                child: Text(
                                                  name,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: 'gupter',
                                                      color: Colors.black),
                                                ),
                                              ),listc[index].sb ? Image.asset('images/verr.png', width: 20, height: 20,) : SizedBox(width: 0,),
                                              ]
                                          ),
                                        ),
                                        Text(
                                          "$year Year, $department, $hall",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'gupter',
                                              color: Color(0xff8a8989),
                                              fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Spacer(),

                                  (emailId!=EmailIdp)? IconButton(onPressed: (){
                                    showDialog(
                                        context: context,
                                        builder: (_){
                                          messagewalamail = emailId;
                                          return Dialog(shape:
                                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),child: const MessageDialog(),);
                                        }
                                    );
                                  }, icon: Image.asset('images/mmess.png',height: 25, width: 25,)) : SizedBox(width: 0,),


                                  emailId == EmailIdp
                                      ? Align(
                                    alignment: Alignment.bottomRight,
                                    child: IconButton(
                                        onPressed: () async {
                                          // set up the button
                                          Widget no = OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                                backgroundColor: const Color(0xffffc491),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(30))),
                                            child: const Text(
                                              "NO",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontFamily: 'gupter',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          );
                                          Widget yes = TextButton(
                                            child: const Text(
                                              "YES",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontFamily: 'gupter',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            onPressed: () async {
                                              DatabaseReference delre = FirebaseDatabase
                                                  .instance
                                                  .ref("Comment/$commentId/$iD");
                                              await delre.remove();

                                              setState(() {
                                                listc.clear();
                                                cid.clear();

                                                DatabaseReference reference =
                                                FirebaseDatabase.instance
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
                                                  sb: false);
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


                                                switch (kc){
                                                  case 1:
                                                    DatabaseReference df = FirebaseDatabase
                                                        .instance
                                                        .ref("All/$commentId");
                                                    df.once().then((value) {
                                                      DataSnapshot sd = value.snapshot;
                                                      Map<dynamic, dynamic> kl =
                                                      sd.value as Map;
                                                      int hj = kl["Comment"] - 1;
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
                                                      int hj = klo["Comment"] - 1;
                                                      DatabaseReference dffo =
                                                      FirebaseDatabase.instance.ref(
                                                          "MyPost/$minemail/All/$commentId/Comment");
                                                      dffo.set(hj);
                                                    });
                                                    break;
                                                  case 2:
                                                    DatabaseReference df =
                                                    FirebaseDatabase.instance.ref(
                                                        "Academic/$Departmentp/$commentId");
                                                    df.once().then((value) {
                                                      DataSnapshot sd = value.snapshot;
                                                      Map<dynamic, dynamic> kl =
                                                      sd.value as Map;
                                                      int hj = kl["Comment"] - 1;
                                                      DatabaseReference dff =
                                                      FirebaseDatabase.instance.ref(
                                                          "Academic/$Departmentp/$commentId/Comment");
                                                      dff.set(hj);
                                                    });
                                                    String? mymail = EmailIdp.replaceAll("@", '');
                                                    String? minemail = mymail.replaceAll(".", "");
                                                    DatabaseReference dfo =
                                                    FirebaseDatabase.instance.ref(
                                                        "MyPost/$minemail/Academic/$commentId");
                                                    dfo.once().then((values) {
                                                      DataSnapshot sdo = values.snapshot;
                                                      Map<dynamic, dynamic> klo =
                                                      sdo.value as Map;
                                                      int hj = klo["Comment"] - 1;
                                                      DatabaseReference dffo =
                                                      FirebaseDatabase.instance.ref(
                                                          "MyPost/$minemail/Academic/$commentId/Comment");
                                                      dffo.set(hj);
                                                    });
                                                    break;
                                                  case 3:
                                                    DatabaseReference df = FirebaseDatabase.instance.ref("Hall/$Hallp/$commentId");
                                                    df.once().then((value) {
                                                      DataSnapshot sd = value.snapshot;
                                                      Map<dynamic,dynamic> kl = sd.value as Map;
                                                      int hj = kl["Comment"]-1;
                                                      DatabaseReference dff = FirebaseDatabase.instance.ref("Hall/$Hallp/$commentId/Comment");
                                                      dff.set(hj);
                                                    });

                                                    String? mymail = EmailIdp.replaceAll("@", '');
                                                    String? minemail = mymail.replaceAll(".", "");
                                                    DatabaseReference dfo = FirebaseDatabase.instance.ref("MyPost/$minemail/Hall/$commentId");
                                                    dfo.once().then((values) {
                                                      DataSnapshot sdo = values.snapshot;
                                                      Map<dynamic,dynamic> klo = sdo.value as Map;
                                                      int hj = klo["Comment"]-1;
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
                                                      int hj = kl["Comment"] - 1;
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
                                                      int hj = klo["Comment"] - 1;
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
                                                      int hj = kl["Comment"] - 1;
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
                                                      int hj = klo["Comment"] - 1;
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
                                                      Map<dynamic, dynamic> kl =
                                                      sd.value as Map;
                                                      int hj = kl["Comment"] - 1;
                                                      DatabaseReference dff = FirebaseDatabase
                                                          .instance
                                                          .ref("Lost/$commentId/Comment");
                                                      dff.set(hj);
                                                    });

                                                    String? mymail =
                                                    EmailIdp.replaceAll("@", '');
                                                    String? minemail =
                                                    mymail.replaceAll(".", "");
                                                    DatabaseReference dfo = FirebaseDatabase
                                                        .instance
                                                        .ref("MyPost/$minemail/Lost/$commentId");
                                                    dfo.once().then((values) {
                                                      DataSnapshot sdo = values.snapshot;
                                                      Map<dynamic, dynamic> klo =
                                                      sdo.value as Map;
                                                      int hj = klo["Comment"] - 1;
                                                      DatabaseReference dffo =
                                                      FirebaseDatabase.instance.ref(
                                                          "MyPost/$minemail/Lost/$commentId/Comment");
                                                      dffo.set(hj);
                                                    });
                                                }


                                              });



                                              Navigator.of(context).pop();
                                            },
                                          );

                                          // set up the AlertDialog
                                          AlertDialog alert = AlertDialog(
                                            backgroundColor: Color(0xfff1f2f6),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(30))),
                                            title: const Text(
                                              "Delete Post",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.deepOrange,
                                                  fontFamily: 'rale'),
                                            ),
                                            content:
                                            const Text("Are you sure to delete this post?",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontFamily: 'gupter')),
                                            actions: [
                                              no,
                                              yes,
                                            ],
                                          );

                                          // show the dialog
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return alert;
                                            },
                                          );
                                        },

                                        icon: Image.asset('images/dell.png',height: 25,width: 25,)),
                                  )
                                      : Align(
                                    alignment: Alignment.bottomRight,
                                    child: IconButton(
                                        onPressed: () async{
                                          // set up the button
                                          Widget no = OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                                backgroundColor: const Color(0xffffc491),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(30))),
                                            child: const Text(
                                              "NO",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontFamily: 'gupter',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          );
                                          Widget yes = TextButton(
                                            child: const Text(
                                              "YES",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontFamily: 'gupter',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            onPressed: () async {
                                              DatabaseReference myrefd = FirebaseDatabase.instance
                                                  .ref("Report/Comment/$commentId");
                                              final jsona = {
                                                "Name": name,
                                                "PhotoUrl": photoUrl,
                                                "Email_ID": emailId,
                                                "Hall": hall,
                                                "Year": year,
                                                "Department": department,
                                                "Post": post,
                                                "ID": iD,
                                                "FileUrl": fileUrl,
                                                "showi": showi,
                                                "showd": showd
                                              };
                                              await myrefd.child(iD).set(jsona);

                                              Navigator.of(context).pop();
                                              Fluttertoast.showToast(msg: "Reported Successfully");

                                              String link = "mailto:jdcodekgp@gmail.com?subject=KGPanchayat Comment Report&body=Comment Details: - "+commentId+"/"+iD+"\nComment reported by $Namep, $EmailIdp\nReason of reporting:";

                                              launchUrl(Uri.parse(link),
                                                  mode: LaunchMode.externalApplication);

                                            },
                                          );

                                          // set up the AlertDialog
                                          AlertDialog alert = AlertDialog(
                                            backgroundColor: Color(0xfff1f2f6),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(30))),
                                            title: const Text(
                                              "Report",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.deepOrange,
                                                  fontFamily: 'rale'),
                                            ),
                                            content:
                                            const Text("Are you sure to report this post?",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontFamily: 'gupter')),
                                            actions: [
                                              no,
                                              yes,
                                            ],
                                          );

                                          // show the dialog
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return alert;
                                            },
                                          );
                                        },
                                      icon: Image.asset("images/spamm.png",height: 25, width: 25,)),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                              (post == "")
                                  ? const SizedBox(
                                height: 0,
                              )
                                  : Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 10.0),
                                    child: secondHalf.isEmpty
                                        ? Linkify(
                                      onOpen: (link) async {
                                        await launchUrl(Uri.parse(link.url),
                                            mode: LaunchMode.externalApplication);
                                      },
                                      text: firstHalf,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontFamily: 'martel'),
                                    )
                                        : Column(
                                      children: <Widget>[
                                        Linkify(
                                          onOpen: (link) async {
                                            await launchUrl(Uri.parse(link.url),
                                                mode: LaunchMode.externalApplication);
                                          },
                                          text: flag
                                              ? ("$firstHalf...")
                                              : (firstHalf + secondHalf),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontFamily: 'martel'),
                                        ),
                                        InkWell(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: <Widget>[
                                              Linkify(
                                                onOpen: (link) async {
                                                  await launchUrl(Uri.parse(link.url),
                                                      mode: LaunchMode
                                                          .externalApplication);
                                                },
                                                text: flag
                                                    ? ("Read More")
                                                    : ("Read Less"),
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'ysa',
                                                    color: Colors.blueAccent),
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            setState(() {
                                              flag = !flag;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  )),
                              showd
                                  ? TextButton(
                                  onPressed: () async {
                                    Uri uri = Uri.parse(fileUrl);
                                    await launchUrl(uri,
                                        mode: LaunchMode.externalApplication);
                                  },
                                  child: const Text(
                                    "Access Document",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'ysa',
                                        color: Color(0xff4e9aef)),
                                  ))
                                  : const SizedBox(
                                height: 0,
                              ),
                              showi
                                  ? Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            showimageurl = fileUrl;
                                            return const ShowImage();
                                          }));
                                    },
                                    child: CachedNetworkImage(
                                        imageUrl: fileUrl,
                                        height: 300,
                                        progressIndicatorBuilder: (_, url, download) {
                                          if (download.progress != null) {
                                            final percent = download.progress! * 100;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                  color: const Color(0xff8a8989),
                                                  value: percent),
                                            );
                                          }

                                          return const Text("");
                                        }),
                                  ))
                                  : const SizedBox(
                                height: 0,
                              ),
                              const SizedBox(
                                height: 5,
                              ),


                              Row(crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,children: [
                                  SizedBox(width: 15,),

                                  listc[index].lb ?

                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        DatabaseReference geta =
                                        FirebaseDatabase.instance.ref("Liked/$iD/$minemail/");
                                        geta.remove();
                                        DatabaseReference get =
                                        FirebaseDatabase.instance.ref("Likes/$iD");
                                        get.once().then((value) async {
                                          DataSnapshot snap = value.snapshot;
                                          if (snap.exists) {
                                            Map<dynamic, dynamic> map = snap.value as Map;
                                            setState(() {
                                              int yu = map["like"];
                                              final json = {
                                                "like": yu - 1
                                              };
                                              DatabaseReference ge =
                                              FirebaseDatabase.instance.ref("Likes/$iD");
                                              ge.set(json);
                                            });
                                          }
                                        });
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset('images/heartlike.png', height: 40, width: 40,),
                                        SizedBox(height: 5,),
                                        Text(listc[index].like.toString(),
                                          style: TextStyle(color: Colors.black),),

                                      ],
                                    ),
                                  ) :


                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        DatabaseReference get =
                                        FirebaseDatabase.instance.ref("Likes/$iD");
                                        get.once().then((value) async {
                                          DataSnapshot snap = value.snapshot;
                                          if (snap.exists) {
                                            Map<dynamic, dynamic> map = snap.value as Map;
                                            setState(() {
                                              int yu = map["like"];
                                              final json = {
                                                "like": yu + 1
                                              };
                                              DatabaseReference ge =
                                              FirebaseDatabase.instance.ref("Likes/$iD");
                                              ge.set(json);
                                              final jj = {
                                                "state": "state"
                                              };
                                              DatabaseReference geta =
                                              FirebaseDatabase.instance.ref(
                                                  "Liked/$iD/$minemail/");
                                              geta.set(jj);
                                            });
                                          } else {
                                            final json = {
                                              "like": 1
                                            };
                                            DatabaseReference ge =
                                            FirebaseDatabase.instance.ref("Likes/$iD");
                                            ge.set(json);
                                            final jj = {
                                              "state": "state"
                                            };
                                            DatabaseReference geta =
                                            FirebaseDatabase.instance.ref("Liked/$iD/$minemail/");
                                            geta.set(jj);
                                          }
                                        });
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset('images/heartunlike.png', height: 40, width: 40,),
                                        SizedBox(height: 5,),
                                        Text(listc[index].like.toString(),
                                          style: TextStyle(color: Colors.black),),],
                                    ),
                                  ),


                                ],),


                              const SizedBox(
                                height: 5,
                              ),



                            ],
                          ),
                        );






                      }),
                ),]
              )),
          floatingActionButton: FloatingActionButton(
            onPressed: () {

              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                return AddComment();
              }));
            },
            backgroundColor: const Color(0xffffc491),
            child: const Icon(
              Icons.add,size: 35,
              color: Color(0xff5a3e28),
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    listc.clear();
    cid.clear();
  }
}
