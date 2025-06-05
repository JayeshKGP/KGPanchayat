import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kgppanchayat/personslist.dart';
import 'package:kgppanchayat/showimage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';
import 'messagedialog.dart';

class PersonProfile extends StatefulWidget {
  const PersonProfile({Key? key}) : super(key: key);

  @override
  State<PersonProfile> createState() => _PersonProfileState();
}

class _PersonProfileState extends State<PersonProfile> {
  String name = "",
      hall = "",
      photourl = "",
      year = "",
      bio = "",
      dept = "",
  instaurl = "",
  fburl = "",
  linkedinurl = "",
  badgeinfo="";



  bool badges = false, follows = false;
  int nooffollowers = 0, nofolo = 0;
  bool issverified = false;


  @override
  Widget build(BuildContext context) {
    String? mymail = personmail.replaceAll("@", '');
    String? thenmail = mymail.replaceAll(".", "");
    String? gh = EmailIdp.replaceAll("@", '');
    String? minemail = gh.replaceAll(".", "");
    DatabaseReference get =
    FirebaseDatabase.instance.ref("UserData/$thenmail");
    get.once().then((value) {
      DataSnapshot snap = value.snapshot;
      Map<dynamic, dynamic> map = snap.value as Map;
      setState(() {
        dept = map["Department"];
        bio = map["Bio"];
        name = map["Name"];
        hall = map["Hall"];
        photourl = map["PhotoUrl"];
        year = map["Year"];
      });
    });

    DatabaseReference sl =
    FirebaseDatabase.instance.ref("Social Links/$thenmail");
    sl.once().then((value) async {
      DataSnapshot snap = value.snapshot;
      if (snap.exists) {
        Map<dynamic, dynamic> map = snap.value as Map;
        setState(() {
          instaurl = map["Insta"];
          fburl = map["FB"];
          linkedinurl = map["LinkedIn"];
        });
      }
    });
    DatabaseReference bads =
    FirebaseDatabase.instance.ref("Badge/$thenmail/");
    bads.once().then((value) async {
      DataSnapshot snap = value.snapshot;
      if (snap.exists) {
        Map<dynamic, dynamic> map = snap.value as Map;
        setState(() {
          badgeinfo = map["badge"];
          badges = true;
        });
      }
    });


    DatabaseReference ouc =
    FirebaseDatabase.instance.ref(
        "Followers/$thenmail/$minemail");
    ouc.once().then((value) async {
      DataSnapshot snap = value.snapshot;
      if (snap.exists) {
        setState(() {
          follows = true;
        });
      } else {
        setState(() {
          follows = false;
        });
      }
    });



    DatabaseReference bn =
    FirebaseDatabase.instance.ref("FollowersCount/$thenmail");
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



    DatabaseReference bafd =
    FirebaseDatabase.instance.ref("Badge/$thenmail/");
    bafd.once().then((value) async {
      DataSnapshot snap = value.snapshot;
      if (snap.exists) {
        issverified = true;
      } else {
        issverified = false;
      }
    });


    return WillPopScope(
      onWillPop: ()async{
        liststu.clear();
        listapplied.clear();
        liststuextra.clear();
        stu.clear();
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(resizeToAvoidBottomInset: false,appBar: AppBar(
        toolbarHeight: 50,
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: const Color(0xffffdfaf),
        titleSpacing: 0,
        iconTheme: IconThemeData(color: Colors.black),
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: true,
        title: const Text(
          "Student Profile",
      style: TextStyle(color: Colors.black, fontFamily: 'gupter')
        ),
      ),
          body: Container(
              height: double.maxFinite,
              color: Color(0xfff1f2f6),
              child: SingleChildScrollView(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [const SizedBox(height: 25,),
                  Row(
                    children: [SizedBox(width: 20,),SizedBox(
                      width: 70,
                      height: 70,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                                showimageurl = photourl;
                                return const ShowImage();
                              }));
                        },
                        child: CachedNetworkImage(
                          imageUrl: photourl,
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
                          imageBuilder: (context, imageProvider) =>
                              Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.circle_outlined),
                        ),
                      ),
                    ),
                    SizedBox(width: 15,),
                    Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Row(
                        children: [SizedBox(
                          width: 200,
                          child: Text(name, style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'gupter',
                              color: Colors.black),
                    textAlign: TextAlign.start,),
                        ),
                          issverified ? Image.asset('images/verr.png', width: 20, height: 20,) : SizedBox(width: 0,)]
                      ),
                      Text("$year Year, $dept, $hall", style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'gupter',
                          color: Color(0xff8a8989),
                          fontSize: 17),textAlign: TextAlign.start,)],)]
                  ),
                  const SizedBox(height: 10,),




                  (personmail!=EmailIdp)? Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [

                    follows ?

                  ElevatedButton(onPressed: ()async{
                    String? je = personmail.replaceAll("@", '');
                    String? postmail = je.replaceAll(".", "");
                    String? mymail = EmailIdp.replaceAll("@", '');
                    String? minemail = mymail.replaceAll(".", "");
                    DatabaseReference delref = FirebaseDatabase
                        .instance
                        .ref("Following/$minemail/$postmail");
                    DatabaseReference jkl = FirebaseDatabase
                        .instance
                        .ref("Followers/$postmail/$minemail");
                    setState(() {
                      follows = false;
                    });


                    DatabaseReference get =
                    FirebaseDatabase.instance.ref("FollowersCount/$thenmail");
                    get.once().then((value) async {
                      DataSnapshot snap = value.snapshot;
                      if (snap.exists) {
                        Map<dynamic, dynamic> map = snap.value as Map;
                        setState(() {
                          int yu = map["count"];
                          final json = {
                            "count": yu - 1
                          };
                          DatabaseReference ge =
                          FirebaseDatabase.instance.ref("FollowersCount/$thenmail");
                          ge.set(json);
                        });
                      }
                    });




                    await delref.remove();
                    await jkl.remove();

                  }, child: Text("UnFollow")) :
                  ElevatedButton(onPressed: ()async{
                    String? je = personmail.replaceAll("@", '');
                    String? postmail = je.replaceAll(".", "");
                    String? mymail = EmailIdp.replaceAll("@", '');
                    String? minemail = mymail.replaceAll(".", "");
                    DatabaseReference addfollow = FirebaseDatabase
                        .instance
                        .ref("Following/$minemail/$postmail");
                    DatabaseReference addfollower = FirebaseDatabase
                        .instance
                        .ref("Followers/$postmail/$minemail");
                    final json = {
                      "follows":"yes"
                    };
                    final jsonn = {
                      "Name": Namep,
                      "Email_ID": EmailIdp,
                      "PhotoUrl": PhotoUrlp,
                      "Year": Yearp,
                      "Department": Departmentp,
                      "Hall": Hallp,
                      "Bio" : Biop
                    };
                    setState(() {
                      follows = true;
                    });



                    DatabaseReference get =
                    FirebaseDatabase.instance.ref("FollowersCount/$thenmail");
                    get.once().then((value) async {
                      DataSnapshot snap = value.snapshot;
                      if (snap.exists) {
                        Map<dynamic, dynamic> map = snap.value as Map;
                        setState(() async{
                          int yu = map["count"];
                          final json = {
                            "count": yu + 1
                          };
                          DatabaseReference ge =
                          FirebaseDatabase.instance.ref("FollowersCount/$thenmail");
                          await ge.set(json);
                        });
                      } else {
                        setState(() async{
                          final json = {
                            "count": 1
                          };
                          DatabaseReference ge =
                          FirebaseDatabase.instance.ref("FollowersCount/$thenmail");
                          await ge.set(json);
                        });
                      }
                    });



                    await addfollow.set(json);
                    await addfollower.set(jsonn);

                  }, child: Text("Follow")),
                    OutlinedButton(onPressed: (){
                      showDialog(
                          context: context,
                          builder: (_){
                            messagewalamail = thenmail;
                            return Dialog(shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),child: const MessageDialog(),);
                          }
                      );
                    }, child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [Text(" Message", style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Colors.black,),)]),style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.black, width: 1),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                    TextButton(onPressed: (){
                      usalist = 2;
                      konachefollowers = thenmail;
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                        return PersonsList();
                      }));
                    }, child: Text((nofolo==1) ? nofolo.toString()+"\nFollower" : nofolo.toString()+"\nFollowers", style: TextStyle(color: Colors.black, fontFamily: 'gupter',fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.center,))
                    ],
                  ) : SizedBox(height: 0,),









                  (bio == "") ? const SizedBox(height: 0,) :
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        text: 'Bio: ',
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'gupter',
                            color: Colors.orangeAccent), /*defining default style is optional */

                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        text: '$bio',
                        style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'glory',
                            color: Colors.black), /*defining default style is optional */

                      ),
                    ),
                  ),

                  const SizedBox(height: 30,),



                  badges ? Row(children: [SizedBox(width: 20,),Image.asset('images/verr.png', height: 30, width: 30)]) : SizedBox(height: 0,),
                  badges ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '     :- $badgeinfo',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'glory',
                          color: Colors.black), /*defining default style is optional */

                    ),
                  ) : SizedBox(height: 0,),


                  SizedBox(height: 50,),



                  Center(
                    child: SizedBox(
                      width: 148,
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        (instaurl=="") ? const SizedBox(width: 0,): IconButton(onPressed: (){
                          String link = "https://www.instagram.com/$instaurl";
                          launchUrl(Uri.parse(link),
                              mode: LaunchMode.externalApplication);
                        }, icon: Image.asset('images/instagram.png')),
                        (fburl=="") ? const SizedBox(width: 0,): IconButton(onPressed: (){
                          launchUrl(Uri.parse(fburl),
                              mode: LaunchMode.externalApplication);
                        }, icon: Image.asset('images/facebook.png')),
                        (linkedinurl=="") ? const SizedBox(width: 0,): IconButton(onPressed: (){
                          launchUrl(Uri.parse(linkedinurl),
                              mode: LaunchMode.externalApplication);
                        }, icon: Image.asset('images/linkedin.png'))
                      ],),
                    ),
                  ),


                ],)
              )
          )),
    );
  }
}
