import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CodeUpload extends StatefulWidget {
  @override
  _CodeUploadState createState() => _CodeUploadState();
}

class _CodeUploadState extends State<CodeUpload> {
  var getComp;
  final _key = GlobalKey<FormState>();
  final oddsControl = TextEditingController();
  final betcodeControl = TextEditingController();
  int initialbetType = 0;
  final List<BetCodeType> listbetType = [
    BetCodeType('General', 1),
    BetCodeType('Specific', 2)
  ];
  String betType = '';
  final List<String> betCompany = [
    'Select Platform',
    'Bet9ja',
    'SportyBet',
    'NairaBet',
    'OnexBet'
  ];
  String selectbetCompany = 'Select Platform';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComp = getCompanies();
  }

  getCompanies() async {
    String link = 'https://betslipcode.herokuapp.com/get/company';
    try {
      var getList = await http.get(link);
      if (getList.statusCode == 200) {
        var decode = jsonDecode(getList.body);
        print(decode);
      }
    } catch (e) {}
  }

  _retry (){
    setState(() {
      getComp = getCompanies();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double padding28 = size.height * 0.0350;
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(),
      ),
    );
  }

  upload() async {
    Map uploadData = {
      "betCompany": selectbetCompany,
      "submitter": "test agent",
      "type": betType,
      "slipcode": betcodeControl.text,
      "odds": oddsControl.text
    };
    print(uploadData);
    return showDialog(
        context: context,
        builder: (context) => FutureBuilder(
              future: uploadFuture(uploadData),
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

  uploadFuture(Map data) async {
    var encode = jsonEncode(data);
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        initialbetType = 0;
        betType = '';
        betcodeControl.text = '';
        oddsControl.text = '';
      });
    });
  }
  form (){
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
                TextFormField(
                  controller: betcodeControl,
                  validator: (text) {
                    if (text.length == 0) {
                      return 'Please insert bet code';
                    }
                  },
                  decoration: InputDecoration(labelText: 'Bet Code'),
                ),
                TextFormField(
                    controller: oddsControl,
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
                Container(
                  child: Column(
                    children: listbetType.map((item) {
                      return RadioListTile(
                        groupValue: initialbetType,
                        value: item.index,
                        title: Text('${item.type}'),
                        onChanged: (value) {
                          setState(() {
                            initialbetType = item.index;
                            betType = item.type;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                RaisedButton(
                  child: Text('Upload'),
                  onPressed: () {
                    var finalKey = _key.currentState;
                    if (finalKey.validate()) {
                      if (selectbetCompany == 'Select Platform') {
                        setState(() {
                          // change color
                        });
                      } else if (initialbetType == 0) {
                        setState(() {
                          // change color
                        });
                      } else {
                        finalKey.save();
                        upload();
                      }
                    }
                  },
                )
              ],
            ),
          ),
        );
  }
}

class BetCodeType {
  String type;
  int index;
  BetCodeType(this.type, this.index);
}
