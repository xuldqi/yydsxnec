package com.dn.sports;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.FrameLayout;

import androidx.annotation.Nullable;

import com.bytedance.sdk.openadsdk.AdSlot;
import com.bytedance.sdk.openadsdk.TTAdConstant;
import com.bytedance.sdk.openadsdk.TTAdNative;
import com.bytedance.sdk.openadsdk.TTAdSdk;
import com.bytedance.sdk.openadsdk.TTNativeExpressAd;
import com.dn.sports.adcoinLogin.Ad;
import com.dn.sports.adcoinLogin.StepUserManager;
import com.dn.sports.common.BaseActivity;
import com.dn.sports.common.EyeLog;
import com.dn.sports.common.UmengLog;
import com.dn.sports.utils.Utils;

import java.util.List;

public class WriteInviteCodeActivity extends BaseActivity {

    private EditText writeInviteCode;
    private FrameLayout adArea;
    private long lastClickTime;


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_write_invite_code);
//        writeInviteCode = findViewById(R.id.write_invite_code);
//        adArea = findViewById(R.id.ad_area);
//        loadRandomCoinAd("945008003");
//        if(StepUserManager.getInstance().getUserInfo() == null){
//            finish();
//            return;
//        }
//
//        findViewById(R.id.start_invite_code).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                long current = System.currentTimeMillis();
//                if(current - lastClickTime < 2000){
//                    return;
//                }
//                lastClickTime = current;
//                UmengLog.logEvent(getApplicationContext(),UmengLog.ID.WRITE_INVITE_CODE);
//                StepUserManager.getInstance().inviteFriend(WriteInviteCodeActivity.this,writeInviteCode.getText().toString());
//                finish();
//            }
//        });
//
//        findViewById(R.id.close).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                finish();
//            }
//        });
        writeInviteCode.requestFocus();
        InputMethodManager imm = (InputMethodManager) getSystemService(INPUT_METHOD_SERVICE);
        imm.showSoftInput(writeInviteCode, InputMethodManager.SHOW_IMPLICIT);
    }

    private void loadRandomCoinAd(String adId){
        if(!StepApplication.getInstance().isShowAd()) {
            return;
        }
        adArea.post(new Runnable() {
            @Override
            public void run() {
                float width = adArea.getWidth();
                int dp = Utils.px2dip(WriteInviteCodeActivity.this,width);
                String userId = StepUserManager.getInstance().getUserId(WriteInviteCodeActivity.this);
                if(TextUtils.isEmpty(userId)){
                    userId = "steps";
                }
                TTAdNative mTTAdNative = TTAdSdk.getAdManager().createAdNative(WriteInviteCodeActivity.this);
                AdSlot adSlot = new AdSlot.Builder()
                        .setCodeId(adId)
                        .setSupportDeepLink(true)
                        .setExpressViewAcceptedSize(dp, (dp*2)/3)
                        .setImageAcceptedSize(320, 200)
                        .setAdCount(1) //请求广告数量为1到3条
                        .setOrientation(TTAdConstant.VERTICAL)
                        .setUserID(userId)
                        .build();
                mTTAdNative.loadNativeExpressAd(adSlot, new TTAdNative.NativeExpressAdListener() {
                    @Override
                    public void onError(int code, String message) {
                        EyeLog.loge("loadExpressDrawFeedAd onError:"+message+",code:"+code);
                    }

                    @Override
                    public void onNativeExpressAdLoad(List<TTNativeExpressAd> list) {
                        if (list == null || list.isEmpty()) {
                            EyeLog.loge("on loadExpressDrawFeedAd: ad is null!");
                            return;
                        }
                        buildRandomCoinAd(list.get(0));
                    }
                });
            }
        });
    }

    private void buildRandomCoinAd(final TTNativeExpressAd ad){
        ad.setExpressInteractionListener(new TTNativeExpressAd.ExpressAdInteractionListener() {
            @Override
            public void onAdClicked(View view, int type) {
                EyeLog.logi("广告被点击");
            }

            @Override
            public void onAdShow(View view, int type) {
                EyeLog.logi("广告展示");
            }

            @Override
            public void onRenderFail(View view, String msg, int code) {
                EyeLog.logi("render fail:"+msg);
            }

            @Override
            public void onRenderSuccess(View view, float width, float height) {
                //返回view的宽高 单位 dp
                EyeLog.logi( "渲染成功 width:"+width+",height:"+height);
                adArea.removeAllViews();
                adArea.addView(ad.getExpressAdView());
            }
        });
        ad.render();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }
}
