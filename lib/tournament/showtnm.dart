import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myapp/config/ipconfig.dart';

class Showtnm extends StatelessWidget {
  final int tnmID;
  const Showtnm({Key? key, required this.tnmID}) : super(key: key);

  Future<Map<String, dynamic>> _getbracket() async {
    Uri requestUri = Uri.parse('$ipaddress/tnmbracket/$tnmID');
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
      future: _getbracket(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data!;
            if (data['rows'][0]['tnmTypegame'] == 'leaderboard') {
              return _buildleaderboard(context, data);
            } else if (data['rows'][0]['tnmTypegame'] == 'roundsingle') {
              return _buildroundsingle(context, data);
            } else if (data['rows'][0]['tnmTypegame'] == 'roundrobin') {
              return _buildroundrobin(context, data);
            } else if (data['rows'][0]['tnmTypegame'] == 'single') {
              return _buildsingle(context, data);
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

@override
Widget _buildleaderboard(BuildContext context, Map<String, dynamic> data) {
  List results = data['results'];
  return Container(
    child: SingleChildScrollView(
      child: DataTable(
        columns: [
          DataColumn(
              label: Text('อันดับ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('ผู้เข้าร่วม',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('คะแนน',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
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
              DataCell(Text('${results[index]?['score'] ?? ''}')),
            ],
          ),
        ),
      ),
    ),
  );
}

@override
Widget _buildsingle(BuildContext context, Map<String, dynamic> data) {
  List<Map<String, dynamic>> dataset =
      List<Map<String, dynamic>>.from(data['data']);
  dataset.sort(
      (a, b) => a['round'].compareTo(b['round'])); // Sort dataset by round
  List<DataRow> rows = [];
  String? currentRound;
  for (int i = 0; i < dataset.length; i++) {
    Map<String, dynamic> item = dataset[i];
    if (item['round'] != currentRound) {
      // Add a new header row for a new round
      rows.add(DataRow(cells: [
        DataCell(Text('รอบที่ ${item['round'] ?? ''}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        DataCell(Text('')),
      ]));
      currentRound = item['round'];
    }
    // Add a row for the current item's match
    rows.add(DataRow(cells: [
      DataCell(Text('')),
      DataCell(Text('${item['team1'] ?? ''} - ${item['team2'] ?? ''}')),
    ]));
  }
  return Container(
    child: SingleChildScrollView(
      child: DataTable(
        columns: [
          DataColumn(
              label: Text('รอบการแข่งขัน',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('คู่ระหว่าง',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        ],
        rows: rows,
      ),
    ),
  );
}

@override
Widget _buildroundsingle(BuildContext context, Map<String, dynamic> data) {
  List results = data['data'];
  List scoreboard = data['sortedScoreboard'];

  List<Map<String, dynamic>> dataset =
      List<Map<String, dynamic>>.from(data['data']);
  dataset.sort((a, b) => (a['round'] ?? '').compareTo(b['round'] ?? ''));
  List<DataRow> rows = [];
  String? currentRound;
  for (int i = 0; i < dataset.length; i++) {
    Map<String, dynamic> item = dataset[i];
    if (item['round'] != currentRound &&
        item['team1'] != null &&
        item['team2'] != null) {
      // Add a new header row for a new round
      if (currentRound != null) {
        rows.add(DataRow(cells: [
          DataCell(Text('')),
          DataCell(Text('')),
        ]));
      }
      rows.add(DataRow(cells: [
        DataCell(Text('รอบที่ ${item['round'] ?? ''}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        DataCell(Text('')),
      ]));
      currentRound = item['round'];
    }
    if (currentRound != null &&
        item['team1'] != null &&
        item['team2'] != null) {
      // Add a row for the current item's match
      rows.add(DataRow(cells: [
        DataCell(Text('')),
        DataCell(Text('${item['team1'] ?? ''} - ${item['team2'] ?? ''}')),
      ]));
    }
  }

  return SingleChildScrollView(
    physics: AlwaysScrollableScrollPhysics(),
    child: Column(
      children: [
        SingleChildScrollView(
          child: DataTable(
            columns: [
              DataColumn(
                  label: Text('แมทช์ที่',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('คู่ระหว่าง',
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
                      '${results[index]?['team1'] ?? ''} - ${results[index]?['team2'] ?? ''}')),
                  DataCell(Text(
                      '${results[index]?['score1'] ?? ''} - ${results[index]?['score2'] ?? ''}')),
                ],
              ),
            ),
          ),
        ),
        Column(
          children: [
            Text(
              'ตารางคะแนน',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SingleChildScrollView(
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
                      label: Text('ชนะ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('แพ้',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                ],
                rows: List<DataRow>.generate(
                  scoreboard.length,
                  (index) => DataRow(
                    cells: [
                      DataCell(Text('${index + 1}')),
                      DataCell(Text('${scoreboard[index]?['name'] ?? ''}')),
                      DataCell(Text('${scoreboard[index]?['wins'] ?? ''}')),
                      DataCell(Text('${scoreboard[index]?['losses'] ?? ''}')),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          child: SingleChildScrollView(
            child: DataTable(
              columns: [
                DataColumn(
                    label: Text('รอบการแข่งขัน',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('คู่ระหว่าง',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
              ],
              rows: rows,
            ),
          ),
        ),
      ],
    ),
  );
}

@override
Widget _buildroundrobin(BuildContext context, Map<String, dynamic> data) {
  List results = data['results'];
  List scoreboard = data['sortedScoreboard'];
  return SingleChildScrollView(
    physics: AlwaysScrollableScrollPhysics(),
    child: Column(
      children: [
        SingleChildScrollView(
          child: DataTable(
            columns: [
              DataColumn(
                  label: Text('แมทช์ที่',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('คู่ระหว่าง',
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
                      '${results[index]?['team1'] ?? ''} - ${results[index]?['team2'] ?? ''}')),
                  DataCell(Text(
                      '${results[index]?['score1'] ?? ''} - ${results[index]?['score2'] ?? ''}')),
                ],
              ),
            ),
          ),
        ),
        Column(
          children: [
            Text(
              'ตารางคะแนน',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(
                      label: Text('ผู้เข้าร่วม',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('ชนะ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('แพ้',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                ],
                rows: List<DataRow>.generate(
                  scoreboard.length,
                  (index) => DataRow(
                    cells: [
                      DataCell(Text('${scoreboard[index]?['name'] ?? ''}')),
                      DataCell(Text('${scoreboard[index]?['wins'] ?? ''}')),
                      DataCell(Text('${scoreboard[index]?['losses'] ?? ''}')),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
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
