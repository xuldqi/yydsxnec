package com.dn.sports.adcoinLogin.chuanshanjia;

import android.content.Context;
import android.util.Log;

import com.bytedance.sdk.openadsdk.TTFullScreenVideoAd;

import java.lang.ref.WeakReference;

public class AdLifeListener implements TTFullScreenVideoAd.FullScreenVideoAdInteractionListener {
    private String TAG = "AdLifeListener";

    private final WeakReference<Context> mContextRef;

    public AdLifeListener(Context context) {
        mContextRef = new WeakReference<>(context);
    }

    @Override

    public void onAdShow() {
        Log.d(TAG, "Callback --> FullVideoAd show");
    }

    @Override

    public void onAdVideoBarClick() {
        Log.d(TAG, "Callback --> FullVideoAd bar click");
    }

    @Override

    public void onAdClose() {
        Log.d(TAG, "Callback --> FullVideoAd close");
    }

    @Override
    public void onVideoComplete() {
        Log.d(TAG, "Callback --> FullVideoAd complete");
    }

    @Override
    public void onSkippedVideo() {
        Log.d(TAG, "Callback --> FullVideoAd skipped");
    }
}