import 'package:flutter/material.dart';
import 'package:multi_image_layout/multi_image_layout.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myapp/config/ipconfig.dart';

class Showmatch extends StatelessWidget {
  final int tnmID;
  const Showmatch({Key? key, required this.tnmID}) : super(key: key);

  Future<Map<String, dynamic>> _getmatch() async {
    Uri requestUri = Uri.parse('$ipaddress/tnmmatch/$tnmID');
    var response = await http.get(requestUri);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getmatch(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data!;
            if (data['rows'][0]['tnmTypegame'] == 'leaderboard') {
              return _buildleaderboard(context, data);
            } else if (data['rows'][0]['tnmTypegame'] == 'Blank') {
              return _blank(context, data);
            } else {
              return _normalmatch(context, data);
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
        }
        return CircularProgressIndicator();
      },
    );
  }
}

Widget _normalmatch(BuildContext context, Map<String, dynamic> data) {
  List results = data['results'];
  return Scaffold(
    body: ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            print("กำลังเลือก ");
            //แสดงรายละเอียด วันเวลาที่แข่ง คะแนนของแต่ละทีม/เดี่ยว สถานที่แข่ง
            //เป็น popup
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.7,
            color: Colors.grey[400],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/images/profile-user.png',
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Text(
                      "${results[index]['player1_name']}",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      Text(
                        "${results[index]?['score1'] ?? ''} - ${results[index]?['score2'] ?? ''}",
                        style: TextStyle(fontSize: 22),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Text(
                        "${results[index]?['pDate'] ?? ''}",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Image.asset(
                      'assets/images/profile-user.png',
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Text(
                      "${data['results'][index]['player2_name']}",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

@override
Widget _buildleaderboard(BuildContext context, Map<String, dynamic> data) {
  List results = data['results'];
  return Column(
    children: [
      Text(
        'วันที่ ${results[0]['pDate']} เวลา ${results[0]['time']}',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      Text(
        'สถานที่ ${results[0]['placeName']}',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      Container(
        child: SingleChildScrollView(
          child: DataTable(
            columns: [
              DataColumn(
                  label: Text('อันดับ',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('ผู้เข้าร่วม',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('คะแนน',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
            ],
            rows: List<DataRow>.generate(
              results.length,
              (index) => DataRow(
                cells: [
                  DataCell(Text(
                    '${index + 1}',
                  )),
                  DataCell(Text(
                      '${results[index]['playerFName']} ${results[index]?['playerLName'] ?? ''}')),
                  DataCell(Text('${results[index]['score']}')),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

@override
Widget _blank(BuildContext context, Map<String, dynamic> data) {
  return Center(
    child: Text(
      "ยังไม่เริ่มการแข่งขัน",
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
  );
}
