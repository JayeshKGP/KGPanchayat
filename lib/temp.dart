import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kgppanchayat/lost.dart';
import 'package:kgppanchayat/messageing.dart';
import 'package:kgppanchayat/mystoryview.dart';
import 'package:kgppanchayat/personprofile.dart';
import 'package:kgppanchayat/personslist.dart';
import 'package:kgppanchayat/showimage.dart';
import 'package:kgppanchayat/stories.dart';
import 'package:kgppanchayat/storyview.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'academic.dart';
import 'addpost.dart';
import 'hall.dart';
import 'allpost.dart';
import 'drawer.dart';
import 'funde.dart';
import 'getter.dart';
import 'main.dart';
import 'event.dart';

File? file;

List ids = [];
List<Details> listh = [];
List idsh = [];
List<Details> lista = [];
List idsa = [];
List<Details> liste = [];
List idse = [];
List<Details> listf = [];
List idsf = [];
List<Details> listl = [];
List idsl = [];


List<Stories> storyl = [];
List storal = [];
int unreadcount = 0;
int prog = 0;
bool storyuploaded = false;
String mystoryid = "";
String mystoryurl = "";

class Temp extends StatefulWidget {
  const Temp({Key? key}) : super(key: key);

  @override
  State<Temp> createState() => _TempState();
}

final ItemScrollController itemScrollControllerm = ItemScrollController();
final ItemPositionsListener itemPositionsListenerm =
    ItemPositionsListener.create();
bool update = true;

class _TempState extends State<Temp> with TickerProviderStateMixin {
  late TabController controller;
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 6, vsync: this);
    controller.index = tabindex;
    controller.addListener(_setActiveTabIndex);
    storal.clear();
    storyl.clear();
  }

  void _setActiveTabIndex() {
    tabindex = controller.index;
  }

  @override
  Widget build(BuildContext context) {




    DatabaseReference reference = FirebaseDatabase.instance.ref("Stories");
    reference.orderByChild("ID").onChildAdded.listen((DatabaseEvent value) {
      DataSnapshot snapshot = value.snapshot;

      Map<dynamic, dynamic> map = snapshot.value as Map;
      Stories stories = Stories(
          Name: map["Name"],
          PhotoUrl: map["PhotoUrl"],
          ImageUrl: map["ImageUrl"],
          Email_ID: map["Email_ID"],
          ID: map["ID"],
          date: map["date"],
          islike: false);
      String date = map["date"];
      String strid = map["ID"];
      String tyachamail = map["Email_ID"];
      var posttime = DateTime.parse(date);
      var nowtime = DateTime.now();
      var diff = nowtime.difference(posttime).inHours;
      if(diff.toInt() > 23){
        String? jh = tyachamail.replaceAll("@", '');
        String? mai = jh.replaceAll(".", "");

        DatabaseReference delre = FirebaseDatabase.instance.ref("Stories/$strid");
        delre.remove();
        DatabaseReference delref = FirebaseDatabase.instance.ref("MyStories/$mai");
        delref.remove();
      }else{
        String? jh = tyachamail.replaceAll("@", '');
        String? mai = jh.replaceAll(".", "");
        String? mymail = EmailIdp.replaceAll("@", '');
        String? minemail = mymail.replaceAll(".", "");
        DatabaseReference get = FirebaseDatabase.instance.ref("Following/$minemail/$mai");
        get.once().then((value) async {
          DataSnapshot snap = value.snapshot;
          if (snap.exists) {
            if (storal.contains(map["ID"])) {
            } else {
              storal.insert(0, map["ID"]);
              storyl.insert(0, stories);
            }
          } else {
          }
        });
      }

    });

    String? mymail = EmailIdp.replaceAll("@", '');
    String? minemail = mymail.replaceAll(".", "");
    DatabaseReference get = FirebaseDatabase.instance.ref("Unread/$minemail");
    get.once().then((value) async {
      DataSnapshot snap = value.snapshot;
      if (snap.exists) {
        Map<dynamic, dynamic> map = snap.value as Map;
        unreadcount = map["number"];
      } else {
        unreadcount = 0;
      }
    });
    DatabaseReference fgjg = FirebaseDatabase.instance.ref("MyStories/$minemail");
    fgjg.once().then((valu) async {
      DataSnapshot sna = valu.snapshot;
      if (sna.exists) {
        setState(() {
          storyuploaded = true;
        });
        Map<dynamic, dynamic> m = sna.value as Map;
        mystoryid = m["ID"];
        mystoryurl = m["URL"];
      }else{
        setState(() {
          storyuploaded = false;
        });
      }
    });

    String? g = EmailIdp.replaceAll("@", '');
    String? hyu = g.replaceAll(".", "");
    DatabaseReference bafd =
    FirebaseDatabase.instance.ref("Badge/$hyu/");
    bafd.once().then((value) async {
      DataSnapshot snap = value.snapshot;
      if (snap.exists) {
        kyaverified = true;
      } else {
        kyaverified = false;
      }
    });


    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text(
          "KGPanchayat",
          style: TextStyle(color: Colors.black, fontFamily: 'cagliostro', fontSize: 25),
        ),
        backgroundColor: Color(0xffffdfaf),
        toolbarHeight: 50,
        bottomOpacity: 0.0,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Center(
            child: GestureDetector(
              onTap: () {
                usalist = 1;
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                  return const PersonsList();
                }));
              },
              child: Icon(Icons.search, size: 30,),
            ),
          ),SizedBox(width: 10,),Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Messaging()),
                    ModalRoute.withName("/Temp"));
              },
              child: Badge(
                child: Icon(Icons.inbox),
                label: Text(unreadcount.toString()),
              ),
            ),
          ),
          SizedBox(width: 15,)
        ],
      ),
      body: Container(
        color: Color(0xfff1f2f6),
        height: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(height: 1,color: Colors.black,),
              Container(height: 7,color: Colors.white,),
              Container(
                color: Colors.white,
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: SizedBox(
                    height: 25,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                      child: TabBar(
                          isScrollable: true,
                          indicatorPadding:
                          const EdgeInsets.symmetric(horizontal: 7),
                          controller: controller,
                          indicator: const BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),
                            color: Color(0xffffc491),
                          ),
                          labelColor: const Color(0xff5a3e28),
                          unselectedLabelColor: Colors.black,
                          labelStyle:
                          const TextStyle(fontFamily: 'glory', fontSize: 17, fontWeight: FontWeight.bold),
                          tabs: const [
                            Tab(text: "All"),
                            Tab(text: "Dept"),
                            Tab(text: "Hall"),
                            Tab(
                              text: "Events",
                            ),
                            Tab(
                              text: "Fundae",
                            ),
                            Tab(
                              text: "Lost & Found",
                            )
                          ]),
                    ),
                  ),
                ),
              ),
              Container(height: 7,color: Colors.white,),
              Container(height: 1,color: Colors.black,),
              Container(height: 11,color: Color(0xffffdfaf),),
              Container(height: 1,color: Colors.black,),
              Container(
                height: 130,
                child: Row(children: [SizedBox(width: 8,),
                  storyuploaded
                      ? GestureDetector(
                        onTap: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {

                                return const MyStoryView();
                              }));
                        },
                        child: SizedBox(
                          height: 130,
                          width: 90,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                height: 80,
                                width: 80,
                                child: CachedNetworkImage(
                                  imageUrl: mystoryurl,
                                  progressIndicatorBuilder:
                                      (_, url, download) {
                                    if (download.progress != null) {
                                      final percent =
                                          download.progress! * 100;
                                      return Center(
                                        child: CircularProgressIndicator(
                                            color:
                                            const Color(0xff8a8989),
                                            value: percent),
                                      );
                                    }

                                    return const Text("");
                                  },
                                  imageBuilder:
                                      (context, imageProvider) =>
                                      Container(
                                        width: 55.0,
                                        height: 55.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                  errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                                ),
                              ),
                              SizedBox(height: 3,),
                              Flexible(
                                child: Text(
                                  "Your Story",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : GestureDetector(
                        onTap: () async {
                          final firebaseStorage0 =
                              FirebaseStorage.instance;
                          final imagePicker = ImagePicker();
                          XFile? image;
                          //Check Permissions

                          await Permission.photos.request();
                          var permissionStatuss =
                          await Permission.photos.status;
                          if (permissionStatuss.isGranted) {
                            //Select Image
                            image = await imagePicker.pickImage(
                                source: ImageSource.camera,
                                imageQuality: 30);
                            if (image != null) {
                              //Upload to Firebase
                              XFile g = image;
                              setState(() {
                                file = File(g.path);
                                //showtempi = true;
                              });
                              String? hj = FirebaseDatabase.instance
                                  .ref("Storage")
                                  .push()
                                  .key;
                              var snapshot = firebaseStorage0
                                  .ref("KGP Images/${hj!}")
                                  .putData(await image.readAsBytes());

                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return Dialog(
                                      backgroundColor: Color(0x00ffffff),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30.0)),
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize:
                                            MainAxisSize.min,
                                            children: [
                                              LoadingAnimationWidget
                                                  .threeArchedCircle(
                                                  color: Color(0xffea8537),
                                                  size: 60),
                                              Text(prog.toString(), style: TextStyle(color: Colors.black, fontFamily: 'martel'),)
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });

                              snapshot.snapshotEvents.listen(
                                      (TaskSnapshot taskSnapshot) async {
                                    switch (taskSnapshot.state) {
                                      case TaskState.running:
                                        setState(() {
                                          //showt = true;
                                          //showp = true;
                                        });
                                        final progress = 100.0 *
                                            (taskSnapshot.bytesTransferred /
                                                taskSnapshot.totalBytes);
                                        setState(() {
                                          prog = progress.toInt();
                                        });

                                        break;
                                      case TaskState.paused:
                                        break;
                                      case TaskState.canceled:
                                        break;
                                      case TaskState.error:
                                      // Handle unsuccessful uploads
                                        break;
                                      case TaskState.success:
                                        String imageUrl =
                                        await (await snapshot)
                                            .ref
                                            .getDownloadURL();
                                        DatabaseReference j = FirebaseDatabase
                                            .instance
                                            .ref("Stories");
                                        String key = j.push().key!;
                                        final jsona = {
                                          "Name": Namep,
                                          "PhotoUrl": PhotoUrlp,
                                          "Email_ID": EmailIdp,
                                          "ID": key,
                                          "ImageUrl": imageUrl,
                                          "date": DateTime.now().toString()
                                        };

                                        String? mymail =
                                        EmailIdp.replaceAll("@", '');
                                        String? minemail =
                                        mymail.replaceAll(".", "");
                                        DatabaseReference jok =
                                        FirebaseDatabase.instance
                                            .ref("MyStories/$minemail");
                                        final jfo = {"ID": key,
                                          "URL": imageUrl};
                                        await jok.set(jfo);

                                        await j.child(key).set(jsona);
                                        setState(() {
                                          //filesurl = imageUrl;
                                          //showp = false;
                                          //showi = true;
                                        });

                                        // Handle successful uploads on complete
                                        // ...
                                        Navigator.pop(context);
                                        break;
                                    }
                                  });
                            } else {}
                          } else {}
                        },
                        child: SizedBox(
                          height: 130,
                          width: 90,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                height: 70,
                                width: 70,
                                child: Image.asset("images/adding.png",height: 20,width: 20,)
                              ),
                              SizedBox(height: 3,),
                              Flexible(
                                child: Text(
                                  "Add your\nstory",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  Container(width: 2,color: Colors.black,height: 100,),
                  Expanded(
                    child: (storyl.length == 0) ? Text("    Follow your friends\n   to see their stories",style: TextStyle(fontFamily: 'martel'),) : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: storyl.length,
                      itemBuilder: (_, index) {
                        String Namee = storyl[index].Name;
                        List h = Namee.split(" ");
                        String shownames = h[0];

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                                  storyname = storyl[index].Name;
                                  storypphoto = storyl[index].PhotoUrl;
                                  storyemail = storyl[index].Email_ID;
                                  storyimage = storyl[index].ImageUrl;
                                  storyid = storyl[index].ID;
                                  return const StoryView();
                                }));
                          },
                          child: SizedBox(
                            height: 130,
                            width: 90,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(border: Border.all(width: 3, color: Color(0xfffbab0f)),borderRadius: BorderRadius.circular(200),),
                                  child: CachedNetworkImage(
                                    imageUrl: storyl[index].ImageUrl,
                                    progressIndicatorBuilder:
                                        (_, url, download) {
                                      if (download.progress != null) {
                                        final percent =
                                            download.progress! * 100;
                                        return Center(
                                          child: CircularProgressIndicator(
                                              color:
                                              const Color(0xff8a8989),
                                              value: percent),
                                        );
                                      }

                                      return const Text("");
                                    },
                                    imageBuilder:
                                        (context, imageProvider) =>
                                        Container(
                                          width: 55.0,
                                          height: 55.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                    errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                  ),
                                ),
                                SizedBox(height: 3,),
                                Flexible(
                                  child: Text(
                                    shownames,
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ]),
              ),
              Container(height: 1,color: Colors.black,),
              Container(
                color: Color(0xfff1f2f6),
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height - 270,
                child: TabBarView(
                  controller: controller,
                  children: const [
                    All(),
                    Academic(),
                    Hall(),
                    Event(),
                    Funde(),
                    Lost()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
            return AddPost();
          }));
        },
        backgroundColor: const Color(0xffffc491),
        child: const Icon(
          Icons.add,
          size: 35,
          color: Color(0xff5a3e28),
        ),
      ),
    );
  }
}
