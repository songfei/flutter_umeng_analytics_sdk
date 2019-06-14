#import "FlutterUmengAnalyticsSdkPlugin.h"
#import <UMCommon/UMCommon.h>
#import <UMCommonLog/UMCommonLogHeaders.h>
#import <UMAnalytics/MobClick.h>


@implementation FlutterUmengAnalyticsSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_umeng_analytics_sdk"
            binaryMessenger:[registrar messenger]];
  FlutterUmengAnalyticsSdkPlugin* instance = [[FlutterUmengAnalyticsSdkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getSdkVersion" isEqualToString:call.method]) {
    [self handleGetSdkVersion:call result:result];
  }
  else if ([@"initAnalyticsSdk" isEqualToString:call.method]) {
    [self handleInitAnalyticsSdk:call result:result];
  }
  else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)handleGetSdkVersion: (FlutterMethodCall*)call result:(FlutterResult)result {
    result(@"iOS 6.6.3");
}

- (void)handleInitAnalyticsSdk:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString* appKey = call.arguments[@"appKey"];
    if(!appKey || [appKey length] == 0) {
        return;
    }
    
    NSString* channel = call.arguments[@"channel"];
    if(!channel || [channel length] == 0) {
        channel = @"default";
    }
    
    BOOL encryptEnabled = false;
    NSNumber* encryptEnabledObj = call.arguments[@"encryptEnabled"];
    if(encryptEnabledObj && ![encryptEnabledObj isKindOfClass:[NSNull class]]) {
        encryptEnabled = [encryptEnabledObj boolValue];
    }
    
    BOOL crashReportEnabled = true;
    NSNumber* crashReportEnabledObj = call.arguments[@"crashReportEnabled"];
    if(crashReportEnabledObj && ![crashReportEnabledObj isKindOfClass:[NSNull class]]) {
        crashReportEnabled = [crashReportEnabledObj boolValue];
    }
    
    BOOL logEnabled = false;
    NSNumber* logEnabledObj = call.arguments[@"logEnabled"];
    if(logEnabledObj && ![logEnabledObj isKindOfClass:[NSNull class]]) {
        logEnabled = [logEnabledObj boolValue];
    }
    
    [MobClick setCrashReportEnabled:crashReportEnabled];

    [UMConfigure setEncryptEnabled:encryptEnabled];
    
    [UMConfigure setLogEnabled:logEnabled];
    if(logEnabled) {
        [UMCommonLogManager setUpUMCommonLogManager];
    }
    
    [UMConfigure initWithAppkey:appKey channel:channel];
    
}

@end
