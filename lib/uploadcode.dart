import 'package:flutter/material.dart';

class CodeUpload extends StatefulWidget {
  @override
  _CodeUploadState createState() => _CodeUploadState();
}

class _CodeUploadState extends State<CodeUpload> {
  final _key = GlobalKey<FormState>();
  final oddsControl = TextEditingController();
  final betcodeControl = TextEditingController();
  int initialbetType = 0;
  final List<BetCodeType> listbetType = [
    BetCodeType('general', 1),
    BetCodeType('specific', 2)
  ];
  String betType = '';
  final List<String> betCompany = [
    'Select Platform',
    'Bet9ja',
    'SportyBet',
    'NairaBet',
  ];
  String selectbetCompany = 'Select Platform';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
        ),
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
  }
}

class BetCodeType {
  String type;
  int index;
  BetCodeType(this.type, this.index);
}
