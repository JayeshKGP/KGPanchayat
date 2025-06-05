import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:kgppanchayat/main.dart';
import 'package:kgppanchayat/showimage.dart';
import 'package:url_launcher/url_launcher.dart';

class SocInfo extends StatefulWidget {
  const SocInfo({Key? key}) : super(key: key);

  @override
  State<SocInfo> createState() => _SocInfoState();
}

class _SocInfoState extends State<SocInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2c2c2c),
      appBar: AppBar(
        title: Text(
          societyname,
    style: TextStyle(color: Colors.black, fontFamily: 'gupter')
        ),
        toolbarHeight: 50,
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: Color(0xffffdfaf),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        titleSpacing: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        color: Color(0xfff1f2f6),
        height: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (BuildContext context) {
                      showimageurl = societyphoto;
                      return const ShowImage();
                    }));
                  },
                  child: SizedBox(
                  height: 180,
                  width: 180,
                  child: CachedNetworkImage(
                    imageUrl: societyphoto,
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
              ),
              const SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                (societyinsta=="") ? const SizedBox(width: 0,): IconButton(onPressed: (){
                  launchUrl(Uri.parse(societyinsta),
                      mode: LaunchMode.externalApplication);
                }, icon: Image.asset('images/instagram.png')),
                (societyfacebook=="") ? const SizedBox(width: 0,): IconButton(onPressed: (){
                  launchUrl(Uri.parse(societyfacebook),
                      mode: LaunchMode.externalApplication);
                }, icon: Image.asset('images/facebook.png')),
                (societylinkedin=="") ? const SizedBox(width: 0,): IconButton(onPressed: (){
                  launchUrl(Uri.parse(societylinkedin),
                      mode: LaunchMode.externalApplication);
                }, icon: Image.asset('images/linkedin.png')),
                (societyweb=="") ? const SizedBox(width: 0,): IconButton(onPressed: (){
                  launchUrl(Uri.parse(societyweb),
                      mode: LaunchMode.externalApplication);
                }, icon: Image.asset('images/web.png'))
              ],),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Linkify(
                  onOpen: (link) async {
                    await launchUrl(Uri.parse(link.url),
                        mode: LaunchMode.externalApplication);
                  },
                  text: "    $societyinfo",
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'martel',
                      color: Colors.black),
                ),
              ),
              SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );
  }
}
