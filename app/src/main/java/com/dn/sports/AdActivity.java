package com.dn.sports;

import android.animation.ObjectAnimator;
import android.animation.ValueAnimator;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;

import com.bytedance.sdk.openadsdk.AdSlot;
import com.bytedance.sdk.openadsdk.FilterWord;
import com.bytedance.sdk.openadsdk.TTAdConstant;
import com.bytedance.sdk.openadsdk.TTAdDislike;
import com.bytedance.sdk.openadsdk.TTAdNative;
import com.bytedance.sdk.openadsdk.TTAdSdk;
import com.bytedance.sdk.openadsdk.TTFeedAd;
import com.bytedance.sdk.openadsdk.TTNativeExpressAd;
import com.dn.sports.adcoinLogin.Ad;
import com.dn.sports.adcoinLogin.LoginListener;
import com.dn.sports.adcoinLogin.StepUserManager;
import com.dn.sports.adcoinLogin.chuanshanjia.VideoAd;
import com.dn.sports.adcoinLogin.common.AdListener;
import com.dn.sports.adcoinLogin.model.RandomCoin;
import com.dn.sports.adcoinLogin.model.TaskModel;
import com.dn.sports.adcoinLogin.model.User;
import com.dn.sports.common.BaseActivity;
import com.dn.sports.common.EyeLog;
import com.dn.sports.dialog.DislikeDialog;
import com.dn.sports.fragment.HomeFragment;
import com.dn.sports.utils.Utils;

import java.util.List;

public class AdActivity extends BaseActivity {

    public static String AD_TYPE = "AD_TYPE";
    public static String TASK_ID = "TASK_ID";
    public static String GET_MONEY = "GET_MONEY";
    public static String RANDOM_COIN = "RANDOM_COIN";
    public static String SIGN_COIN = "SIGN_COIN";
    public static String SIGN_REQUEST = "SIGN_REQUEST";
    public static String TASK_COIN = "TASK_COIN";
    public static String PIE_COIN = "PIE_COIN";
    public static String SYNC_STEP = "SYNC_STEP";
    public static String SYNC_STEP_TASK = "SYNC_STEP_TASK";
    public static String SYNC_TASK_AD_RESULT= "SYNC_TASK_AD_RESULT";
    public static String COIN_NUM= "COIN_NUM";
    private static String RANDOM_AD_ID= "945008003";
    private static String VIDEO_AD_ID= "944570768";
    private boolean canReturn = false;
    private LinearLayout adArea;
    private TextView adCloseTime;
    private int randomCoinAdId = 0;
    private String type;
    private int isDouble = 0;
    private int taskID = 0;
    private GradientDrawable drawable;
    private  ValueAnimator valueAnimator;
//    private Handler adHandler = new Handler(Looper.getMainLooper()){
//        @Override
//        public void handleMessage(Message msg) {
//            super.handleMessage(msg);
//            if(msg.what ==1){
//                int count = Integer.valueOf(adCloseTime.getText().toString());
//                if(count == 0){
//                    adCloseTime.setText(count+"");
////                    findViewById(R.id.ad_close).setVisibility(View.VISIBLE);
////                    adCloseTime.setVisibility(View.INVISIBLE);
////                    canReturn = true;
////                    findViewById(R.id.video_double_coin).setEnabled(true);
//                }else{
//                    count = count -1;
//                    adCloseTime.setText(count+"");
//                    adHandler.sendEmptyMessageDelayed(1,1000);
//                }
//            }
//        }
//    };
//
//    private LoginListener loginListener = new LoginListener(){
//
//        @Override
//        public void onUserInfoUpdate(int msg, User info) {
//            super.onUserInfoUpdate(msg, info);
//            TextView ad_text_coin = findViewById(R.id.ad_text_coin);
//            String moneyText = getResources().getString(R.string.get_coin_in_ad_activity);
//            moneyText = String.format(moneyText, String.valueOf((int)info.getBalance()),StepUserManager.coinToMoney(info.getBalance()));
//            ad_text_coin.setText(moneyText);
//        }
//
//        @Override
//        public void onGetTaskReward(TaskModel taskModel) {
//            super.onGetTaskReward(taskModel);
////            findViewById(R.id.video_double_coin).setEnabled(true);
////            findViewById(R.id.video_double_coin).setBackgroundResource(R.drawable.press_background_get);
//        }
//
//        @Override
//        public void onError(int msg, String info) {
//            super.onError(msg, info);
//
//            adHandler.post(new Runnable() {
//                @Override
//                public void run() {
//                    if(msg == Ad.Login.MSG_GET_RANDOM_COIN){
//                        TextView textView = findViewById(R.id.ad_text);
//                        textView.setText(getResources().getString(R.string.get_reward_failed));
//                    }
//
//                    if(msg == Ad.Login.MSG_SIGN) {
//                        TextView textView = findViewById(R.id.ad_text);
//                        textView.setText(getResources().getString(R.string.get_reward_failed));
//                        TextView ad_text_coin = findViewById(R.id.ad_text_coin);
//                        ad_text_coin.setText(getResources().getString(R.string.sgin_failed));
//                    }
//
//                    if(msg == Ad.Login.MSG_GET_REWARD) {
//                        TextView textView = findViewById(R.id.ad_text);
//                        textView.setText(getResources().getString(R.string.get_reward_failed));
//                        TextView ad_text_coin = findViewById(R.id.ad_text_coin);
//                        ad_text_coin.setText("稍后重新尝试");
//                    }
//                }
//            });
//        }
//    };
//
//    @Override
//    protected void onDestroy() {
//        super.onDestroy();
//        StepUserManager.getInstance().removeLoginListener(loginListener);
//        if(valueAnimator != null){
//            valueAnimator.cancel();
//        }
//    }
//
//    @Override
//    protected void onCreate(@Nullable Bundle savedInstanceState) {
//        getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
//            Window window = getWindow();
//            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
//            window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
//            window.setStatusBarColor(getResources().getColor(R.color.dialog_background_color));
//            window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_LAYOUT_STABLE);
//            window.setNavigationBarColor(getResources().getColor(R.color.dialog_background_color));
//        }
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_ad);
//
//        if(getIntent() == null){
//            finish();
//            return;
//        }
//        adArea = findViewById(R.id.ad_area);
//        adArea.setVisibility(View.INVISIBLE);
//        adCloseTime = findViewById(R.id.ad_close_time);
//        adCloseTime.setText("3");
//        findViewById(R.id.ad_close).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                finish();
//            }
//        });
//        StepUserManager.getInstance().setLoginListener(loginListener);
//        type = getIntent().getStringExtra(AD_TYPE);
//        ProgressBar pb = findViewById(R.id.progress_bar);
//        pb.startAnimation(AnimationUtils.loadAnimation(this,
//                R.anim.progress_anim));
//        findViewById(R.id.video_double_coin).setEnabled(false);
//        findViewById(R.id.video_double_coin).setVisibility(View.GONE);
//        //领取随机金币
//        if(RANDOM_COIN.equals(type)){
//            loadRandomCoinAd(RANDOM_AD_ID);
//            final int coin = getIntent().getIntExtra("ad_coin",0);
//            final int id = getIntent().getIntExtra("ad_coin_id",0);
//            randomCoinAdId = id;
//            TextView textView = findViewById(R.id.ad_text);
//            textView.setText(getResources().getString(R.string.get_random_coin_reward));
//            TextView textView2 = findViewById(R.id.ad_text_unit);
//            textView2.setText("+"+coin);
//
//            TextView ad_text_coin = findViewById(R.id.ad_text_coin);
//            String moneyText = getResources().getString(R.string.get_coin_in_ad_activity);
//            User user = StepUserManager.getInstance().getUserInfo();
//            moneyText = String.format(moneyText, String.valueOf((int)user.getBalance()),StepUserManager.coinToMoney(user.getBalance()));
//            ad_text_coin.setText(moneyText);
//
//            StepUserManager.getInstance().getRandomCoin(AdActivity.this,randomCoinAdId);
//            ((TextView)findViewById(R.id.video_double_coin)).setText(getResources().getString(R.string.sure_get_coin));
//            findViewById(R.id.video_double_coin).setOnClickListener(new View.OnClickListener() {
//                @Override
//                public void onClick(View v) {
//                    finish();
//                }
//            });
//        }else if(SIGN_COIN.equals(type)){
//            loadRandomCoinAd(RANDOM_AD_ID);
//            TextView textView = findViewById(R.id.ad_text);
//            textView.setText(getResources().getString(R.string.today_sgin_hint));
//            final int coin = getIntent().getIntExtra("ad_coin",0);
//            TextView textView2 = findViewById(R.id.ad_text_unit);
//            textView2.setText("+"+coin);
//
//            TextView ad_text_coin = findViewById(R.id.ad_text_coin);
//            String moneyText = getResources().getString(R.string.get_coin_in_ad_activity);
//            User user = StepUserManager.getInstance().getUserInfo();
//            moneyText = String.format(moneyText, String.valueOf((int)user.getBalance()),StepUserManager.coinToMoney(user.getBalance()));
//            ad_text_coin.setText(moneyText);
//
//            StepUserManager.getInstance().getRandomCoin(AdActivity.this,randomCoinAdId);
//            ((TextView)findViewById(R.id.video_double_coin)).setText(getResources().getString(R.string.sure_get_coin));
//            findViewById(R.id.video_double_coin).setOnClickListener(new View.OnClickListener() {
//                @Override
//                public void onClick(View v) {
//                    finish();
//                }
//            });
//        }else if(TASK_COIN.equals(type)) {
//            final int id = getIntent().getIntExtra("ad_task_id",0);
//            final String title = getIntent().getStringExtra("ad_task_title");
//            loadRandomCoinAd(RANDOM_AD_ID);
//
//            TextView textView = findViewById(R.id.ad_text);
//            textView.setText(title);
//
//            final int coin = getIntent().getIntExtra("ad_task_coin",0);
//            TextView textView2 = findViewById(R.id.ad_text_unit);
//            textView2.setText("+"+coin);
//
//            TextView ad_text_coin = findViewById(R.id.ad_text_coin);
//            String moneyText = getResources().getString(R.string.get_coin_in_ad_activity);
//            ((TextView)findViewById(R.id.video_double_coin)).setText(getResources().getString(R.string.sure_get_coin));
//            User user = StepUserManager.getInstance().getUserInfo();
//            if(user == null)
//                return;
//            moneyText = String.format(moneyText, String.valueOf((int)user.getBalance()),StepUserManager.coinToMoney(user.getBalance()));
//            ad_text_coin.setText(moneyText);
//            findViewById(R.id.video_double_coin).setOnClickListener(new View.OnClickListener() {
//                @Override
//                public void onClick(View v) {
//                    finish();
//                }
//            });
//            StepUserManager.getInstance().getTaskReward(this,id);
//        }else if(PIE_COIN.equals(type)) {
//            isDouble = 1;
//            taskID = StepUserManager.TaskID.TASK_ID_SLOT;
//            loadRandomCoinAd(RANDOM_AD_ID);
//            User user = StepUserManager.getInstance().getUserInfo();
//            if(user == null)
//                return;
//            String coin = getIntent().getStringExtra("coin");
//            TextView textView2 = findViewById(R.id.ad_text_unit);
//            textView2.setText("+"+coin);
//            TextView textView = findViewById(R.id.ad_text);
//            textView.setText(getResources().getString(R.string.luck_reward));
//            loadVideoAd(coin);
//            findViewById(R.id.video_double_coin).setVisibility(View.VISIBLE);
//            findViewById(R.id.video_double_coin).setEnabled(true);
//            ((TextView)findViewById(R.id.video_double_coin)).setText(getResources().getString(R.string.video_double_coin));
//            findViewById(R.id.video_double_coin).setOnClickListener(new View.OnClickListener() {
//                @Override
//                public void onClick(View v) {
//                   if(videoAd.isAdLoaded())
//                       videoAd.showAd(AdActivity.this,0);
//                }
//            });
//
//            TextView ad_text_coin = findViewById(R.id.ad_text_coin);
//            String moneyText = getResources().getString(R.string.get_coin_in_ad_activity);
//            moneyText = String.format(moneyText, String.valueOf((int)user.getBalance()),StepUserManager.coinToMoney(user.getBalance()));
//            ad_text_coin.setText(moneyText);
//
//            StepUserManager.getInstance().getTaskReward(this, StepUserManager.TaskID.TASK_ID_SLOT);
//        }else if(SYNC_STEP.equals(type)) {
//            isDouble = 0;
//            loadRandomCoinAd(RANDOM_AD_ID);
//            ((TextView)findViewById(R.id.video_double_coin)).setText(getResources().getString(R.string.sure_get_coin));
//            findViewById(R.id.video_double_coin).setEnabled(true);
//            findViewById(R.id.video_double_coin).setOnClickListener(new View.OnClickListener() {
//                @Override
//                public void onClick(View v) {
//                    finish();
//                }
//            });
//            User user = StepUserManager.getInstance().getUserInfo();
//            if(user == null)
//                return;
//            String coin = getIntent().getStringExtra("coin");
//            TextView textView = findViewById(R.id.ad_text);
//            textView.setText(getResources().getString(R.string.get_sync_step_reward));
//
//            findViewById(R.id.layout_coin_num).setVisibility(View.GONE);
//
//            TextView ad_text_coin = findViewById(R.id.ad_text_coin);
//            String moneyText = getResources().getString(R.string.get_coin_in_ad_activity);
//            moneyText = String.format(moneyText, String.valueOf((int)user.getBalance()),StepUserManager.coinToMoney(user.getBalance()));
//            ad_text_coin.setText(moneyText);
//        }else if(SYNC_STEP_TASK.equals(type)) {
//            final int id = getIntent().getIntExtra(TASK_ID,0);
//            isDouble = 1;
//            taskID = id;
//            loadRandomCoinAd(RANDOM_AD_ID);
//            int coinNum = getIntent().getIntExtra(COIN_NUM,0);
//            loadVideoAd(String.valueOf(coinNum));
//            TextView textView = findViewById(R.id.ad_text);
//            textView.setText(getResources().getString(R.string.get_step_target_reward));
//            TextView textView2 = findViewById(R.id.ad_text_unit);
//            textView2.setText("+"+coinNum);
//
//            TextView ad_text_coin = findViewById(R.id.ad_text_coin);
//            String moneyText = getResources().getString(R.string.get_coin_in_ad_activity);
//            ((TextView)findViewById(R.id.video_double_coin)).setText(getResources().getString(R.string.sure_get_coin));
//            User user = StepUserManager.getInstance().getUserInfo();
//            if(user == null)
//                return;
//            moneyText = String.format(moneyText, String.valueOf((int)user.getBalance()),StepUserManager.coinToMoney(user.getBalance()));
//            ad_text_coin.setText(moneyText);
//            findViewById(R.id.video_double_coin).setVisibility(View.VISIBLE);
//            findViewById(R.id.video_double_coin).setEnabled(true);
//            ((TextView)findViewById(R.id.video_double_coin)).setText(getResources().getString(R.string.video_double_coin));
//            findViewById(R.id.video_double_coin).setOnClickListener(new View.OnClickListener() {
//                @Override
//                public void onClick(View v) {
//                    if(videoAd.isAdLoaded())
//                        videoAd.showAd(AdActivity.this,0);
//                }
//            });
//            StepUserManager.getInstance().getTaskReward(this,id);
//        }else if(GET_MONEY.equals(type)) {
//            loadRandomCoinAd(RANDOM_AD_ID);
//            findViewById(R.id.video_double_coin).setVisibility(View.GONE);
//            User user = StepUserManager.getInstance().getUserInfo();
//            if(user == null)
//                return;
//            TextView textView = findViewById(R.id.ad_text);
//            textView.setText(getResources().getString(R.string.get_money_hint));
//
//            findViewById(R.id.layout_coin_num).setVisibility(View.GONE);
//
//            TextView ad_text_coin = findViewById(R.id.ad_text_coin);
//            String moneyText = getResources().getString(R.string.get_coin_in_ad_activity);
//            moneyText = String.format(moneyText, String.valueOf((int)user.getBalance()),StepUserManager.coinToMoney(user.getBalance()));
//            ad_text_coin.setText(moneyText);
//        }else if(SIGN_REQUEST.equals(type)){
//            loadRandomCoinAd(RANDOM_AD_ID);
//            findViewById(R.id.video_double_coin).setVisibility(View.GONE);
//            TextView textView = findViewById(R.id.ad_text);
//            textView.setText(getResources().getString(R.string.sgin_success));
//
//            int coinNum = getIntent().getIntExtra(COIN_NUM,0);
//            TextView textView2 = findViewById(R.id.ad_text_unit);
//            textView2.setText("+"+coinNum);
//
//            User user = StepUserManager.getInstance().getUserInfo();
//            if(user == null)
//                return;
//
//            TextView ad_text_coin = findViewById(R.id.ad_text_coin);
//            String moneyText = getResources().getString(R.string.get_coin_in_ad_activity);
//            moneyText = String.format(moneyText, String.valueOf((int)user.getBalance()),StepUserManager.coinToMoney(user.getBalance()));
//            ad_text_coin.setText(moneyText);
//
//            StepUserManager.getInstance().signRequest(this);
//        }
//
//        adHandler.sendEmptyMessageDelayed(1,1000);
//        if(!StepApplication.getInstance().isShowAd()) {
//            findViewById(R.id.video_double_coin).setVisibility(View.GONE);
//        }
//    }
//
//    private void loadRandomCoinAd(String adId){
//        if(!StepApplication.getInstance().isShowAd()) {
//            return;
//        }
//        View view = findViewById(R.id.ad_layout);
//        view.post(new Runnable() {
//            @Override
//            public void run() {
//                float width = view.getWidth();
//                int dp = Utils.px2dip(AdActivity.this,width)-20;
//                String userId = StepUserManager.getInstance().getUserId(AdActivity.this);
//                if(TextUtils.isEmpty(userId)){
//                    userId = "steps";
//                }
//                TTAdNative mTTAdNative = TTAdSdk.getAdManager().createAdNative(AdActivity.this);
//                AdSlot adSlot = new AdSlot.Builder()
//                        .setCodeId(adId)
//                        .setSupportDeepLink(true)
//                        .setExpressViewAcceptedSize(dp, (dp*5)/7)
//                        .setImageAcceptedSize(320, 320)
//                        .setAdCount(1) //请求广告数量为1到3条
//                        .setOrientation(TTAdConstant.VERTICAL)
//                        .setUserID(userId)
//                        .build();
//                mTTAdNative.loadNativeExpressAd(adSlot, new TTAdNative.NativeExpressAdListener() {
//                    @Override
//                    public void onError(int code, String message) {
//                        EyeLog.loge("loadExpressDrawFeedAd onError:"+message+",code:"+code);
//                        canReturn = true;
//                    }
//
//                    @Override
//                    public void onNativeExpressAdLoad(List<TTNativeExpressAd> list) {
//                        if (list == null || list.isEmpty()) {
//                            EyeLog.loge("on loadExpressDrawFeedAd: ad is null!");
//                            return;
//                        }
//                        buildRandomCoinAd(list.get(0));
//                    }
//                });
//            }
//        });
//    }
//
//    private void buildRandomCoinAd(final TTNativeExpressAd ad){
//        ad.setExpressInteractionListener(new TTNativeExpressAd.ExpressAdInteractionListener() {
//            @Override
//            public void onAdClicked(View view, int type) {
//                EyeLog.logi("广告被点击");
//            }
//
//            @Override
//            public void onAdShow(View view, int type) {
//                EyeLog.logi("广告展示");
//            }
//
//            @Override
//            public void onRenderFail(View view, String msg, int code) {
//                EyeLog.logi("render fail:"+msg);
//                canReturn = true;
//            }
//
//            @Override
//            public void onRenderSuccess(View view, float width, float height) {
//                //返回view的宽高 单位 dp
//                EyeLog.logi( "渲染成功 width:"+width+",height:"+height);
//                drawable = new GradientDrawable();
//                int r = (int)getResources().getDimension(R.dimen.padding_10);
//                drawable.setColor(Color.WHITE);
//                drawable.setStroke(15, Color.BLUE);
//                drawable.setCornerRadius(r);
//                adArea.setBackground(drawable);
//
//                valueAnimator = ValueAnimator.ofInt(0, 150);
//                valueAnimator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
//                    @Override
//                    public void onAnimationUpdate(ValueAnimator animation) {
//                        int color = (int) animation.getAnimatedValue();
//                        drawable.setStroke(15, Color.rgb(50+color,240-color,100+color));
//                        adArea.setBackground(drawable);
//                    }
//                });
//                valueAnimator.setDuration(3000);
//                valueAnimator.setRepeatCount(ValueAnimator.INFINITE);//无限循环
//                valueAnimator.setRepeatMode(ValueAnimator.REVERSE);
//                valueAnimator.start();
//
//                ProgressBar pb = findViewById(R.id.progress_bar);
//                pb.clearAnimation();
//                adArea.removeAllViews();
//                adArea.addView(ad.getExpressAdView());
//                adArea.setVisibility(View.VISIBLE);
//            }
//        });
//        ad.render();
//    }
//
//    private void loadVideoAd(String coin){
//        findViewById(R.id.video_double_coin).setEnabled(false);
//        findViewById(R.id.video_double_coin).setBackgroundResource(R.drawable.press_background_already_get);
//        initShowVideoAd(coin);
//    }
//
//    private VideoAd videoAd;
//
//    public void initShowVideoAd(String coin){
//        videoAd = new VideoAd();
//        videoAd.setAdId(VIDEO_AD_ID,isDouble,taskID);
//        videoAd.initAd(this,new AdListener(){
//
//            @Override
//            public void adLoad() {
//                super.adLoad();
//            }
//
//            @Override
//            public void onRewarded() {
//                super.onRewarded();
//            }
//
//            @Override
//            public void onRewardedSuccess(boolean isSuccess) {
//                super.onRewardedSuccess(isSuccess);
//                if(isSuccess) {
//
//                    String hint = getResources().getString(R.string.double_coin_hint);
//                    hint = String.format(hint,coin);
//                    Toast.makeText(AdActivity.this, hint, Toast.LENGTH_SHORT).show();
//                    StepUserManager.getInstance().getUserInfoBYUserId(AdActivity.this);
//                }else{
//                    Toast.makeText(AdActivity.this, getResources().getString(R.string.double_coin_fail_hint), Toast.LENGTH_SHORT).show();
//                }
//            }
//
//            @Override
//            public void adClose() {
//                super.adClose();
//
//                finish();
//            }
//
//            @Override
//            public void adError(String error) {
//                super.adError(error);
//                Toast.makeText(AdActivity.this,getResources().getString(R.string.no_video_ad),Toast.LENGTH_SHORT).show();
//            }
//        });
//    }
//
//    @Override
//    public void onBackPressed() {
//        if(canReturn){
//            super.onBackPressed();
//        }
//    }
}
