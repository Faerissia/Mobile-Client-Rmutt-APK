import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myapp/tournament/info.dart';
import 'package:myapp/tournament/regform/otp.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myapp/config/ipconfig.dart';

class regsingle extends StatefulWidget {
  final int tnmID;
  const regsingle({Key? key, required this.tnmID}) : super(key: key);

  @override
  State<regsingle> createState() => _regsingleState();
}

Future<void> showAlert(BuildContext context, String title, String message) async{
  showDialog(
    context: context,
     builder: (BuildContext context) {
       return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
       );
     });
}

class _regsingleState extends State<regsingle> {
  int tnmID = 0;
  List universityList = [];
  List facultyList = [];
  var selectuni;
  var selectfac;
  var titlename = '';
  var detaildoc = '';

  Future getform() async {
    String _baseUrl = "$ipaddress/singlereg/${widget.tnmID}";
    Uri requestUri = Uri.parse('${_baseUrl}/');
    var response = await http.get(requestUri);
    
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      setState(() {
        universityList = decoded["rows"];
        facultyList = decoded["results"];
        titlename = decoded["data"][0]["tnmName"];
        detaildoc = decoded["data"][0]["tnmUrl"];
      });
    }

    
  }

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tnmID = widget.tnmID;
    getform();
    
  }
  
  final TextEditingController _playerFName = TextEditingController();
  final TextEditingController _playerLName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController dateInput = TextEditingController();
  final TextEditingController _playerPhone = TextEditingController();
  final TextEditingController _idcard = TextEditingController();

  List<File> selectplayerFile = [];

  var fileaname;
  var filebname;
  var filecname;

  String textfilenamea = "";
  String textfilenameb = "";
  String textfilenamec = "";

  String? selectgender;
  final List<DropdownMenuItem<String>> gender =
      ["ชาย", "หญิง"].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(
        value,
        style: TextStyle(color: Colors.black, fontSize: 15),
        maxLines: 2,
      ),
    );
  }).toList();


  String _fileName = "";
  late File _file;

  @override
  Widget build(BuildContext context) {
    var widhtB = MediaQuery.of(context).size.width * 0.3;
    var widhtIB = MediaQuery.of(context).size.width * 0.6;

    int _counter = 0;
    dynamic placeholder = "";

    return Container(
      color: Colors.black,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 3, 42, 121),
          title: Text(
            "${titlename}",
            style: TextStyle(fontSize: 18),
          ), //แก้ไขหัวข้อเปลี่ยนตามกีฬาที่กด
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 15, top: 10),
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 1.02,
            color: Color.fromARGB(255, 233, 231, 231),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(width: widhtB, child: Text('ชื่อ')),
                    SizedBox(width: 5),
                    Container(
                      width: widhtIB,
                      child: Expanded(
                        child: TextField(
                          style: TextStyle(height: 1),
                          controller: _playerFName,
                          decoration: InputDecoration(
                              hintText: "", border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(width: widhtB, child: Text('นามสกุล')),
                    SizedBox(width: 5),
                    Container(
                      width: widhtIB,
                      child: Expanded(
                        child: TextField(
                          style: TextStyle(height: 1),
                          controller: _playerLName,
                          decoration: InputDecoration(
                              hintText: "", border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(width: widhtB, child: Text('เพศ')),
                    SizedBox(width: 5),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: DropdownButton(
                        value: selectgender,
                        items: gender,
                        onChanged: (value) {
                          setState(() {
                            selectgender = value;
                          });
                        },
                        hint: Text('เลือกเพศ'),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(width: widhtB, child: Text('วันเกิด')),
                    SizedBox(width: 5),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: TextField(
                          controller: dateInput,
                          //editing controller of this TextField
                          decoration: InputDecoration(
                              icon: Icon(
                                  Icons.calendar_today), //icon of text field
                              labelText: "Enter Date" //label text of field
                              ),
                          readOnly: true,
                          //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2100));

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              setState(() {
                                dateInput.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {}
                          },
                        )),
                  ],
                ),
                Row(
                  children: [
                    Container(width: widhtB, child: Text('เบอร์โทร')),
                    SizedBox(width: 5),
                    Container(
                      width: widhtIB,
                      child: Expanded(
                        child: TextField(
                          style: TextStyle(height: 1),
                          keyboardType: TextInputType.number,
                          controller: _playerPhone,
                          maxLength: 10,
                          decoration: InputDecoration(
                              hintText: "", border: OutlineInputBorder()),
                        ),
                        
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(width: widhtB, child: Text('อีเมล')),
                    SizedBox(width: 5),
                    Container(
                      width: widhtIB,
                      child: Expanded(
                        child: TextField(
                          style: TextStyle(height: 1),
                          controller: _email,
                          decoration: InputDecoration(
                              hintText: "", border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(width: widhtB, child: Text('มหาวิทยาลัย')),
                    SizedBox(width: 5),
                    Flexible(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: DropdownButton<String>(
                          items: universityList.map((item) {
                            return DropdownMenuItem(
                              value: item["uniID"].toString(),
                              child: Text(item["initials"].toString()),
                            );
                          }).toList(),
                          value: selectuni,
                          onChanged: (value) {
                            setState(() {
                              selectuni = value;
                              selectfac = null;
                            });
                          },
                          hint: Text('เลือกมหาวิทยาลัย'),
                          isExpanded: true, // Set this to true to allow the DropdownButton to expand
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(width: widhtB, child: Text('คณะ')),
                    SizedBox(width: 5),
                    Flexible(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: DropdownButton<String>(
                          items: facultyList
                          .where((item) => item["uniID"].toString() == selectuni)
                          .map((item) {
                            return DropdownMenuItem(
                              value: item["facultyID"].toString(),
                              child: Text(item["name"].toString()),
                            );
                          }).toList(),
                          value: selectfac,
                          onChanged: (value) {
                            setState(() {
                              selectfac = value;
                            });
                          },
                          hint: Text('เลือกคณะ'),
                          isExpanded: true, // Set this to true to allow the DropdownButton to expand
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(width: widhtB, child: Text('บัตรประชาชน')),
                    SizedBox(width: 5),
                    Container(
                      width: widhtIB,
                      child: Expanded(
                        child: TextField(
                          style: TextStyle(height: 1),
                          keyboardType: TextInputType.number,
                          controller: _idcard,
                          maxLength: 13,
                          decoration: InputDecoration(
                              hintText: "", border: OutlineInputBorder()),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'เอกสารสำเนา$detaildoc',
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '*อัพโหลดอย่างน้อย 1 ไฟล์ (png, pdf, jpg)',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                Container(
                  //color: Colors.black,
                  height: MediaQuery.of(context).size.height * 0.19,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(textfilenamea),
                          IconButton(
                              onPressed: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles();
                                if (result != null) {
                                  PlatformFile filea = result.files.first;

                                  print(filea.name);
                                  print(filea.bytes);
                                  print(filea.size);
                                  print(filea.extension);
                                  print(filea.path);

                                  setState(() {
                                    selectplayerFile.add(File(filea.path!));
                                    fileaname = filea.name;
                                    print(fileaname);
                                    textfilenamea = filea.name;
                                  });
                                } else {}
                              },
                              icon: Icon(Icons.add)),
                        ],
                      ),
                      Row(
                        children: [
                          Text(textfilenameb),
                          IconButton(
                              onPressed: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles();
                                if (result != null) {
                                  PlatformFile fileb = result.files.first;

                                  print(fileb.name);
                                  print(fileb.bytes);
                                  print(fileb.size);
                                  print(fileb.extension);
                                  print(fileb.path);

                                  setState(() {
                                    selectplayerFile.add(File(fileb.path!));
                                    filebname = fileb.name;
                                    print(filebname);
                                    textfilenameb = fileb.name;
                                  });
                                } else {
                                  // User canceled the picker
                                }
                              },
                              icon: Icon(Icons.add)),
                        ],
                      ),
                      Row(
                        children: [
                          Text(textfilenamec),
                          IconButton(
                              onPressed: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles();
                                if (result != null) {
                                  PlatformFile filec = result.files.first;

                                  print(filec.name);
                                  print(filec.bytes);
                                  print(filec.size);
                                  print(filec.extension);
                                  print(filec.path);

                                  setState(() {
                                    selectplayerFile.add(File(filec.path!));
                                    filecname = filec.name;
                                    print(filecname);
                                    textfilenamec = filec.name;
                                  });
                                } else {
                                  // User canceled the picker
                                }
                              },
                              icon: Icon(Icons.add)),
                        ],
                      ),
                    ],
                  ),
                  
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 140),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          String playerFName = _playerFName.text;
                          String playerLName = _playerLName.text;
                          String bdate = dateInput.text;
                          String email = _email.text;
                          String playerPhone = _playerPhone.text;
                          String idcard = _idcard.text;


                          postBody( ) async {
                            showDialog(
                              context: context,
                              builder: (context){
                            return Center(child: CircularProgressIndicator());
                                
                              },
                            );
                          try{
                            var request = http.MultipartRequest(
                              'POST',
                              Uri.parse("$ipaddress/singlereg/"),
                                    );

                              for(int i=0;i< selectplayerFile.length;i++){
                              request.files.add(await http.MultipartFile.fromPath('playerFile${i+1}',selectplayerFile[i].path));
                              }

                              request.fields['playerFName'] = playerFName;
                              request.fields['playerLName'] = playerLName;
                              request.fields['playerGender'] = selectgender.toString();
                              request.fields['playerBirthday'] = bdate;
                              request.fields['playerPhone'] = playerPhone;
                              request.fields['playerEmail'] = email;
                              request.fields['facultyID'] = selectfac;
                              request.fields['playerIDCard'] = idcard;
                              request.fields['tnmID'] = tnmID.toString();

                              print(selectplayerFile);
                              
                              var response = await request.send();

                              if(response.statusCode == 200){
                                print('File upload success');
                                var responseData = await http.Response.fromStream(response);
                                print(responseData.body);
        
                                Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => otp(responseData: responseData.body)))
                                  .then((_) => Navigator.of(context).popUntil((route) => route.isFirst));

                              }else{
                                print('failed to upload ${response.statusCode}');
                              }

                          }catch (e) {
                            print(e);
                          }
                          }



                          if(playerFName.length == 0){
                            showAlert(context, 'แจ้งเตือน', 'กรุณากรอกชื่อ');
                          }else if(playerLName.length == 0){
                            showAlert(context, 'แจ้งเตือน', 'กรุณากรอกนามสกุล');
                          }else if(selectgender == null){
                            showAlert(context, 'แจ้งเตือน', 'กรุณาใส่เพศ');
                          }else if(bdate.length == 0){
                            showAlert(context, 'แจ้งเตือน', 'กรุณาใส่วัน/เดือน/ปีเกิด');
                          }else if(playerPhone.length == 0){
                            showAlert(context, 'แจ้งเตือน', 'กรุณาใส่เบอร์โทร');
                          }else if(playerPhone.length < 10){
                            showAlert(context, 'แจ้งเตือน', 'รูปแบบเบอร?โทรศัพท์ไม่ถูกต้อง');
                          }else if(email.length == 0){
                            showAlert(context, 'แจ้งเตือน', 'กรุณาใส่อีเมล');
                          }else if(!email.contains('@') || !email.contains('.')){
                            showAlert(context, 'แจ้งเตือน', 'รูปแบบอีเมลไม่ถูกต้อง');
                          }else if(selectuni == null){
                            showAlert(context, 'แจ้งเตือน', 'กรุณาเลือกมหาวิทยาลัย');
                          }else if(selectfac == null){
                            showAlert(context, 'แจ้งเตือน', 'กรุณาเลือกคณะ');
                          }else if(idcard.length == 0){
                            showAlert(context, 'แจ้งเตือน', 'กรุณากรอกบัตรประจำตัวประชาชน');
                          }else if(idcard.length < 13){
                            showAlert(context, 'แจ้งเตือน', 'รูปแบบบัตรประชาชนไม่ถูกต้อง');
                          }else if(fileaname == null && filebname == null && filecname == null){
                            showAlert(context, 'แจ้งเตือน', 'กรุณาใส่รูปอย่างน้อย 1 ภาพ');
                          }else{
                          print(playerFName);
                          print(playerLName);
                          print(selectgender);
                          print(bdate);
                          print(playerPhone);
                          print(email);
                          print(selectuni);
                          print(selectfac);
                          print(idcard);
                          print(fileaname);
                          print(filebname);
                          print(filecname);
                          postBody();

                          }

                          
                          
                        },
                        child: Text(
                          'ยืนยัน',
                          style: TextStyle(fontSize: 15),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
