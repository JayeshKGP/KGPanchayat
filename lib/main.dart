import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:kgppanchayat/comment.dart';
import 'package:kgppanchayat/dar.dart';
import 'package:kgppanchayat/getterlinks.dart';
import 'package:kgppanchayat/gettermessage.dart';
import 'package:kgppanchayat/gettersaved.dart';
import 'package:kgppanchayat/gettersocieties.dart';
import 'package:kgppanchayat/tatpurta.dart';
import 'package:kgppanchayat/temp.dart';
import 'getter.dart';
import 'getterusers.dart';
import 'login.dart';
import 'splash.dart';
import 'firebase_options.dart';
import 'getterc.dart';


String badgeemail = '';
bool fal = true;
bool flag = true;
bool open = true;
bool kon = true;
String showimageurl = "";
String storyimage="", storyid="", storyname="", storypphoto="", storyemail="";
String Departmentp = "";
String EmailIdp = "";
String Hallp = "";
String Namep = "";
String PhotoUrlp = "";
String Yearp = "0";
String Biop = "";
List<DetailsC> listc = [];
List<StudentsList> liststu = [];
List<StudentsList> liststuextra = [];
List<StudentsList> listapplied = [];
List<SocietyList> listsoc = [];
List<LinkList> listlink = [];
List<SocietyList> listsocextra = [];
List ssoo = [];
List llii = [];
List<Details> listsa = [];
List ideva = [];
List<Details> listeva = [];
List<Message> listmess = [];
List<DetailsSaved> listsaved = [];
List idsaved = [];
List cid = [];
List stu = [];
String commentId = "";
int j = 0;
int tabindex = 0;
String personmail = "";
int kc = 1;
String messagewalamail = "";
bool notiall = true;
bool notidept = true;
bool notihall = true;
bool notievents = true;
bool notifundae = true;
bool notilost = true;
bool noticomment = true;
bool notimessage = true;
bool kyaverified = false;
String postmail = "";
int usalist = 0;
String konachefollowers = "";

String societyname="", societyphoto="", societyinfo="", societyinsta="", societyfacebook="", societylinkedin="", societyweb ="";

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options: const FirebaseOptions(apiKey: "AIzaSyDDl9ampVOjdQvqGese-EDHXVcVnOzOBgo", appId: "1:814029290671:web:5a16d5f5ddc9f0aca2e85a", messagingSenderId: "814029290671", projectId: "kgppanchayat-6356e"),);
  }else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }


  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return MaterialApp(home: user==null ? const Login() : const Splash(), debugShowCheckedModeBanner: false);

    //return MaterialApp(home: tatpurta());
    //return MaterialApp(home: Asach());
  }
}
