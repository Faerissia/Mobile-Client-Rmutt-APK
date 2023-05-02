import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myapp/tournament/regform/otpteam.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:myapp/config/ipconfig.dart';

class RegisterTeamScreen extends StatefulWidget {
  final int tnmID;
  const RegisterTeamScreen({Key? key, required this.tnmID}) : super(key: key);
  @override
  _RegisterTeamScreenState createState() => _RegisterTeamScreenState();
}

class _RegisterTeamScreenState extends State<RegisterTeamScreen> {

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

  File? _teamimage;

 Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if(pickedFile != null){
      setState(() {
      _teamimage = File(pickedFile.path);
    });
    }

  }

    List<List<File>> selectplayerFile = List.generate(15, (_) => []);


   List<String?> fileaname = List.generate(15, (_) => '');
   List<String?> filebname = List.generate(15, (_) => '');
   List<String?> filecname = List.generate(15, (_) => '');


  
  int tnmID = 0;
  int totalplayer = 0;

  var titlename = '';
  var detaildoc = '';

  List universityList = [];
  List facultyList = [];
  List<String?> selectuni = List.generate(15, (_) => null);
  List<String?> selectfac = List.generate(15, (_) => null);

  final TextEditingController _teamName = TextEditingController();
  final TextEditingController _agentFName = TextEditingController();
  final TextEditingController _agentLName = TextEditingController();
  final TextEditingController _agentPhone = TextEditingController();
  final TextEditingController _agentEmail = TextEditingController();
  final picker = ImagePicker();

  //player
  final List<TextEditingController> _playerFName = List.generate(15, (_) => TextEditingController());
  final List<TextEditingController> _playerLName = List.generate(15, (_) => TextEditingController());
  final List<TextEditingController> _playerPhone = List.generate(15, (_) => TextEditingController());
  final List<TextEditingController> _playerEmail = List.generate(15, (_) => TextEditingController());
  final List<TextEditingController> _playerIDCard = List.generate(15, (_) => TextEditingController());
  final List<TextEditingController> dateInput = List.generate(15, (_) => TextEditingController());
  
  List<String?> _playerGender = List.generate(15, (_) => null);


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getform();
  }

  Future getform() async {
    Uri requestUri = Uri.parse('$ipaddress/teamreg/${widget.tnmID}/');
    var response = await http.get(requestUri);
    
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      setState(() {

        print(decoded);

        totalplayer = decoded["data"][0]["sportPlaynum"];
        universityList = decoded["rows"];
        facultyList = decoded["results"];
        titlename = decoded["data"][0]["tnmName"];
        detaildoc = decoded["data"][0]["tnmUrl"];
        tnmID = widget.tnmID;



      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${titlename}"),
        backgroundColor: Color.fromARGB(255, 3, 42, 121),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _teamName,
              decoration: InputDecoration(
                labelText: 'ชื่อทีม',
              ),
            ),
            Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _agentFName,
                      decoration: InputDecoration(
                        labelText: 'ชื่อ(ตัวแทน)',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _agentLName,
                      decoration: InputDecoration(
                        labelText: 'นามสกุล(ตัวแทน)',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
            TextFormField(
              controller: _agentPhone,
              maxLength: 10,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'เบอร์โทร(ตัวแทน)',
              ),
            ),
            TextFormField(
              controller: _agentEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'อีเมล(ตัวแทน)',
              ),
            ),
            
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                if(_teamimage != null) Image.file(_teamimage ?? File('assets/images/defult_image.png')),
                SizedBox(height: 10),
                ElevatedButton(
                  child: Text("แนบรูปภาพ"),
                  onPressed: _getImage,
                ),

              ],
            ),
            Text("________________________________________________________",
          style: TextStyle(
            fontSize: 14.0,
            height: 3 //You can set your custom height here
          )
        ),
            
           Column(
  children: [
    for (var i = 0; i < totalplayer; i++)
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
          child:Text('ผู้เล่นคนที่ ${i + 1} ',
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 2,
            fontSize: 18,
          ),),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _playerFName[i],
                      decoration: InputDecoration(
                        labelText: 'ชื่อ',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _playerLName[i],
                      decoration: InputDecoration(
                        labelText: 'นามสกุล',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
           
          Row(
              children: [
              DropdownButton(
            value: _playerGender[i],
            onChanged: (value) {
              setState(() {
                _playerGender[i] = value;
              });
            },
            items: [
              DropdownMenuItem(
                value: 'ชาย',
                child: Text('ชาย'),
              ),
              DropdownMenuItem(
                value: 'หญิง',
                child: Text('หญิง'),
              ),
            ],
            hint: Text('เลือกเพศ'),
          ),
                    SizedBox(width: 5),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: TextField(
                          controller: dateInput[i],
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
                              String formattedDate =DateFormat('yyyy-MM-dd').format(pickedDate);
                              TextEditingController controller = TextEditingController(text: formattedDate);
                              setState(() {
                                dateInput[i] = controller; //set output date to TextField value.
                              });
                            } else {}
                          },
                        )),
                  ],
                ),
         
          TextFormField(
            controller: _playerPhone[i],
            maxLength: 10,
            decoration: InputDecoration(
              labelText: 'เบอร์โทรศัพท์',
            ),
             keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: _playerEmail[i],
            decoration: InputDecoration(
              labelText: 'อีเมล',
            ),
            keyboardType: TextInputType.emailAddress,
            
          ),
          Row(
                  children: [
                    SizedBox(width: 5),
                    Flexible(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 1,
                        child: DropdownButton<String>(
                          items: universityList.map((item) {
                            return DropdownMenuItem(
                              value: item["uniID"].toString(),
                              child: Text(item["initials"].toString()),
                            );
                          }).toList(),
                          value: selectuni[i],
                          onChanged: (value) {
                            setState(() {
                              selectuni[i] = value;
                              selectfac[i] = null;
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
                    SizedBox(width: 5),
                    Flexible(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 1,
                        child: DropdownButton<String>(
                          items: facultyList
                          .where((item) => item["uniID"].toString() == selectuni[i])
                          .map((item) {
                            return DropdownMenuItem(
                              value: item["facultyID"].toString(),
                              child: Text(item["name"].toString()),
                            );
                          }).toList(),
                          value: selectfac[i],
                          onChanged: (value) {
                            setState(() {
                              selectfac[i] = value;
                            });
                          },
                          hint: Text('เลือกคณะ'),
                          isExpanded: true, // Set this to true to allow the DropdownButton to expand
                        ),
                      ),
                    ),
                  ],
                ),
          TextFormField(
            controller: _playerIDCard[i],
            maxLength: 13,
            decoration: InputDecoration(
              labelText: 'รหัสประจำตัวประชาชน',
            ),
            keyboardType: TextInputType.number,
          ),SizedBox(height: 10),
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
                          Text(fileaname[i]??''),
                          IconButton(
                              onPressed: () async {
                                FilePickerResult? result = await FilePicker.platform.pickFiles();
                                if (result != null) {
                                  PlatformFile filea = result.files.first;

                                  print(filea.name);
                                  print(filea.bytes);
                                  print(filea.size);
                                  print(filea.extension);
                                  print(filea.path);

                                  setState(() {
                                    selectplayerFile[i].insert(0, File(filea.path!));
                                    // selectplayerFile1[i].add(File(filea.path!));
                                    fileaname[i] = filea.name;
                                    print(fileaname);
                                  });
                                } else {}
                              },
                              icon: Icon(Icons.add)),
                        ],
                      ),
                      Row(
                        children: [
                          Text(filebname[i]??''),
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
                                    selectplayerFile[i].insert(1, File(fileb.path!));
                                    // selectplayerFile2[i].add(File(fileb.path!));
                                    filebname[i] = fileb.name;
                                    print(filebname);
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
                          Text(filecname[i]??''),
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
                                    selectplayerFile[i].insert(2, File(filec.path!));
                                    // selectplayerFile3[i].add(File(filec.path!));
                                    filecname[i] = filec.name;
                                    print(filecname);
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
          Text("________________________________________________________",
          style: TextStyle(
            fontSize: 14.0,
            height: 3 //You can set your custom height here
          )
        ),
        ],
      ),
  ],
),
Padding(
                  padding: const EdgeInsets.only(top: 10, left: 140),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {


                              final teamname = _teamName.text;
                              final agentname = _agentFName.text;
                              final agentlnane = _agentLName.text;
                              final agentphone = _agentPhone.text;
                              final agentemail = _agentEmail.text;

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
                              Uri.parse("$ipaddress/teamreg/"),
                                    );
                              final formData = <String, List<String>>{
                                'teamName':[],
                                'NameAgent':[],
                                'LnameAgent':[],
                                'teamPhoneA':[],
                                'teamEmailA':[],
                                'tnmID':[],
                                'uniID':[],
                                'playerFName':[],
                                'playerLName':[],
                                'playerGender':[],
                                'playerBirthday':[],
                                'facultyID':[],
                                'playerPhone':[],
                                'playerEmail':[],
                                'playerIDCard':[]
                              };

                              request.files.add(await http.MultipartFile.fromPath('teamPic',_teamimage?.path ??'default/path/to/image.png'));
                              //team
                              
                              formData['teamName']?.add(teamname);
                              formData['NameAgent']?.add(agentname);
                              formData['LnameAgent']?.add(agentlnane);
                              formData['teamPhoneA']?.add(agentphone);
                              formData['teamEmailA']?.add(agentemail);
                              formData['tnmID']?.add(tnmID.toString());
                              formData['uniID']?.add(selectuni[0].toString());
                              
                              for(int i=0;i< totalplayer;i++){

                              for(int j=0;j< selectplayerFile[i].length;j++){
                              request.files.add(await http.MultipartFile.fromPath('playerFile${i+1}',selectplayerFile[i][j].path));
                              }

                              //player
                              final playername = _playerFName[i].text;
                              final playerlname = _playerLName[i].text;
                              final playerphone = _playerPhone[i].text;
                              final playeremail = _playerEmail[i].text;
                              final bdate = dateInput[i].text;
                              final playercard = _playerIDCard[i].text;
                              final playergender = _playerGender[i]??'';
                              final faculty = selectfac[i]??'';
                              formData['playerFName']?.add(playername);
                              formData['playerLName']?.add(playerlname);
                              formData['playerGender']?.add(playergender);
                              formData['facultyID']?.add(faculty);
                              formData['playerBirthday']?.add(bdate);
                              formData['playerPhone']?.add(playerphone);
                              formData['playerEmail']?.add(playeremail);
                              formData['playerIDCard']?.add(playercard);

                              
                              }

                              for (final entry in formData.entries) {
                                request.fields[entry.key] = entry.value.join(',');
                              }


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

                           postBody();




                          if(_teamName.text.length == 0){
                             showAlert(context, 'แจ้งเตือน', 'กรุณาใส่ชื่อทีม');
                          }else if(_agentFName.text.length == 0){
                            showAlert(context, 'แจ้งเตือน', 'กรุณาใส่ชื่อตัวแทน');
                          }else if(_agentLName.text.length == 0){
                            showAlert(context, 'แจ้งเตือน', 'กรุณาใส่นามสกุลตัวแทน');
                          }else if(_agentPhone.text.length == 0){
                            showAlert(context, 'แจ้งเตือน', 'กรุณาใส่เบอร์โทรศัพท์ตัวแทน');
                          }else if(_agentEmail.text.length == 0 || !agentemail.contains('@') ){
                            showAlert(context, 'แจ้งเตือน', 'รูปแบบอีเมลตัวแทนไม่ถูกต้อง');
                          }else if(_teamimage == null){
                            showAlert(context, 'แจ้งเตือน', 'กรุณาเลือกรูปทีม');
                          }else{
                          bool checkperplay = true;
                          for(var x =0;x<totalplayer;x++){
                            if(checkperplay == true){
                          if(_playerFName[x].text.length == 0){
                            showAlert(context, 'แจ้งเตือน', 'กรุณากรอกชื่อผู้เล่นคนที่ ${x+1}');
                            checkperplay = false;
                          }else if(_playerLName[x].text.length == 0){
                            showAlert(context, 'แจ้งเตือน', 'กรุณากรอกนามสกุลผู้เล่นคนที่ ${x+1}');
                            checkperplay = false;
                          }else if(_playerPhone[x].text.length == 0 || _playerPhone[x].text.length < 10){
                            showAlert(context, 'แจ้งเตือน', 'เบอร์โทรผู้เล่นคนที่ ${x+1} ไม่ถูกต้อง');
                            checkperplay = false;
                          }else if(_playerEmail[x].text.length == 0){
                            showAlert(context, 'แจ้งเตือน', 'กรุณากรอกอีเมลผู้เล่นคนที่ ${x+1}');
                            checkperplay = false;
                          }else if(_playerGender[x] == null){
                            showAlert(context, 'แจ้งเตือน', 'กรุณาเลือกเพศผู้เล่นคนที่ ${x+1}');
                            checkperplay = false;
                          }else if(selectfac[x] == null){
                            showAlert(context, 'แจ้งเตือน', 'กรุณาเลือกคณะผู้เล่นคนที่ ${x+1}');
                            checkperplay = false;
                          }else if(dateInput[x].text.length == 0){
                            showAlert(context, 'แจ้งเตือน', 'กรุณาเลือกวันเกิดผู้เล่นคนที่ ${x+1}');
                            checkperplay = false;
                          }else if(_playerIDCard[x].text.length == 0 || _playerIDCard[x].text.length < 13 ){
                            showAlert(context, 'แจ้งเตือน', 'รหัสบัตรชาชนผู้เล่นคนที่ ${x+1} ไม่ถูกต้อง');
                            checkperplay = false;
                          }else if(fileaname[x] == '' && filebname[x] == '' && filecname[x] == ''){
                            showAlert(context, 'แจ้งเตือน', 'กรุณาอัพโหลดไฟล์เล่นคนที่ ${x+1} อย่างน้อย 1 ไฟล์');
                            checkperplay = false;
                          }else if(x+1 == totalplayer){
                            postBody();
                          }
                            }
                          }
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
    );
  }
}
