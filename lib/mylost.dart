import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:kgppanchayat/comment.dart';
import 'package:kgppanchayat/personprofile.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher.dart';
import 'getter.dart';
import 'main.dart';
import 'messagedialog.dart';
import 'showimage.dart';
import 'temp.dart';
import 'mypost.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class MyLost extends StatefulWidget {
  const MyLost({Key? key}) : super(key: key);

  @override
  State<MyLost> createState() => _MyLostState();
}
bool updatel = true;
int mycindexl = 0;
class _MyLostState extends State<MyLost> {
  final ItemScrollController itemScrollController = ItemScrollController();
  int jot = 0;
  int myj = 0;
  bool countbool= false;
  @override
  Widget build(BuildContext context) {
    String? mymail = EmailIdp.replaceAll("@", '');
    String? minemail = mymail.replaceAll(".", "");
    DatabaseReference reference = FirebaseDatabase.instance.ref("MyPost/$minemail/Lost");
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
      myj = map.length;
    });
    reference.orderByChild("ID").onChildAdded.listen((DatabaseEvent value) {
      DataSnapshot snapshot = value.snapshot;

      Map<dynamic, dynamic> map = snapshot.value as Map;
      Details de = Details(
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
          sb: false);
      setState(() {
        if (listlm.length != myj) {
          if (idslm.contains(map["ID"])) {
          } else {
            idslm.insert(0, map["ID"]);
            listlm.insert(0, de);
          }
        } else {
          if (update) {
            itemScrollController.jumpTo(index: mycindexl);
            mycindexl = 0;
            updatel = false;
          }
        }
      });
    });





    return countbool
        ? Center(child: const Text("Add your first post.", style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'glory', fontWeight: FontWeight.bold)))
        : MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ScrollablePositionedList.builder(
          itemScrollController: itemScrollController,
          itemCount: listlm.length,
          itemBuilder: (_, index) {
            String name = listlm[index].Name;
            String photoUrl = listlm[index].PhotoUrl;
            String emailId = listlm[index].Email_ID;
            String hall = listlm[index].Hall;
            String year = listlm[index].Year;
            String department = listlm[index].Department;
            String post = listlm[index].Post;
            String iD = listlm[index].ID;
            int comments = listlm[index].Comment;
            String fileUrl = listlm[index].FileUrl;
            bool showi = listlm[index].showi;
            bool showd = listlm[index].showd;

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
                  listlm[index].like = map["like"];
                });
              }
            });

            DatabaseReference geta =
            FirebaseDatabase.instance.ref("Liked/$iD/$minemail/");
            geta.once().then((value) async {
              DataSnapshot snap = value.snapshot;
              if (snap.exists) {
                listlm[index].lb = true;
              }else{
                listlm[index].lb = false;
              }
            });



            DatabaseReference gh =
            FirebaseDatabase.instance.ref("Lost/$iD");
            gh.once().then((value) async {
              DataSnapshot snap = value.snapshot;
              if (snap.exists) {
                Map<dynamic, dynamic> map = snap.value as Map;
                setState(() {
                  listlm[index].Comment = map["Comment"];
                });
              }
            });
            DatabaseReference beta =
            FirebaseDatabase.instance.ref("Saved/$minemail/$iD/");
            beta.once().then((value) async {
              DataSnapshot snap = value.snapshot;
              if (snap.exists) {
                listlm[index].sp = true;
              } else {
                listlm[index].sp = false;
              }
            });
            String? j = emailId.replaceAll("@", '');
            String? postmail = j.replaceAll(".", "");

            DatabaseReference bad =
            FirebaseDatabase.instance.ref("Badge/$postmail/");
            bad.once().then((value) async {
              DataSnapshot snap = value.snapshot;
              if (snap.exists) {
                listlm[index].sb = true;
              } else {
                listlm[index].sb = false;
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
                                  ),listlm[index].sb ? Image.asset('images/verr.png', width: 20, height: 20,) : SizedBox(width: 0,),
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
                      }, icon: Image.asset('images/mmess.png',height: 20, width: 20,)) : SizedBox(width: 0,),

                      emailId == EmailIdp ?
                      Align(
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
                                  String? mymail = EmailIdp.replaceAll("@", '');
                                  String? minemail = mymail.replaceAll(".", "");
                                  DatabaseReference delref = FirebaseDatabase.instance.ref("MyPost/$minemail/Lost/$iD");
                                  await delref.remove();

                                  DatabaseReference delre = FirebaseDatabase.instance.ref("Lost/$iD");
                                  await delre.remove();


                                  setState(() {
                                    listlm.clear();
                                    idslm.clear();
                                    DatabaseReference reference =
                                    FirebaseDatabase.instance.ref("MyPost/$minemail/Lost");
                                    reference.once().then((value) {
                                      DataSnapshot snap = value.snapshot;
                                      Map<dynamic, dynamic> map = snap.value as Map;
                                      myj = map.length;
                                    });
                                    reference
                                        .orderByChild("ID")
                                        .onChildAdded
                                        .listen((DatabaseEvent value) {
                                      DataSnapshot snapshot = value.snapshot;
                                      Map<dynamic, dynamic> map = snapshot.value as Map;
                                      Details de = Details(
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
                                          sb: false);
                                      setState(() {
                                        if (listlm.length != myj) {
                                          if(idslm.contains(map["ID"])){

                                          }else{
                                            listlm.insert(0, de);
                                            idslm.insert(0, map["ID"]);
                                          }

                                        }
                                      });
                                    });
                                  });

                                  setState(() {
                                    listl.clear();
                                    idsl.clear();
                                    DatabaseReference reference =
                                    FirebaseDatabase.instance.ref("Lost");
                                    reference.once().then((value) {
                                      DataSnapshot snap = value.snapshot;
                                      Map<dynamic, dynamic> map = snap.value as Map;
                                      jot = map.length;
                                    });
                                    reference
                                        .orderByChild("ID")
                                        .onChildAdded
                                        .listen((DatabaseEvent value) {
                                      DataSnapshot snapshot = value.snapshot;
                                      Map<dynamic, dynamic> map = snapshot.value as Map;
                                      Details de = Details(
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
                                          sb: false);
                                      setState(() {
                                        if (listl.length != jot) {
                                          listl.insert(0, de);
                                          idsl.insert(0, map["ID"]);
                                        }
                                      });
                                    });
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

                            icon: Image.asset('images/dell.png',height: 20,width: 20,)),
                      ) : const SizedBox(width: 0,),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  (post=="") ? const SizedBox(height: 0,) :
                  Padding(
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
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      },
                      child: const Text("Access Document",style: TextStyle(fontSize: 18, fontFamily: 'ysa', color: Color(
                          0xff4e9aef)),))
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
                            height: 250,
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
                            }

                        ),))
                      : const SizedBox(
                    height: 0,
                  ),

                  Row(crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,children: [
                      SizedBox(width: 15,),

                      listlm[index].lb ?

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
                            Text(listlm[index].like.toString(),
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
                            Text(listlm[index].like.toString(),
                              style: TextStyle(color: Colors.black),),],
                        ),
                      ),


                      GestureDetector(
                        onTap: () {
                          mycindexl = index;
                          commentId = iD;
                          kc = 6;
                          postmail = emailId;
                          setState(() {
                            kon = false;
                          });
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
                                listlm[index].Comment.toString(),
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

                      listlm[index].sp ? IconButton(onPressed: () {
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
                            "Comment": 6,
                            "FileUrl": fileUrl,
                            "showi": showi,
                            "showd": showd
                          };
                          beta.set(jn);
                        });
                      }, icon: Image.asset('images/unsavem.png')),

                      SizedBox(width: 15,)


                    ],),

                  const SizedBox(
                    height: 5,
                  ),


                ],
              ),
            );
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    listlm.clear();
    idslm.clear();
    updatel = true;
  }
}
