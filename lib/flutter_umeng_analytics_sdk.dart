import 'dart:async';
import 'dart:core';

import 'package:flutter/services.dart';

class FlutterUmengAnalyticsSdk {
  static const MethodChannel _channel = const MethodChannel('flutter_umeng_analytics_sdk');

  /// 获取 SDK 版本
  static Future<String> get sdkVersion async {
    final String version = await _channel.invokeMethod('getSdkVersion');
    return version;
  }

  /// 初始化 SDK
  /// `appKey` 在平台申请的 appKey
  static Future<void> initAnalyticsSdk({
    String appKey,
    String channel,
    bool encryptEnabled,
    bool crashReportEnabled,
    bool logEnabled,
  }) async {
    var params = {
      'appKey': appKey,
      'channel': channel,
      'encryptEnabled': encryptEnabled,
      'crashReportEnabled': crashReportEnabled,
      'logEnabled': logEnabled,
    };
    print(params);
    await _channel.invokeMethod('initAnalyticsSdk', params);
  }

  /// 设置经纬度信息
  /// `latitude` 纬度.
  /// `longitude` 经度.
  static Future<void> setLocation({
    latitude: double,
    longitude: double,
  }) async {
    await _channel.invokeMethod('setLocation', {
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  /// 获取 UMID
  static Future<String> get umid async {
    final String umidString = await _channel.invokeMethod('getUmid');
    return umidString;
  }

  /// 获取集成测试需要的 DeviceID
  static Future<String> get deviceIDForIntegration async {
    final String deviceID = await _channel.invokeMethod('getDeviceIDForIntegration');
    return deviceID;
  }

  /// 判断设备是否越狱，依据是否存在 apt 和 Cydia.app
  /// 仅 iOS, Android 永远返回 false
  static Future<bool> get isJailbroken async {
    final bool result = await _channel.invokeMethod('isJailbroken');
    return result;
  }

  /// 判断 App 是否被破解
  /// 仅 iOS, Android 永远返回 false
  static Future<bool> get isPirated async {
    final bool result = await _channel.invokeMethod('isPirated');
    return result;
  }

  // ---------------------------------------------------------------------------------------
  //  页面计时
  // ---------------------------------------------------------------------------------------

  /// 手动页面时长统计, 记录某个页面展示的时长.
  /// `pageName` 统计的页面名称.
  /// `seconds` 单位为秒，int型.
  static Future<void> logPageView({
    pageName: String,
    seconds: int,
  }) async {
    await _channel.invokeMethod('logPageView', {
      'pageName': pageName,
      'seconds': seconds,
    });
  }

  /// 自动页面时长统计, 开始记录某个页面展示时长.
  /// 使用方法：必须配对调用beginLogPageView 和 endLogPageView 两个函数来完成自动统计，若只调用某一个函数不会生成有效数据。
  /// 在该页面展示时调用 beginLogPageView ，当退出该页面时调用 endLogPageView 。
  /// `pageName` 统计的页面名称.
  static Future<void> beginLogPageView({
    pageName: String,
  }) async {
    await _channel.invokeMethod('beginLogPageView', {
      'pageName': pageName,
    });
  }

  /// 自动页面时长统计, 结束记录某个页面展示时长.
  /// 使用方法：必须配对调用 beginLogPageView 和 endLogPageView 两个函数来完成自动统计，若只调用某一个函数不会生成有效数据。
  /// 在该页面展示时调用 beginLogPageView ，当退出该页面时调用 endLogPageView
  /// `pageName` 统计的页面名称.
  static Future<void> endLogPageView({
    pageName: String,
  }) async {
    await _channel.invokeMethod('endLogPageView', {
      'pageName': pageName,
    });
  }

// ---------------------------------------------------------------------------------------
//  事件统计
// ---------------------------------------------------------------------------------------

  /// 自定义事件,数量统计.
  /// 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
  /// `eventId` 网站上注册的事件Id.
  /// `label` 分类标签。不同的标签会分别进行统计，方便同一事件的不同标签的对比,为nil或空字符串时后台会生成和 eventId 同名的标签.
  /// `counter` 累加值。为减少网络交互，可以自行对某一事件ID的某一分类标签进行累加，再传入次数作为参数。
  ///  警告：
  ///   1. 每个 event 的 attributes 不能超过 10 个
  ///   2. eventId、attributes 中 key 和 value 都不能使用空格和特殊字符，必须是 String ,且长度不能超过255个字符（否则将截取前255个字符）
  ///   3. id， ts， du 是保留字段，不能作为 eventId 及 key 的名称
  static Future<void> event({
    eventId: String,
    label: String,
    attributes: dynamic,
    counter: int,
  }) async {
    await _channel.invokeMethod('event', {
      'eventId': eventId,
      'label': label,
      'attributes': attributes,
      'counter': counter,
    });
  }

  /// 自定义事件,开始时长统计.
  /// 使用前，请先到友盟 App 管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件 ID .
  /// beginEvent , endEvent 要配对使用,也可以自己计时后通过 durations 参数传递进来
  static Future<void> beginEvent({
    eventId: String,
    label: String,
    attributes: dynamic,
  }) async {
    await _channel.invokeMethod('beginEvent', {
      'eventId': eventId,
      'label': label,
      'attributes': attributes,
    });
  }

  /// 自定义事件,结束时长统计.
  /// 使用前，请先到友盟 App 管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件 ID .
  /// beginEvent , endEvent 要配对使用,也可以自己计时后通过 durations 参数传递进来
  static Future<void> endEvent({
    eventId: String,
    label: String,
    attributes: dynamic,
  }) async {
    await _channel.invokeMethod('endEvent', {
      'eventId': eventId,
      'label': label,
      'attributes': attributes,
    });
  }

  /// 自定义事件，自己计时，需要传毫秒进来
  /// 使用前，请先到友盟 App 管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件 ID .
  static Future<void> eventDurations({
    eventId: String,
    millisecond: int,
    label: String,
    attributes: dynamic,
  }) async {
    await _channel.invokeMethod('eventDurations', {
      'eventId': eventId,
      'millisecond': millisecond,
      'label': label,
      'attributes': attributes,
    });
  }

// ---------------------------------------------------------------------------------------
//  用户相关
// ---------------------------------------------------------------------------------------

  /// 开始 PUID 统计，如果想要结束该 PUID 的统计，需要调用 profileSignOff 函数
  /// `puid` 用户 ID
  /// `provider`  账户提供者 : 不能以下划线 "_" 开头，使用大写字母和数字标识; 如果是上市公司，建议使用股票代码。
  static Future<void> profileSignIn({
    puid: String,
    provider: String,
  }) async {
    await _channel.invokeMethod('profileSignIn', {
      'puid': puid,
      'provider': provider,
    });
  }

  /// 停止对 PUID 的统计
  static Future<void> profileSignOff() async {
    await _channel.invokeMethod('profileSignIn');
  }
}
