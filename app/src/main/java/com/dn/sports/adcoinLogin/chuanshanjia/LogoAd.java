package com.dn.sports.adcoinLogin.chuanshanjia;

import android.content.Context;
import android.util.Log;

import com.bytedance.sdk.openadsdk.AdSlot;
import com.bytedance.sdk.openadsdk.TTAdConfig;
import com.bytedance.sdk.openadsdk.TTAdConstant;
import com.bytedance.sdk.openadsdk.TTAdNative;
import com.bytedance.sdk.openadsdk.TTAdSdk;
import com.bytedance.sdk.openadsdk.TTSplashAd;
import com.dn.sports.adcoinLogin.common.AdListener;
import com.dn.sports.adcoinLogin.common.CommonAdInterface;
import com.dn.sports.common.EyeLog;


public class LogoAd implements CommonAdInterface {
    private TTAdNative mTTAdNative;
    private TTSplashAd mTtSplashAd;
    private boolean isLoaded = false;


    @Override
    public void initAd(Context context, final AdListener adListener) {

        String adId = "887294120";
        mTTAdNative = TTAdSdk.getAdManager().createAdNative(context);
        isLoaded = false;
        AdSlot adSlot = new AdSlot.Builder()
                .setCodeId(adId)
                .setImageAcceptedSize((1920*6)/13, 1080)
                .setSupportDeepLink(true)
                .build();

        mTTAdNative.loadSplashAd(adSlot, new TTAdNative.SplashAdListener() {
            @Override
            public void onError(int i, String s) {
                EyeLog.loge("ByteJumpAd+onError:"+s+",i:"+i);
                if(adListener != null)
                    adListener.adError(s);
            }

            @Override
            public void onTimeout() {
                EyeLog.logi("ByteJumpAd+onTimeout:");
                if(adListener != null)
                    adListener.adError("onTimeout");
            }

            @Override
            public void onSplashAdLoad(TTSplashAd ttSplashAd) {
                EyeLog.logi("ByteJumpAd+onSplashAdLoad:");
                mTtSplashAd = ttSplashAd;
                isLoaded = true;
                if(adListener != null)
                    adListener.adLoad();
            }
        });

    }

    public TTSplashAd getmTtSplashAd() {
        return mTtSplashAd;
    }

    @Override
    public void showAd(Context context, int type) {

    }

    @Override
    public boolean isAdLoaded() {
        return isLoaded;
    }

    @Override
    public void pause(Context context) {

    }

    @Override
    public void resume(Context context) {

    }

    @Override
    public void release(Context context) {
        mTTAdNative = null;
    }
}
