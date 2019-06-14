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
  else if ([@"setLocation" isEqualToString:call.method]) {
      [self handleSetLocation:call result:result];
  }
  else if ([@"getUmid" isEqualToString:call.method]) {
      [self handleGetUmid:call result:result];
  }
  else if ([@"getDeviceIDForIntegration" isEqualToString:call.method]) {
      [self handleGetDeviceIDForIntegration:call result:result];
  }
  else if ([@"getIsJailbroken" isEqualToString:call.method]) {
      [self handleGetIsJailbroken:call result:result];
  }
  else if ([@"getIsPirated" isEqualToString:call.method]) {
      [self handleGetIsPirated:call result:result];
  }
  else if ([@"logPageView" isEqualToString:call.method]) {
      [self handleLogPageView:call result:result];
  }
  else if ([@"beginLogPageView" isEqualToString:call.method]) {
      [self handleBeginLogPageView:call result:result];
  }
  else if ([@"endLogPageView" isEqualToString:call.method]) {
      [self handleEndLogPageView:call result:result];
  }
  else if ([@"event" isEqualToString:call.method]) {
      [self handleEvent:call result:result];
  }
  else if ([@"beginEvent" isEqualToString:call.method]) {
      [self handleBeginEvent:call result:result];
  }
  else if ([@"eventDurations" isEqualToString:call.method]) {
      [self handleEventDurations:call result:result];
  }
  else if ([@"profileSignIn" isEqualToString:call.method]) {
      [self handleProfileSignIn:call result:result];
  }
  else if ([@"profileSignIn" isEqualToString:call.method]) {
      [self handleProfileSignIn:call result:result];
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
        result(nil);
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
    
    [MobClick setAutoPageEnabled:NO];
    [MobClick setCrashReportEnabled:crashReportEnabled];

    [UMConfigure setEncryptEnabled:encryptEnabled];
    
    [UMConfigure setLogEnabled:logEnabled];
    if(logEnabled) {
        [UMCommonLogManager setUpUMCommonLogManager];
    }
    
    [UMConfigure initWithAppkey:appKey channel:channel];
    
    result(nil);
}


- (void)handleSetLocation:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    double latitude = 0.0;
    NSNumber* latitudeObj = call.arguments[@"latitude"];
    if(latitudeObj && ![latitudeObj isKindOfClass:[NSNull class]]) {
        latitude = [latitudeObj doubleValue];
    }
    
    double longitude = 0.0;
    NSNumber* longitudeObj = call.arguments[@"longitude"];
    if(longitudeObj && ![longitudeObj isKindOfClass:[NSNull class]]) {
        longitude = [longitudeObj doubleValue];
    }
    
    [MobClick setLatitude:latitude longitude:longitude];
    
    result(nil);
}

- (void)handleGetUmid: (FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* umid = [UMConfigure umidString];
    result(umid);
}

- (void)handleGetDeviceIDForIntegration: (FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* deviceID = [UMConfigure deviceIDForIntegration];
    result(deviceID);
}

- (void)handleGetIsJailbroken: (FlutterMethodCall*)call result:(FlutterResult)result {
    BOOL isJailbroken = [MobClick isJailbroken];
    result([NSNumber numberWithBool:isJailbroken]);
}

- (void)handleGetIsPirated: (FlutterMethodCall*)call result:(FlutterResult)result {
    BOOL isPirated = [MobClick isPirated];
    result([NSNumber numberWithBool:isPirated]);
}

- (void)handleLogPageView:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString* pageName = call.arguments[@"pageName"];
    if(!pageName || [pageName length] == 0) {
        result(nil);
        return;
    }
    
    int seconds = 0;
    NSNumber* secondsObj = call.arguments[@"seconds"];
    if(secondsObj && ![secondsObj isKindOfClass:[NSNull class]]) {
        seconds = [secondsObj intValue];
    }
    
    [MobClick logPageView:pageName seconds:seconds];
    result(nil);
}

- (void)handleBeginLogPageView:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString* pageName = call.arguments[@"pageName"];
    if(!pageName || [pageName length] == 0) {
        result(nil);
        return;
    }
    
    [MobClick beginLogPageView:pageName];
    result(nil);
}

- (void)handleEndLogPageView:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString* pageName = call.arguments[@"pageName"];
    if(!pageName || [pageName length] == 0) {
        result(nil);
        return;
    }
    
    [MobClick endLogPageView:pageName];
    result(nil);
}

- (void)handleEvent:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString* eventId = call.arguments[@"eventId"];
    if(!eventId || [eventId length] == 0) {
        result(nil);
        return;
    }
    
    NSString* label = call.arguments[@"label"];
    if(!label || [eventId length] == 0) {
        label = @"";
    }
    
    NSDictionary* attributes = call.arguments[@"attributes"];
    if([attributes isKindOfClass:[NSNull class]]) {
        attributes = nil;
    }
    
    NSNumber* counterObj = call.arguments[@"counter"];
    if(counterObj && ![counterObj isKindOfClass:[NSNull class]]) {
        [MobClick event:eventId attributes:attributes counter:[counterObj intValue]];
    }
    else {
        if(attributes == nil) {
            [MobClick event:eventId label:label];
        }
        else {
            [MobClick event:eventId attributes:attributes];
        }
    }
    result(nil);
}

- (void)handleBeginEvent:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString* eventId = call.arguments[@"eventId"];
    if(!eventId || [eventId length] == 0) {
        result(nil);
        return;
    }
    
    NSString* label = call.arguments[@"label"];
    if(!label || [eventId length] == 0) {
        label = @"";
    }
    
    NSDictionary* attributes = call.arguments[@"attributes"];
    if(attributes && [attributes isKindOfClass:[NSNull class]]) {
        attributes = nil;
    }
    
    if(attributes == nil) {
        [MobClick beginEvent:eventId label:label];
    }
    else {
        [MobClick beginEvent:eventId primarykey:nil attributes:attributes];
    }
    result(nil);
}

- (void)handleEndEvent:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString* eventId = call.arguments[@"eventId"];
    if(!eventId || [eventId length] == 0) {
        result(nil);
        return;
    }
    
    NSString* label = call.arguments[@"label"];
    if(!label || [eventId length] == 0) {
        label = @"";
    }
    
    [MobClick endEvent:eventId label:label];
    result(nil);
}

- (void)handleEventDurations:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString* eventId = call.arguments[@"eventId"];
    if(!eventId || [eventId length] == 0) {
        result(nil);
        return;
    }
    
    int millisecond = 0;
    NSNumber* millisecondObj = call.arguments[@"millisecond"];
    if(millisecondObj && ![millisecondObj isKindOfClass:[NSNull class]]) {
        millisecond = [millisecondObj intValue];
    }
    
    NSString* label = call.arguments[@"label"];
    if(!label || [eventId length] == 0) {
        label = @"";
    }
    
    NSDictionary* attributes = call.arguments[@"attributes"];
    if(attributes && [attributes isKindOfClass:[NSNull class]]) {
        attributes = nil;
    }
    
    if(attributes == nil) {
        [MobClick event:eventId label:label durations:millisecond];
    }
    else {
        [MobClick event:eventId attributes:attributes durations:millisecond];
    }
    
    result(nil);
}

- (void)handleProfileSignIn:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString* puid = call.arguments[@"puid"];
    if(!puid || [puid length] == 0) {
        result(nil);
        return;
    }
    
    NSString* provider = call.arguments[@"provider"];
    if(!provider || [provider length] == 0) {
        provider = @"";
    }
    
    if([provider length] == 0) {
        [MobClick profileSignInWithPUID:puid];
    }
    else {
        [MobClick profileSignInWithPUID:puid provider:provider];
    }
    
    result(nil);
}

- (void)handleProfileSignOff:(FlutterMethodCall*)call result:(FlutterResult)result {
    [MobClick profileSignOff];
    result(nil);
}

@end
