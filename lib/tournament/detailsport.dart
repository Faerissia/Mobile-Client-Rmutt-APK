import 'package:flutter/material.dart';
import '../main.dart';
import 'package:myapp/tournament/info.dart';
import 'package:myapp/tournament/showtnm.dart';
import 'package:myapp/tournament/showteam.dart';
import 'package:myapp/tournament/showmatch.dart';
import 'package:myapp/tournament/highlight.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myapp/config/ipconfig.dart';

class detailsport extends StatefulWidget {
  final int tnmID;
  const detailsport({Key? key, required this.tnmID}) : super(key: key);

  @override
  State<detailsport> createState() => _detailsportState();
}

class _detailsportState extends State<detailsport> {
  int tnmID = 0;
  String tnmName = '';
  Future<String> gettnmName() async {
    Uri requestUri = Uri.parse('${ipaddress}/tnmdetail/${tnmID}');
    var response = await http.get(requestUri);
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);

      setState(() {
        tnmName = decoded['rows'][0]['tnmName'];
      });
    }
    return 'success';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tnmID = widget.tnmID;
    gettnmName();
  }

  late TabController tabController;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 3, 42, 121),
          title: Text(
            "${tnmName}",
            style: TextStyle(fontSize: 18),
          ), //แก้ไขหัวข้อเปลี่ยนตามกีฬาที่กด
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Container(
                width: 80,
                child: Tab(
                  text: 'ข้อมูล',
                  icon: Icon(Icons.info),
                ),
              ),
              Tab(
                text: 'สายการแข่งขัน',
                icon: Icon(Icons.star),
              ),
              Tab(
                text: 'ผู้เข้าร่วม',
                icon: Icon(Icons.group),
              ),
              Tab(
                text: 'แมตช์การแข่งขัน',
                icon: Icon(Icons.event),
              ),
              Container(
                width: 80,
                child: Tab(
                  text: 'ไฮไลต์',
                  icon: Icon(Icons.smart_display),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Info(tnmID: tnmID),
            Showtnm(tnmID: tnmID),
            ShowTeam(tnmID: tnmID),
            Showmatch(tnmID: tnmID),
            showhighlight(tnmID: tnmID),
          ],
        ),
      ),
    );
  }
}
