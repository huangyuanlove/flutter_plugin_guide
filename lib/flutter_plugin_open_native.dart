import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
class FlutterPluginOpenNative {
  static const MethodChannel _channel =
      const MethodChannel('flutter_plugin_open_native');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void>  openNative(String url) async {
    await _channel.invokeMethod('openOSView',url);
  }
}


typedef void TextViewCreatedCallback(TextViewController controller);
class TextViewController {
  TextViewController._(int id)
      : _channel = new MethodChannel('me.chunyu.textview/textview');

  final MethodChannel _channel;

  Future<void> setText(String text) async {
    assert(text != null);
    return _channel.invokeMethod('setText', text);
  }
}

class AndroidTextView extends StatefulWidget {

  final TextViewCreatedCallback onTextViewCreated;
  const AndroidTextView({
    Key key,
    this.onTextViewCreated,
  }) : super(key: key);

  @override
  _AndroidTextViewState createState() => _AndroidTextViewState();
}

class _AndroidTextViewState extends State<AndroidTextView> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'me.chunyu.textview/textview',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }else if (defaultTargetPlatform == TargetPlatform.iOS){
      return UiKitView(
        viewType: 'me.chunyu.textview/textview',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the text_view plugin');

  }
  void _onPlatformViewCreated(int id) {
    if (widget.onTextViewCreated == null) {
      return;
    }
    print("id _onPlatformViewCreated :--> $id");


    widget.onTextViewCreated(new TextViewController._(id));
  }
}