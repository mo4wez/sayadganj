package com.example.sayadganj

import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import org.json.JSONObject

object RtlWordNotificationHelper {
    private const val PREFS_NAME = "sayadganj_rtl_alarms"
    private const val CHANNEL_DAILY = "sayadganj_word_of_day"
    private const val CHANNEL_TEST = "sayadganj_word_of_day_test_v2"
    private const val RLM = "\u200F"

    fun ensureChannels(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        val dailyChannel = NotificationChannel(
            CHANNEL_DAILY,
            "روچ ءِ گال (Word of the Day)",
            NotificationManager.IMPORTANCE_DEFAULT
        ).apply {
            description = "هر روچ یک نوکیں بلوچی گالے گوں آئی ءِ مانا ءَ"
        }

        val testChannel = NotificationChannel(
            CHANNEL_TEST,
            "روچ ءِ گال (تست)",
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "جار جَنَگ ءِ تست"
        }

        manager.createNotificationChannel(dailyChannel)
        manager.createNotificationChannel(testChannel)
    }

    fun scheduleNotification(
        context: Context,
        id: Int,
        wordId: Int,
        title: String,
        body: String,
        triggerAtMillis: Long,
        isTest: Boolean
    ) {
        ensureChannels(context)

        val payload = JSONObject().apply {
            put("id", id)
            put("wordId", wordId)
            put("title", title)
            put("body", body)
            put("triggerAtMillis", triggerAtMillis)
            put("isTest", isTest)
        }
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .edit()
            .putString(id.toString(), payload.toString())
            .apply()

        setSystemAlarm(context, id, wordId, title, body, triggerAtMillis, isTest)
    }

    private fun setSystemAlarm(
        context: Context,
        id: Int,
        wordId: Int,
        title: String,
        body: String,
        triggerAtMillis: Long,
        isTest: Boolean
    ) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, RtlWordNotificationReceiver::class.java).apply {
            putExtra("id", id)
            putExtra("wordId", wordId)
            putExtra("title", title)
            putExtra("body", body)
            putExtra("isTest", isTest)
        }

        val pendingIntent = PendingIntent.getBroadcast(
            context,
            id,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val canExact = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            alarmManager.canScheduleExactAlarms()
        } else {
            true
        }

        if (isTest && canExact) {
            alarmManager.setAlarmClock(
                AlarmManager.AlarmClockInfo(triggerAtMillis, pendingIntent),
                pendingIntent
            )
        } else if (canExact) {
            alarmManager.setExactAndAllowWhileIdle(
                AlarmManager.RTC_WAKEUP,
                triggerAtMillis,
                pendingIntent
            )
        } else {
            alarmManager.setAndAllowWhileIdle(
                AlarmManager.RTC_WAKEUP,
                triggerAtMillis,
                pendingIntent
            )
        }
    }

    fun cancelAll(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val ids = (4100..4106).toList() + listOf(9999)

        for (id in ids) {
            val intent = Intent(context, RtlWordNotificationReceiver::class.java)
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                id,
                intent,
                PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE
            )
            if (pendingIntent != null) {
                alarmManager.cancel(pendingIntent)
                pendingIntent.cancel()
            }
        }

        prefs.edit().clear().apply()
        NotificationManagerCompat.from(context).cancelAll()
    }

    fun rescheduleAfterBoot(context: Context) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val now = System.currentTimeMillis()
        for ((key, raw) in prefs.all) {
            val jsonStr = raw as? String ?: continue
            val obj = runCatching { JSONObject(jsonStr) }.getOrNull() ?: continue
            val triggerAt = obj.optLong("triggerAtMillis", 0L)
            if (triggerAt <= now) {
                prefs.edit().remove(key).apply()
                continue
            }
            setSystemAlarm(
                context = context,
                id = obj.getInt("id"),
                wordId = obj.getInt("wordId"),
                title = obj.getString("title"),
                body = obj.getString("body"),
                triggerAtMillis = triggerAt,
                isTest = obj.optBoolean("isTest", false)
            )
        }
    }

    fun showNotification(
        context: Context,
        id: Int,
        wordId: Int,
        title: String,
        body: String,
        isTest: Boolean
    ) {
        ensureChannels(context)
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .edit()
            .remove(id.toString())
            .apply()

        val rtlTitle = "$RLM$title"
        val rtlBody = "$RLM$body"

        val launchIntent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra("word_id", wordId)
        }

        val contentIntent = PendingIntent.getActivity(
            context,
            id,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val smallIconRes = context.resources
            .getIdentifier("ic_stat_sayadganj", "drawable", context.packageName)
            .takeIf { it != 0 } ?: context.applicationInfo.icon

        val channelId = if (isTest) CHANNEL_TEST else CHANNEL_DAILY

        val notification = NotificationCompat.Builder(context, channelId)
            .setSmallIcon(smallIconRes)
            .setContentTitle(rtlTitle)
            .setContentText(rtlBody)
            .setStyle(
                NotificationCompat.BigTextStyle()
                    .setBigContentTitle(rtlTitle)
                    .bigText(rtlBody)
            )
            .setContentIntent(contentIntent)
            .setAutoCancel(true)
            .setPriority(
                if (isTest) NotificationCompat.PRIORITY_HIGH
                else NotificationCompat.PRIORITY_DEFAULT
            )
            .build()

        try {
            NotificationManagerCompat.from(context).notify(id, notification)
        } catch (_: SecurityException) {
            // Ignored if POST_NOTIFICATIONS was revoked by user
        }
    }
}

class RtlWordNotificationReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED ||
            intent.action == Intent.ACTION_MY_PACKAGE_REPLACED
        ) {
            RtlWordNotificationHelper.rescheduleAfterBoot(context)
            return
        }

        val id = intent.getIntExtra("id", 4100)
        val wordId = intent.getIntExtra("wordId", -1)
        val title = intent.getStringExtra("title") ?: return
        val body = intent.getStringExtra("body") ?: return
        val isTest = intent.getBooleanExtra("isTest", false)

        if (wordId > 0) {
            RtlWordNotificationHelper.showNotification(
                context = context,
                id = id,
                wordId = wordId,
                title = title,
                body = body,
                isTest = isTest
            )
        }
    }
}