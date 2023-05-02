import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:myapp/tournament/detailsport.dart';
import 'package:myapp/main.dart';
import 'package:myapp/config/ipconfig.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class showending extends StatefulWidget {
  const showending({super.key});

  @override
  State<showending> createState() => _sportState();
}

@override
void initState() {
  var colora = Colors.grey;
}

class _sportState extends State<showending> {
  List ending = [];
  Future<String> getongoing() async {
    Uri requestUri = Uri.parse('${ipaddress}/ending');
    var response = await http.get(requestUri);
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      print(decoded);
      setState(() {
        ending = decoded;
      });
    }

    return 'success';
  }

  @override
  void initState() {
    // TODO: implement initState
    getongoing();
  }

  var colora = Colors.grey;
  var texts = "สิ้นสุดการแข่งขันแล้ว";
  bool headervisible = true;
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 42, 121),
        title: Visibility(visible: headervisible, child: Text("$texts")),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          SearchBarAnimation(
              searchBoxWidth: MediaQuery.of(context).size.width * 0.98,
              hintText: "ค้นหากีฬา",
              onPressButton: (isOpen) {
                setState(() {
                  if (headervisible == true) {
                    headervisible = false;
                  } else {
                    headervisible = true;
                  }
                  textController.clear();
                });
              },
              textEditingController: textController,
              isOriginalAnimation: false,
              trailingWidget: const Icon(
                Icons.search,
                size: 20,
                color: Colors.black,
              ),
              secondaryButtonWidget: const Icon(
                Icons.close,
                size: 20,
                color: Colors.black,
              ),
              buttonWidget: const Icon(
                Icons.search,
                size: 20,
                color: Colors.black,
              )),
        ],
      ),

      // body
      body: Padding(
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
                childAspectRatio: 0.70, //เลขมาก = ลดลง
                mainAxisSpacing: 5, //ช่องว่างของกรอบ บนล่าง
                crossAxisSpacing: 0.1, //ช่องว่างของกรอบ ซ้ายขวา
              ),
              itemCount: ending.length, //แก้ไขใส่ค่าตาม length ของข้อมูล
              itemBuilder: (BuildContext context, index) {
                return GestureDetector(
                  onTap: () {
                    int tnmID = ending[index]['tnmID'];
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => detailsport(
                                tnmID:
                                    tnmID))); //แก้ไขเป็นแต่ละกีฬา พารามิเตอร์
                  },
                  child: Card(
                    elevation: 5,
                    color: Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                              '${ending[index]['tnmName']}', //ตัวอย่างการดึง index มาแสดง แก้ไข SQL NAME Tournamment
                              style: TextStyle(fontSize: 15)),
                        ),
                        Text(
                                            '', //ตัวอย่างการดึง index มาแสดง แก้ไข SQL NAME Tournamment
                                            style: TextStyle(fontSize: 8),
                                            textAlign: TextAlign.center,
                                          ),
                        Container(
                            height: MediaQuery.of(context).size.height * 0.18,
                            child: Image.network(
                              '$ipaddress/assets/images/${ending[index]['tnmPicture']}',
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.2,
                            )),
                            Text(
                                            '', //ตัวอย่างการดึง index มาแสดง แก้ไข SQL NAME Tournamment
                                            style: TextStyle(fontSize: 8),
                                            textAlign: TextAlign.center,
                                          ),
                            Text(
                                'วันที่เปิดรับสมัคร',
                                style: TextStyle(fontSize: 15)),
                        Text('${ending[index]['tnmStartdate']} - ${ending[index]['tnmEnddate']}',
                            style: TextStyle(fontSize: 14)),
                        Text('${ending[index]['sportPlaynum'] > 1 ? 'ทีมที่เข้าร่วม' : 'ผู้เข้าร่วม'} ${ending[index]['nop'] ~/ ending[index]['sportPlaynum']} ${ending[index]['sportPlaynum'] > 1 ? 'ทีม' : 'คน'}',
                            style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
