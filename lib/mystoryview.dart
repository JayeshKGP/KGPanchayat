import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kgppanchayat/main.dart';
import 'package:kgppanchayat/temp.dart';
import 'package:photo_view/photo_view.dart';

class MyStoryView extends StatefulWidget {
  const MyStoryView({Key? key}) : super(key: key);

  @override
  State<MyStoryView> createState() => _MyStoryViewState();
}

class _MyStoryViewState extends State<MyStoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: const Color(0xffffdfaf),
        titleSpacing: 0,
        iconTheme: IconThemeData(color: Colors.black),
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
              onPressed: () {
                // set up the button
                Widget no = OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xffffc491),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: const Text(
                    "NO",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: 'gupter',
                        fontWeight: FontWeight.w500),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                );
                Widget yes = TextButton(
                  child: const Text(
                    "YES",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: 'gupter',
                        fontWeight: FontWeight.w500),
                  ),
                  onPressed: () async {
                    String? mymail = EmailIdp.replaceAll("@", '');
                    String? minemail = mymail.replaceAll(".", "");

                    DatabaseReference delre =
                        FirebaseDatabase.instance.ref("Stories/$mystoryid");
                    await delre.remove();
                    DatabaseReference delref =
                        FirebaseDatabase.instance.ref("MyStories/$minemail");
                    await delref.remove();
                    Navigator.of(context).pop();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const Temp()),
                        ModalRoute.withName("/Temp"));
                  },
                );

                // set up the AlertDialog
                AlertDialog alert = AlertDialog(
                  backgroundColor: Color(0xfff1f2f6),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  title: const Text(
                    "Delete Story",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.deepOrange,
                        fontFamily: 'rale'),
                  ),
                  content: const Text("Are you sure to delete this story?",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'gupter')),
                  actions: [
                    no,
                    yes,
                  ],
                );

                // show the dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ))
        ],
        title: Row(children: [
          CachedNetworkImage(
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
              width: 30.0,
              height: 30.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          SizedBox(
            width: 5,
          ),
          Text(Namep, style: TextStyle(fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'gupter',
              color: Colors.black))
        ]),
      ),
      body: Container(
        color: Color(0xfff1f2f6),
        height: double.maxFinite,
        width: double.maxFinite,
        child: CachedNetworkImage(
          imageUrl: mystoryurl,
          imageBuilder: (context, imageProvider) => PhotoView(
            imageProvider: imageProvider,
          ),
          placeholder: (context, url) => Center(child: SizedBox(height: 100, width: 100,child: const CircularProgressIndicator())),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
