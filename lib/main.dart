import 'dart:async';

import 'package:flutter/material.dart';
import 'package:phishtesterflutter/controller/mainController.dart';
import 'package:phishtesterflutter/widgets/customDialog.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

/*
* Phish: http://united-bank-africa.com
* Not a phish: http://google.com
* Unknown: https://optusnet-upgrade.weebly.com/
* exk54411@eoopy.com 1qazxsw23edc
*/

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phishing Link Tester',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Phishing Link Tester'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _urlText = TextEditingController();
  FocusNode _urlFocus = FocusNode();
  String _result = 'Enter a URL to check if it is valid';
  Color _resultColor = Colors.black;

  StreamSubscription _intentDataStreamSubscription;

  void _submit() async {
    if (_urlText.text.isEmpty) {
      msgDialog(context, 'Error', 'Please enter a URL');
      return;
    }

    if(!_urlText.text.startsWith('http://') && !_urlText.text.startsWith('https://')) {
      setState(() {
        _urlText.text = 'http://' + _urlText.text;
      });
    }

    bool _validURL = Uri.parse(_urlText.text).isAbsolute;
    if(!_validURL) {
      msgDialog(context, 'Error', 'Please enter a valid URL!');
      return;
    }


    FocusScope.of(context).unfocus();
    var data = await checkUrl(context: context, url: _urlText.value.text);
    print(data);

    if(!data['results']['in_database']) {
      setState(() {
        _result = 'Status Unknown';
        _resultColor = Colors.grey;
      });
      return;
    }

    if(data['results']['verified']) {
      if (data['results']['valid'])
        setState(() {
          _result = 'This site is a phish';
          _resultColor = Colors.red;
        });
      else
        setState(() {
          _result = 'This site is not a phishing site.';
          _resultColor = Colors.green;
        });
    } else
      setState(() {
        _result = 'Status Unknown';
        _resultColor = Colors.grey;
      });

//    if (data['results']['verified'] && data['results']['valid'])
//      setState(() {
//        _result = 'This site is a phish';
//        _resultColor = Colors.red;
//      });
//    else if (data['results']['verified'] && !data['results']['valid'])
//      setState(() {
//        _result = 'This site is not a phishing site.';
//        _resultColor = Colors.green;
//      });
//    else
//      setState(() {
//        _result = 'Status Unknown';
//        _resultColor = Colors.grey;
//      });
  }

  @override
  void initState() {
    super.initState();

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      setState(() {
        _urlText.text = value;
      });
      if(_urlText.text.isNotEmpty) {
        print('hello stef');
        _submit();
      }
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String value) {
      setState(() {
        _urlText.text = value;
      });
      if(_urlText.text.isNotEmpty) {
        print('hello stef');
        _submit();
      }
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    _urlFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder tffBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Color(0xFFc2c2c2), width: 2.0),
    );

    OutlineInputBorder tffBorderFocused = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Colors.white, width: 2.0),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _urlText,
              focusNode: _urlFocus,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: Colors.black, fontSize: 18),
              decoration: InputDecoration(
                  labelText: "Enter URL",
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                  focusedBorder: tffBorderFocused,
                  enabledBorder: tffBorder,
                  filled: true),
            ),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: () => _submit(),
              color: Color(0xff006699),
              textColor: Colors.white,
              child: Text('Check URL'),
              minWidth: MediaQuery.of(context).size.width - 15,
              height: 55,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: () {
                setState(() {
                  _result = 'Enter a URL to check if it is valid';
                  _urlText.text = '';
                  _resultColor = Colors.black;
                });
              },
              color: Color(0xff006699),
              textColor: Colors.white,
              child: Text('Reset'),
              minWidth: MediaQuery.of(context).size.width - 15,
              height: 55,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            SizedBox(height: 30),
            Text(
              _result,
              style: TextStyle(
                  color: _resultColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
