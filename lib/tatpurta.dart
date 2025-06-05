import 'package:flutter/material.dart';

class tatpurta extends StatefulWidget {
  const tatpurta({Key? key}) : super(key: key);

  @override
  State<tatpurta> createState() => _tatpurtaState();
}

class _tatpurtaState extends State<tatpurta> {





  String cc = "";
  List<String> halllgist = <String>[
    'Select',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("he"),),
    body: Column(children: [SizedBox(height: 100,),
    ElevatedButton(onPressed: (){
      setState(() {
        halllgist.removeAt(2);
        halllgist.removeAt(3);
      });
    }, child: Text("hf")),
    Text(halllgist[2])],),);
  }
}
