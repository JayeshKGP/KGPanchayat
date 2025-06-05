import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kgppanchayat/getterlinks.dart';
import 'package:kgppanchayat/main.dart';
import 'package:kgppanchayat/temp.dart';
import 'package:url_launcher/url_launcher.dart';

class ImpLinks extends StatefulWidget {
  const ImpLinks({Key? key}) : super(key: key);

  @override
  State<ImpLinks> createState() => _ImpLinksState();
}

class _ImpLinksState extends State<ImpLinks> {
  int hh = 0;
  bool countbool = false;

  @override
  void initState() {
    listlink.clear();
    llii.clear();

  }


  @override
  Widget build(BuildContext context) {

    DatabaseReference reference = FirebaseDatabase.instance.ref("Links");
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
      hh = map.length;
    });
    reference.orderByChild("Name").onChildAdded.listen((DatabaseEvent value) {
      DataSnapshot snapshot = value.snapshot;

      Map<dynamic, dynamic> map = snapshot.value as Map;
      LinkList de = LinkList(
          Name: map["Name"],
          Link: map["Link"],
      Photo: map["Photo"]);
      setState(() {
        if (listlink.length != hh) {
          if (listlink.length < hh) {
            if (llii.contains(map["Name"])) {
            } else {
              int u = listlink.length;
              listlink.insert(u, de);
              llii.insert(u, map["Name"]);
            }
          } else if (listlink.length > hh) {
            listlink.clear();
            llii.clear();
            listlink.insert(0, de);
            llii.insert(0, map["Name"]);
          }
        }
      });
    });

    return WillPopScope(onWillPop: () async {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Temp()),
          ModalRoute.withName("/Temp"));

      return true;
    },
    child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black,),
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
          "Important Links",
          style: TextStyle(color: Colors.black, fontFamily: 'gupter'),
        ),
      ),
      body: countbool
          ? const Center(
          child: Text(
            "No Links",
              style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'glory', fontWeight: FontWeight.bold),
          ))
          : Container(
        height: double.maxFinite,
        color: const Color(0xfff1f2f6),
        child: Column(children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: listlink.length,
                itemBuilder: (_, index) {
                  String name = listlink[index].Name;
                  String link = listlink[index].Link;
                  String photo = listlink[index].Photo;

                  return GestureDetector(
                    onTap: (){
                      launchUrl(Uri.parse(link),
                          mode: LaunchMode.externalApplication);
                    },
                    child: Card(
                      color: Colors.white,
                      child: Column(
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
                                  child: CachedNetworkImage(
                                    imageUrl: photo,
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
                                    },
                                    imageBuilder:
                                        (context, imageProvider) =>
                                        Container(
                                          width: 42.0,
                                          height: 42.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                    errorWidget:
                                        (context, url, error) =>
                                    const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              SizedBox(width: 15,),
                              Flexible(
                                child: Text(
                                  name,
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
                      ),
                    ),
                  );
                }),
          ),
        ]),
      ),
    ));
  }
}
