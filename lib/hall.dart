import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kgppanchayat/comment.dart';
import 'package:kgppanchayat/personprofile.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher.dart';
import 'messagedialog.dart';
import 'showimage.dart';
import 'getter.dart';
import 'main.dart';
import 'temp.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

bool updateh = true;
int cindexh = 0;


class Hall extends StatefulWidget {
  const Hall({Key? key}) : super(key: key);

  @override
  State<Hall> createState() => _HallState();
}

class _HallState extends State<Hall> {
  bool countbool= false;
  int joh = 0;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
  ItemPositionsListener.create();
  @override
  Widget build(BuildContext context){
    DatabaseReference referenceh = FirebaseDatabase.instance.ref("Hall/$Hallp");
    referenceh.once().then((value) {
      DataSnapshot snap = value.snapshot;
      setState(() {
        if(snap.exists){
          countbool = false;
        }else{
          countbool = true;
        }
      });
      Map<dynamic, dynamic> map = snap.value as Map;
      joh = map.length;
    });
    referenceh.orderByChild("ID").onChildAdded.listen((DatabaseEvent value) {
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
        if (listh.length != joh) {
          if(listh.length < joh){
            if(idsh.contains(map["ID"])){
            }else{
              idsh.insert(0, map["ID"]);
              listh.insert(0, de);
            }
          }else if(listh.length > joh){
            listh.clear();
            idsh.clear();
            idsh.insert(0, map["ID"]);
            listh.insert(0, de);
          }
        }else{
          if (updateh) {
            itemScrollController.jumpTo(index: cindexh);
            cindexh = 0;
            updateh = false;
          }
        }
      });
    });




    return countbool
        ? Center(child: const Text("Click on '+' to add first post.",
        style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'glory', fontWeight: FontWeight.bold)))
        : MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ScrollablePositionedList.builder(
          itemScrollController: itemScrollController,
          itemPositionsListener: itemPositionsListener,
          itemCount: listh.length,
          itemBuilder: (_, index) {
            String name = listh[index].Name;
            String photoUrl = listh[index].PhotoUrl;
            String emailId = listh[index].Email_ID;
            String hall = listh[index].Hall;
            String year = listh[index].Year;
            String department = listh[index].Department;
            String post = listh[index].Post;
            String iD = listh[index].ID;
            int comments = listh[index].Comment;
            String fileUrl = listh[index].FileUrl;
            bool showi = listh[index].showi;
            bool showd = listh[index].showd;

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
                  listh[index].like = map["like"];
                });
              }
            });

            DatabaseReference geta =
            FirebaseDatabase.instance.ref("Liked/$iD/$minemail/");
            geta.once().then((value) async {
              DataSnapshot snap = value.snapshot;
              if (snap.exists) {
                listh[index].lb = true;
              }else{
                listh[index].lb = false;
              }
            });



            DatabaseReference gh =
            FirebaseDatabase.instance.ref("Hall/$Hallp/$iD");
            gh.once().then((value) async {
              DataSnapshot snap = value.snapshot;
              if (snap.exists) {
                Map<dynamic, dynamic> map = snap.value as Map;
                setState(() {
                  listh[index].Comment = map["Comment"];
                });
              }
            });
            DatabaseReference beta =
            FirebaseDatabase.instance.ref("Saved/$minemail/$iD/");
            beta.once().then((value) async {
              DataSnapshot snap = value.snapshot;
              if (snap.exists) {
                listh[index].sp = true;
              } else {
                listh[index].sp = false;
              }
            });

            String? j = emailId.replaceAll("@", '');
            String? postmail = j.replaceAll(".", "");

            DatabaseReference bad =
            FirebaseDatabase.instance.ref("Badge/$postmail/");
            bad.once().then((value) async {
              DataSnapshot snap = value.snapshot;
              if (snap.exists) {
                listh[index].sb = true;
              } else {
                listh[index].sb = false;
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
                                  ),listh[index].sb ? Image.asset('images/verr.png', width: 20, height: 20,) : SizedBox(width: 0,),
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
                                  DatabaseReference delref = FirebaseDatabase.instance.ref("MyPost/$minemail/Hall/$iD");
                                  await delref.remove();

                                  DatabaseReference delre = FirebaseDatabase.instance.ref("Hall/$hall/$iD");
                                  await delre.remove();
                                  setState(() {
                                    listh.clear();
                                    idsh.clear();

                                    DatabaseReference referenceh =
                                    FirebaseDatabase.instance.ref("Hall/$Hallp");
                                    referenceh.once().then((value) {
                                      DataSnapshot snap = value.snapshot;
                                      Map<dynamic, dynamic> map = snap.value as Map;
                                      joh = map.length;
                                    });
                                    referenceh
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
                                        if (listh.length != joh) {
                                          if(idsh.contains(map["ID"])){
                                            listh.insert(0, de);
                                            idsh.insert(0, map["ID"]);
                                          }
                                        }});
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
                      ) : Align(
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
                                  DatabaseReference myrefd = FirebaseDatabase
                                      .instance
                                      .ref("Report/Hall");
                                  final jsona = {
                                    "Name": name,
                                    "PhotoUrl": photoUrl,
                                    "Email_ID": emailId,
                                    "Hall": hall,
                                    "Year": year,
                                    "Department": department,
                                    "Post": post,
                                    "ID": iD,
                                    "Comment": comments,
                                    "FileUrl": fileUrl,
                                    "showi": showi,
                                    "showd": showd
                                  };
                                  await myrefd.child(iD).set(jsona);

                                  Navigator.of(context).pop();
                                  Fluttertoast.showToast(msg: "Reported Successfully");
                                  String link = "mailto:jdcodekgp@gmail.com?subject=KGPanchayat Post Report&body=Post Details: Hall-"+iD+"\nPost reported by $Namep, $EmailIdp\nReason of reporting:";
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
                            icon: Image.asset("images/spamm.png",height: 20, width: 20,)),
                      ),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  (post=="") ? const SizedBox(height: 0,) :
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                        child: secondHalf.isEmpty
                            ? Linkify(
                          onOpen: (link) async {
                            await launchUrl(Uri.parse(link.url),
                                mode: LaunchMode.externalApplication);
                          },
                          text: firstHalf,
                          style: const TextStyle(fontSize: 18,
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
                              text: flag ? ("$firstHalf...") : (firstHalf + secondHalf),
                              style: const TextStyle(fontSize: 18,
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
                                          mode: LaunchMode.externalApplication);
                                    },
                                    text: flag ? ("Read More") : ("Read Less"),
                                    style: const TextStyle(fontSize: 18, fontFamily: 'ysa', color: Color(
                                        0xff4e9aef)),
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

                      listh[index].lb ?

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
                            Text(listh[index].like.toString(),
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
                            Text(listh[index].like.toString(),
                              style: TextStyle(color: Colors.black),),],
                        ),
                      ),


                      GestureDetector(
                        onTap: () {
                          cindexh = index;
                          commentId = iD;
                          kc =3;
                          postmail = emailId;
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
                                listh[index].Comment.toString(),
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

                      listh[index].sp ? IconButton(onPressed: () {
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
                            "Comment": 3,
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
    listh.clear();
    idsh.clear();
    updateh = true;
  }
}
