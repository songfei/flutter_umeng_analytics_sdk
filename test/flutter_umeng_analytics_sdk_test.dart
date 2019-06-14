import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_umeng_analytics_sdk/flutter_umeng_analytics_sdk.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_umeng_analytics_sdk');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterUmengAnalyticsSdk.sdkVersion, '42');
  });
}
