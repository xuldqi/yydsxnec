package com.dn.sports.adcoinLogin.chuanshanjia;

import android.app.Activity;
import android.util.Log;

import com.bytedance.sdk.openadsdk.TTAdConstant;
import com.bytedance.sdk.openadsdk.TTAdNative;
import com.bytedance.sdk.openadsdk.TTFullScreenVideoAd;
import com.dn.sports.common.LogUtils;

public class AdLoadListener implements TTAdNative.FullScreenVideoAdListener {

    private String TAG = "AdLoadListener";
    private final Activity mActivity;

    private TTFullScreenVideoAd mAd;

    public AdLoadListener(Activity activity) {
        mActivity = activity;
    }

    @Override
    public void onError(int code, String message) {
        LogUtils.e(TAG, "Callback --> onError: " + code + ", " + message);
    }

    @Override

    public void onFullScreenVideoAdLoad(TTFullScreenVideoAd ad) {
        LogUtils.e(TAG, "Callback --> onFullScreenVideoAdLoad");
        handleAd(ad);
    }

    @Override

    public void onFullScreenVideoCached() {
        // 已废弃 请使用 onRewardVideoCached(TTRewardVideoAd ad) 方法
    }

    @Override

    public void onFullScreenVideoCached(TTFullScreenVideoAd ad) {
        LogUtils.e(TAG, "Callback --> onFullScreenVideoCached");
        handleAd(ad);
    }

    /**
     * 处理广告对象
     */

    public void handleAd(TTFullScreenVideoAd ad) {
        if (mAd != null) {
            return;
        }
        mAd = ad;
        //【必须】广告展示时的生命周期监听

        mAd.setFullScreenVideoAdInteractionListener(new AdLifeListener(mActivity));
        //【可选】监听下载状态
        mAd.setDownloadListener(new DownloadStatusListener());



        showAd(TTAdConstant.RitScenes.CUSTOMIZE_SCENES, "scenes_test");

    }

    /**
     * 触发展示广告
     */

    public void showAd(TTAdConstant.RitScenes ritScenes, String scenes) {
        if (mAd == null) {
//            TToast.show(mActivity, "当前广告未加载好，请先点击加载广告");
            return;
        }

        mAd.showFullScreenVideoAd(mActivity, ritScenes, scenes);
        // 广告使用后应废弃
        mAd = null;
    }
}