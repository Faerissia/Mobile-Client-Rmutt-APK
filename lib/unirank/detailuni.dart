import 'package:flutter/material.dart';
import 'package:myapp/unirank/UniversityScoreDetail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myapp/config/ipconfig.dart';

class detailuni extends StatefulWidget {
  const detailuni({super.key});
  @override
  State<detailuni> createState() => _detailuniState();
}

class _detailuniState extends State<detailuni> {
  List result = [];
  Future<String> gettnmName() async {
    Uri requestUri = Uri.parse('${ipaddress}/result/');
    var response = await http.get(requestUri);
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      setState(() {
        result = decoded['results'];
        print(result);
      });
    }

    return 'success';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettnmName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 42, 121),
        title: Text("อันดับมหาวิทยาลัย"),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.96,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    border: Border(
                      left: BorderSide(width: 2.0),
                      right: BorderSide(width: 2.0),
                      top: BorderSide(width: 2.0),
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Text(
                    'อันดับ',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width / 3 - 18,
                  top: 10,
                  child: Text(
                    'มหาวิทยาลัย',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Text(
                    'จำนวนเหรียญ',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.70,
              width: MediaQuery.of(context).size.width * 0.96,
              child: Container(
                color: Colors.grey[350],
                child: ListView.builder(
                  itemCount: result.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: 5, left: 5, top: 3),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 60),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // SizedBox(
                              //   width: 22,
                              // ),
                              Text(
                                "${(index + 1)}",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                              // SizedBox(
                              //   width: 80,
                              // ),
                              TextButton(
                                onPressed: () {
                                  int uniID = result[index]['uniID'];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UniversityScoreDetail(
                                                uniID: uniID)),
                                  );
                                },
                                child: Text(
                                  "${result[index]['name']}",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              // SizedBox(
                              //   width: 80,
                              // ),
                              Text(
                                "${(result[index]['st1'] + result[index]['nd2'] + result[index]['rd3'])}",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    ;
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
