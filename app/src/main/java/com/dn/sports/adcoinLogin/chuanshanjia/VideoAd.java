package com.dn.sports.adcoinLogin.chuanshanjia;

import android.app.Activity;
import android.content.Context;

import com.bytedance.sdk.openadsdk.AdSlot;
import com.bytedance.sdk.openadsdk.TTAdConstant;
import com.bytedance.sdk.openadsdk.TTAdManager;
import com.bytedance.sdk.openadsdk.TTAdNative;
import com.bytedance.sdk.openadsdk.TTAdSdk;
import com.bytedance.sdk.openadsdk.TTRewardVideoAd;
import com.dn.sports.adcoinLogin.StepUserManager;
import com.dn.sports.adcoinLogin.common.AdListener;
import com.dn.sports.adcoinLogin.common.CommonAdInterface;
import com.dn.sports.common.EyeLog;
import com.dn.sports.utils.Utils;

public class VideoAd implements CommonAdInterface {
    private TTAdNative mTTAdNative;
    private boolean isLoaded = false;
    private TTRewardVideoAd ttRewardVideoAd;
    private String adId = "";
    private int isDouble;
    private int taskId;

    public void setAdId(String adId,int isDouble,int taskId) {
        this.adId = adId;
        this.isDouble = isDouble;
        this.taskId = taskId;
    }

    @Override
    public void initAd(Context context, final AdListener adListener) {
        mTTAdNative = TTAdSdk.getAdManager().createAdNative(context);
        isLoaded = false;
        String userId = (String) Utils.get(context, StepUserManager.USER_ID_KEY,"");
        String extra = "isDouble="+isDouble+"&task_id="+taskId;
        EyeLog.logi("VideoAd+initAd extra:"+extra+",userId:"+userId+",adId:"+adId);
        AdSlot adSlot = new AdSlot.Builder()
                .setCodeId(adId)
                .setSupportDeepLink(true)
                .setImageAcceptedSize(1080, 1920)
                .setRewardName("金币") //奖励的名称
                .setRewardAmount(3)  //奖励的数量
                .setUserID(userId)//用户id,必传参数
                .setMediaExtra(extra) //附加参数，可选
                .setOrientation(TTAdConstant.VERTICAL) //必填参数，期望视频的播放方向：TTAdConstant.HORIZONTAL 或 TTAdConstant.VERTICAL
                .build();
//        mTTAdNative.loadRewardVideoAd(adSlot, new TTAdNative.RewardVideoAdListener() {
//            @Override
//            public void onError(int code, String message) {
//                isLoaded = false;
//                if (adListener != null)
//                    adListener.adError("onError:"+message+",code:"+code);
//                EyeLog.loge("VideoAd+onError:"+message+",code:"+code);
//            }
//            //视频广告加载后的视频文件资源缓存到本地的回调
//            @Override
//            public void onRewardVideoCached() {
//                EyeLog.logi("VideoAd+onRewardVideoCached");
//                isLoaded = true;
//                if (adListener != null)
//                    adListener.adLoad();
//            }
//
//            @Override
//            public void onRewardVideoAdLoad(TTRewardVideoAd ad) {
//                EyeLog.logi("VideoAd+onRewardVideoAdLoad");
//                isLoaded = true;
//                ttRewardVideoAd = ad;
//                ttRewardVideoAd.setRewardAdInteractionListener(new TTRewardVideoAd.RewardAdInteractionListener() {
//
//                    @Override
//                    public void onSkippedVideo() {
//                        EyeLog.logi("VideoAd+onSkippedVideo");
//                    }
//
//                    @Override
//                    public void onVideoError() {
//                        EyeLog.logi("VideoAd+onVideoError");
//                        if (adListener != null)
//                            adListener.adError("onVideoError");
//                    }
//
//                    @Override
//                    public void onAdShow() {
//                        EyeLog.logi("VideoAd+onAdShow");
//                        if (adListener != null)
//                            adListener.adShow();
//                    }
//
//                    @Override
//                    public void onAdVideoBarClick() {
//                        EyeLog.logi("VideoAd+onAdVideoBarClick");
//                    }
//
//                    @Override
//                    public void onAdClose() {
//                        EyeLog.logi("VideoAd+onAdClose");
//                        if (adListener != null)
//                            adListener.adClose();
//                    }
//
//                    @Override
//                    public void onVideoComplete() {
//                        EyeLog.logi("VideoAd+onVideoComplete");
//                    }
//
//                    @Override
//                    public void onRewardVerify(boolean rewardVerify, int rewardAmount, String rewardName) {
//                        EyeLog.logi("VideoAd+onRewardVerify:"+rewardVerify+",rewardAmount:"+rewardAmount+",rewardName:"+rewardName);
//                        if (adListener != null) {
//                            adListener.onRewarded();
//                        }
//
//                        if (adListener != null) {
//                            adListener.onRewardedSuccess(rewardVerify);
//                        }
//                    }
//                });
//            }
//        });
    }

    @Override
    public void showAd(Context context, int type) {
        ttRewardVideoAd.showRewardVideoAd((Activity) context);
    }

    @Override
    public boolean isAdLoaded() {
        return isLoaded;
    }

    @Override
    public void release(Context context) {
    }

    @Override
    public void resume(Context context) {

    }

    @Override
    public void pause(Context context) {

    }
}
