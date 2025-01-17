package com.zikostudio.remoteshutdowndesktop

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.FlutterMain


class WidgetReceiver : BroadcastReceiver() {
    private val action = "com.zikostudio.EXECUTE_DART_CODE"
    private val CHANNEL = "com.zikostudio.widget/channel"


    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != action) return
        Log.i("WidgetInfo","Button clicked")
        // Communicate with Flutter using platform channels
        // Check if a cached FlutterEngine exists, else create a new one

        // Check if a cached FlutterEngine exists, else create a new one
        var flutterEngine = FlutterEngineCache.getInstance()["background_engine"]
        if (flutterEngine == null) {
            flutterEngine = FlutterEngine(context)
            // Ensure the Dart entrypoint matches the background entrypoint in Dart code


            flutterEngine!!.dartExecutor.executeDartEntrypoint(
                 DartExecutor.DartEntrypoint(context.assets.toString(),"backgroundMain")
            )
            Log.i(null,context.assets.toString())
            FlutterEngineCache.getInstance().put("background_engine", flutterEngine)
        }


        // Send the method call to Dart code
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.invokeMethod("executeDartCode", null)

    }
}