import 'package:flutter/material.dart';
import 'package:kgppanchayat/societyinfo.dart';
import 'package:kgppanchayat/temp.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';

class Intern extends StatefulWidget {
  const Intern({Key? key}) : super(key: key);

  @override
  State<Intern> createState() => _InternState();
}

class _InternState extends State<Intern> {
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
              "Placement & Internship",
              style: TextStyle(color: Colors.black, fontFamily: 'gupter'),
            ),
          ),
          body: Container(
            color: Color(0xfff1f2f6),
            height: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text("Powered by:", style: TextStyle(fontSize: 18,fontFamily: 'glory', fontWeight: FontWeight.bold, color: Colors.grey),textAlign: TextAlign.center,),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder:
                              (BuildContext context) {
                            societyname = "Communiqué";
                            societyphoto = "https://firebasestorage.googleapis.com/v0/b/kgppanchayat-6356e.appspot.com/o/SocietiesPhoto%2F287948070_736458940734716_1480473895532563764_n.jpg?alt=media&token=d310d690-7f08-4d49-8afb-b18dd6fd1641";
                            societyinfo = "Anindya Dutta created Communiqué in 2006 with the novel goal of giving IIT Kharagpur students a solid platform to develop their soft skills and personalities. This idea was inspired by the disappointment of hiring companies with the communication skills of the brilliant students. Communiqué works to achieve its mission of inspiring, fostering confidence, and providing each KGPian with soft skills that will help them develop a successful career. Communiqué recognizes the value of communication and soft skills in both personal and professional life. It also takes into account the varied backgrounds of the students.";
                            societyinsta = "https://www.instagram.com/communique_iitkgp/";
                            societyfacebook = "https://www.facebook.com/communique.iitkgp/";
                            societylinkedin = "https://www.linkedin.com/company/communiqu-iit-kharagpur/about/";
                            societyweb = "http://www.cqiitkgp.com/";
                            return const SocInfo();
                          }));
                    },
                    child: Card(child: Container(width: 250,child: Column(
                        children: [SizedBox(height: 3,),Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 15,),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 0),
                              child: SizedBox(
                                height: 42,
                                width: 42,
                                child: ClipRRect(borderRadius: BorderRadius.circular(100),child: Image.asset('images/communique.jpg'),),
                              ),
                            ),
                            SizedBox(width: 15,),
                            Flexible(
                              child: Text(
                                "Communiqué",
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight:
                                    FontWeight.bold,
                                    fontFamily: 'martel',
                                    color: Colors.black),
                              ),
                            ),
                            SizedBox(width: 5,)
                          ],
                        ),SizedBox(height: 3,)]
                    ),)),
                  ),
                  SizedBox(height: 10),
                  Row(children: const [
                    SizedBox(
                      width: 15,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Placement:",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'allura',
                              fontSize: 30)),
                    )
                  ]),
                  SizedBox(height: 10),
                  Row(children: const [
                    SizedBox(
                      width: 15,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Software:",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'martel',
                              fontSize: 17)),

                    )
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [OutlinedButton(onPressed: (){
                    String link = "https://youtube.com/playlist?list=PLjbVxBu5FA6OHFC9AxP2NIgRTwef-fmeI";
                    launchUrl(Uri.parse(link),
                        mode: LaunchMode.externalApplication);
                  }, child: Text("Video Series",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black, width: 1),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                    OutlinedButton(onPressed: (){
                      String link = "https://cq-iitkharagpur.medium.com/list/cqsoftwaretalks-c1f33eebec65";
                      launchUrl(Uri.parse(link),
                          mode: LaunchMode.externalApplication);
                    }, child: Text("Articles",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.black, width: 1),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),],),



                  SizedBox(height: 5),
                  Row(children: const [
                    SizedBox(
                      width: 15,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Consult:",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'martel',
                              fontSize: 17)),

                    )
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [OutlinedButton(onPressed: (){
                    String link = "https://youtube.com/playlist?list=PLjbVxBu5FA6NwzyO19MiAPjsKNctwLwU3";
                    launchUrl(Uri.parse(link),
                        mode: LaunchMode.externalApplication);
                  }, child: Text("Video Series",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black, width: 1),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                    OutlinedButton(onPressed: (){
                      String link = "https://cq-iitkharagpur.medium.com/list/cqconsultalks-41d419b1790c";
                      launchUrl(Uri.parse(link),
                          mode: LaunchMode.externalApplication);
                    }, child: Text("Articles",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.black, width: 1),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),],),

                  SizedBox(height: 5),
                  Row(children: const [
                    SizedBox(
                      width: 15,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Finance:",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'martel',
                              fontSize: 17)),

                    )
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [OutlinedButton(onPressed: (){
                    String link = "https://youtube.com/playlist?list=PLjbVxBu5FA6PaqY38xEM6o3_JG68_AFgI";
                    launchUrl(Uri.parse(link),
                        mode: LaunchMode.externalApplication);
                  }, child: Text("Video Series",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black, width: 1),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                    OutlinedButton(onPressed: (){
                      String link = "https://cq-iitkharagpur.medium.com/list/cqfinforte-515b32cc3adf";
                      launchUrl(Uri.parse(link),
                          mode: LaunchMode.externalApplication);
                    }, child: Text("Articles",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.black, width: 1),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),],),

                  SizedBox(height: 5),
                  Row(children: const [
                    SizedBox(
                      width: 15,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Core:",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'martel',
                              fontSize: 17)),

                    )
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [OutlinedButton(onPressed: (){
                    String link = "https://youtube.com/playlist?list=PLjbVxBu5FA6Ogf3O0qJqXHk0wnYOel2Zu";
                    launchUrl(Uri.parse(link),
                        mode: LaunchMode.externalApplication);
                  }, child: Text("Video Series",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black, width: 1),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                    OutlinedButton(onPressed: (){
                      String link = "https://cq-iitkharagpur.medium.com/list/cqcorecombat-d1de5b8e732f";
                      launchUrl(Uri.parse(link),
                          mode: LaunchMode.externalApplication);
                    }, child: Text("Articles",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.black, width: 1),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),],),


                  SizedBox(height: 5),
                  Row(children: const [
                    SizedBox(
                      width: 15,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("FMCG:",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'martel',
                              fontSize: 17)),

                    )
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [OutlinedButton(onPressed: (){
                    String link = "https://youtube.com/playlist?list=PLjbVxBu5FA6Pi2bpFEpvQcx8J8aUlEA_7";
                    launchUrl(Uri.parse(link),
                        mode: LaunchMode.externalApplication);
                  }, child: Text("Video Series",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black, width: 1),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                    OutlinedButton(onPressed: (){
                      String link = "https://cq-iitkharagpur.medium.com/list/cqfmcgluminaries-240108407147";
                      launchUrl(Uri.parse(link),
                          mode: LaunchMode.externalApplication);
                    }, child: Text("Articles",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.black, width: 1),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),],),


                  SizedBox(height: 5),
                  Row(children: const [
                    SizedBox(
                      width: 15,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Data:",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'martel',
                              fontSize: 17)),

                    )
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [OutlinedButton(onPressed: (){
                    String link = "https://youtube.com/playlist?list=PLjbVxBu5FA6Ofl9B9mTvvxCxpbzioLfpA";
                    launchUrl(Uri.parse(link),
                        mode: LaunchMode.externalApplication);
                  }, child: Text("Video Series",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black, width: 1),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                    ],),


                  SizedBox(height: 5),
                  Row(children: const [
                    SizedBox(
                      width: 15,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Product:",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'martel',
                              fontSize: 17)),

                    )
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [OutlinedButton(onPressed: (){
                    String link = "https://youtube.com/playlist?list=PLjbVxBu5FA6MklqfZEXhMNF6EUKX8aKEL";
                    launchUrl(Uri.parse(link),
                        mode: LaunchMode.externalApplication);
                  }, child: Text("Video Series",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black, width: 1),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                  ],),


                  SizedBox(height: 5),
                  Row(children: const [
                    SizedBox(
                      width: 15,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Datacrux:",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'martel',
                              fontSize: 17)),

                    )
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                    OutlinedButton(onPressed: (){
                      String link = "https://cq-iitkharagpur.medium.com/list/cqdatacrux-3cbf44634c26";
                      launchUrl(Uri.parse(link),
                          mode: LaunchMode.externalApplication);
                    }, child: Text("Articles",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.black, width: 1),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),],),


                  SizedBox(height: 5),
                  Row(children: const [
                    SizedBox(
                      width: 15,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Product:",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'martel',
                              fontSize: 17)),

                    )
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                    OutlinedButton(onPressed: (){
                      String link = "https://cq-iitkharagpur.medium.com/list/cqproductseries-ee806f921a24";
                      launchUrl(Uri.parse(link),
                          mode: LaunchMode.externalApplication);
                    }, child: Text("Articles",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.black, width: 1),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)))),],),






                  SizedBox(height: 10),
                  Row(children: const [
                    SizedBox(
                      width: 15,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Internship:",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'allura',
                              fontSize: 30)),
                    )
                  ]),
                  SizedBox(height: 10),
                  Row(children: const [
                    SizedBox(
                      width: 15,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("CV Building:",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'martel',
                              fontSize: 17)),

                    )
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [OutlinedButton(onPressed: (){
                    String link = "https://youtube.com/playlist?list=PLjbVxBu5FA6NnnO5tVfseoJFDFZUkNWyy";
                    launchUrl(Uri.parse(link),
                        mode: LaunchMode.externalApplication);
                  }, child: Text("Video Series",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black, width: 1),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                    ],),

                  SizedBox(height: 5),
                  Row(children: const [
                    SizedBox(
                      width: 15,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Off-Campus:",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'martel',
                              fontSize: 17)),

                    )
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [OutlinedButton(onPressed: (){
                    String link = "https://youtube.com/playlist?list=PLjbVxBu5FA6MLLyq6cyO5NPFWv4pJ0SvV";
                    launchUrl(Uri.parse(link),
                        mode: LaunchMode.externalApplication);
                  }, child: Text("Video Series",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black, width: 1),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                  ],),



                  SizedBox(height: 5),
                  Row(children: const [
                    SizedBox(
                      width: 15,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Software:",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'martel',
                              fontSize: 17)),

                    )
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [OutlinedButton(onPressed: (){
                    String link = "https://youtube.com/playlist?list=PLjbVxBu5FA6Octgoox0BvnKiU4Ai4-ZVO";
                    launchUrl(Uri.parse(link),
                        mode: LaunchMode.externalApplication);
                  }, child: Text("Video Series",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black, width: 1),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                  ],),



                  SizedBox(height: 5),
                  Row(children: const [
                    SizedBox(
                      width: 15,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Consult:",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'martel',
                              fontSize: 17)),

                    )
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [OutlinedButton(onPressed: (){
                    String link = "https://youtube.com/playlist?list=PLjbVxBu5FA6OPDURwwIy-uDzguvs2dUMn";
                    launchUrl(Uri.parse(link),
                        mode: LaunchMode.externalApplication);
                  }, child: Text("Video Series",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black, width: 1),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                  ],),




                  SizedBox(height: 5),
                  Row(children: const [
                    SizedBox(
                      width: 15,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Finance:",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'martel',
                              fontSize: 17)),

                    )
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [OutlinedButton(onPressed: (){
                    String link = "https://youtube.com/playlist?list=PLjbVxBu5FA6MITXCFJ9kaP9Md_62lVJBB";
                    launchUrl(Uri.parse(link),
                        mode: LaunchMode.externalApplication);
                  }, child: Text("Video Series",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black, width: 1),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                  ],),



                  SizedBox(height: 5),
                  Row(children: const [
                    SizedBox(
                      width: 15,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Core:",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'martel',
                              fontSize: 17)),

                    )
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [OutlinedButton(onPressed: (){
                    String link = "https://youtube.com/playlist?list=PLjbVxBu5FA6MgSRmk-6PJSuDanaqHm0-c";
                    launchUrl(Uri.parse(link),
                        mode: LaunchMode.externalApplication);
                  }, child: Text("Video Series",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black, width: 1),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                  ],),


                  SizedBox(height: 5),
                  Row(children: const [
                    SizedBox(
                      width: 15,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Analytics:",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'martel',
                              fontSize: 17)),

                    )
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [OutlinedButton(onPressed: (){
                    String link = "https://youtube.com/playlist?list=PLjbVxBu5FA6OWF_qW6Ue5nb2pWmohZwvt";
                    launchUrl(Uri.parse(link),
                        mode: LaunchMode.externalApplication);
                  }, child: Text("Video Series",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black, width: 1),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                  ],),



                  SizedBox(height: 5),
                  Row(children: const [
                    SizedBox(
                      width: 15,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("FMCG:",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'martel',
                              fontSize: 17)),

                    )
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [OutlinedButton(onPressed: (){
                    String link = "https://youtube.com/playlist?list=PLjbVxBu5FA6MC1o5cGFpsjZ74x2U0MvfK";
                    launchUrl(Uri.parse(link),
                        mode: LaunchMode.externalApplication);
                  }, child: Text("Video Series",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black, width: 1),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                  ],),




                  SizedBox(height: 5),
                  Row(children: const [
                    SizedBox(
                      width: 15,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Data:",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'martel',
                              fontSize: 17)),

                    )
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [OutlinedButton(onPressed: (){
                    String link = "https://youtube.com/playlist?list=PLjbVxBu5FA6PQvbM6ET-9mbYJM-3lfHbD";
                    launchUrl(Uri.parse(link),
                        mode: LaunchMode.externalApplication);
                  }, child: Text("Video Series",style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black, width: 1),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                  ],),
                  SizedBox(height: 15,)
                ],
              ),
            ),
          ),
        ));
  }
}
