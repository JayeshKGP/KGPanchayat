import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'main.dart';

class ShowImage extends StatefulWidget {
  const ShowImage({Key? key}) : super(key: key);

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
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
      ),
      body: Container(
        color: Color(0xfff1f2f6),
        height: double.maxFinite,
        width: double.maxFinite,
        child: CachedNetworkImage(
          imageUrl: showimageurl,
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
