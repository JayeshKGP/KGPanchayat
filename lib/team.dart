import 'package:flutter/material.dart';
import 'package:kgppanchayat/personprofile.dart';
import 'package:kgppanchayat/temp.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';

class Team extends StatefulWidget {
  const Team({Key? key}) : super(key: key);

  @override
  State<Team> createState() => _TeamState();
}

class _TeamState extends State<Team> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Temp()),
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
            backgroundColor: Color(0xffffdfaf),
            titleSpacing: 0,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            title: const Text(
              "Our Team",
              style: TextStyle(color: Colors.black, fontFamily: 'gupter'),
            ),
          ),
          body: Container(
            color: Color(0xfff1f2f6),
            height: double.maxFinite,
            width: double.maxFinite,
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) {
                          personmail = "jayeshdeshmukh@kgpian.iitkgp.ac.in";
                          return const PersonProfile();
                        }));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Container(
                        width: 250,
                        height: 250,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Founder & Developer",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'courgette'),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'images/jayesh.jpg',
                                height: 80,

                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              "Deshmukh Jayesh",
                              style: TextStyle(fontSize: 20, fontFamily: 'martel'),
                            ),
                            Text("2nd Year, AGFE, VS", style: TextStyle(fontSize: 20, fontFamily: 'glory', fontWeight: FontWeight.bold,color: Colors.blueGrey)),
                            SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      String link = "https://www.instagram.com/jayeshdeshmukh1902/";
                                      launchUrl(Uri.parse(link),
                                          mode: LaunchMode.externalApplication);
                                    },
                                    icon: Image.asset("images/instagram.png")),
                                IconButton(
                                    onPressed: () {
                                      String link = "https://www.facebook.com/profile.php?id=100084844342600";
                                      launchUrl(Uri.parse(link),
                                          mode: LaunchMode.externalApplication);
                                    },
                                    icon: Image.asset("images/facebook.png")),
                                IconButton(
                                    onPressed: () {
                                      String link = "https://www.linkedin.com/in/jayesh-deshmukh-kgp/";
                                      launchUrl(Uri.parse(link),
                                          mode: LaunchMode.externalApplication);
                                    },
                                    icon: Image.asset("images/linkedin.png")),
                              ],
                            )
                          ],
                        )),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) {
                          personmail = "sharwarimuley02@kgpian.iitkgp.ac.in";
                          return const PersonProfile();
                        }));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Container(
                        width: 250,
                        height: 250,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Design Head",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'courgette'),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'images/Sharwari.jpg',
                                height: 80,

                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              "Sharwari Muley",
                              style: TextStyle(fontSize: 20, fontFamily: 'martel'),
                            ),
                            Text("2nd Year, Meta, SNIG", style: TextStyle(fontSize: 20, fontFamily: 'glory', fontWeight: FontWeight.bold,color: Colors.blueGrey)),
                            SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      String link = "https://www.instagram.com/sharwari_0212/";
                                      launchUrl(Uri.parse(link),
                                          mode: LaunchMode.externalApplication);
                                    },
                                    icon: Image.asset("images/instagram.png")),
                                IconButton(
                                    onPressed: () {
                                      String link = "https://www.facebook.com/profile.php?id=100087380539244";
                                      launchUrl(Uri.parse(link),
                                          mode: LaunchMode.externalApplication);
                                    },
                                    icon: Image.asset("images/facebook.png")),
                                IconButton(
                                    onPressed: () {
                                      String link = "https://www.linkedin.com/in/sharwari-muley-1a3304261/";
                                      launchUrl(Uri.parse(link),
                                          mode: LaunchMode.externalApplication);
                                    },
                                    icon: Image.asset("images/linkedin.png")),
                              ],
                            )
                          ],
                        )),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) {
                          personmail = "1rushikeshkanade@kgpian.iitkgp.ac.in";
                          return const PersonProfile();
                        }));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Container(
                        width: 250,
                        height: 250,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Co-founder & Strategy",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'courgette'),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'images/Rushikesh.jpg',
                                height: 80,

                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              "Kanade Rushikesh",
                              style: TextStyle(fontSize: 20, fontFamily: 'martel'),
                            ),
                            Text("2nd Year, Eco, HJB", style: TextStyle(fontSize: 20, fontFamily: 'glory', fontWeight: FontWeight.bold,color: Colors.blueGrey)),
                            SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      String link = "https://www.instagram.com/rushikanade/";
                                      launchUrl(Uri.parse(link),
                                          mode: LaunchMode.externalApplication);
                                    },
                                    icon: Image.asset("images/instagram.png")),
                                IconButton(
                                    onPressed: () {
                                      String link = "https://www.facebook.com/rushi.kanade.948";
                                      launchUrl(Uri.parse(link),
                                          mode: LaunchMode.externalApplication);
                                    },
                                    icon: Image.asset("images/facebook.png")),
                                IconButton(
                                    onPressed: () {
                                      String link = "https://www.linkedin.com/in/rushikesh-kanade-970a15259/";
                                      launchUrl(Uri.parse(link),
                                          mode: LaunchMode.externalApplication);
                                    },
                                    icon: Image.asset("images/linkedin.png")),
                              ],
                            )
                          ],
                        )),
                  ),
                ),
              ],
            )),
          ),
        ));
  }
}
