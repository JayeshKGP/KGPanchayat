import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kgppanchayat/studyiidialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'temp.dart';

class Study extends StatefulWidget {
  const Study({Key? key}) : super(key: key);

  @override
  State<Study> createState() => _StudyState();
}

class _StudyState extends State<Study> {
  String bb="";
  bool showdept = false;
  bool showsub = false;
  String dept = "";
  String year = "";


  Widget customradiodept(String text) {
    return Container(
      width: 100,
      height: 50,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              side: BorderSide(
                  width: (dept == text) ? 3 : 1,
                  color: (dept == text) ? Colors.black : Colors.black)),
          onPressed: () {
            setState(() {
              dept = text;
              String msg = dept+year;
              DatabaseReference by = FirebaseDatabase.instance.ref("Study Material/"+msg);
              by.once().then((value) {
                DataSnapshot fj = value.snapshot;
                if(fj.exists){
                  DatabaseReference b = FirebaseDatabase.instance.ref("Study Material");
                  b.once().then((value) async{
                    DataSnapshot h = value.snapshot;
                    if(h.exists){
                      Map<dynamic, dynamic> map = h.value as Map;
                      bb = map[msg];
                      if(bb!=""){
                        Uri uri = Uri.parse((bb).toString());
                        await launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      }else{
                        Fluttertoast.showToast(msg: "Will update soon...");
                      }
                    }else{
                    }
                  });
                }else{
                  Fluttertoast.showToast(msg: "Will update soon...", backgroundColor: Colors.deepOrange);
                }
              });



            });
          },
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'ubuntu',
                fontSize: 13,
                color: (dept == text) ? Colors.black : Colors.black,
                fontWeight: (dept == text) ? FontWeight.bold : FontWeight.normal),
          )),
    );
  }
  Widget customradioyear(String text) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            side: BorderSide(
                width: (year == text) ? 3 : 1,
                color: (year == text) ? Colors.black : Colors.black)),
        onPressed: () {
          setState(() {
            year = text;
            if(year=='1st'){
              showsub = true;
              showdept = false;
            }else{
              showdept = true;
              showsub = false;
            }

          });
        },
        child: Text(
          text,
          style: TextStyle(
              fontFamily: 'ubuntu',
              color: (year == text) ? Colors.black : Colors.black,
              fontWeight: (year == text) ? FontWeight.bold : FontWeight.normal),
        ));
  }
  @override
  Widget build(BuildContext context) {
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
          backgroundColor: const Color(0xffffdfaf),
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          actions: [IconButton(onPressed: (){
            showDialog(
                context: context,
                builder: (_){
                  return Dialog(shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),child: const StudyiDialog(),);
                }
            );
          }, icon: Icon(Icons.info_outline, color: Colors.black,))],
          title: const Text(
            "Study Material",
            style: TextStyle(color: Colors.black, fontFamily: 'gupter'),
          ),
        ),
        body: Container(
          height: double.maxFinite,
          color: const Color(0xfff1f2f6),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: const Color(0xfff1f2f6),
                  height: 30,
                ),
                Row(children:  const [
                  SizedBox(
                    width: 15,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Year of study:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'gupter',
                            fontSize: 22)),
                  )
                ]),
                SizedBox(height: 6,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customradioyear("1st"),
                    customradioyear("2nd"),
                    customradioyear("3rd"),
                    customradioyear("4th"),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                showdept ? Row(children: const [
                  SizedBox(
                    width: 15,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Choose department:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'gupter',
                            fontSize: 22)),
                  )
                ]) : SizedBox(height: 0,),
                showdept ? SizedBox(height: 13,):SizedBox(height: 0,),
                showdept ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customradiodept("Aero"),
                    customradiodept("AGFE"),
                    customradiodept("Archi"),


                  ],
                ) : SizedBox(height: 0,),
                showdept ? SizedBox(height: 8,):SizedBox(height: 0,),
                showdept ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customradiodept("BioTech"),
                    customradiodept("Chemical"),
                    customradiodept("Chemistry"),



                  ],
                ) : SizedBox(height: 0,),
                showdept ? SizedBox(height: 8,):SizedBox(height: 0,),
                showdept ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customradiodept("Civil"),
                    customradiodept("CSE"),
                    customradiodept("Eco"),


                  ],
                ) : SizedBox(height: 0,),
                showdept ? SizedBox(height: 8,):SizedBox(height: 0,),
                showdept ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customradiodept("ECE"),
                    customradiodept("EE"),
                    customradiodept("Indu"),



                  ],
                ) : SizedBox(height: 0,),
                showdept ? SizedBox(height: 8,):SizedBox(height: 0,),
                showdept ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customradiodept("Instru"),
                    customradiodept("Geology"),
                    customradiodept("GeoPhy"),

                  ],
                ) : SizedBox(height: 0,),
                showdept ? SizedBox(height: 8,):SizedBox(height: 0,),
                showdept ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customradiodept("Manufac"),
                    customradiodept("Mech"),
                    customradiodept("Meta"),

                  ],
                ) : SizedBox(height: 0,),
                showdept ? SizedBox(height: 8,):SizedBox(height: 0,),
                showdept ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customradiodept("Mining"),
                    customradiodept("MnC"),
                    customradiodept("OENA"),
                  ],
                ) : SizedBox(height: 0,),
                showdept ? SizedBox(height: 8,):SizedBox(height: 0,),
                showdept ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customradiodept("Phy"),
                  ],
                ) : SizedBox(height: 0,),

                showsub ? Row(children: const [
                  SizedBox(
                    width: 15,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Choose Subject:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'gupter',
                            fontSize: 22)),
                  )
                ]) : SizedBox(height: 0,),
                showsub ? SizedBox(height: 3,):SizedBox(height: 0,),
                showsub ? Row(children: const [
                  SizedBox(
                    width: 15,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Physics Sem:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'glory',
                            fontSize: 17)),
                  )
                ]) : SizedBox(height: 0,),
                showsub ? SizedBox(height: 5,): SizedBox(height: 0,),
                showsub ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customradiodept("BEM"),
                    customradiodept("ET"),

                  ],
                ) : SizedBox(height: 0,),
                showsub ? SizedBox(height: 8,): SizedBox(height: 0,),
                showsub ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customradiodept("EVS"),
                    customradiodept("POW"),

                  ],
                ) : SizedBox(height: 0,),
                showsub ? SizedBox(height: 8,): SizedBox(height: 0,),
                showsub ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customradiodept("Phy Lab"),
                    customradiodept("Engg Lab"),

                  ],
                ) : SizedBox(height: 0,),
                showsub ? SizedBox(height: 8,): SizedBox(height: 0,),
                showsub ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customradiodept("DIY Lab"),

                  ],
                ) : SizedBox(height: 0,),
                showsub ? SizedBox(height: 8,): SizedBox(height: 0,),
                showsub ? Row(children: const [
                  SizedBox(
                    width: 15,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Chemistry Sem:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'glory',
                            fontSize: 17)),
                  )
                ]) : SizedBox(height: 0,),
                showsub ? SizedBox(height: 5,): SizedBox(height: 0,),
                showsub ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customradiodept("Bio"),
                    customradiodept("Chem"),
                  ],
                ) : SizedBox(height: 0,),
                showsub ? SizedBox(height: 8,): SizedBox(height: 0,),
                showsub ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customradiodept("HS"),
                    customradiodept("PDS"),
                  ],
                ) : SizedBox(height: 0,),
                showsub ? SizedBox(height: 8,): SizedBox(height: 0,),
                showsub ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customradiodept("Chem Lab"),
                    customradiodept("PDS Lab"),
                  ],
                ) : SizedBox(height: 0,),
                showsub ? SizedBox(height: 8,): SizedBox(height: 0,),
                showsub ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customradiodept("ED and CAD"),
                  ],
                ) : SizedBox(height: 0,),
                showsub ? SizedBox(height: 20,): SizedBox(height: 0,),
                showsub ? Row(children: const [
                  SizedBox(
                    width: 15,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("Maths:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'glory',
                            fontSize: 17)),
                  )
                ]) : SizedBox(height: 0,),
                showsub ? SizedBox(height: 5,): SizedBox(height: 0,),
                showsub ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customradiodept("Advanced Calculus"),
                    customradiodept("Linear Algebra"),
                  ],
                ) : SizedBox(height: 0,),


                showsub ? SizedBox(height: 20,): SizedBox(height: 0,),
                showsub ? Row(children: const [
                  SizedBox(
                    width: 15,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("PYQs:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'glory',
                            fontSize: 17)),
                  )
                ]) : SizedBox(height: 0,),
                showsub ? SizedBox(height: 5,): SizedBox(height: 0,),
                showsub ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customradiodept("PYQs"),
                  ],
                ) : SizedBox(height: 0,),
                showsub ? SizedBox(height: 15,): SizedBox(height: 0,),

                SizedBox(height: 100,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
