package com.dn.sports.adcoinLogin.common;

import android.content.Context;

public interface CommonAdInterface {

    void initAd(Context context, AdListener adListener);

    void showAd(Context context, int type);

    boolean isAdLoaded();

    void release(Context context);

    void resume(Context context);

    void pause(Context context);

}
