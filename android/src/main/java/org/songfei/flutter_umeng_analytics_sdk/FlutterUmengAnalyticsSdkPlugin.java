package org.songfei.flutter_umeng_analytics_sdk;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.os.Bundle;

import com.umeng.analytics.MobclickAgent;
import com.umeng.commonsdk.UMConfigure;

import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class FlutterUmengAnalyticsSdkPlugin implements MethodCallHandler {

    private static Activity activity;
    private static Context context;

    private static Application.ActivityLifecycleCallbacks mLifecycleCallbacks = new Application.ActivityLifecycleCallbacks() {
        @Override
        public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
        }

        @Override
        public void onActivityStarted(Activity activity) {
        }

        @Override
        public void onActivityResumed(Activity activity) {
            MobclickAgent.onResume(activity);
        }

        @Override
        public void onActivityPaused(Activity activity) {
            MobclickAgent.onPause(activity);
        }

        @Override
        public void onActivityStopped(Activity activity) {
        }

        @Override
        public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
        }

        @Override
        public void onActivityDestroyed(Activity activity) {
        }
    };

    public static void registerWith(Registrar registrar) {

        activity = registrar.activity();
        context = registrar.context();

        activity.getApplication().registerActivityLifecycleCallbacks(mLifecycleCallbacks);

        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_umeng_analytics_sdk");
        channel.setMethodCallHandler(new FlutterUmengAnalyticsSdkPlugin());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getSdkVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("initAnalyticsSdk")) {
            handleInitAnalyticsSdk(call, result);
        } else if (call.method.equals("setLocation")) {
            handleSetLocation(call, result);
        } else if (call.method.equals("getUmid")) {
            handleGetUmid(call, result);
        } else if (call.method.equals("getDeviceIDForIntegration")) {
            handleGetDeviceIDForIntegration(call, result);
        } else if (call.method.equals("getMacAddress")) {
            handleGetMacAddress(call, result);
        } else if (call.method.equals("getIsJailbroken")) {
            handleGetIsJailbroken(call, result);
        } else if (call.method.equals("getIsPirated")) {
            handleGetIsPirated(call, result);
        } else if (call.method.equals("logPageView")) {
            handleLogPageView(call, result);
        } else if (call.method.equals("beginLogPageView")) {
            handleBeginLogPageView(call, result);
        } else if (call.method.equals("endLogPageView")) {
            handleEndLogPageView(call, result);
        } else if (call.method.equals("event")) {
            handleEvent(call, result);
        } else if (call.method.equals("beginEvent")) {
            handleBeginEvent(call, result);
        } else if (call.method.equals("endEvent")) {
            handleEndEvent(call, result);
        } else if (call.method.equals("eventDurations")) {
            handleEventDurations(call, result);
        } else if (call.method.equals("profileSignIn")) {
            handleProfileSignIn(call, result);
        } else if (call.method.equals("profileSignOff")) {
            handleProfileSignOff(call, result);
        } else {
            result.notImplemented();
        }
    }

    void handleInitAnalyticsSdk(MethodCall call, Result result) {
        String appKey = "";
        if (call.hasArgument("appKey") && call.argument("appKey") != null) {
            appKey = call.argument("appKey");
        }
        if (appKey.length() == 0) {
            result.success(null);
            return;
        }

        String channel = "default";
        if (call.hasArgument("channel") && call.argument("channel") != null) {
            channel = call.argument("channel");
        }

        boolean encryptEnabled = false;
        if (call.hasArgument("encryptEnabled") && call.argument("encryptEnabled") != null) {
            encryptEnabled = call.argument("encryptEnabled");
        }

        boolean crashReportEnabled = true;
        if (call.hasArgument("crashReportEnabled") && call.argument("crashReportEnabled") != null) {
            crashReportEnabled = call.argument("crashReportEnabled");
        }

        boolean logEnabled = false;
        if (call.hasArgument("logEnabled") && call.argument("logEnabled") != null) {
            logEnabled = call.argument("logEnabled");
        }

        UMConfigure.setLogEnabled(logEnabled);
        UMConfigure.setEncryptEnabled(encryptEnabled);

        UMConfigure.init(context, appKey, channel, UMConfigure.DEVICE_TYPE_PHONE, null);
        MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.MANUAL);
        MobclickAgent.setCatchUncaughtExceptions(crashReportEnabled);

        result.success(null);
    }

    void handleSetLocation(MethodCall call, Result result) {
        double latitude = 0.0;
        if (call.hasArgument("latitude") && call.argument("latitude") != null) {
            latitude = call.argument("latitude");
        }

        double longitude = 0.0;
        if (call.hasArgument("longitude") && call.argument("longitude") != null) {
            longitude = call.argument("longitude");
        }

        MobclickAgent.setLocation(latitude, longitude);
        result.success(null);
    }

    void handleGetUmid(MethodCall call, Result result) {
        String umid = UMConfigure.getUMIDString(context);
        result.success(umid);
    }

    void handleGetDeviceIDForIntegration(MethodCall call, Result result) {
        String deviceID = UMConfigure.getTestDeviceInfo(context)[0];
        result.success(deviceID);
    }

    void handleGetMacAddress(MethodCall call, Result result) {
        String macAddress = UMConfigure.getTestDeviceInfo(context)[1];
        result.success(macAddress);
    }

    void handleGetIsJailbroken(MethodCall call, Result result) {
        result.success(false);
    }

    void handleGetIsPirated(MethodCall call, Result result) {
        result.success(false);
    }

    // Android 没有实现
    void handleLogPageView(MethodCall call, Result result) {
        result.success(null);
    }

    void handleBeginLogPageView(MethodCall call, Result result) {
        String pageName = "";
        if (call.hasArgument("pageName") && call.argument("pageName") != null) {
            pageName = call.argument("pageName");
        }

        if (pageName.length() == 0) {
            result.success(null);
            return;
        }

        MobclickAgent.onPageStart(pageName);
        result.success(null);
    }

    void handleEndLogPageView(MethodCall call, Result result) {

        String pageName = "";
        if (call.hasArgument("pageName") && call.argument("pageName") != null) {
            pageName = call.argument("pageName");
        }
        if (pageName.length() == 0) {
            result.success(null);
            return;
        }

        MobclickAgent.onPageEnd(pageName);

        result.success(null);
    }

    void handleEvent(MethodCall call, Result result) {
        String eventId = "";
        if (call.hasArgument("eventId") && call.argument("eventId") != null) {
            eventId = call.argument("eventId");
        }
        if (eventId.length() == 0) {
            result.success(null);
            return;
        }

        String label = null;
        if (call.hasArgument("label") && call.argument("label") != null) {
            label = call.argument("label");
        }

        Map<String, String> attributes = null;
        if (call.hasArgument("attributes") && call.argument("attributes") != null) {
            try {
                attributes = call.argument("attributes");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        if (call.hasArgument("counter") && call.argument("counter") != null) {
            int counter = call.argument("counter");
            MobclickAgent.onEventValue(context, eventId, attributes, counter);
        } else {
            if (attributes == null) {
                if (label == null) {
                    MobclickAgent.onEvent(context, eventId);
                } else {
                    MobclickAgent.onEvent(context, eventId, label);
                }
            } else {
                MobclickAgent.onEvent(context, eventId, attributes);
            }
        }
        result.success(null);
    }

    // Android 没有实现
    void handleBeginEvent(MethodCall call, Result result) {
        result.success(null);
    }

    // Android 没有实现
    void handleEndEvent(MethodCall call, Result result) {
        result.success(null);
    }

    // Android 没有实现
    void handleEventDurations(MethodCall call, Result result) {
        result.success(null);
    }

    void handleProfileSignIn(MethodCall call, Result result) {

        String puid = "";
        if (call.hasArgument("puid") && call.argument("puid") != null) {
            puid = call.argument("puid");
        }
        if (puid.length() == 0) {
            result.success(null);
            return;
        }

        String provider = null;
        if (call.hasArgument("provider") && call.argument("provider") != null) {
            provider = call.argument("provider");
        }

        if (provider != null && provider.length() > 0) {
            MobclickAgent.onProfileSignIn(puid, provider);
        } else {
            MobclickAgent.onProfileSignIn(puid);
        }

        result.success(null);
    }

    void handleProfileSignOff(MethodCall call, Result result) {
        MobclickAgent.onProfileSignOff();
        result.success(null);
    }
}
