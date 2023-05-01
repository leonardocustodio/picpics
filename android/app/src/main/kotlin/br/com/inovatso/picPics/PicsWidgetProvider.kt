//package br.com.inovatso.picPics
//
//import android.app.PendingIntent
//import android.appwidget.AppWidgetManager
//import android.content.Context
//import android.content.Intent
//import android.content.SharedPreferences
//import android.widget.RemoteViews
//import android.graphics.Bitmap
//import android.graphics.BitmapFactory
//import android.util.Base64
//import android.widget.ImageView
//import es.antonborri.home_widget.HomeWidgetProvider
//
//class PicsWidgetProvider : HomeWidgetProvider() {
//
//    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
//        appWidgetIds.forEach { widgetId ->
//            val views = RemoteViews(context.packageName, R.layout.pics_widget_layout).apply {
//                //Open App on Widget Click
//                setOnClickPendingIntent(R.id.widget_container,
//                        PendingIntent.getActivity(context, 0, Intent(context, MainActivity::class.java), 0))
//
//                var imageBytes = Base64.decode(widgetData.getString("imageEncoded", null) ?: "", Base64.DEFAULT)
//                val decodedImage: Bitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)
//                setImageViewBitmap(R.id.widget_image, decodedImage)
//            }
//
//            appWidgetManager.updateAppWidget(widgetId, views)
//        }
//    }
//}