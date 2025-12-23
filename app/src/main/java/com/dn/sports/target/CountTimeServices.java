package com.dn.sports.target;

import android.app.Service;
import android.content.Intent;
import android.os.Binder;
import android.os.IBinder;

public class CountTimeServices extends Service {



    public class CountTimeServicesBinder extends Binder {
        public CountTimeServices getCountTimeService() {
            return CountTimeServices.this;
        }
    }

    @Override
    public IBinder onBind(Intent intent) {
        return new CountTimeServicesBinder();
    }

    @Override
    public void onCreate() {
        super.onCreate();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }
}
