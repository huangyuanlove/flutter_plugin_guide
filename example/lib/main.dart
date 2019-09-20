import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter_plugin_open_native/flutter_plugin_open_native.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterPluginOpenNative.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Text('Running on: $_platformVersion\n'),
            RaisedButton(
              onPressed: () {
                FlutterPluginOpenNative.openNative("https://blog.huangyuanlove.com");
              },
              child: Text("打开网页"),
            ),
            Container(
              color: Colors.amberAccent,
              width: 300.0,
              height: 300.0,
              child: AndroidTextView(
                onTextViewCreated: _onTextViewCreated,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTextViewCreated(TextViewController controller) {

    controller.setText('Hello from ${Platform.isAndroid ?"Android":"iOS"}');
  }
}
