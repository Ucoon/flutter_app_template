package tech.ucoon.flutter_app_template;

import com.jarvanmo.rammus.RammusPlugin;

import io.flutter.app.FlutterApplication;

public class YardiApplication extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        //初始化阿里云推送
        RammusPlugin.initPushService(this);
    }
}
