import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kgppanchayat/personprofile.dart';
import 'package:photo_view/photo_view.dart';
import 'main.dart';
import 'messagedialog.dart';

class StoryView extends StatefulWidget {
  const StoryView({Key? key}) : super(key: key);

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: const Color(0xffffdfaf),
        iconTheme: IconThemeData(color: Colors.black),
        titleSpacing: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: true,
        title: GestureDetector(
          onTap: (){
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) {
                      personmail = storyemail;
                      return const PersonProfile();
                    }));
          },
          child: Row(children: [CachedNetworkImage(
            imageUrl: storypphoto,
            progressIndicatorBuilder: (_, url, download) {
              if (download.progress != null) {
                final percent = download.progress! * 100;
                return Center(
                  child: CircularProgressIndicator(
                      color: const Color(0xff8a8989),
                      value: percent),
                );
              }

              return const Text("");
            },
            imageBuilder: (context, imageProvider) =>
                Container(
                  width: 30.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover),
                  ),
                ),
            errorWidget: (context, url, error) =>
            const Icon(Icons.error),
          ), SizedBox(width: 5,),Text(storyname, style: TextStyle(fontSize: 15,
              fontWeight: FontWeight.w500,
              fontFamily: 'gupter',
              color: Colors.black)), Spacer(), IconButton(onPressed: (){
            showDialog(
                context: context,
                builder: (_){
                  messagewalamail = storyemail;
                  return Dialog(shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),child: const MessageDialog(),);
                }
            );
          }, icon: Image.asset('images/storymes.png',height: 25, width: 25,)),SizedBox(width: 5,)]),
        ),
      ),
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: CachedNetworkImage(
          imageUrl: storyimage,
          imageBuilder: (context, imageProvider) => PhotoView(
            imageProvider: imageProvider,
          ),
          placeholder: (context, url) =>
          Center(child: SizedBox(height: 100, width: 100,child: const CircularProgressIndicator())),
          errorWidget: (context, url, error) =>
          const Icon(Icons.error),
        ),
      ),

    );
  }
}