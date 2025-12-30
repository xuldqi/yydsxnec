package com.dn.sports.adcoinLogin.chuanshanjia;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import com.bytedance.sdk.openadsdk.AdSlot;
import com.bytedance.sdk.openadsdk.TTAdNative;
import com.bytedance.sdk.openadsdk.TTAdSdk;
import com.bytedance.sdk.openadsdk.TTFullScreenVideoAd;
import com.dn.sports.adcoinLogin.common.AdListener;
import com.dn.sports.adcoinLogin.common.CommonAdInterface;
import com.dn.sports.common.EyeLog;


/**
 * 开屏/插屏广告
 * 更新：使用新的插屏广告位ID 953473682
 */
public class LogoAd implements CommonAdInterface {
    private TTAdNative mTTAdNative;
    private TTFullScreenVideoAd mTTFullScreenVideoAd;
    private boolean isLoaded = false;
    private Activity mActivity;

    // 新的插屏广告位ID
    private static final String AD_ID = "953473682";

    @Override
    public void initAd(Context context, final AdListener adListener) {
        if (context instanceof Activity) {
            mActivity = (Activity) context;
        }
        
        mTTAdNative = TTAdSdk.getAdManager().createAdNative(context);
        isLoaded = false;
        
        AdSlot adSlot = new AdSlot.Builder()
                .setCodeId(AD_ID)
                .setSupportDeepLink(true)
                .build();

        // 使用全屏视频广告（插屏）加载方式
        mTTAdNative.loadFullScreenVideoAd(adSlot, new TTAdNative.FullScreenVideoAdListener() {
            @Override
            public void onError(int code, String message) {
                EyeLog.loge("LogoAd+onError:" + message + ",code:" + code);
                if (adListener != null) {
                    adListener.adError(message);
                }
            }

            @Override
            public void onFullScreenVideoAdLoad(TTFullScreenVideoAd ad) {
                EyeLog.logi("LogoAd+onFullScreenVideoAdLoad");
                mTTFullScreenVideoAd = ad;
                isLoaded = true;
                if (adListener != null) {
                    adListener.adLoad();
                }
            }

            @Override
            public void onFullScreenVideoCached() {
                EyeLog.logi("LogoAd+onFullScreenVideoCached");
            }

            @Override
            public void onFullScreenVideoCached(TTFullScreenVideoAd ad) {
                EyeLog.logi("LogoAd+onFullScreenVideoCached with ad");
            }
        });
    }

    public TTFullScreenVideoAd getFullScreenVideoAd() {
        return mTTFullScreenVideoAd;
    }

    @Override
    public void showAd(Context context, int type) {
        if (mTTFullScreenVideoAd != null && context instanceof Activity) {
            mTTFullScreenVideoAd.showFullScreenVideoAd((Activity) context);
        }
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
        mTTFullScreenVideoAd = null;
    }
}
