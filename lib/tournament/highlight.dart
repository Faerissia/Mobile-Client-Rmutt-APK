import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/showall/ending.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:myapp/config/ipconfig.dart';

class showhighlight extends StatelessWidget {
  final int tnmID;
  const showhighlight({Key? key, required this.tnmID}) : super(key: key);

  Future<Map<String, dynamic>> _gethighlight() async {
    Uri requestUri = Uri.parse('$ipaddress/tnmhighlight/$tnmID');
    var response = await http.get(requestUri);
    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _gethighlight(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data!;
            if (data['rows'].length > 0) {
              return _picture(context, data);
            } else {
              return _blank(context, data);
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

Widget _picture(BuildContext context, Map<String, dynamic> data) {
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
              onTap: () async {
                if (data['rows'][index]['filePic'] == null) {
                  String videoId = data['rows'][index]['linkvid'].substring(
                      data['rows'][index]['linkvid'].lastIndexOf('/') + 1);
                  String videoUrl = 'https://www.youtube.com/watch?v=$videoId';
                  await launch(videoUrl);
                } else {
                  print('${data['rows'][index]['filePic']}');
                }
              },
              child: Card(
                elevation: 5,
                color: Color.fromARGB(255, 255, 255, 255),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text('${data['rows'][index]['date']}'),
                    ),
                    if (data['rows'][index]['linkvid'] == null)
                      Container(
                        padding: const EdgeInsets.only(top: 0),
                        height: MediaQuery.of(context).size.height * 0.18,
                        child: CachedNetworkImage(
                          key: UniqueKey(),
                          imageUrl:
                              '$ipaddress/assets/images/${data['rows'][index]['filePic']}',
                        ),
                      )
                    else
                      Stack(children: [
                        CachedNetworkImage(
                          key: UniqueKey(),
                          imageUrl:
                              'https://img.youtube.com/vi/${data['rows'][index]['linkvid'].substring(data['rows'][index]['linkvid'].lastIndexOf('/') + 1)}/0.jpg',
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/images/youtube.png',
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: MediaQuery.of(context).size.height * 0.16,
                            ),
                          ),
                        ),
                      ]),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Text(
                        '${data['rows'][index]['description']}',
                        style: TextStyle(fontSize: 15),
                      ),
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
      "ไม่พบรายการ",
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
  );
}
