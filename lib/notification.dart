import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kgppanchayat/main.dart';
import 'package:kgppanchayat/splash.dart';
import 'package:kgppanchayat/temp.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class NotiSett extends StatefulWidget {
  const NotiSett({Key? key}) : super(key: key);

  @override
  State<NotiSett> createState() => _NotiSettState();
}

class _NotiSettState extends State<NotiSett> {
  void toggleall(bool vale) {
    setState(() {
      notiall = !notiall;
    });
  }
  void toggledept(bool vale) {
    setState(() {
      notidept = !notidept;
    });
  }
  void togglehall(bool vale) {
    setState(() {
      notihall = !notihall;
    });
  }
  void toggleevents(bool vale) {
    setState(() {
      notievents = !notievents;
    });
  }
  void togglefunde(bool vale) {
    setState(() {
      notifundae = !notifundae;
    });
  }
  void togglelost(bool vale) {
    setState(() {
      notilost = !notilost;
    });
  }
  void togglecomment(bool vale) {
    setState(() {
      noticomment = !noticomment;
    });
  }
  bool updateload = false;



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
            "Notification Settings",
            style: TextStyle(color: Colors.black, fontFamily: 'gupter'),
          ),
        ),
        body: Container(
          height: double.maxFinite,
          color: Color(0xfff1f2f6),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Row(children: [
                      SizedBox(width: 50,),
                      Text(
                        "All:",
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'gupter',
                            color: Colors.black),
                      ),
                      Spacer(),
                      Switch(
                        value: notiall,
                        onChanged: toggleall,
                        activeColor: Colors.deepOrange,
                        inactiveThumbColor: Colors.white,
                      ),
                      SizedBox(width: 50,)
                    ]),
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Row(children: [
                      SizedBox(width: 50),
                      Text(
                        "Department:",
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'gupter',
                            color: Colors.black),
                      ),
                      Spacer(),
                      Switch(
                        value: notidept,
                        onChanged: toggledept,
                        activeColor: Colors.deepOrange,
                        inactiveThumbColor: Colors.white,
                      ),
                      SizedBox(width: 50)
                    ]),
                  ),
                ),
                SizedBox(height: 15,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Row(children: [
                      SizedBox(width: 50),
                      Text(
                        "Hall:",
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'gupter',
                            color: Colors.black),
                      ),
                      Spacer(),
                      Switch(
                        value: notihall,
                        onChanged: togglehall,
                        activeColor: Colors.deepOrange,
                        inactiveThumbColor: Colors.white,
                      ),
                      SizedBox(width: 50,)
                    ]),
                  ),
                ),
                SizedBox(height: 15,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Row(children: [
                      SizedBox(width: 50),
                      Text(
                        "Events:",
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'gupter',
                            color: Colors.black),
                      ),
                      Spacer(),
                      Switch(
                        value: notievents,
                        onChanged: toggleevents,
                        activeColor: Colors.deepOrange,
                        inactiveThumbColor: Colors.white,
                      ),
                      SizedBox(width: 50,)
                    ]),
                  ),
                ),
                SizedBox(height: 15,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Row(children: [
                      SizedBox(width: 50),
                      Text(
                        "Fundae:",
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'gupter',
                            color: Colors.black),
                      ),
                      Spacer(),
                      Switch(
                        value: notifundae,
                        onChanged: togglefunde,
                        activeColor: Colors.deepOrange,
                        inactiveThumbColor: Colors.white,
                      ),
                      SizedBox(width: 50,)
                    ]),
                  ),
                ),
                SizedBox(height: 15,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Row(children: [
                      SizedBox(width: 50),
                      Text(
                        "Lost & Found:",
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'gupter',
                            color: Colors.black),
                      ),
                      Spacer(),
                      Switch(
                        value: notilost,
                        onChanged: togglelost,
                        activeColor: Colors.deepOrange,
                        inactiveThumbColor: Colors.white,
                      ),
                      SizedBox(width: 50,)
                    ]),
                  ),
                ),
                SizedBox(height: 15,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Row(children: [
                      SizedBox(width: 50),
                      Text(
                        "Comments and\nMessage:",
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'gupter',
                            color: Colors.black),
                      ),
                      Spacer(),
                      Switch(
                        value: noticomment,
                        onChanged: togglecomment,
                        activeColor: Colors.deepOrange,
                        inactiveThumbColor: Colors.white,
                      ),
                      SizedBox(width: 50,)
                    ]),
                  ),
                ),
                SizedBox(height: 50,),
                updateload
                    ? LoadingAnimationWidget.threeArchedCircle(
                    color: const Color(0xffea8537), size: 38)
                    : OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.black, width: 1),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      setState(() {
                        updateload = true;
                      });
                      String? mymail = EmailIdp.replaceAll("@", '');
                      String? minemail = mymail.replaceAll(".", "");
                      DatabaseReference df = FirebaseDatabase.instance.ref("NotiSett/$minemail");
                      final jsons = {
                        'All': notiall,
                        'Dept': notidept,
                        'Hall': notihall,
                        'Events' : notievents,
                        'Fundae': notifundae,
                        'Lost': notilost,
                        'Comment': noticomment
                      };
                      await df.set(jsons);
                      open = true;
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const Splash()),
                          ModalRoute.withName("/Temp"));
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Done",
                          style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804))
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Temp()),
            ModalRoute.withName("/Temp"));

        return true;
      },
    );
  }
}
