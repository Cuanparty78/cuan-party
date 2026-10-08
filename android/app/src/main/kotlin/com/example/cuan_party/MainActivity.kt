package com.example.cuan_party

import im.zego.zego_express_engine.ZegoExpressEnginePlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Force ZEGO to detach and attach again so its MethodChannel
        // plugins.zego.im/zego_express_engine always gets a live handler.
        flutterEngine.plugins.remove(ZegoExpressEnginePlugin::class.java)
        flutterEngine.plugins.add(ZegoExpressEnginePlugin())
    }
}
