import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kgppanchayat/getterusers.dart';
import 'package:kgppanchayat/personprofile.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'main.dart';
import 'messagedialog.dart';
import 'mypost.dart';
import 'temp.dart';

class PersonsList extends StatefulWidget {
  const PersonsList({Key? key}) : super(key: key);

  @override
  State<PersonsList> createState() => _PersonsListState();
}

final searchcon = TextEditingController();

class _PersonsListState extends State<PersonsList> {
  List<String> yearslist = <String>[
    'Year',
    '1st',
    '2nd',
    '3rd',
    '4th',
    '5th'
  ];
  List<String> deptlist = <String>[
    'Dept',
    'Aero',
    'AGFE',
    'Archi',
    'BioTech',
    'Chemical',
    'Chemistry',
    'Civil',
    'CSE',
    'ECE',
    'Eco',
    'EE',
    'Geology',
    'GeoPhy',
    'Indu',
    'Instru',
    'Manufac',
    'Mech',
    'Meta',
    'Mining',
    'MnC',
    'OENA',
    'Phy',
  ];
  List<String> halllist = <String>[
    'Hall',
    'Azad',
    'BCRoy',
    'BRH',
    'Gokhale',
    'HJB',
    'JCB',
    'LBS',
    'LLR',
    'MMM',
    'MS',
    'MT',
    'Nehru',
    'Patel',
    'Rani Laxmibai',
    'RK',
    'RP',
    'SAM',
    'SNIG',
    'SNVH',
    'VS',
    'ZH'
  ];
  bool countbool = false;
  int hh = 0;
  bool clearvisi = false;
  String year = "Year";
  String dept = "Dept";
  String hall = "Hall";
  bool noresults = false;

  @override
  void initState() {
    searchcon.clear();
    liststu.clear();
    listapplied.clear();
    liststuextra.clear();
    stu.clear();
    searchcon.addListener(() {
      setState(() {
        if (searchcon.text == "") {
          clearvisi = false;
          liststu.clear();
          int tt = listapplied.length;
          for (int i = tt - 1; i >= 0; i--) {
            liststu.insert(0, listapplied[i]);
          }
        } else {
          clearvisi = true;
          liststu.clear();
          int tt = listapplied.length;
          for (int i = tt - 1; i >= 0; i--) {
            if (listapplied[i]
                .Name
                .toLowerCase()
                .contains(searchcon.text.toLowerCase())) {
              liststu.insert(0, listapplied[i]);
            }
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (usalist == 1) {
      DatabaseReference reference = FirebaseDatabase.instance.ref("UserData");
      reference.once().then((value) {
        DataSnapshot snap = value.snapshot;
        countbool = false;
        Map<dynamic, dynamic> map = snap.value as Map;
        hh = map.length;
      });
      reference.orderByChild("Year").onChildAdded.listen((DatabaseEvent value) {
        DataSnapshot snapshot = value.snapshot;

        Map<dynamic, dynamic> map = snapshot.value as Map;
        StudentsList de = StudentsList(
            Name: map["Name"],
            PhotoUrl: map["PhotoUrl"],
            Email_ID: map["Email_ID"],
            Hall: map["Hall"],
            Year: map["Year"],
            Department: map["Department"],
            Bio: map["Bio"],
            sb: false,
            sf: false);
        setState(() {
          if (liststuextra.length < hh) {
            if (stu.contains(map["Email_ID"])) {
            } else {
              int u = liststuextra.length;
              liststu.insert(u, de);
              listapplied.insert(u, de);
              liststuextra.insert(u, de);
              stu.insert(u, map["Email_ID"]);
            }
          } else if (liststuextra.length > hh) {
            liststu.clear();
            liststuextra.clear();
            listapplied.clear();
            stu.clear();
            liststu.insert(0, de);
            listapplied.insert(0, de);
            liststuextra.insert(0, de);
            stu.insert(0, map["Email_ID"]);
          }
        });
      });
    } else if (usalist == 2) {
      DatabaseReference reference =
          FirebaseDatabase.instance.ref("Followers/$konachefollowers");
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
      reference.orderByChild("Year").onChildAdded.listen((DatabaseEvent value) {
        DataSnapshot snapshot = value.snapshot;

        Map<dynamic, dynamic> map = snapshot.value as Map;
        StudentsList de = StudentsList(
            Name: map["Name"],
            PhotoUrl: map["PhotoUrl"],
            Email_ID: map["Email_ID"],
            Hall: map["Hall"],
            Year: map["Year"],
            Department: map["Department"],
            Bio: map["Bio"],
            sb: false,
            sf: false);
        setState(() {
          if (liststuextra.length != hh) {
            if (liststuextra.length < hh) {
              if (stu.contains(map["Email_ID"])) {
              } else {
                int u = liststu.length;
                liststu.insert(u, de);
                listapplied.insert(u, de);
                liststuextra.insert(u, de);
                stu.insert(u, map["Email_ID"]);
              }
            } else if (liststuextra.length > hh) {
              liststu.clear();
              liststuextra.clear();
              listapplied.clear();
              stu.clear();
              liststu.insert(0, de);
              listapplied.insert(0, de);
              liststuextra.insert(0, de);
              stu.insert(0, map["Email_ID"]);
            }
          }
        });
      });
    }


    return WillPopScope(
        onWillPop: () async {
          usalist = 1;
          Navigator.of(context).pop();
          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                usalist = 1;
                Navigator.of(context).pop();

              },
            ),
            toolbarHeight: 50,
            bottomOpacity: 0.0,
            elevation: 0.0,
            backgroundColor: Color(0xffffdfaf),
            titleSpacing: 0,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              (usalist == 1) ? "Search Users" : "Followers",
    style: TextStyle(color: Colors.black, fontFamily: 'gupter')
            ),
          ),
          body: countbool
              ? Container(
            color: Color(0xfff1f2f6),
                child: Center(
                    child: Text(
                    (usalist == 1) ? "." : "No followers",
                        style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'glory', fontWeight: FontWeight.bold)
                  )),
              )
              : Container(
                  color: Color(0xfff1f2f6),
                  height: double.maxFinite,
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
                            hintStyle: const TextStyle(
                                fontSize: 20,
                                color: Color(0xffb6b4b4),
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
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [Container(
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
                          });
                        },
                        items: yearslist.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(fontSize: 18, fontFamily: 'glory',fontWeight: FontWeight.bold),),
                          );
                        }).toList(),
                      ),
                    ), Container(
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
                          });
                        },
                        items: deptlist.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(fontSize: 18, fontFamily: 'glory',fontWeight: FontWeight.bold),),
                          );
                        }).toList(),
                      ),
                    ),],),
                    SizedBox(height: 5,),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [Container(
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
                          });
                        },
                        items: halllist.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(fontSize: 18, fontFamily: 'glory',fontWeight: FontWeight.bold),),
                          );
                        }).toList(),
                      ),
                    ),Container(width: 150, height: 60, child: Padding(
                        padding: EdgeInsets.all(1),
                        child: OutlinedButton(onPressed: () {
                          liststu.clear();
                          listapplied.clear();

                          for (int i = hh - 1; i >= 0; i--) {
                            liststu.insert(0, liststuextra[i]);
                            listapplied.insert(0, liststuextra[i]);
                          }

                          if(year!="Year"){
                            int y = liststu.length;
                            for (int i = y - 1; i >= 0; i--) {
                              if(year!=liststu[i].Year){
                                liststu.removeAt(i);
                                listapplied.removeAt(i);
                              }
                            }
                          }
                          if(hall!="Hall"){
                            int y = liststu.length;
                            for (int i = y - 1; i >= 0; i--) {
                              if(hall!=liststu[i].Hall){
                                liststu.removeAt(i);
                                listapplied.removeAt(i);
                              }
                            }
                          }
                          if(dept!="Dept"){
                            int y = liststu.length;
                            for (int i = y - 1; i >= 0; i--) {
                              if(dept!=liststu[i].Department){
                                liststu.removeAt(i);
                                listapplied.removeAt(i);
                              }
                            }
                          }
                          setState(() {
                            if(listapplied.length == 0){
                              noresults = true;
                            }else{
                              noresults = false;
                            }
                          });



                        }, child: Text("Apply",style: TextStyle(fontSize: 19, color: Color(0xfffa8804), fontFamily: 'gupter'),),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.black, width: 2),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                    ),
                      ),)],),
                    SizedBox(height: 5,),



                    Container(
                      height: MediaQuery.of(context).size.height - 350,
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ScrollablePositionedList.builder(
                            shrinkWrap: true,
                            itemCount: liststu.length,
                            itemBuilder: (_, index) {
                              String name = liststu[index].Name;
                              String photoUrl = liststu[index].PhotoUrl;
                              String emailId = liststu[index].Email_ID;
                              String hall = liststu[index].Hall;
                              String year = liststu[index].Year;
                              String department = liststu[index].Department;
                              String bio = liststu[index].Bio;

                              String? mymail = EmailIdp.replaceAll("@", '');
                              String? minemail = mymail.replaceAll(".", "");

                              String? je = emailId.replaceAll("@", '');
                              String? postmail = je.replaceAll(".", "");

                              DatabaseReference bad = FirebaseDatabase.instance
                                  .ref("Badge/$postmail/");
                              bad.once().then((value) async {
                                DataSnapshot snap = value.snapshot;
                                if (snap.exists) {
                                  liststu[index].sb = true;
                                } else {
                                  liststu[index].sb = false;
                                }
                              });

                              DatabaseReference follows = FirebaseDatabase
                                  .instance
                                  .ref("Following/$minemail/$postmail");
                              follows.once().then((value) async {
                                DataSnapshot snap = value.snapshot;
                                if (snap.exists) {
                                  liststu[index].sf = true;
                                } else {
                                  liststu[index].sf = false;
                                }
                              });

                              return Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(7),
                                          child: GestureDetector(
                                            onTap: (){
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (BuildContext context) {
                                                    personmail = emailId;
                                                    return const PersonProfile();
                                                  }));
                                            },
                                            child: SizedBox(
                                              height: 50,
                                              width: 50,
                                              child: CachedNetworkImage(
                                                imageUrl: photoUrl,
                                                progressIndicatorBuilder: (_, url,
                                                    download) {
                                                  if (download.progress != null) {
                                                    final percent = download.progress! * 100;
                                                    return Center(
                                                      child: CircularProgressIndicator(
                                                          color: const Color(0xff8a8989),
                                                          value: percent
                                                      ),
                                                    );
                                                  }

                                                  return const Text("");
                                                },
                                                imageBuilder: (context, imageProvider) =>
                                                    Container(
                                                      width: 42.0,
                                                      height: 42.0,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image: imageProvider, fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (BuildContext context) {
                                                      personmail = emailId;
                                                      return const PersonProfile();
                                                    }));
                                          },
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(vertical: 0),
                                                child: Row(
                                                    children: [SizedBox(
                                                      width: 120,
                                                      child: Text(
                                                        name,
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w500,
                                                            fontFamily: 'gupter',
                                                            color: Colors.black),
                                                      ),
                                                    ),liststu[index].sb ? Image.asset('images/verr.png', width: 20, height: 20,) : SizedBox(width: 0,),
                                                    ]
                                                ),
                                              ),
                                              Text(
                                                "$year Year, $department, $hall",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'gupter',
                                                    color: Color(0xff8a8989),
                                                    fontSize: 12),
                                              )
                                            ],
                                          ),
                                        ),
                                        new Spacer(),
                                        (emailId!=EmailIdp)? IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) {
                                                    messagewalamail = emailId;
                                                    return Dialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30)),
                                                      child:
                                                          const MessageDialog(),
                                                    );
                                                  });
                                            },
                                            icon: Image.asset('images/mmess.png',height: 25, width: 25,)) : SizedBox(width: 0,),
                                        liststu[index].sf
                                            ? (emailId!=EmailIdp)? Container(
                                          width: 90,
                                              child: ElevatedButton(
                                                  onPressed: () async {
                                                    String? je =
                                                        emailId.replaceAll("@", '');
                                                    String? postmail =
                                                        je.replaceAll(".", "");
                                                    String? mymail =
                                                        EmailIdp.replaceAll(
                                                            "@", '');
                                                    String? minemail =
                                                        mymail.replaceAll(".", "");
                                                    DatabaseReference delref =
                                                        FirebaseDatabase.instance.ref(
                                                            "Following/$minemail/$postmail");
                                                    DatabaseReference jkl =
                                                        FirebaseDatabase.instance.ref(
                                                            "Followers/$postmail/$minemail");
                                                    setState(() {
                                                      liststu[index].sf = false;
                                                    });

                                                    DatabaseReference get =
                                                        FirebaseDatabase.instance.ref(
                                                            "FollowersCount/$postmail");
                                                    get.once().then((value) async {
                                                      DataSnapshot snap =
                                                          value.snapshot;
                                                      if (snap.exists) {
                                                        Map<dynamic, dynamic> map =
                                                            snap.value as Map;
                                                        setState(() {
                                                          int yu = map["count"];
                                                          final json = {
                                                            "count": yu - 1
                                                          };
                                                          DatabaseReference ge =
                                                              FirebaseDatabase
                                                                  .instance
                                                                  .ref(
                                                                      "FollowersCount/$postmail");
                                                          ge.set(json);
                                                        });
                                                      }
                                                    });

                                                    await delref.remove();
                                                    await jkl.remove();
                                                  },
                                                  child: Text("UnFollow", style: TextStyle(fontSize: 12),)),
                                            ) : SizedBox(width: 0,)
                                            : (emailId!=EmailIdp)? Container(
                                          width: 90,
                                              child: ElevatedButton(
                                                  onPressed: () async {
                                                    String? je =
                                                        emailId.replaceAll("@", '');
                                                    String? postmail =
                                                        je.replaceAll(".", "");
                                                    String? mymail =
                                                        EmailIdp.replaceAll(
                                                            "@", '');
                                                    String? minemail =
                                                        mymail.replaceAll(".", "");
                                                    DatabaseReference addfollow =
                                                        FirebaseDatabase.instance.ref(
                                                            "Following/$minemail/$postmail");
                                                    DatabaseReference addfollower =
                                                        FirebaseDatabase.instance.ref(
                                                            "Followers/$postmail/$minemail");
                                                    final json = {"follows": "yes"};
                                                    final jsonn = {
                                                      "Name": Namep,
                                                      "Email_ID": EmailIdp,
                                                      "PhotoUrl": PhotoUrlp,
                                                      "Year": Yearp,
                                                      "Department": Departmentp,
                                                      "Hall": Hallp,
                                                      "Bio": Biop
                                                    };
                                                    setState(() {
                                                      liststu[index].sf = true;
                                                    });

                                                    DatabaseReference get =
                                                        FirebaseDatabase.instance.ref(
                                                            "FollowersCount/$postmail");
                                                    get.once().then((value) async {
                                                      DataSnapshot snap =
                                                          value.snapshot;
                                                      if (snap.exists) {
                                                        Map<dynamic, dynamic> map =
                                                            snap.value as Map;
                                                        setState(() async {
                                                          int yu = map["count"];
                                                          final json = {
                                                            "count": yu + 1
                                                          };
                                                          DatabaseReference ge =
                                                              FirebaseDatabase
                                                                  .instance
                                                                  .ref(
                                                                      "FollowersCount/$postmail");
                                                          await ge.set(json);
                                                        });
                                                      } else {
                                                        setState(() async {
                                                          final json = {"count": 1};
                                                          DatabaseReference ge =
                                                              FirebaseDatabase
                                                                  .instance
                                                                  .ref(
                                                                      "FollowersCount/$postmail");
                                                          await ge.set(json);
                                                        });
                                                      }
                                                    });

                                                    await addfollow.set(json);
                                                    await addfollower.set(jsonn);
                                                  },
                                                  child: Text("Follow", style: TextStyle(fontSize: 12),)),
                                            ) : SizedBox(width: 0,),
                                      SizedBox(width: 8,)],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ),
                  ]),
                ),
        ));
  }
}

void cleartext() {
  searchcon.clear();
}
