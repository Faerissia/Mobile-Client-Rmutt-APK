import 'dart:isolate';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myapp/tournament/regform/regteam.dart';
import 'package:multi_image_layout/multi_image_layout.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myapp/tournament/regform/regteam.dart';
import 'package:myapp/tournament/regform/single.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:myapp/config/ipconfig.dart';

class Info extends StatelessWidget {
  final int tnmID;
  const Info({Key? key, required this.tnmID}) : super(key: key);

  Future<Map<String, dynamic>> _getinfo() async {
    Uri requestUri = Uri.parse('$ipaddress/tnmdetail/$tnmID');
    var response = await http.get(requestUri);
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getinfo(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data!;

            return _builddetail(context, data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
        }
        return CircularProgressIndicator();
      },
    );
  }
}


Widget _builddetail(BuildContext context, Map<String, dynamic> data) {

Future<void> downloadFile(String url, String fileName) async {

  final response = await http.get(Uri.parse(url));
  final bytes = response.bodyBytes;
  final directory = await getExternalStorageDirectory();

  
  String newPath ="";
  List<String> folders = directory!.path.split("/");
  for(int x = 1;x<folders.length;x++){
    String folder = folders[x];
    if(folder != "Android"){
      newPath += "/"+folder;
    }else{
      break;
    }
  }
  newPath = newPath+"/Download";
  
  final file = File('$newPath/$fileName');
  print(file);
  await file.writeAsBytes(bytes).then((_) {
    print('File download complete');
  });

}

  List<String> tnmFiles = (data['rows'][0]['tnmFile1'] as String).split(',');
  String typegame = '';
  if(data['rows'][0]['tnmTypegame'] == 'single'){
    typegame = 'Single Elimination (แพ้คัดออก)';
  }else if(data['rows'][0]['tnmTypegame'] == 'roundrobin'){
    typegame = 'Round Robin (พบกันหมด)';
  }else if(data['rows'][0]['tnmTypegame'] == 'leaderboard'){
    typegame = 'leaderboard (ตารางผู้นำ)';
  }else if(data['rows'][0]['tnmTypegame'] == 'roundsingle'){
    typegame = 'พบกันหมดและแพ้คัดออก';
  }else{
    typegame = 'ยังไม่เริ่มการแข่งขัน';
  }
DateTime now = DateTime.now();
String formattedDate = DateFormat('dd MMMM yyyy').format(now);
DateTime today = DateFormat('dd MMMM yyyy').parse(formattedDate);
DateTime rstart = DateFormat('dd MMMM yyyy').parse(data['rows'][0]['rstartdate']);
DateTime rend = DateFormat('dd MMMM yyyy').parse(data['rows'][0]['renddate']);

bool isTodayAfterRStart = today.isAfter(rstart);
bool isTodayBeforeREnd = today.isBefore(rend);


  return Container(
    height: MediaQuery.of(context).size.height * 1,
    width: MediaQuery.of(context).size.width * 1,
    color: Color.fromARGB(255, 233, 231, 231),
    child: SingleChildScrollView(
      child: Column(
        children: [
          CachedNetworkImage(
            key: UniqueKey(),
            imageUrl:
                '$ipaddress/assets/images/${data['rows'][0]['tnmPicture']}',
            height: 200,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: isTodayAfterRStart && isTodayBeforeREnd || today == rstart || today == rend
                        ? ElevatedButton(
                            onPressed: () {
                              int tnmID = data['rows'][0]['tnmID'];
                              int sportPlaynum = data['rows'][0]['sportPlaynum'];
                              if (sportPlaynum == 1) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => regsingle(
                                      tnmID: tnmID,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterTeamScreen(
                                      tnmID: tnmID,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'สมัครเข้าแข่งขัน ',
                              style: TextStyle(fontSize: 20),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                          )
                        : Container(),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Icon(Icons.pending_actions),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                            'เปิดรับสมัครวันที่ ${data['rows'][0]['rstartdate']} - ${data['rows'][0]['renddate']}'), //แก้ไขตาม SQL ดึงข้อมูลมาแสดง
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Icon(Icons.calendar_month),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                            'เริ่มการแข่งขันวันที่ ${data['rows'][0]['tnmstartdate']} - ${data['rows'][0]['tnmenddate']}'), //แก้ไขตาม SQL ดึงข้อมูลมาแสดง
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        Icon(Icons.star),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text(
                            '${typegame}'), //แก้ไขตาม SQL ดึงข้อมูลมาแสดง
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    GestureDetector(
                      child: Row(
                        children: [
                          Icon(Icons.description),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Row(
                            children: [
                              Text('ไฟล์เอกสาร'),
                              GestureDetector(
                                  onTap: () async {
                                    print('${tnmFiles[0]}');
                                    downloadFile('$ipaddress/assets/doc/${tnmFiles[0]}','${tnmFiles[0]}');
                       
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Text('ไฟล์ 1',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline
                                    ),
                                    ),
                                  )),
                              if (tnmFiles.length == 2)
                                GestureDetector(
                                    onTap: () {
                                      print('${tnmFiles[1]}');
                                      downloadFile('$ipaddress/assets/doc/${tnmFiles[1]}','${tnmFiles[1]}');
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Text('ไฟล์ 2',
                                      style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline
                                    ),
                                    ),
                                    )),
                              if (tnmFiles.length == 3)
                                GestureDetector(
                                    onTap: () {
                                      print('${tnmFiles[2]}');
                                      downloadFile('$ipaddress/assets/doc/${tnmFiles[2]}','${tnmFiles[2]}');
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Text('ไฟล์ 3',
                                      style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline
                                    ),
                                    ),
                                    )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'รายละเอียดการแข่ง',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ), //หัวข้อ
                        Text(
                            '${data['rows'][0]['tnmDetail']}'), //ดึงข้อมูลจาก SQL มาแสดง
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 10)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
