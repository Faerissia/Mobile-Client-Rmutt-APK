import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/tournament/detailsport.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/config/ipconfig.dart';

class otp extends StatefulWidget {
  
final String responseData;
  const otp({Key? key, required this.responseData}) : super(key: key);

  @override
  State<otp> createState() => _otpState();
}


Future<void> alerterror(BuildContext context, String title, String message) async{
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
                                        child: Text('ตกลง'),
                                      ),
                                    ],
                                  );
                                });
                            }


class _otpState extends State<otp> {


  bool _isButtonDisabled = false;
int _remainingTime = 0;
Timer? _timer;

postSingle( ) async {
                              try{
                            var request = http.MultipartRequest(
                              'POST',
                              Uri.parse("$ipaddress/otpagain/"),
                                    );

                              request.fields['tnmID'] = jsonData["tnmID"];
                              request.fields['Email'] = jsonData["playerEmail"];
                              request.fields['OTP'] = jsonData["OTP"].toString();

                              var response = await request.send();

                              if(response.statusCode == 200){
                                print('File upload success');
                                var responseData = await http.Response.fromStream(response);
                                print(responseData.body);

                                alerterror(context, 'แจ้งเตือน', 'ส่ง OTP ไปที่อีเมลแล้ว!');
                                
                                
                              }
                          }catch (e) {
                            print(e);
                          }
                          }

  void _handleButtonPress() {
    if (!_isButtonDisabled) {
      setState(() {
        _isButtonDisabled = true;
        _remainingTime = 30;
      });
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingTime > 0) {
            _remainingTime--;
          } else {
            _isButtonDisabled = false;
            _timer?.cancel();
          }
        });
      });
      // Perform button action here
      print('tsetdt');
    }
  }

  final TextEditingController _pin1 = TextEditingController();
  final TextEditingController _pin2 = TextEditingController();
  final TextEditingController _pin3 = TextEditingController();
  final TextEditingController _pin4 = TextEditingController();

  String combinedpintootp(){
    String pin1 = _pin1.text;
    String pin2 = _pin2.text;
    String pin3 = _pin3.text;
    String pin4 = _pin4.text;
    String combined = '$pin1$pin2$pin3$pin4';
    return combined;
  }

  late Map<String, dynamic> jsonData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    jsonData = json.decode(widget.responseData);
  }

  @override
  Widget build(BuildContext context) {

    

    var widthIB = MediaQuery.of(context).size.width * 0.15;

    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 3, 42, 121),
          title: Text(
            "รหัสยืนยันการสมัคร",
          ),
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.25,
                //color: Colors.grey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        "ส่งรหัสยืนยันการสมัครไปยังอีเมล : ${jsonData["playerEmail"]}", //รับตัวแปรอีเมลเข้ามาใส่
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                //color: Colors.red[400],
                height: MediaQuery.of(context).size.height * 0.45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      //color: Colors.amber[400],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: widthIB,
                                child: Expanded(
                                  child: TextFormField(
                                    onChanged: (value) {
                                      if(value.length == 1){
                                        FocusScope.of(context).nextFocus();
                                      }
                                    },
                                    onSaved: (pin1) {

                                      
                                    },
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.headline6,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder()),
                                        controller: _pin1,
                                  ),
                                ),
                              )
                            ],
                          ),
                          
                          Column(
                            children: [
                              Container(
                                width: widthIB,
                                child: Expanded(
                                  child: TextFormField(
                                    onChanged: (value) {
                                      if(value.length == 1){
                                        FocusScope.of(context).nextFocus();
                                      }
                                    },
                                    onSaved: (pin2) {
                                      
                                    },
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.headline6,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder()),
                                        controller: _pin2,
                                  ),
                                ),
                              )
                            ],
                          ),
                          
                          Column(
                            children: [
                              Container(
                                width: widthIB,
                                child: Expanded(
                                  child: TextFormField(
                                    onChanged: (value) {
                                      if(value.length == 1){
                                        FocusScope.of(context).nextFocus();
                                      }
                                    },
                                    onSaved: (pin3) {
                                      
                                    },
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.headline6,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder()),
                                        controller: _pin3,
                                  ),
                                ),
                              )
                            ],
                          ),
                          
                          Column(
                            children: [
                              Container(
                                width: widthIB,
                                child: Expanded(
                                  child: TextFormField(
                                    onChanged: (value) {
                                      if(value.length == 1){
                                        FocusScope.of(context).nextFocus();
                                      }
                                    },
                                    onSaved: (pin4) {
                                      
                                      
                                    },
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.headline6,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder()),
                                        controller: _pin4,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(padding:EdgeInsets.only(top: 20),
                    child: Center(
                  child: _isButtonDisabled
                ? Text('ส่งได้อีกครั้งภายใน $_remainingTime วินาที')
                : SizedBox.shrink(),
                ),
                ),
                    Padding(
                      padding: EdgeInsets.only(top: 70),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          
                          ElevatedButton(
                            onPressed:_isButtonDisabled ? null : _handleButtonPress,
                            child: Text('ส่งอีกครั้ง',
                                    style: TextStyle(fontSize: 15),
                            ),
                            style: ElevatedButton.styleFrom(
                            backgroundColor: _isButtonDisabled ? Colors.grey : Colors.orange,
                            ),
                          ),
                          SizedBox(width: 10,),
                          ElevatedButton(
                            onPressed: () {

                              int tnmID = int.parse(jsonData["tnmID"]);

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

                                        Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => detailsport(tnmID: tnmID)))
                                  .then((_) => Navigator.of(context).popUntil((route) => route.isFirst));
                                        
                                        },
                                        child: Text('ตกลง'),
                                      ),
                                    ],
                                  );
                                });
                            }

                              String fronOTP = combinedpintootp();

                              

                              postSingle( ) async {
                              try{
                            var request = http.MultipartRequest(
                              'POST',
                              Uri.parse("$ipaddress/verifysingle/"),
                                    );

                              request.fields['playerFName'] = jsonData["playerFName"];
                              request.fields['playerLName'] = jsonData["playerLName"];
                              request.fields['playerGender'] = jsonData["playerGender"];
                              request.fields['playerBirthday'] = jsonData["playerBirthday"];
                              request.fields['playerPhone'] = jsonData["playerPhone"];
                              request.fields['playerEmail'] = jsonData["playerEmail"];
                              request.fields['facultyID'] = jsonData["facultyID"];
                              request.fields['playerIDCard'] = jsonData["playerIDCard"];
                              request.fields['tnmID'] = jsonData["tnmID"];
                              request.fields['playerFile1'] = jsonData["playerFile1"];
                              request.fields['OTP'] = jsonData["OTP"].toString();
                              request.fields['submitOTP'] = fronOTP;

                              var response = await request.send();

                              if(response.statusCode == 200){
                                print('File upload success');
                                var responseData = await http.Response.fromStream(response);
                                print(responseData.body);

                                showAlert(context, 'แจ้งเตือน', 'สมัครเข้าร่วมเสร็จสิ้น');
                                
                                
                              }
                          }catch (e) {
                            print(e);
                          }
                          }

                          if(fronOTP == jsonData["OTP"].toString() ){
                            postSingle();
                          }else{
                            alerterror(context,'แจ้งเตือน','รหัส OTP ไม่ถูกต้อง');

                          }


                          
                            },
                            child: Text("ยืนยัน",
                                    style: TextStyle(fontSize: 15),
                            ),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

                          