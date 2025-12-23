package com.dn.sports.common;

public class EyeLog {

    private static final String LOG_TAG = "Steps";
    private static final boolean isDebug = true;

    public static void logi(String info){
        if(isDebug)
            android.util.Log.i(LOG_TAG,info);
    }

    public static void logd(String info){
        if(isDebug)
            android.util.Log.d(LOG_TAG,info);
    }

    public static void loge(String info){
        android.util.Log.e(LOG_TAG,info);
    }
}
