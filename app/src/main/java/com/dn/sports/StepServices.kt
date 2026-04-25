package com.dn.sports

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.os.IBinder
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import androidx.lifecycle.LifecycleService
import androidx.lifecycle.lifecycleScope
import com.dn.sports.adcoinLogin.LoginListener
import com.dn.sports.adcoinLogin.StepUserManager
import com.dn.sports.utils.SharedPreferenceUtil
import com.dn.sports.utils.Utils
import kotlinx.coroutines.launch
import java.text.NumberFormat

/**
 * Modernized Step Counting Service (Foreground Service 2.0)
 * Handles background step counting, notification updates, and data sync to Room.
 */
class StepServices : LifecycleService() {

    private val stepUserManager = StepUserManager.getInstance()
    private val nf: NumberFormat by lazy {
        NumberFormat.getNumberInstance().apply {
            maximumFractionDigits = 2
        }
    }

    private var builder: NotificationCompat.Builder? = null
    private var remoteViews: RemoteViews? = null

    private val loginListener = object : com.dn.sports.adcoinLogin.LoginListener() {
        override fun onStepChange() {
            super.onStepChange()
            updateNotification()
            syncStepsToDatabase()
            updateWidget()
        }
    }

    private fun updateWidget() {
        // Persist today's steps for the Widget
        val steps = stepUserManager.todaySteps
        SharedPreferenceUtil.getInstance(this).put("today_steps", steps)

        // Notify Widget
        sendBroadcast(Intent("com.dn.sports.ACTION_UPDATE_WIDGET").apply {
            setPackage(packageName)
        })
    }

    override fun onCreate() {
        super.onCreate()
        stepUserManager.setLoginListener(loginListener)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        super.onStartCommand(intent, flags, startId)
        if (builder == null || remoteViews == null) {
            addNotify()
        }
        return START_STICKY
    }

    private fun addNotify() {
        val open = SharedPreferenceUtil.getInstance(this).get("testFeedMessage", false) as Boolean
        if (!open) return

        val channelId = "com.steps"
        val channelName = "ChannelSteps"

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            val channel = NotificationChannel(channelId, channelName, NotificationManager.IMPORTANCE_LOW).apply {
                enableLights(true)
                lightColor = Color.RED
                setShowBadge(true)
                lockscreenVisibility = Notification.VISIBILITY_SECRET
            }
            manager.createNotificationChannel(channel)
        }

        remoteViews = RemoteViews(packageName, R.layout.notify_layout).apply {
            val openIt = Intent(this@StepServices, MainActivity::class.java).apply {
                putExtra(START_FORM_SERVICE, true)
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            }
            val pendingIntent = PendingIntent.getActivity(
                this@StepServices, 1, openIt,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            setOnClickPendingIntent(R.id.notify_root_layout, pendingIntent)
            setTextViewText(R.id.notify_image_title, Utils.getTopTitleName(this@StepServices))
        }

        builder = NotificationCompat.Builder(this, channelId).apply {
            setSmallIcon(R.mipmap.ic_app)
            setContent(remoteViews)
            setSound(null)
            setOngoing(true)
            priority = NotificationCompat.PRIORITY_LOW
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                setVisibility(NotificationCompat.VISIBILITY_SECRET)
            }
        }

        updateNotification()
        startForeground(NOTIFICATION_ID, builder?.build())
    }

    private fun updateNotification() {
        remoteViews?.let { views ->
            val steps = stepUserManager.todaySteps
            val kmiles = steps * 0.6f / 1000
            val data = "${steps}步 | ${nf.format(kmiles)}公里 | ${(kmiles * 14 / 60 * 240).toInt()}千卡"

            views.setTextViewText(R.id.notify_data, data)
            builder?.setContent(views)

            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.notify(NOTIFICATION_ID, builder?.build())
        }
    }

    private fun syncStepsToDatabase() {
        lifecycleScope.launch {
            val steps = stepUserManager.todaySteps
            StepApplication.getInstance().repository.upsertDailyStepsRecord(steps)
        }
    }

    override fun onDestroy() {
        stepUserManager.removeLoginListener(loginListener)
        super.onDestroy()
    }

    companion object {
        private const val NOTIFICATION_ID = 110
        const val START_FORM_SERVICE = "start_form_service"
    }
}
