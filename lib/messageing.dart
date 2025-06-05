import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:kgppanchayat/gettermessage.dart';
import 'package:kgppanchayat/personprofile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';
import 'messagedialog.dart';
import 'temp.dart';


class Messaging extends StatefulWidget {
  const Messaging({Key? key}) : super(key: key);

  @override
  State<Messaging> createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  bool countbool= false;
  String? bn = "";
  @override
  Widget build(BuildContext context) {
    bn = FirebaseAuth.instance.currentUser?.displayName;
    String? mymail = EmailIdp.replaceAll("@", '');
    String? minemail = mymail.replaceAll(".", "");
    DatabaseReference reference =
    FirebaseDatabase.instance.ref("Messages/$minemail");
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
      Message de = Message(
          Name: map["Name"],
          PhotoUrl: map["PhotoUrl"],
          Email_ID: map["Email_ID"],
          Hall: map["Hall"],
          Year: map["Year"],
          Department: map["Department"],
          Post: map["Post"],
          ID: map["ID"],
          sb: false);
      setState(() {
        if (listmess.length != j) {
          if (listmess.length < j) {
            if (cid.contains(map["ID"])) {
            } else {
              listmess.insert(0, de);
              cid.insert(0, map["ID"]);
            }
          } else if (listmess.length > j) {
            listmess.clear();
            cid.clear();
            listmess.insert(0, de);
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
              "Inbox",
              style: TextStyle(color: Colors.black, fontFamily: 'gupter'),
            ),
          ),
          body: countbool
              ? Center(child: const Text("Messages send to you will be visible here", style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'glory', fontWeight: FontWeight.bold)))
              : Container(
              height: double.maxFinite,
              color: const Color(0xfff1f2f6),
              child: Column(
                  children: [Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: listmess.length,
                        itemBuilder: (_, index) {
                          String name = listmess[index].Name;
                          String photoUrl = listmess[index].PhotoUrl;
                          String emailId = listmess[index].Email_ID;
                          String hall = listmess[index].Hall;
                          String year = listmess[index].Year;
                          String department = listmess[index].Department;
                          String post = listmess[index].Post;
                          String iD = listmess[index].ID;

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

                          String? je = emailId.replaceAll("@", '');
                          String? postmail = je.replaceAll(".", "");

                          DatabaseReference bad =
                          FirebaseDatabase.instance.ref("Badge/$postmail/");
                          bad.once().then((value) async {
                            DataSnapshot snap = value.snapshot;
                            if (snap.exists) {
                              listmess[index].sb = true;
                            } else {
                              listmess[index].sb = false;
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
                                                ),listmess[index].sb ? Image.asset('images/verr.png', width: 20, height: 20,) : SizedBox(width: 0,),
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
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (_){
                                                  messagewalamail = emailId;
                                                  return Dialog(shape:
                                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),child: const MessageDialog(),);
                                                }
                                            );
                                          },

                                          icon: const Icon(
                                            Icons.reply,
                                            color: Color(0xffea8537),
                                          )),
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
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          );






                        }),
                  ),]
              )),
        ));
  }

  @override
  void initState() {
    super.initState();
    listmess.clear();
    cid.clear();
    String? mymail = EmailIdp.replaceAll("@", '');
    String? minemail = mymail.replaceAll(".", "");
    final json = {
      "number": 0
    };
    DatabaseReference ge =
    FirebaseDatabase.instance.ref("Unread/$minemail");
    ge.set(json);
  }
}
