package com.example.sayadganj

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL_NAME = "com.example.sayadganj/rtl_notifications"
    }

    private var channel: MethodChannel? = null
    private var initialWordId: Int? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val wordId = intent?.getIntExtra("word_id", -1) ?: -1
        if (wordId > 0) {
            initialWordId = wordId
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val wordId = intent.getIntExtra("word_id", -1)
        if (wordId > 0) {
            channel?.invokeMethod("onNotificationTapped", wordId)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "scheduleNotification" -> {
                        val id = call.argument<Int>("id") ?: 4100
                        val wordId = call.argument<Int>("wordId") ?: -1
                        val title = call.argument<String>("title") ?: ""
                        val body = call.argument<String>("body") ?: ""
                        val triggerAtMillis = call.argument<Number>("triggerAtMillis")?.toLong() ?: 0L
                        val isTest = call.argument<Boolean>("isTest") ?: false

                        RtlWordNotificationHelper.scheduleNotification(
                            context = applicationContext,
                            id = id,
                            wordId = wordId,
                            title = title,
                            body = body,
                            triggerAtMillis = triggerAtMillis,
                            isTest = isTest
                        )
                        result.success(null)
                    }
                    "cancelAll" -> {
                        RtlWordNotificationHelper.cancelAll(applicationContext)
                        result.success(null)
                    }
                    "getInitialWordId" -> {
                        val id = initialWordId
                        initialWordId = null
                        result.success(id)
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }
}