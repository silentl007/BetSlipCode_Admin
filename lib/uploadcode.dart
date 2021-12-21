import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_picker/date_time_picker.dart';

class CodeUpload extends StatefulWidget {
  final String agent;
  CodeUpload(this.agent);
  @override
  _CodeUploadState createState() => _CodeUploadState();
}

class _CodeUploadState extends State<CodeUpload> {
  var getComp;
  // var notifi;
  // var upcode;
  final _key = GlobalKey<FormState>();
  final oddsControl = TextEditingController();
  final betcodeControl = TextEditingController();
  final timeControl = TextEditingController();
  final dateControl = TextEditingController();
  int initialbetType = 0;
  final List<BetCodeType> listbetType = [
    BetCodeType('General', 1),
    BetCodeType('Specific', 2)
  ];
  String betType = '';
  List<String> betCompany = [];
  List<String> sports = [];
  String selectbetCompany = 'Select Platform';
  String selectSports = 'Select Sports';
  DateTime now = new DateTime.now();
  @override
  void initState() {
    super.initState();
    getComp = getCompanies();
    // notifi = notify();
    // upcode = uploadFuture();
  }

  getCompanies() async {
    String link = 'https://betslipcode.herokuapp.com/get/company';
    try {
      var getList = await http.get(link);
      if (getList.statusCode == 200) {
        var decode = jsonDecode(getList.body);
        decode[0]['company'].forEach((string) => betCompany.add(string));
        decode[0]['sports'].forEach((string) => sports.add(string));
        betCompany.insert(0, 'Select Platform');
        sports.insert(0, 'Select Sports');
        return betCompany;
      }
    } catch (e) {
      print(e);
    }
  }

  _retry() {
    setState(() {
      getComp = getCompanies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: getComp,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: CircularProgressIndicator(
                  value: 3,
                ),
              );
            } else if (snapshot.hasData) {
              return form();
            } else {
              return Center(
                child: ElevatedButton(
                  child: Text('Retry'),
                  onPressed: () {
                    _retry();
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }

  form() {
    return Form(
      key: _key,
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: DropdownButton<String>(
                value: selectbetCompany,
                items: betCompany.map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem(
                    child: Text(item),
                    value: item,
                  );
                }).toList(),
                onChanged: (text) {
                  setState(() {
                    selectbetCompany = text;
                  });
                },
              ),
            ),
            Container(
              child: DropdownButton<String>(
                value: selectSports,
                items: sports.map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem(
                    child: Text(item),
                    value: item,
                  );
                }).toList(),
                onChanged: (text) {
                  setState(() {
                    selectSports = text;
                  });
                },
              ),
            ),
            TextFormField(
              controller: betcodeControl,
              // ignore: missing_return
              validator: (text) {
                if (text.length == 0) {
                  return 'Please insert bet code';
                }
              },
              decoration: InputDecoration(labelText: 'Bet Code'),
            ),
            TextFormField(
                controller: oddsControl,
                textCapitalization: TextCapitalization.characters,
                // ignore: missing_return
                validator: (text) {
                  if (text.length == 0) {
                    return 'Please insert bet odds';
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Bet Odds')),
            SizedBox(
              height: 5,
            ),
            DateTimePicker(
              controller: timeControl,
              type: DateTimePickerType.time,
              timeLabelText: 'Earliest Game Time',
              // ignore: missing_return
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please fill this entry';
                }
              },
            ),
            Divider(),
            DateTimePicker(
              controller: dateControl,
              firstDate: DateTime(now.year, now.month, now.day),
              lastDate: DateTime(2300),
              type: DateTimePickerType.date,
              dateLabelText: 'Earliest Date Time',
              // ignore: missing_return
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please fill this entry';
                }
              },
            ),
            Divider(),
            ElevatedButton(
              child: Text('Upload'),
              onPressed: () {
                var finalKey = _key.currentState;
                if (finalKey.validate()) {
                  if (selectbetCompany == 'Select Platform') {
                    setState(() {
                      // change color
                    });
                  } else if (selectSports == 'Select Sports') {
                    setState(() {});
                  } else {
                    finalKey.save();
                    upload();
                  }
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            widget.agent == 'Gangster Baby'
                ? ElevatedButton(
                    onPressed: () {
                      notifyDiag();
                    },
                    child: Text('Notify'))
                : Container()
          ],
        ),
      ),
    );
  }

  notify() async {
    print('------------------ ia am called');
    var link = Uri.parse('https://fcm.googleapis.com/fcm/send');
    Map<String, dynamic> body = {
      'notification': <String, dynamic>{
        'body': "Hello CodeRealmer! Today's codes are currently available",
      },
      'priority': 'high',
      'to': '/topics/coderealm',
    };
    var encodeData = jsonEncode(body);
    try {
      var sendNotif = await http.post(link, body: encodeData, headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'key=AAAAvLZo-Hk:APA91bEssqW19374tIKtY1YwRVGqG2r4Gl726hcD6SN212YmWavQy4wQPzCMWr_SLBDpoj2DbXKA6eCIyVfMu0I-qGKjwBpjf0oRNJkLjpDdCO8OW8BQ_0Bq9WVd_yCxRJQhgQFMzxN7'
      });
      return sendNotif.statusCode;
    } catch (e) {
      print('------------ FCM Error $e -----------------');
      return null;
    }
  }

  notifyDiag() async {
    return showDialog(
        context: context,
        builder: (context) => FutureBuilder(
              future: notify(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Container(
                    color: Colors.transparent,
                    child: AlertDialog(
                      content: LinearProgressIndicator(
                        backgroundColor: Colors.white,
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ),
                  );
                } else {
                  return AlertDialog(
                    content: snapshot.data == 200
                        ? Text('Users notified!')
                        : Text('Something went wrong check console!'),
                  );
                }
              },
            ));
  }

  upload() async {
    return showDialog(
        context: context,
        builder: (context) => FutureBuilder(
              future: uploadFuture(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Container(
                    color: Colors.transparent,
                    child: AlertDialog(
                      content: LinearProgressIndicator(
                        backgroundColor: Colors.white,
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ),
                  );
                } else {
                  return AlertDialog(
                    content: snapshot.data == 200
                        ? Text('Upload Successful')
                        : snapshot.data == 500
                            ? Text('Betcode already added')
                            : Text('Network Error!'),
                  );
                }
              },
            ));
  }

  uploadFuture() async {
    Map uploadData = {
      "betCompany": selectbetCompany,
      "submitter": widget.agent ?? "test agent",
      "type": betType,
      "slipcode": betcodeControl.text,
      "odds": oddsControl.text,
      "sport": selectSports,
      "start": timeControl.text,
      "startdate": dateControl.text
    };
    var encode = jsonEncode(uploadData);
    String link = 'https://betslipcode.herokuapp.com/post/code';
    try {
      var post = await http.post(link,
          body: encode,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      if (post.statusCode == 200) {
        resetValues();
        return post.statusCode;
      } else {
        return post.statusCode;
      }
    } catch (e) {
      return 400;
    }
  }

  resetValues() {
    var finalKey = _key.currentState;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        initialbetType = 0;
        betType = '';
        finalKey.reset();
        selectbetCompany = 'Select Platform';
        selectSports = 'Select Sports';
      });
    });
  }
}

class BetCodeType {
  String type;
  int index;
  BetCodeType(this.type, this.index);
}
