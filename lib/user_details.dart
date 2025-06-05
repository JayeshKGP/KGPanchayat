import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'splash.dart';
import 'main.dart';

class UserData extends StatefulWidget {
  const UserData({Key? key}) : super(key: key);
  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  String? name = "", link = "", email = "";
  String year = "Year";
  String dept = "Dept";
  String hall = "Hall";
  final instaurl = TextEditingController();
  final fburl = TextEditingController();
  final linkedinurl = TextEditingController();
  List<String> yearslist = <String>['Year', '1st', '2nd', '3rd', '4th', '5th'];
  List<String> deptlist = <String>['Dept', 'Aero', 'AGFE', 'Archi', 'BioTech', 'Chemical',
    'Chemistry', 'Civil', 'CSE', 'ECE',
    'Eco', 'EE', 'Geology','GeoPhy','Indu', 'Instru',
    'Manufac', 'Mech', 'Meta',
    'Mining', 'MnC', 'OENA', 'Phy',
  ];
  List<String> halllist = <String>['Hall', 'Azad', 'BCRoy', 'BRH', 'Gokhale', 'HJB',
    'JCB', 'LBS', 'LLR', 'MMM', 'MS',
    'MT', 'Nehru', 'Patel','Rani Laxmibai','RK','RP', 'SAM',
    'SNIG', 'SNVH',
    'VS', 'ZH'
  ];
  String tdept = "";
  String tyear = "";
  String thall = "";
  bool error = false;

  bool updateload = false;
  bool bioerror = false;
  String errormessage = "";
  String errormessagebio = "Tell something about yourself in Bio\n(a short intro)";
  File? file;
  bool accept = false;
  bool showt = false;
  bool showaccepterror = false;
  bool showp = false;
  int prog = 101;
  String imgUrl = "";
  final bios = TextEditingController();

  @override
  void initState() {
    super.initState();
    name = FirebaseAuth.instance.currentUser?.displayName;
    link = FirebaseAuth.instance.currentUser?.photoURL;
    email = FirebaseAuth.instance.currentUser?.email;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: const Color(0xffffdfaf),
        titleSpacing: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "  Edit Profile",
          style: TextStyle(color: Colors.black, fontFamily: 'gupter'),
        ),
      ),
      body: Container(
        height: double.maxFinite,
        color: const Color(0xfff1f2f6),
        child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [Column(children: [
                  SizedBox(width: 80,
                      height: 80,
                      child: CachedNetworkImage(
                        imageUrl: link!,
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
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                      )),
                  IconButton(
                    icon: const Icon(
                      Icons.change_circle_outlined,
                      size: 30,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () async {
                      final firebaseStorage = FirebaseStorage.instance;
                      final imagePicker = ImagePicker();
                      final PickedFile pickedfile;
                      //Check Permissions
                      await Permission.photos.request();

                      var permissionStatus = await Permission.photos.status;

                      if (permissionStatus.isGranted) {
                        //Select Image
                        pickedfile = (await imagePicker.getImage(
                          source: ImageSource.gallery,
                        ))!;
                        CroppedFile? image = await ImageCropper().cropImage(
                          sourcePath: pickedfile.path,
                          aspectRatioPresets: Platform.isAndroid
                              ? [
                            CropAspectRatioPreset.square,
                          ]
                              : [
                            CropAspectRatioPreset.square,
                          ],
                          uiSettings: [
                            AndroidUiSettings(
                                toolbarTitle: 'Crop Image',
                                toolbarColor: Colors.deepOrange,
                                toolbarWidgetColor: Colors.white,
                                initAspectRatio: CropAspectRatioPreset.square,
                                lockAspectRatio: true,
                                hideBottomControls: true),
                            IOSUiSettings(
                              title: 'Cropper',
                            ),
                            WebUiSettings(
                              context: context,
                            ),
                          ],
                        );
                        if (image != null) {
                          //Upload to Firebase
                          XFile g = XFile(image.path);
                          setState(() {
                            file = File(g.path);
                          });
                          String? hj = FirebaseDatabase.instance
                              .ref("Storage")
                              .push()
                              .key;
                          var snapshot = firebaseStorage
                              .ref("KGP Images/${hj!}")
                              .putData(await image.readAsBytes());

                          snapshot.snapshotEvents
                              .listen((TaskSnapshot taskSnapshot) async {
                            switch (taskSnapshot.state) {
                              case TaskState.running:
                                setState(() {
                                  showt = true;
                                  showp = true;
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
                                imgUrl =
                                await (await snapshot).ref.getDownloadURL();
                                setState(() {
                                  link = imgUrl;
                                  showp = false;
                                });

                                // Handle successful uploads on complete
                                // ...
                                break;
                            }
                          });
                        } else {
                        }
                      }
                    },
                  ),
                ],
                ),

                  Column(children: [SizedBox(
                    width: 230,
                    child: Text(
                      name!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'gupter',
                            color: Colors.black),
                    ),
                  ),
                    Text(
                      "$tyear, $tdept, $thall",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'gupter',
                          color: Color(0xff8a8989),
                          fontSize: 17),
                    ),],)],),

                showp
                    ? LoadingAnimationWidget.threeArchedCircle(
                    color: const Color(0xffea8537), size: 60)
                    : const SizedBox(
                  height: 0,
                ),
                showt
                    ? Text("$prog% Uploaded",style: const TextStyle(fontFamily: 'chivo',color: Color(0xff8a8989)))
                    : const SizedBox(
                  height: 0,
                ),
                const SizedBox(
                  height: 5,
                ),

                Row(children: const [
                  SizedBox(
                    width: 15,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Your Info:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'gupter',
                            fontSize: 22)),
                  )
                ]),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                  child: TextField(
                    style: const TextStyle(fontSize: 20, color: Colors.black,fontFamily: 'martel'),
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 3,
                    decoration:  const InputDecoration(
                        hintStyle: TextStyle(fontSize: 20, color: Color(0xffb6b4b4,),fontFamily: 'martel'),
                        filled: true,
                        hintText: "Write about yourself...",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(
                                color: Color(0xff424242), width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(
                                color: Color(0xff424242), width: 2))),
                    controller: bios,
                  ),
                ),
                const SizedBox(height: 30,),


                SizedBox(height: 5,),

                Row(children: const [
                  SizedBox(
                    width: 15,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Choose Year:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'gupter',
                            fontSize: 22)),
                  )
                ]),
                Container(
                  width: 150,
                  height: 60,
                  child: DropdownButtonFormField<String>(
                    value: year,
                    icon: Image.asset('images/ddrop.png'),
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder( //
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),// <-- SEE HERE
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder( //<-- SEE HERE
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    dropdownColor: Colors.white,
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        year = value!;
                        tyear = value;
                      });
                    },
                    items: yearslist.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(fontSize: 18, fontFamily: 'glory',fontWeight: FontWeight.bold),),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Row(children: const [
                  SizedBox(
                    width: 15,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Choose Department:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'gupter',
                            fontSize: 22)),
                  )
                ]),

                Container(
                  width: 150,
                  height: 60,
                  child: DropdownButtonFormField<String>(
                    value: dept,
                    icon: Image.asset('images/ddrop.png'),
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder( //
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),// <-- SEE HERE
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder( //<-- SEE HERE
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    dropdownColor: Colors.white,
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dept = value!;
                        tdept = value;
                      });
                    },
                    items: deptlist.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(fontSize: 18, fontFamily: 'glory',fontWeight: FontWeight.bold),),
                      );
                    }).toList(),
                  ),
                ),


                SizedBox(
                  height: 10,
                ),
                Row(children: const [
                  SizedBox(
                    width: 15,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Choose Hall:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'gupter',
                            fontSize: 22)),
                  )
                ]),

                Container(
                  width: 150,
                  height: 60,
                  child: DropdownButtonFormField<String>(
                    value: hall,
                    icon: Image.asset('images/ddrop.png'),
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder( //
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),// <-- SEE HERE
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder( //<-- SEE HERE
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    dropdownColor: Colors.white,
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        hall = value!;
                        thall = value;
                      });
                    },
                    items: halllist.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(fontSize: 18, fontFamily: 'glory',fontWeight: FontWeight.bold),),
                      );
                    }).toList(),
                  ),
                ),


                const SizedBox(
                  height: 20,
                ),
                Row(children: const [
                  SizedBox(
                    width: 15,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Social Media Links:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'gupter',
                            fontSize: 22)),
                  )
                ]),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                  child: TextField(

                    style: const TextStyle(fontSize: 20, color: Colors.black,fontFamily: 'martel'),
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration:  InputDecoration(
                        hintStyle: const TextStyle(fontSize: 20, color: Color(0xffb6b4b4,),fontFamily: 'martel'),
                        filled: true,
                        hintText: "Insta Username",
                        prefixIcon: Padding(padding:EdgeInsets.symmetric(horizontal: 10) ,child: Image.asset('images/instagram.png')),
                        prefixIconConstraints: BoxConstraints(maxHeight: 50, maxWidth: 50),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(
                                color: Color(0xff424242), width: 1)),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(
                                color: Color(0xff424242), width: 2))),
                    controller: instaurl,
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                  child: TextField(
                    style: const TextStyle(fontSize: 20, color: Colors.black,fontFamily: 'martel'),
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration:  InputDecoration(
                        hintStyle: const TextStyle(fontSize: 20, color: Color(0xffb6b4b4,),fontFamily: 'martel'),
                        filled: true,
                        hintText: "LinkedIN Url",
                        prefixIcon: Padding(padding:EdgeInsets.symmetric(horizontal: 10) ,child: Image.asset('images/linkedin.png')),
                        prefixIconConstraints: BoxConstraints(maxHeight: 50, maxWidth: 50),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(
                                color: Color(0xff424242), width: 1)),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(
                                color: Color(0xff424242), width: 2))),
                    controller: linkedinurl,
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                  child: TextField(

                    style: const TextStyle(fontSize: 20, color: Colors.black,fontFamily: 'martel'),
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration:  InputDecoration(
                        hintStyle: const TextStyle(fontSize: 20, color: Color(0xffb6b4b4,),fontFamily: 'martel'),
                        filled: true,
                        hintText: "FB Url",
                        prefixIcon: Padding(padding:EdgeInsets.symmetric(horizontal: 10) ,child: Image.asset('images/facebook.png')),
                        prefixIconConstraints: BoxConstraints(maxHeight: 50, maxWidth: 50),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(
                                color: Color(0xff424242), width: 1)),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(
                                color: Color(0xff424242), width: 2))),
                    controller: fburl,
                  ),
                ),


                SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(decoration: BoxDecoration(
                      color: Color(0x5cffdfaf),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Colors.black,)
                  ),child: Column(children: [
                    SizedBox(height: 10,),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 15),child: Text("If you hold a position in Hall Council, Technology Students Gymkhana, or any Society, contact us for a badge on our app.", style: TextStyle(fontFamily: 'martel'),textAlign: TextAlign.center,)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Image.asset('images/verr.png', width: 20, height: 20,),SizedBox(width: 20,),OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.black, width: 1),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () {
                              Navigator.of(context).pop();
                              String link = "mailto:jdcodekgp@gmail.com?subject=Applying for a badge&body=Name: $Namep\nEmail ID: $EmailIdp\n";
                              launchUrl(Uri.parse(link),
                                  mode: LaunchMode.externalApplication);
                            },
                            child: const Text(
                              "Contact Us",
                              style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),
                            )),
                        ]),
                    SizedBox(height: 10,),
                  ],),),
                ),

                SizedBox(height: 5,),

                const SizedBox(height: 15,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Transform.scale(
                    scale: 1.3,
                    child: Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.black),
                      child: Checkbox(value: accept, onChanged: (newvalue){
                        setState(() {
                          accept = newvalue!;
                        });
                      },
                      activeColor: const Color(0xffffc491),
                      checkColor: const Color(0xff5a3e28),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),),
                    ),
                  )
                    ,const Text("I accept the",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontFamily: 'glory', fontSize: 15),),TextButton(onPressed: (){
                    String link = "https://kgpanchayatapp.blogspot.com/2023/04/kgpanchayat-rules-and-regulations.html";
                    launchUrl(Uri.parse(link),
                        mode: LaunchMode.externalApplication);
                  }, child: const Text("Rules and Regulations",style: TextStyle(color: Color(0xfffa8804), fontWeight: FontWeight.bold, fontFamily: 'glory', fontSize: 15))),
                ]),
                showaccepterror ? Column(
                    children: const [SizedBox(height: 5,),Text("You must accept the rules and regulations to use the app",style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'verdana',
                        fontSize: 12)),
                    ] ) : const SizedBox(height: 0,),

                bioerror ? Column(
                    children: [const SizedBox(height: 5,),Text(errormessagebio,textAlign: TextAlign.center,style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'verdana',
                        fontSize: 12)),
                    ] ) : const SizedBox(height: 0,),
                const SizedBox(height: 10,),
                SizedBox(height: 5,),

                error ? Column(
                    children: [const SizedBox(height: 5,),Text(errormessage,style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'verdana',
                        fontSize: 12)),
                    ] ) : const SizedBox(height: 0,),
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
                      if(accept){
                        setState(() {
                          showaccepterror = false;
                        });
                        errormessage = "";
                        if(bios.text==""){
                          setState(() {
                            bioerror = true;
                          });
                        }else{
                          setState(() {
                            bioerror = false;
                          });
                          if(year=="Year"){
                            setState(() {
                              error = true;
                              errormessage = "Please select year of study\n";
                            });
                          }else{
                            if(dept=="Dept"){
                              setState(() {
                                error = true;
                                errormessage = "Please select your department\n";
                              });
                            }else{
                              if(hall=="Hall"){
                                setState(() {
                                  error = true;
                                  errormessage = "Please select your Hall\n";
                                });
                              }else{
                                setState(() {
                                  error = false;
                                  updateload = true;
                                });
                                String? mymail = email?.replaceAll("@", '');
                                String? minemail = mymail?.replaceAll(".", "");
                                DatabaseReference refe =
                                FirebaseDatabase.instance.ref("UserData/${minemail!}");
                                final json = {
                                  "Name": name,
                                  "Email_ID": email,
                                  "PhotoUrl": link,
                                  "Year": year,
                                  "Department": dept,
                                  "Hall": hall,
                                  "Bio" : bios.text
                                };
                                await refe.set(json);
                                DatabaseReference df = FirebaseDatabase.instance.ref("NotiSett/$minemail");
                                final jsons = {
                                  'All': true,
                                  'Dept': true,
                                  'Hall': true,
                                  'Events' : true,
                                  'Fundae': true,
                                  'Lost': true,
                                  'Comment': true
                                };
                                df.set(jsons);

                                DatabaseReference yu =
                                FirebaseDatabase.instance.ref("Social Links/$minemail");
                                final nn = {
                                  "Insta": instaurl.text,
                                  "FB": fburl.text,
                                  "LinkedIn": linkedinurl.text,
                                };
                                await yu.set(nn);


                                FocusScope.of(context).unfocus();
                                open = true;
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => const Splash()),
                                    ModalRoute.withName("/Temp"));
                              }
                            }
                          }
                        }
                      }else{
                        setState(() {
                          showaccepterror = true;
                        });
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Update Profile",
                        style: TextStyle(fontSize: 18, fontFamily: 'gupter', color: Color(0xfffa8804)),
                      ),
                    )),
                const SizedBox(height: 10,)
              ],

            )),
      ),
    );
  }
}
