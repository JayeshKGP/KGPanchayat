import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kgppanchayat/gettersocieties.dart';
import 'package:kgppanchayat/main.dart';
import 'package:kgppanchayat/societyiidialog.dart';
import 'package:kgppanchayat/societyinfo.dart';
import 'package:kgppanchayat/temp.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher.dart';

class Societies extends StatefulWidget {
  const Societies({Key? key}) : super(key: key);

  @override
  State<Societies> createState() => _SocietiesState();
}
final searchcon = TextEditingController();
class _SocietiesState extends State<Societies> {
  int hh = 0;
  bool countbool = false;
  bool clearvisi = false;

  @override
  void initState() {
    searchcon.clear();
    listsoc.clear();
    listsocextra.clear();
    ssoo.clear();
    searchcon.addListener(() {
      setState(() {
        if (searchcon.text == "") {
          clearvisi = false;
          listsoc.clear();
          int tt = listsocextra.length;
          for (int i = tt - 1; i >= 0; i--) {
            listsoc.insert(0, listsocextra[i]);
          }
        } else {
          clearvisi = true;
          listsoc.clear();
          int tt = listsocextra.length;
          for (int i = tt - 1; i >= 0; i--) {
            if (listsocextra[i]
                .Name
                .toLowerCase()
                .contains(searchcon.text.toLowerCase())) {
              listsoc.insert(0, listsocextra[i]);
            }
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    DatabaseReference reference = FirebaseDatabase.instance.ref("Societies");
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
      SocietyList de = SocietyList(
          Name: map["Name"],
          PhotoUrl: map["PhotoUrl"],
          Info: map["Info"],
          Insta: map["Insta"],
          Facebook: map["Facebook"],
          LinkedIn: map["LinkedIn"],
          Website: map["Website"]);
      setState(() {
        if (listsocextra.length != hh) {
          if (listsocextra.length < hh) {
            if (ssoo.contains(map["Name"])) {
            } else {
              int u = listsoc.length;
              listsoc.insert(u, de);
              listsocextra.insert(u, de);
              ssoo.insert(u, map["Name"]);
            }
          } else if (listsocextra.length > hh) {
            listsoc.clear();
            listsocextra.clear();
            ssoo.clear();
            listsoc.insert(0, de);
            listsocextra.insert(0, de);
            ssoo.insert(0, map["Name"]);
          }
        }
      });
    });

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
        backgroundColor: const Color(0xffffdfaf),
        titleSpacing: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        actions: [IconButton(onPressed: (){
          showDialog(
              context: context,
              builder: (_){
                return Dialog(shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),child: const SocietyiDialog(),);
              }
          );
        }, icon: Icon(Icons.info_outline, color: Colors.black,))],
        title: const Text(
          "Societies & Clubs",
          style: TextStyle(color: Colors.black, fontFamily: 'gupter'),
        ),
      ),
      body: countbool
          ? const Center(
          child: Text(
            "No Societies",
            style: TextStyle(color: Colors.white),
          ))
          : Container(
        height: double.maxFinite,
        color: const Color(0xfff1f2f6),
        child: Column(children: [
          SizedBox(height: 25,),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 0, horizontal: 50),
            child: TextField(
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontFamily: 'martel'),
              cursorColor: Colors.black,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.black,size: 30,),
                  suffixIcon: Visibility(
                      visible: clearvisi,
                      child: IconButton(
                          onPressed: cleartext,
                          icon: Icon(
                            Icons.clear,
                            color: Colors.red,
                          ))),
                  hintStyle: TextStyle(
                      fontSize: 20,
                      color: Color(
                        0xffb6b4b4,
                      ),
                      fontFamily: 'martel'),
                  filled: true,
                  hintText: "Search...",
                  enabledBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(18)),
                      borderSide: BorderSide(
                          color: Color(0xff424242), width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(18)),
                      borderSide: BorderSide(
                          color: Color(0xff2c2c2c), width: 2))),
              controller: searchcon,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: listsoc.length,
                itemBuilder: (_, index) {
                  String name = listsoc[index].Name;
                  String photoUrl = listsoc[index].PhotoUrl;
                  String info = listsoc[index].Info;
                  String insta = listsoc[index].Insta;
                  String facebook = listsoc[index].Facebook;
                  String linkedin = listsoc[index].LinkedIn;
                  String website = listsoc[index].Website;

                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder:
                              (BuildContext context) {
                            societyname = name;
                            societyphoto = photoUrl;
                            societyinfo = info;
                            societyinsta = insta;
                            societyfacebook = facebook;
                            societylinkedin = linkedin;
                            societyweb = website;
                            return const SocInfo();
                          }));
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
                                    imageUrl: photoUrl,
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

void cleartext() {
  searchcon.clear();
}

