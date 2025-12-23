package com.dn.sports;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.IBinder;
import android.widget.RemoteViews;

import androidx.annotation.Nullable;

import com.dn.sports.adcoinLogin.LoginListener;
import com.dn.sports.adcoinLogin.StepUserManager;
import com.dn.sports.utils.SharedPreferenceUtil;
import com.dn.sports.utils.Utils;

import java.text.NumberFormat;

/**
 * 显示通知栏服务，监听步数
 * */
public class StepServices extends Service {

    private StepUserManager stepUserManager = StepUserManager.getInstance();
    private NumberFormat nf;

    private LoginListener loginListener = new LoginListener(){
        @Override
        public void onStepChange() {
            super.onStepChange();
            if(remoteViews != null) {
                int steps = stepUserManager.getTodaySteps();
                float kmiles = ((float) steps) * 0.6f / 1000;
                String data = steps + "步" + " | ";
                data = data + nf.format(kmiles) + "公里" + " | ";
                float times = kmiles * 14;
                data = data + (int) ((times / 60) * 240) + "千卡";
                remoteViews.setTextViewText(R.id.notify_data, data);
                builder.setContent(remoteViews);
                startForeground(110, builder.build());
            }
        }
    };

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        StepUserManager.getInstance().setLoginListener(loginListener);
        nf = NumberFormat.getNumberInstance();
        nf.setMaximumFractionDigits(2);
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if(builder == null || remoteViews == null) {
            addNotify();
        }
        return START_STICKY;
    }

    private Notification.Builder builder;
    private RemoteViews remoteViews;
    public static final String START_FORM_SERVICE = "start_form_service";
    public final static String INTENT_BUTTONID_TAG = "ButtonId";
    public final static int BUTTON_OPEN_APP = 1;
    public final String CHANNEL_ONE_ID = "com.steps";
    public final String CHANNEL_ONE_NAME = "ChannelSteps";

    public void addNotify(){

        boolean open = (boolean) SharedPreferenceUtil.Companion.getInstance(this).get("testFeedMessage", true);
        if (!open) {
            return;
        }

        builder = new Notification.Builder
                (this.getApplicationContext());
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            NotificationChannel notificationChannel;
            notificationChannel = new NotificationChannel(CHANNEL_ONE_ID,
                    CHANNEL_ONE_NAME, NotificationManager.IMPORTANCE_HIGH);
            notificationChannel.enableLights(true);
            notificationChannel.setImportance(NotificationManager.IMPORTANCE_LOW);
            notificationChannel.setLightColor(Color.RED);
            notificationChannel.setShowBadge(true);
            notificationChannel.setLockscreenVisibility(Notification.VISIBILITY_SECRET);
            NotificationManager manager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
            manager.createNotificationChannel(notificationChannel);
            builder.setChannelId(CHANNEL_ONE_ID);
        }
        remoteViews = new RemoteViews(getPackageName(), R.layout.notify_layout);//通知栏布局
        Intent openIt = new Intent(this, MainActivity.class);
        openIt.putExtra(START_FORM_SERVICE,true);
        openIt.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        openIt.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
        PendingIntent itP = PendingIntent.getActivity(this, BUTTON_OPEN_APP, openIt, PendingIntent.FLAG_UPDATE_CURRENT);
        remoteViews.setOnClickPendingIntent(R.id.notify_root_layout, itP);

        remoteViews.setTextViewText(R.id.notify_image_title, Utils.getTopTitleName(this));
        builder.setSmallIcon(R.mipmap.ic_app);
        builder.setContent(remoteViews);
        builder.setSound(null,null);
        if(Build.VERSION.SDK_INT>=21)
            builder.setVisibility(Notification.VISIBILITY_SECRET);

        startForeground(110, builder.build());
    }
}
