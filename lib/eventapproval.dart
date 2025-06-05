import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import 'package:http/http.dart' as http;

int j = 0;
int jot = 0;
bool update = true;
int cindex = 0;
final ItemScrollController itemScrollController = ItemScrollController();
final ItemPositionsListener itemPositionsListener =
    ItemPositionsListener.create();

class EventApproval extends StatefulWidget {
  const EventApproval({Key? key}) : super(key: key);

  @override
  State<EventApproval> createState() => _EventApprovalState();
}

class _EventApprovalState extends State<EventApproval> {
  bool countbool = false;

  @override
  Widget build(BuildContext context) {
    DatabaseReference reference = FirebaseDatabase.instance.ref("EventApproval");
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
        if (listeva.length != j) {
          if (listeva.length < j) {
            if (ideva.contains(map["ID"])) {
            } else {
              ideva.insert(0, map["ID"]);
              listeva.insert(0, de);
            }
          } else if (listeva.length > j) {
            setState(() {
              listeva.clear();
              ideva.clear();
              listeva.insert(0, de);
              ideva.insert(0, map["ID"]);
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
            automaticallyImplyLeading: false,
            title: const Text(
              "Event Approval",
              style: TextStyle(color: Colors.black, fontFamily: 'gupter'),
            ),
          ),
          body: countbool
              ? Center(
                  child: const Text(
                  "No pending approval",
                      style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'glory', fontWeight: FontWeight.bold)
                ))
              : MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ScrollablePositionedList.builder(
                      itemScrollController: itemScrollController,
                      itemPositionsListener: itemPositionsListener,
                      itemCount: listeva.length,
                      itemBuilder: (_, index) {
                        String name = listeva[index].Name;
                        String photoUrl = listeva[index].PhotoUrl;
                        String emailId = listeva[index].Email_ID;
                        String hall = listeva[index].Hall;
                        String year = listeva[index].Year;
                        String department = listeva[index].Department;
                        String post = listeva[index].Post;
                        String iD = listeva[index].ID;
                        int comments = listeva[index].Comment;
                        String fileUrl = listeva[index].FileUrl;
                        bool showi = listeva[index].showi;
                        bool showd = listeva[index].showd;

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
                              listeva[index].like = map["like"];
                            });
                          }
                        });

                        DatabaseReference geta =
                            FirebaseDatabase.instance.ref("Liked/$iD/$minemail/");
                        geta.once().then((value) async {
                          DataSnapshot snap = value.snapshot;
                          if (snap.exists) {
                            listeva[index].lb = true;
                          } else {
                            listeva[index].lb = false;
                          }
                        });

                        DatabaseReference gh =
                            FirebaseDatabase.instance.ref("All/$iD");
                        gh.once().then((value) async {
                          DataSnapshot snap = value.snapshot;
                          if (snap.exists) {
                            Map<dynamic, dynamic> map = snap.value as Map;
                            setState(() {
                              listeva[index].Comment = map["Comment"];
                            });
                          }
                        });

                        DatabaseReference beta =
                            FirebaseDatabase.instance.ref("Saved/$minemail/$iD/");
                        beta.once().then((value) async {
                          DataSnapshot snap = value.snapshot;
                          if (snap.exists) {
                            listeva[index].sp = true;
                          } else {
                            listeva[index].sp = false;
                          }
                        });

                        String? j = emailId.replaceAll("@", '');
                        String? postmail = j.replaceAll(".", "");

                        DatabaseReference bad =
                            FirebaseDatabase.instance.ref("Badge/$postmail/");
                        bad.once().then((value) async {
                          DataSnapshot snap = value.snapshot;
                          if (snap.exists) {
                            listeva[index].sb = true;
                          } else {
                            listeva[index].sb = false;
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
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        personmail = emailId;
                                        return const PersonProfile();
                                      }));
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 0),
                                          child: Row(children: [
                                            SizedBox(
                                              width: 200,
                                              child: Text(
                                                name,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'gupter',
                                                    color: Colors.black),
                                              ),
                                            ),
                                            listeva[index].sb
                                                ? Image.asset(
                                                    'images/verr.png',
                                                    width: 20,
                                                    height: 20,
                                                  )
                                                : SizedBox(
                                                    width: 0,
                                                  ),
                                          ]),
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
                                  (emailId != EmailIdp)
                                      ? IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (_) {
                                                  messagewalamail = emailId;
                                                  return Dialog(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                30)),
                                                    child: const MessageDialog(),
                                                  );
                                                });
                                          },
                        icon: Image.asset('images/mmess.png',height: 25, width: 25,))
                                      : SizedBox(
                                          width: 0,
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
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            showimageurl = fileUrl;
                                            return const ShowImage();
                                          }));
                                        },
                                        child: CachedNetworkImage(
                                            imageUrl: fileUrl,
                                            height: 250,
                                            progressIndicatorBuilder:
                                                (_, url, download) {
                                              if (download.progress != null) {
                                                final percent =
                                                    download.progress! * 100;
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: const Color(
                                                              0xff8a8989),
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

                              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [IconButton(onPressed: ()async{
                                String? mymail = listeva[index].Email_ID.replaceAll("@", '');
                                String? minemail = mymail.replaceAll(".", "");
                                DatabaseReference refd = FirebaseDatabase.instance.ref("Event");
                                DatabaseReference myrefd = FirebaseDatabase.instance
                                    .ref("MyPost/$minemail/Event");
                                final jsona = {
                                  "Name": listeva[index].Name,
                                  "PhotoUrl": listeva[index].PhotoUrl,
                                  "Email_ID": listeva[index].Email_ID,
                                  "Hall": listeva[index].Hall,
                                  "Year": listeva[index].Year,
                                  "Department": listeva[index].Department,
                                  "Post": listeva[index].Post,
                                  "ID": listeva[index].ID,
                                  "Comment": 0,
                                  "FileUrl": listeva[index].FileUrl,
                                  "showi": listeva[index].showi,
                                  "showd": listeva[index].showd
                                };

                                await refd.child(listeva[index].ID).set(jsona);
                                await myrefd.child(listeva[index].ID).set(jsona);

                                String keyhere = listeva[index].ID;
                                DatabaseReference delre =
                                FirebaseDatabase.instance
                                    .ref("EventApproval/$keyhere");
                                await delre.remove();

                                String toParams = '/topics/Events';
                                var data = {
                                  'to': '${toParams}',
                                  'priority': 'high',
                                  'notification':{
                                    'title': 'Events - ${listeva[index].Name}',
                                    'body': listeva[index].Post,

                                  }
                                };
                                await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'), body: jsonEncode(data ), headers: {
                                  'Content-Type': 'application/json; charset=UTF-8',
                                  'Authorization': 'key=AAAAvYftPK8:APA91bH9CqoAbmH7pLUZI5CpHKVB-K_1AmUV13Ic1FQnASqd8WJ4yYPkCGCXFeMOzzisMXH8Md9maDGsbrgJRua8qp0lVq5HClGUzqpUteB0de9qYFR8D7U94ZtNFjYs8qNaM-TBRZB7'
                                });


                              }, icon: Icon(Icons.currency_yen_sharp, color: Colors.green,)), IconButton(onPressed: ()async{
                                String keyhere = listeva[index].ID;
                                DatabaseReference delre =
                                FirebaseDatabase.instance
                                    .ref("EventApproval/$keyhere");
                                await delre.remove();
                              }, icon: Icon(Icons.close, color: Colors.redAccent,))],)
                            ],
                          ),
                        );
                      }),
                )),
    );
  }

  @override
  void initState() {
    super.initState();
    listeva.clear();
    ideva.clear();
    update = true;
  }
}
