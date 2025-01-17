package com.zikostudio.remoteshutdowndesktop

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

class WidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context?, appWidgetManager: AppWidgetManager?, appWidgetIds: IntArray?
    ) {
        super.onUpdate(context, appWidgetManager, appWidgetIds)
        appWidgetIds?.forEach { id ->
            val intent = Intent(context, WidgetReceiver::class.java)
            intent.action = "com.zikostudio.EXECUTE_DART_CODE"
            val pendingIntent = PendingIntent.getBroadcast(
                context, 0, intent, PendingIntent.FLAG_IMMUTABLE
            )
            if (context == null) return
            val views = RemoteViews(context.packageName, R.layout.button_widget)
            views.setOnClickPendingIntent(R.id.simpleImageButton,pendingIntent)
            appWidgetManager?.updateAppWidget(id,views)
        }

    }
}