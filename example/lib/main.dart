import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_umeng_analytics_sdk/flutter_umeng_analytics_sdk.dart';

void main() {
  initUmeng();
  runApp(MyApp());
}

void initUmeng() async {
  String appKey = "";
  // 测试 appKey
  if (Platform.isAndroid) {
    appKey = '5d031a284ca357e055000367';
  } else if (Platform.isIOS) {
    appKey = '5d031a483fc1959fb3001069';
  }

  print(appKey);
  await FlutterUmengAnalyticsSdk.initAnalyticsSdk(
    appKey: appKey,
    channel: 'default',
    encryptEnabled: true,
    crashReportEnabled: true,
    logEnabled: true,
  );
  await FlutterUmengAnalyticsSdk.setLocation(latitude: 23.0, longitude: 116.33);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _mac = "Unknow";
  String _umid = 'Unknow';
  bool _isJailbroken;
  bool _isPirated;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String mac;
    String umid;
    bool isJailbroken;
    bool isPirated;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterUmengAnalyticsSdk.deviceIDForIntegration;
      mac = await FlutterUmengAnalyticsSdk.macAddress;
      print('$platformVersion $mac');
      umid = await FlutterUmengAnalyticsSdk.umid;
      isJailbroken = await FlutterUmengAnalyticsSdk.isJailbroken;
      isPirated = await FlutterUmengAnalyticsSdk.isPirated;
    } on PlatformException {}

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _mac = mac;
      _umid = umid;
      _isJailbroken = isJailbroken;
      _isPirated = isPirated;
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
              Text('deviceID: $_platformVersion'),
              Text('Mac: $_mac'),
              Text('UMID: $_umid'),
              Text('isJailbroken: $_isJailbroken'),
              Text('isPirated: $_isPirated'),
              FlatButton(
                child: Text('进入页面10秒'),
                onPressed: () {
                  FlutterUmengAnalyticsSdk.logPageView(pageName: 'test', seconds: 10);
                },
              ),
              FlatButton(
                child: Text('进入页面'),
                onPressed: () {
                  FlutterUmengAnalyticsSdk.beginLogPageView(pageName: 'test2');
                },
              ),
              FlatButton(
                child: Text('退出页面'),
                onPressed: () {
                  FlutterUmengAnalyticsSdk.endLogPageView(pageName: 'test2');
                },
              ),
              FlatButton(
                child: Text('自定义事件'),
                onPressed: () {
                  FlutterUmengAnalyticsSdk.event(eventId: 'test');
                },
              ),
            ],
          )),
    );
  }
}
