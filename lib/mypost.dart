import 'package:flutter/material.dart';
import 'package:kgppanchayat/mylost.dart';
import 'myacademic.dart';
import 'myhall.dart';
import 'getter.dart';
import 'main.dart';
import 'myallpost.dart';
import 'myevent.dart';
import 'myfunde.dart';
import 'temp.dart';


List<Details> listm= [];
List idsm = [];
List<Details> listhm = [];
List idshm = [];
List<Details> listam = [];
List idsam = [];
List<Details> listem = [];
List idsem = [];
List<Details> listfm = [];
List idsfm = [];
List<Details> listlm = [];
List idslm = [];
class MyPost extends StatefulWidget {
  const MyPost({Key? key}) : super(key: key);

  @override
  State<MyPost> createState() => _MyPostState();
}
class _MyPostState extends State<MyPost> with TickerProviderStateMixin{
  late TabController controller;
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 6, vsync: this);
    controller.index = tabindex;
    controller.addListener(_setActiveTabIndex);

  }
  void _setActiveTabIndex() {
    tabindex = controller.index;
  }

  @override
  Widget build(BuildContext context) {


    return WillPopScope(onWillPop: ()async{
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const Temp()),
          ModalRoute.withName("/Temp"));
      return true;
    },

    child:  Scaffold(
      appBar: AppBar(leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black,),
        onPressed: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Temp()),
              ModalRoute.withName("/Temp"));
        },
      ),title: const Text("My Post",style: TextStyle(color: Colors.black, fontFamily: 'gupter'),),
          backgroundColor: Color(0xffffdfaf),toolbarHeight: 50,
        bottomOpacity: 0.0,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
        elevation: 0.0),
      body: Container(
        height: double.maxFinite,
        color: const Color(0xfff1f2f6),
        child: Column(
          children: [
            Container(height: 1,color: Colors.black,),
            Container(height: 7,color: Colors.white,),
            Container(
              color: Colors.white,
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  height: 25,
                  child: ClipRRect(
                    borderRadius:  const BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                    child: TabBar(
                        isScrollable: true,
                        indicatorPadding: const EdgeInsets.symmetric(horizontal: 7),
                        controller: controller,
                        indicator:  const BoxDecoration(
                          borderRadius:  BorderRadius.all(Radius.circular(5.0)),
                          color: Color(0xffffc491),
                        ),
                        labelColor:  const Color(0xff5a3e28),
                        unselectedLabelColor:  Colors.black,
                        labelStyle:
                        const TextStyle(fontFamily: 'glory', fontSize: 17, fontWeight: FontWeight.bold),
                        tabs: const [
                          Tab(text: "All"),
                          Tab(text: "Dept"),
                          Tab(text: "Hall"),
                          Tab(text: "Events",),
                          Tab(text: "Fundae",),
                          Tab(text: "Lost & Found",)
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
              color: const Color(0xfff1f2f6),
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height - 140,
              child: TabBarView(
                controller: controller,
                children: const [MyAll(), MyAcademic(), MyHall(),MyEvent(), MyFunde(), MyLost()],
              ),

            ),
          ],
        ),
      ),
    ));
  }
}
