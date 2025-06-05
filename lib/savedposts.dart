import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kgppanchayat/gettersaved.dart';
import 'package:kgppanchayat/messagedialog.dart';
import 'package:kgppanchayat/personprofile.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'comment.dart';
import 'main.dart';
import 'showimage.dart';
import 'getter.dart';
import 'temp.dart';
int j = 0;
int jot=0;
bool update = true;
int cindex = 0;
final ItemScrollController itemScrollController = ItemScrollController();
final ItemPositionsListener itemPositionsListener =
ItemPositionsListener.create();
class SavedPosts extends StatefulWidget {
  const SavedPosts({Key? key}) : super(key: key);

  @override
  State<SavedPosts> createState() => _SavedPostsState();
}

class _SavedPostsState extends State<SavedPosts> {
  bool countbool = false;

  @override
  Widget build(BuildContext context) {
    String? mymail = EmailIdp.replaceAll("@", '');
    String? minemail = mymail.replaceAll(".", "");
    DatabaseReference reference = FirebaseDatabase.instance.ref("Saved/$minemail");
    reference.once().then((value) {
      DataSnapshot snap = value.snapshot;
      setState(() {
        if (snap.exists) {
          countbool = false;
        } else {
          countbool = true;
        }
      });
      Map<dynamic, dynamic> map = snap.value as Map;
      j = map.length;
    });
    reference
        .orderByChild("ID")
        .onChildAdded
        .listen((DatabaseEvent value) {
      DataSnapshot snapshot = value.snapshot;

      Map<dynamic, dynamic> map = snapshot.value as Map;
      DetailsSaved de = DetailsSaved(
          Name: map["Name"],
          PhotoUrl: map["PhotoUrl"],
          Email_ID: map["Email_ID"],
          Hall: map["Hall"],
          Year: map["Year"],
          Department: map["Department"],
          Post: map["Post"],
          ID: map["ID"],
          Comment: map["Comment"],
          FileUrl: map["FileUrl"],
          showi: map["showi"],
          showd: map["showd"],
          like: 0,
          lb: false,
          sp: false,
          sb: false,
        comm: 0
      );
      setState(() {
        if (listsaved.length != j) {
          if (listsaved.length < j) {
            if (idsaved.contains(map["ID"])) {} else {
              idsaved.insert(0, map["ID"]);
              listsaved.insert(0, de);
            }
          } else if (listsaved.length > j) {
            setState(() {
              listsaved.clear();
              idsaved.clear();
              listsaved.insert(0, de);
              idsaved.insert(0, map["ID"]);
            });
          }
        } else {
          if (update) {
            itemScrollController.jumpTo(index: cindex);
            cindex = 0;
            update = false;
          }
        }
      });
    });


    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const Temp()),
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
                        const Temp()),
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
              "Saved Posts",
              style: TextStyle(color: Colors.black, fontFamily: 'gupter'),
            ),
          ),
    body: countbool
        ? Center(child: const Text("Your saved posts will be visible here.",
        style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'glory', fontWeight: FontWeight.bold)))
        : Container(
      height: double.maxFinite,
      color: const Color(0xfff1f2f6),
          child: MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ScrollablePositionedList.builder(
            itemScrollController: itemScrollController,
            itemPositionsListener: itemPositionsListener,
            itemCount: listsaved.length,
            itemBuilder: (_, index) {
              String name = listsaved[index].Name;
              String photoUrl = listsaved[index].PhotoUrl;
              String emailId = listsaved[index].Email_ID;
              String hall = listsaved[index].Hall;
              String year = listsaved[index].Year;
              String department = listsaved[index].Department;
              String post = listsaved[index].Post;
              String iD = listsaved[index].ID;
              int comments = listsaved[index].Comment;
              String fileUrl = listsaved[index].FileUrl;
              bool showi = listsaved[index].showi;
              bool showd = listsaved[index].showd;
              switch(comments){
                case 1:
                  DatabaseReference get =
                  FirebaseDatabase.instance.ref("All/$iD");
                  get.once().then((value) async {
                    DataSnapshot snap = value.snapshot;
                    if (snap.exists) {
                      Map<dynamic, dynamic> map = snap.value as Map;
                      setState(() {
                        listsaved[index].comm = map["Comment"];
                      });
                    }
                  });
                  break;
                case 2:
                  DatabaseReference get =
                  FirebaseDatabase.instance.ref("Academic/$department/$iD");
                  get.once().then((value) async {
                    DataSnapshot snap = value.snapshot;
                    if (snap.exists) {
                      Map<dynamic, dynamic> map = snap.value as Map;
                      setState(() {
                        listsaved[index].comm = map["Comment"];
                      });
                    }
                  });
                  break;
                case 3:
                  DatabaseReference get =
                  FirebaseDatabase.instance.ref("Hall/$hall/$iD");
                  get.once().then((value) async {
                    DataSnapshot snap = value.snapshot;
                    if (snap.exists) {
                      Map<dynamic, dynamic> map = snap.value as Map;
                      setState(() {
                        listsaved[index].comm = map["Comment"];
                      });
                    }
                  });
                  break;
                case 4:
                  DatabaseReference get =
                  FirebaseDatabase.instance.ref("Event/$iD");
                  get.once().then((value) async {
                    DataSnapshot snap = value.snapshot;
                    if (snap.exists) {
                      Map<dynamic, dynamic> map = snap.value as Map;
                      setState(() {
                        listsaved[index].comm = map["Comment"];
                      });
                    }
                  });
                  break;
                case 5:
                  DatabaseReference get =
                  FirebaseDatabase.instance.ref("Funde/$iD");
                  get.once().then((value) async {
                    DataSnapshot snap = value.snapshot;
                    if (snap.exists) {
                      Map<dynamic, dynamic> map = snap.value as Map;
                      setState(() {
                        listsaved[index].comm = map["Comment"];
                      });
                    }
                  });
                  break;
                case 6:
                  DatabaseReference get =
                  FirebaseDatabase.instance.ref("Lost/$iD");
                  get.once().then((value) async {
                    DataSnapshot snap = value.snapshot;
                    if (snap.exists) {
                      Map<dynamic, dynamic> map = snap.value as Map;
                      setState(() {
                        listsaved[index].comm = map["Comment"];
                      });
                    }
                  });
                  break;

              }


              String? mymail = EmailIdp.replaceAll("@", '');
              String? minemail = mymail.replaceAll(".", "");


              late String firstHalf;
              late String secondHalf;
              String jj = "hh";
              bool g = false;

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
                    listsaved[index].like = map["like"];
                  });
                }
              });

              DatabaseReference geta =
              FirebaseDatabase.instance.ref("Liked/$iD/$minemail/");
              geta.once().then((value) async {
                DataSnapshot snap = value.snapshot;
                if (snap.exists) {
                  listsaved[index].lb = true;
                } else {
                  listsaved[index].lb = false;
                }
              });


              DatabaseReference gh =
              FirebaseDatabase.instance.ref("All/$iD");
              gh.once().then((value) async {
                DataSnapshot snap = value.snapshot;
                if (snap.exists) {
                  Map<dynamic, dynamic> map = snap.value as Map;
                  setState(() {
                    listsaved[index].Comment = map["Comment"];
                  });
                }
              });

              DatabaseReference beta =
              FirebaseDatabase.instance.ref("Saved/$minemail/$iD/");
              beta.once().then((value) async {
                DataSnapshot snap = value.snapshot;
                if (snap.exists) {
                  listsaved[index].sp = true;
                } else {
                  listsaved[index].sp = false;
                }
              });

              String? j = emailId.replaceAll("@", '');
              String? postmail = j.replaceAll(".", "");

              DatabaseReference bad =
              FirebaseDatabase.instance.ref("Badge/$postmail/");
              bad.once().then((value) async {
                DataSnapshot snap = value.snapshot;
                if (snap.exists) {
                  listsaved[index].sb = true;
                } else {
                  listsaved[index].sb = false;
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
                                      width: 150,
                                      child: Text(
                                        name,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'gupter',
                                            color: Colors.black),
                                      ),
                                    ),listsaved[index].sb ? Image.asset('images/verr.png', width: 20, height: 20,) : SizedBox(width: 0,),
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
                        IconButton(onPressed: (){
                          showDialog(
                              context: context,
                              builder: (_){
                                messagewalamail = emailId;
                                return Dialog(shape:
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),child: const MessageDialog(),);
                              }
                          );
                        }, icon: Image.asset('images/mmess.png',height: 20, width: 20,)),

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
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (
                                    BuildContext context) {
                                  showimageurl = fileUrl;
                                  return const ShowImage();
                                }));
                          },
                          child: CachedNetworkImage(
                              imageUrl: fileUrl,
                              height: 250,
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


                    Row(crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,children: [
                        SizedBox(width: 15,),

                        listsaved[index].lb ?

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
                              Text(listsaved[index].like.toString(),
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
                              Text(listsaved[index].like.toString(),
                                style: TextStyle(color: Colors.black),),],
                          ),
                        ),


                        GestureDetector(
                          onTap: () {
                            cindex = index;
                            commentId = iD;
                            postmail = emailId;
                            kc = comments;
                            kon = true;
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Comment()),
                                ModalRoute.withName("/Temp"));
                          },
                          child: Column(
                              children: [
                                Image.asset('images/nbn.png', width: 40, height: 40,),
                                SizedBox(height: 5,),
                                Text(
                                  listsaved[index].comm.toString(),
                                  style: const TextStyle(
                                      color: Colors.black),
                                ),
                              ]),
                        ),

                        SizedBox(width: 5,),
                        Column(
                            children: [SizedBox(height: 4,),GestureDetector(
                              onTap: () async {
                                if (showi) {
                                  var file = await DefaultCacheManager().getSingleFile(fileUrl);
                                  XFile result = XFile(file.path);
                                  Share.shareXFiles([result], text: post);
                                }else{
                                  Share.share(post + fileUrl);
                                }
                              },
                              child: Image.asset('images/sshare.png', height: 32, width: 32,),
                            ),]
                        ),

                        Spacer(),

                        listsaved[index].sp ? IconButton(onPressed: () {
                          setState(() {
                            DatabaseReference beta =
                            FirebaseDatabase.instance.ref("Saved/$minemail/$iD/");
                            beta.remove();
                          });
                        }, icon: Image.asset('images/savem.png')) :
                        IconButton(onPressed: () {
                          setState(() {
                            DatabaseReference beta =
                            FirebaseDatabase.instance.ref("Saved/$minemail/$iD/");
                            final jn = {
                              "Name": name,
                              "PhotoUrl": photoUrl,
                              "Email_ID": emailId,
                              "Hall": hall,
                              "Year": year,
                              "Department": department,
                              "Post": post,
                              "ID": iD,
                              "Comment": 1,
                              "FileUrl": fileUrl,
                              "showi": showi,
                              "showd": showd
                            };
                            beta.set(jn);
                          });
                        }, icon: Image.asset('images/unsavem.png')),

                        SizedBox(width: 15,)


                      ],),



                  ],
                ),
              );
            }),
    ),
        )));
  }

  @override
  void initState() {
    super.initState();
    listsaved.clear();
    idsaved.clear();
    update = true;
  }
}