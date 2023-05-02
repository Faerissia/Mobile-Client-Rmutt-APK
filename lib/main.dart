import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:myapp/tournament/detailsport.dart';
//แสดงรายการทั้งหมด
import 'package:myapp/showall/opening.dart';
import 'package:myapp/showall/ongoing.dart';
import 'package:myapp/showall/ending.dart';
import 'package:myapp/showall/all.dart';

import 'package:myapp/unirank/detailuni.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myapp/config/ipconfig.dart';


void main() async {
  runApp(const MyApp());


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'RMUTT GAMES'),
      //home: const second()
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List openingdata = [];
  List ongoingdata = [];
  List endingdata = [];
  Future<String> getindex() async {
    Uri requestUri = Uri.parse('${ipaddress}/');
    var response = await http.get(requestUri);
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      var opening = decoded['opening'];
      var ongoing = decoded['ongoing'];
      var ending = decoded['ending'];

      setState(() {
        openingdata = opening;
        ongoingdata = ongoing;
        endingdata = ending;
        print(endingdata.length);
      });
    }

    return 'success';
  }

  

  @override
  void initState() {
    // TODO: implement initState

    getindex();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 42, 121),
        title: Text(widget.title),
      ),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 33, 130, 191),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text(
                " การแข่งขันทั้งหมด",
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => showall()));
              },
            ),
            ListTile(
              title: const Text(
                "การแข่งขันที่เปิดรับสมัคร",
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => showopening()));
              },
            ),
            ListTile(
              title: const Text(
                "การแข่งขันที่ดำเนินการอยู่",
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => showongoing()));
              },
            ),
            ListTile(
              title: const Text(
                "การแข่งขันที่สิ้นสุดแล้ว",
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => showending()));
              },
            ),
            ListTile(
              title: const Text(
                "อันดับมหาวิทยาลัย",
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => detailuni()));
              },
            ),

            // ListTile(
            //   title: Text("เมนู 2"),
            //   onTap: () {
            //   },
            // ),
            // ListTile(
            //   title: Text("เมนู 3"),
            //   onTap: () {
            //   },
            // ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: Container(
                  //กรอบเขียว in design + เทา in mobile
                  //height: 400,
                  color: Color.fromARGB(255, 208, 208, 208),
                  child: Column(
                    children: [
                      //กรอบเหลือง in design + ฟ้า in mobile
                      Container(
                          color: Color.fromARGB(255, 55, 188, 255),
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 50)), //ระยะห่างปุ่มกับข้อความ
                              Text(
                                'การแข่งขันที่เปิดรับสมัคร',
                                style: TextStyle(fontSize: 18),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 18)), //ระยะห่างปุ่มกับข้อความ
                              SizedBox(
                                width: 84,
                                height: 25,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                showongoing())); //sport() ไว้กดหน้าที่ต้องการไป
                                  },
                                  child: Text('ดูทั้งหมด'),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange),
                                ),
                              )
                            ],
                          )),

                      //เริ่มแสดงการแข่งที่เปิดรับสมัคร
                      if(openingdata.length > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Container(
                            //color: Colors.amber,
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: MediaQuery.of(context).size.width * 1,
                            child: ListView.builder(
                              itemCount: openingdata
                                  .length, //แก้ตามจำนวนข้อมูลใน MySQL
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      //height: MediaQuery.of(context).size.height * 0.2,
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            'ชื่อ ${openingdata[index]['tnmName']}', //ตัวอย่างการดึง index มาแสดง แก้ไข SQL NAME Tournamment
                                            style: TextStyle(fontSize: 15),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            '', //ตัวอย่างการดึง index มาแสดง แก้ไข SQL NAME Tournamment
                                            style: TextStyle(fontSize: 8),
                                            textAlign: TextAlign.center,
                                          ),
                                          Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.19,
                                              child: Image.network(
                                                '${ipaddress}/assets/images/${openingdata[index]['tnmPicture']}',
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                              )),
                                              Text(
                                            '', //ตัวอย่างการดึง index มาแสดง แก้ไข SQL NAME Tournamment
                                            style: TextStyle(fontSize: 8),
                                            textAlign: TextAlign.center,
                                          ),
                                              Text(
                                              'วันที่เปิดรับสมัคร',
                                              style: TextStyle(fontSize: 15)),
                                          Text(
                                              '${openingdata[index]['Rstartdate']} - ${openingdata[index]['Renddate']}',
                                              style: TextStyle(fontSize: 15)),
                                          Text(
                                              '${openingdata[index]['sportPlaynum'] > 1 ? 'ทีมที่เข้าร่วม' : 'ผู้เข้าร่วม'} ${openingdata[index]['nop'] ~/ openingdata[index]['sportPlaynum']} ${openingdata[index]['sportPlaynum'] > 1 ? 'ทีม' : 'คน'}',
                                              style: TextStyle(fontSize: 15)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    
                                    int tnmID = openingdata[index]['tnmID'];
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                detailsport(tnmID: tnmID)));
                                  },
                                );
                              },
                            )),
                      ),
                      //จบหัวข้อการแข่งขันที่ดำเนินอยู่
                    ],
                  ),
                ),
              ),

              //เริ่มแถบรายการที่ดำเนินการอยู่
              if(ongoingdata.length > 0)
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: Container(
                  //กรอบเขียว in design + เทา in mobile
                  //height: 400,
                  color: Color.fromARGB(255, 208, 208, 208),
                  child: Column(
                    children: [
                      //กรอบเหลือง in design + ฟ้า in mobile
                      Container(
                          color: Color.fromARGB(255, 55, 188, 255),
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(padding: EdgeInsets.only(left: 50)),
                              Text(
                                'การแข่งขันที่ดำเนินการอยู่',
                                style: TextStyle(fontSize: 18),
                              ),
                              Padding(padding: EdgeInsets.only(left: 18)),
                              SizedBox(
                                width: 84,
                                height: 25,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                showopening()));
                                  },
                                  child: Text('ดูทั้งหมด'),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange),
                                ),
                              )
                            ],
                          )),
                      //เริ่มแสดงรายการที่เปิดรับสมัคร
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Container(
                            color: Color.fromARGB(255, 213, 213, 213),
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: MediaQuery.of(context).size.width * 1,
                            child: ListView.builder(
                              itemCount: ongoingdata.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      //height: MediaQuery.of(context).size.height * 0.2,
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                              'ชื่อ ${ongoingdata[index]["tnmName"]}', //ตัวอย่างการดึง index มาแสดง แก้ไข SQL NAME Tournamment
                                              style: TextStyle(fontSize: 15)),
                                               Text(
                                            '', //ตัวอย่างการดึง index มาแสดง แก้ไข SQL NAME Tournamment
                                            style: TextStyle(fontSize: 8),
                                            textAlign: TextAlign.center,
                                          ),
                                          Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.19,
                                              child: Image.network(
                                                '${ipaddress}/assets/images/${ongoingdata[index]['tnmPicture']}',
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                              )),
                                               Text(
                                            '', //ตัวอย่างการดึง index มาแสดง แก้ไข SQL NAME Tournamment
                                            style: TextStyle(fontSize: 8),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                              'วันที่ ${ongoingdata[index]["tnmstartdate"]}',
                                              style: TextStyle(fontSize: 15)),
                                          Text(
                                              '${ongoingdata[index]['sportPlaynum'] > 1 ? 'ทีมที่เข้าร่วม' : 'ผู้เข้าร่วม'} ${ongoingdata[index]['nop'] ~/ ongoingdata[index]['sportPlaynum']} ${ongoingdata[index]['sportPlaynum'] > 1 ? 'ทีม' : 'คน'}',
                                              style: TextStyle(fontSize: 15)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    int tnmID = ongoingdata[index]['tnmID'];
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                detailsport(tnmID: tnmID)));
                                  },
                                );
                              },
                            )),
                      ),
                      //จบหัวข้อการแข่งขันที่เปิดรับสมัคร
                    ],
                  ),
                ),
              ),

              //เริ่มแถบสิ้นสุดการแข่งขันแล้ว
              if(endingdata.length > 0)
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                child: Container(
                  //กรอบเขียว in design + เทา in mobile
                  //height: 400,
                  color: Color.fromARGB(255, 208, 208, 208),
                  child: Column(
                    children: [
                      //กรอบเหลือง in design + ฟ้า in mobile
                      Container(
                          color: Color.fromARGB(255, 55, 188, 255),
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(padding: EdgeInsets.only(left: 80)),
                              Text(
                                'สิ้นสุดการแข่งขันแล้ว',
                                style: TextStyle(fontSize: 18),
                              ),
                              Padding(padding: EdgeInsets.only(left: 15)),
                              SizedBox(
                                width: 84,
                                height: 25,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                showending()));
                                  },
                                  child: Text('ดูทั้งหมด'),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange),
                                ),
                              )
                            ],
                          )),
                      //เริ่มแสดงสิ้นสุดการแข่งขันแล้ว
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Container(
                            color: Color.fromARGB(255, 212, 212, 212),
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: MediaQuery.of(context).size.width * 1,
                            child: ListView.builder(
                              itemCount:endingdata.length, //แก้ตามจำนวนข้อมูลใน MySQL
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      //height: MediaQuery.of(context).size.height * 0.2,
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                              '${endingdata[index]["tnmName"]}', //ตัวอย่างการดึง index มาแสดง แก้ไข SQL NAME Tournamment
                                              style: TextStyle(fontSize: 15)),
                                               Text(
                                            '', //ตัวอย่างการดึง index มาแสดง แก้ไข SQL NAME Tournamment
                                            style: TextStyle(fontSize: 8),
                                            textAlign: TextAlign.center,
                                          ),
                                          Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.19,
                                              child: Image.network(
                                                '${ipaddress}/assets/images/${endingdata[index]['tnmPicture']}',
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                              )),
                                               Text(
                                            '', //ตัวอย่างการดึง index มาแสดง แก้ไข SQL NAME Tournamment
                                            style: TextStyle(fontSize: 8),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                              'วันที่แข่งขัน',
                                              style: TextStyle(fontSize: 15)),
                                              Text(
                                              '${endingdata[index]["tnmStartdate"]} - ${endingdata[index]["tnmEnddate"]}',
                                              style: TextStyle(fontSize: 15)),
                                          Text(
                                              '${endingdata[index]['sportPlaynum'] > 1 ? 'ทีมที่เข้าร่วม' : 'ผู้เข้าร่วม'} ${endingdata[index]['nop'] ~/ endingdata[index]['sportPlaynum']} ${endingdata[index]['sportPlaynum'] > 1 ? 'ทีม' : 'คน'}',
                                              style: TextStyle(fontSize: 15)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    int tnmID = endingdata[index]['tnmID'];
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                detailsport(tnmID: tnmID)));
                                  },
                                );
                              },
                            )),
                      ),
                      //จบหัวข้อสิ้นสุดการแข่งขันแล้ว
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
