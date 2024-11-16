package com.zikostudio.remoteshutdowndesktop

import android.annotation.SuppressLint
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.RemoteViews


/**
 * Implementation of App Widget functionality.
 */
class ButtonWidget : AppWidgetProvider() {

    private fun pendingItent(context: Context?, action: String): PendingIntent? {
        val intent = Intent(context, javaClass)
        intent.action = action
        return PendingIntent.getBroadcast(
            context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        super.onReceive(context, intent)
        if (intent != null) {
            if (intent.action == "pressed") {
                Log.i("tag", "afze")

                callDart().invokeChannel("pressed")
            }
        }
    }

    @SuppressLint("UnspecifiedImmutableFlag")
    override fun onUpdate(
        context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray
    ) {
        super.onUpdate(context, appWidgetManager, appWidgetIds)

        for (appWidgetId in appWidgetIds) {

            val views = RemoteViews(context.packageName, R.layout.button_widget)

            views.setOnClickPendingIntent(R.id.simpleImageButton, pendingItent(context, "pressed"))

            // Instruct the widget manager to update the widget
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

}
