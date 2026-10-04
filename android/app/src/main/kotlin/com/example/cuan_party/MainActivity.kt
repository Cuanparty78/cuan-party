package com.example.cuan_party

import im.zego.zego_express_engine.ZegoExpressEnginePlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ZEGO normally auto-registers through Flutter's generated registrant.
        // This guard explicitly attaches it when the current Flutter/Android
        // embedding did not register the plugin, which otherwise causes
        // MissingPluginException on plugins.zego.im/zego_express_engine.
        if (!flutterEngine.plugins.has(ZegoExpressEnginePlugin::class.java)) {
            flutterEngine.plugins.add(ZegoExpressEnginePlugin())
        }
    }
}
