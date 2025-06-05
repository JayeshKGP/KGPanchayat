import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kgppanchayat/cdc.dart';
import 'package:kgppanchayat/eventapproval.dart';
import 'package:kgppanchayat/implinks.dart';
import 'package:kgppanchayat/messageoutbox.dart';
import 'package:kgppanchayat/notification.dart';
import 'package:kgppanchayat/personslist.dart';
import 'package:kgppanchayat/savedposts.dart';
import 'package:kgppanchayat/showimage.dart';
import 'package:kgppanchayat/societies.dart';
import 'package:kgppanchayat/team.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'editprofile.dart';
import 'mypost.dart';
import 'study.dart';
import 'login.dart';
import 'main.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  Color edit = Colors.black;
  Color my = Colors.black;
  Color contact = Colors.black;
  Color privacy = Colors.black;
  bool sign_out_bool = false;
  int nofolo = 0;
  bool eventappro = false;

  @override
  Widget build(BuildContext context) {
    String? gh = EmailIdp.replaceAll("@", '');
    String? minemail = gh.replaceAll(".", "");
    DatabaseReference io = FirebaseDatabase.instance.ref("Approval/$minemail");
    io.once().then((value) async{
      DataSnapshot ss = value.snapshot;
      if(ss.exists){
        setState(() {
          eventappro = true;
        });
      }else{
        setState(() {
          eventappro = false;
        });
      }
    });


    DatabaseReference bn =
    FirebaseDatabase.instance.ref("FollowersCount/$minemail");
    bn.once().then((value) async {
      DataSnapshot snap = value.snapshot;
      if (snap.exists) {
        Map<dynamic, dynamic> map = snap.value as Map;
        setState(() {
          int yu = map["count"];
          nofolo = yu;
        });
      }else{
        setState(() {
          nofolo = 0;
        });
      }
    });

    return Drawer(
      child: Container(
        color: const Color(0xfff1f2f6),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(color: Color(0xffffdfaf),height: 80,child: Column(children: [SizedBox(height: 45,),Row(children: [SizedBox(width: 20,),Text("MY PROFILE",style: TextStyle(color: Colors.black, fontFamily: 'artifika', fontSize: 20)),],)]),),

              Container(
                width: double.maxFinite,
                child: Row(
                  children: [
                    SizedBox(width: 20,),
                    Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: SizedBox(
                      height: 90,
                      width: 90,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                                showimageurl = PhotoUrlp;
                                return const ShowImage();
                              }));
                        },
                        child: CachedNetworkImage(
                          imageUrl: PhotoUrlp,
                          progressIndicatorBuilder: (_, url, download) {
                            if (download.progress != null) {
                              final percent = download.progress! * 100;
                              return Center(
                                child: CircularProgressIndicator(
                                    color: const Color(0xff8a8989), value: percent),
                              );
                            }

                            return const Text("");
                          },
                          imageBuilder: (context, imageProvider) => Container(
                            width: 90.0,
                            height: 90.0,
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
                  ]
                ),
              ),
              Row(
                children: [SizedBox(width: 20,),SizedBox(
                  width: 200,
                  child: Text(
                    Namep,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'gupter',
                        color: Color(0xff000000)),
                  ),
                ),
                kyaverified ? Image.asset('images/verr.png', width: 20, height: 20,) : SizedBox(width: 0,)]
              ),
              Row(
                children: [SizedBox(width: 20,),Text(
                  "$Yearp Year, $Departmentp, $Hallp",
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: 'gupter',
                      color: Color(0xff8a8989),
                      fontSize: 16),
                ),]
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [OutlinedButton(onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfile()),
                    ModalRoute.withName("/Temp"));
              }, child: Text("Edit Profile",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.black, width: 1),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
                OutlinedButton(onPressed: (){
                  String? gh = EmailIdp.replaceAll("@", '');
                  String? minemail = gh.replaceAll(".", "");
                  usalist = 2;
                  konachefollowers = minemail;
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                    return PersonsList();
                  }));
                }, child: Text((nofolo==1) ? nofolo.toString()+" Follower" : nofolo.toString()+" Followers",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.black, width: 1),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
              ],),

              SizedBox(height: 5,),
              Container(height: 1,color: Colors.black,),

              const SizedBox(
                height: 15,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [GestureDetector(
                    child: Card(
                      color: const Color(0xffffffff),
                      child: SizedBox(
                        width: 130,
                        child: Column(
                          children: [SizedBox(height: 5,),Row(
                            children: [SizedBox(width: 10,),Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset("images/speech.png", height: 35,),
                                SizedBox(height: 5,),
                                Text(
                                  "My Post",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'glory',
                                      color: Color(0xff000000)),
                                ),
                              ],
                            ),]
                          ),
                          SizedBox(height: 5,)]
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const MyPost()),
                          ModalRoute.withName("/Temp"));
                    }),
                  GestureDetector(
                      child: Card(
                        color: const Color(0xffffffff),
                        child: SizedBox(
                          width: 130,
                          child: Column(
                              children: [SizedBox(height: 5,),Row(
                                  children: [SizedBox(width: 10,),Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset("images/study.png", height: 35,),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Study Material",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'glory',
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff000000)),
                                      ),
                                    ],
                                  ),]
                              ),
                                SizedBox(height: 5,)]
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const Study()),
                            ModalRoute.withName("/Temp"));
                      }),]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [GestureDetector(
                      child: Card(
                        color: const Color(0xffffffff),
                        child: SizedBox(
                          width: 130,
                          child: Column(
                              children: [SizedBox(height: 5,),Row(
                                  children: [SizedBox(width: 10,),Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset("images/link.png", height: 35,),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Important\nLinks",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'glory',
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff000000)),
                                      ),
                                    ],
                                  ),]
                              ),
                                SizedBox(height: 5,)]
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const ImpLinks()),
                            ModalRoute.withName("/Temp"));
                      }),
                    GestureDetector(
                        child: Card(
                          color: const Color(0xffffffff),
                          child: SizedBox(
                            width: 130,
                            child: Column(
                                children: [SizedBox(height: 5,),Row(
                                    children: [SizedBox(width: 10,),Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.asset("images/society.png", height: 35,),
                                        SizedBox(height: 5,),
                                        Text(
                                          "Societies\n& Clubs",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'glory',
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xff000000)),
                                        ),
                                      ],
                                    ),]
                                ),
                                  SizedBox(height: 5,)]
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const Societies()),
                              ModalRoute.withName("/Temp"));
                        }),]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [GestureDetector(
                      child: Card(
                        color: const Color(0xffffffff),
                        child: SizedBox(
                          width: 130,
                          child: Column(
                              children: [SizedBox(height: 5,),Row(
                                  children: [SizedBox(width: 10,),Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset("images/savess.png", height: 35,),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Saved Posts",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'glory',
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff000000)),
                                      ),
                                    ],
                                  ),]
                              ),
                                SizedBox(height: 5,)]
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const SavedPosts()),
                            ModalRoute.withName("/Temp"));
                      }),
                    GestureDetector(
                        child: Card(
                          color: const Color(0xffffffff),
                          child: SizedBox(
                            width: 130,
                            child: Column(
                                children: [SizedBox(height: 5,),Row(
                                    children: [SizedBox(width: 10,),Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.asset("images/outbox.png", height: 35,),
                                        SizedBox(height: 5,),
                                        Text(
                                          "Outbox",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'glory',
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xff000000)),
                                        ),
                                      ],
                                    ),]
                                ),
                                  SizedBox(height: 5,)]
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const MessageOutbox()),
                              ModalRoute.withName("/Temp"));
                        }),]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [GestureDetector(
                      child: Card(
                        color: const Color(0xffffffff),
                        child: SizedBox(
                          width: 130,
                          child: Column(
                              children: [SizedBox(height: 5,),Row(
                                  children: [SizedBox(width: 10,),Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset("images/notification.png", height: 35,),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Notification\nSettings",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'glory',
                                            color: Color(0xff000000)),
                                      ),
                                    ],
                                  ),]
                              ),
                                SizedBox(height: 5,)]
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const NotiSett()),
                            ModalRoute.withName("/Temp"));
                      }),
                    GestureDetector(
                        child: Card(
                          color: const Color(0xffffffff),
                          child: SizedBox(
                            width: 130,
                            child: Column(
                                children: [SizedBox(height: 5,),Row(
                                    children: [SizedBox(width: 10,),Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.asset("images/internship.png", height: 35,),
                                        SizedBox(height: 5,),
                                        Text(
                                          "Placement &\nInternship",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'glory',
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xff000000)),
                                        ),
                                      ],
                                    ),]
                                ),
                                  SizedBox(height: 5,)]
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const Intern()),
                              ModalRoute.withName("/Temp"));
                        }),
                    ]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [GestureDetector(
                      child: Card(
                        color: const Color(0xffffffff),
                        child: SizedBox(
                          width: 130,
                          child: Column(
                              children: [SizedBox(height: 5,),Row(
                                  children: [SizedBox(width: 10,),Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset("images/guidelines.png", height: 35,),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Rules and\nRegulations",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'glory',
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff000000)),
                                      ),
                                    ],
                                  ),]
                              ),
                                SizedBox(height: 5,)]
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        String link = "https://kgpanchayatapp.blogspot.com/2023/04/kgpanchayat-rules-and-regulations.html";
                        launchUrl(Uri.parse(link),
                            mode: LaunchMode.externalApplication);
                      }),
                    GestureDetector(
                        child: Card(
                          color: const Color(0xffffffff),
                          child: SizedBox(
                            width: 130,
                            child: Column(
                                children: [SizedBox(height: 5,),Row(
                                    children: [SizedBox(width: 10,),Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.asset("images/policy.png", height: 35,),
                                        SizedBox(height: 5,),
                                        Text(
                                          "Privacy\nPolicy",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'glory',
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xff000000)),
                                        ),
                                      ],
                                    ),]
                                ),
                                  SizedBox(height: 5,)]
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          String link = "https://kgpanchayatapp.blogspot.com/2023/04/kgpanchayat-privacy-policy.html";
                          launchUrl(Uri.parse(link),
                              mode: LaunchMode.externalApplication);
                        }),]
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [GestureDetector(
                      child: Card(
                        color: const Color(0xffffffff),
                        child: SizedBox(
                          width: 130,
                          child: Column(
                              children: [SizedBox(height: 5,),Row(
                                  children: [SizedBox(width: 10,),Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset("images/email.png", height: 35,),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Contact\nUS",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'glory',
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff000000)),
                                      ),
                                    ],
                                  ),]
                              ),
                                SizedBox(height: 5,)]
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        String link = "mailto:jdcodekgp@gmail.com?subject=A user from KGPanchayat app&body=Name: $Namep\nEmail ID: $EmailIdp\n";
                        launchUrl(Uri.parse(link),
                            mode: LaunchMode.externalApplication);
                      }),
                    GestureDetector(
                        child: Card(
                          color: const Color(0xffffffff),
                          child: SizedBox(
                            width: 130,
                            child: Column(
                                children: [SizedBox(height: 5,),Row(
                                    children: [SizedBox(width: 10,),Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.asset("images/teamwork.png", height: 35,),
                                        SizedBox(height: 5,),
                                        Text(
                                          "Our\nTeam",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'glory',
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xff000000)),
                                        ),
                                      ],
                                    ),]
                                ),
                                  SizedBox(height: 5,)]
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const Team()),
                              ModalRoute.withName("/Temp"));
                        }),
                  ]
              ),
              eventappro ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [GestureDetector(
                      child: Card(
                        color: const Color(0xffffffff),
                        child: SizedBox(
                          width: 130,
                          child: Column(
                              children: [SizedBox(height: 5,),Row(
                                  children: [SizedBox(width: 10,),Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset("images/guidelines.png", height: 35,),
                                      SizedBox(height: 5,),
                                      Text(
                                        "Event\nApproval",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'glory',
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff000000)),
                                      ),
                                    ],
                                  ),]
                              ),
                                SizedBox(height: 5,)]
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const EventApproval()),
                            ModalRoute.withName("/Temp"));
                      }),
                    ]
              ) : SizedBox(height: 0,),

              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  sign_out_bool ? LoadingAnimationWidget.threeArchedCircle(
                      color: const Color(0xffea8537), size: 38)
                      : GestureDetector(
                    child: SizedBox(
                        height: 60,
                        child: Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          color: const Color(0xffffffff),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Image.asset('images/logg.png', width: 40,),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "Sign Out",
                                style: TextStyle(
                                  fontFamily: 'artifika',
                                    fontSize: 23, color: Color(0xff5a3e28)),
                              ),
                              SizedBox(
                                width: 20,
                              )
                            ],
                          ),
                        )),
                    onTap: () async {
                      setState(() {
                        sign_out_bool = true;
                      });
                      GoogleSignIn().signOut();
                      try {
                        GoogleSignIn().disconnect();
                      } catch (e) {}
                      String? mymail = EmailIdp.replaceAll("@", '');
                      String? minemail = mymail.replaceAll(".", "");
                      FirebaseAuth.instance.signOut();
                      await FirebaseMessaging.instance.unsubscribeFromTopic(Hallp);
                      await FirebaseMessaging.instance.unsubscribeFromTopic(Departmentp);
                      await FirebaseMessaging.instance.unsubscribeFromTopic("All");
                      await FirebaseMessaging.instance.unsubscribeFromTopic("Events");
                      await FirebaseMessaging.instance.unsubscribeFromTopic("Fundae");
                      await FirebaseMessaging.instance.unsubscribeFromTopic("Lost");
                      await FirebaseMessaging.instance.unsubscribeFromTopic(minemail);

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                          ModalRoute.withName("/Temp"));
                      setState(() {
                        sign_out_bool = false;
                      });
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
