import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myapp/config/ipconfig.dart';

class ShowTeam extends StatelessWidget {
  final int tnmID;
  const ShowTeam({Key? key, required this.tnmID}) : super(key: key);

  Future<Map<String, dynamic>> _getParticipant() async {
    Uri requestUri = Uri.parse('$ipaddress/tnmparticipant/$tnmID');
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
      future: _getParticipant(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data!;
            if (data['result'][0]['sportPlaynum'] == 1) {
              if (data['rows'].length > 0) {
                return _buildSingleList(context, data);
              } else {
                return _blank(context, data);
              }
            } else {
              if (data['rows'].length > 0) {
                return _buildTeamList(context, data);
              } else {
                return _blank(context, data);
              }
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

Widget _buildSingleList(BuildContext context, Map<String, dynamic> data) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        //borderRadius: BorderRadius.circular(35),
        color: Colors.grey,
      ),
      height: MediaQuery.of(context).size.height * 1,
      width: MediaQuery.of(context).size.width * 1,
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 0.9, //เลขมาก = ลดลง
            mainAxisSpacing: 10, //ช่องว่างของกรอบ บนล่าง
            crossAxisSpacing: 5, //ช่องว่างของกรอบ ซ้ายขวา
          ),
          itemCount: data['rows'].length, //แก้ไขใส่ค่าตาม length ของข้อมูล
          itemBuilder: (BuildContext context, index) {
            return GestureDetector(
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => detailsport())); //แก้ไขเป็นแต่ละทีม พารามิเตอร์
              },
              child: Card(
                elevation: 5, //เงาของกรอบ
                color: Color.fromARGB(255, 255, 255, 255),

                child: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(top: 10),
                        height: MediaQuery.of(context).size.height * 0.18,
                        child: Image.asset('assets/images/1.png')),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                          '${data['rows'][index]['playerFName']} ${data['rows'][index]['playerLName']} ',
                          style: TextStyle(fontSize: 15)),
                    ),
                  ],
                ),
              ),
            );
          }),
    ),
  );
}

Widget _buildTeamList(BuildContext context, Map<String, dynamic> data) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        //borderRadius: BorderRadius.circular(35),
        color: Colors.grey,
      ),
      height: MediaQuery.of(context).size.height * 1,
      width: MediaQuery.of(context).size.width * 1,
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 0.9, //เลขมาก = ลดลง
            mainAxisSpacing: 10, //ช่องว่างของกรอบ บนล่าง
            crossAxisSpacing: 5, //ช่องว่างของกรอบ ซ้ายขวา
          ),
          itemCount: data['rows'].length, //แก้ไขใส่ค่าตาม length ของข้อมูล
          itemBuilder: (BuildContext context, index) {
            return GestureDetector(
              onTap: () {
                print('test');
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => detailsport())); //แก้ไขเป็นแต่ละทีม พารามิเตอร์
              },
              child: Card(
                elevation: 5, //เงาของกรอบ
                color: Colors.amber,

                child: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(top: 10),
                        height: MediaQuery.of(context).size.height * 0.18,
                        child: CachedNetworkImage(
                            key: UniqueKey(),
                            imageUrl:
                                '$ipaddress/assets/team/${data['rows'][index]['teamPic']}')),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text('${data['rows'][index]['teamName']}',
                          style: TextStyle(fontSize: 15)),
                    ),
                  ],
                ),
              ),
            );
          }),
    ),
  );
}

@override
Widget _blank(BuildContext context, Map<String, dynamic> data) {
  return Center(
    child: Text(
      "ยังไม่มีผู้เข้าร่วม",
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
  );
}
