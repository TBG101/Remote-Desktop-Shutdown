package com.zikostudio.remoteshutdowndesktop

import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class callDart : FlutterActivity() {
    private lateinit var channel: MethodChannel
    private val CHANNEL = "channel"


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL);
    }

    fun invokeChannel(channelname: String) {
        if (channel == null) {
            Log.i("yah", "channel is null")
            return
        }
        try {
            channel!!.invokeMethod(channelname, null)
        } catch (e: Exception) {
            Log.i("error", "eerror on invoce $e")
        }

    }


}