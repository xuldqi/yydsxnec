package com.dn.sports;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.format.DateFormat;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.dn.sports.adcoinLogin.LoginListener;
import com.dn.sports.adcoinLogin.StepUserManager;
import com.dn.sports.adcoinLogin.chuanshanjia.VideoAd;
import com.dn.sports.adcoinLogin.common.AdListener;
import com.dn.sports.adcoinLogin.model.SignRecord;
import com.dn.sports.adcoinLogin.model.User;
import com.dn.sports.common.BaseActivity;
import com.dn.sports.common.Constant;
import com.dn.sports.common.EyeLog;
import com.dn.sports.common.UmengLog;
import com.dn.sports.dialog.ProgressDialog;
import com.dn.sports.utils.DateTest;
import com.dn.sports.utils.Utils;
import com.dn.sports.view.SignItem;
import com.tencent.mm.opensdk.modelmsg.SendAuth;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class SignActivity extends BaseActivity {
    private Handler mainHandler = new Handler(Looper.getMainLooper());
    private ProgressDialog dialog = null;
    private List<SignItem> signItems = new ArrayList<>();

    private LoginListener loginListener = new LoginListener(){
        @Override
        public void onSign() {
            super.onSign();
            StepUserManager.getInstance().getUserInfoBYUserId(SignActivity.this);
            Toast.makeText(StepApplication.getInstance(),getResources().getString(R.string.sign_ok),Toast.LENGTH_SHORT).show();

            String todayDate = DateFormat.format("MM-dd",Calendar.getInstance().getTime()).toString();
            for(SignItem item:signItems){
                if(item.isSameDate(todayDate)) {
                    item.setTodayIsSign(true);
                }
            }
        }

        @Override
        public void onSignList(List<SignRecord> datas) {
            super.onSignList(datas);
            for(SignRecord signRecord:datas){
                EyeLog.logi(signRecord.toString());
                for(SignItem item:signItems){
                    item.checkIsSign(signRecord);
                }
            }
        }

        @Override
        public void onAlreadySign() {
            super.onAlreadySign();
            Toast.makeText(StepApplication.getInstance(),getResources().getString(R.string.sign_already),Toast.LENGTH_SHORT).show();
        }

        @Override
        public void onError(int msg, String info) {
            super.onError(msg, info);
        }
    };

    private void updateData(){
        User signUserInfo = StepUserManager.getInstance().getUserInfo();
        if(StepUserManager.getInstance().isNeedLogin() || signUserInfo == null) {
            return;
        }
        String money = signUserInfo.getBalance()+"";
        ((TextView) findViewById(R.id.current_money)).setText(getResources().getString(R.string.sgin_total_money)+money);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_sign);
        initWXLogin();
        findViewById(R.id.root).setPadding(0, Utils.getStatusBarHeight(this),0,0);
        ((TextView) findViewById(R.id.title)).setText(getResources().getString(R.string.today_sgin));
        ((TextView) findViewById(R.id.title)).setTextColor(Color.WHITE);
        ((ImageView)findViewById(R.id.back_btn)).setImageResource(R.mipmap.back_btn_white);
        findViewById(R.id.back_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        StepUserManager.getInstance().setLoginListener(loginListener);
        StepUserManager.getInstance().signRequestList(this);

        //updateData();

        signItems.add(findViewById(R.id.sign_item_1));
        signItems.add(findViewById(R.id.sign_item_2));
        signItems.add(findViewById(R.id.sign_item_3));
        signItems.add(findViewById(R.id.sign_item_4));
        signItems.add(findViewById(R.id.sign_item_5));
        signItems.add(findViewById(R.id.sign_item_6));
        signItems.add(findViewById(R.id.sign_item_7));


        String todayDate = DateFormat.format("MM-dd",Calendar.getInstance().getTime()).toString();
        EyeLog.logi("todayDate:"+todayDate);
        List<DateTest.WeekDay> weekDays = DateTest.getWeekDay();
        int i = 0;
        boolean isToToday = false;
        for(DateTest.WeekDay item:weekDays){
            signItems.get(i).setWeekDay(item,isToToday);
            if(item.day.equals(todayDate)){
                isToToday = true;
            }
            i = i+1;
        }

        for(SignItem item:signItems){
            if(item.isSameDate(todayDate)) {
                item.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        //不展示广告直接签到
                        if(!StepApplication.getInstance().isShowAd()){
                            Intent it = new Intent(SignActivity.this, AdActivity.class);
//                            it.putExtra(AdActivity.AD_TYPE,AdActivity.SIGN_REQUEST);
//                            it.putExtra(AdActivity.COIN_NUM,120);
                            startActivity(it);
                            return;
                        }

                        if(videoAd.isAdLoaded()){
                            UmengLog.logEvent(getApplicationContext(),UmengLog.ID.SIGN_REQUEST);
                            videoAd.showAd(SignActivity.this,0);
                        }else{
                            Toast.makeText(SignActivity.this,getResources().getString(R.string.no_video_ad),Toast.LENGTH_SHORT).show();
                        }
                    }
                });
            }
        }

        mainHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                dialog = ProgressDialog.createDialog(SignActivity.this);
                dialog.show();
                initShowVideoAd();
            }
        },100);

        mainHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                if(dialog != null&&dialog.isShowing())
                    dialog.dismiss();
                Toast.makeText(SignActivity.this,getResources().getString(R.string.no_video_ad),Toast.LENGTH_SHORT).show();
            }
        },8000);


        Date date = new Date();
        EyeLog.logi(DateFormat.format("MM-dd", date).toString());

    }

    private IWXAPI api;
    private void initWXLogin(){
        api = WXAPIFactory.createWXAPI(this, Constant.WX_LOGIN.getWxAppId(this),true);
        api.registerApp(Constant.WX_LOGIN.getWxAppId(this));
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        StepUserManager.getInstance().removeLoginListener(loginListener);
    }

    private VideoAd videoAd;
    private boolean isSigned = false;

    public void initShowVideoAd(){
        videoAd = new VideoAd();
        videoAd.setAdId("944570768",0,0);
        videoAd.initAd(this,new AdListener(){

            @Override
            public void adLoad() {
                super.adLoad();
                mainHandler.removeCallbacksAndMessages(null);
                if(dialog != null&&dialog.isShowing())
                    dialog.dismiss();
            }

            @Override
            public void onRewarded() {
                super.onRewarded();
                UmengLog.logEvent(getApplicationContext(),UmengLog.ID.SIGN);
                isSigned = true;
            }

            @Override
            public void adClose() {
                super.adClose();
                if(isSigned){
                    isSigned = false;
                    Intent it = new Intent(SignActivity.this, AdActivity.class);
//                    it.putExtra(AdActivity.AD_TYPE,AdActivity.SIGN_REQUEST);
//                    it.putExtra(AdActivity.COIN_NUM,120);
                    startActivity(it);
                }else{
                    Toast.makeText(SignActivity.this,getResources().getString(R.string.sgin_failed),Toast.LENGTH_SHORT).show();
                }
            }

            @Override
            public void adError(String error) {
                super.adError(error);
                if(dialog != null&&dialog.isShowing())
                    dialog.dismiss();
                Toast.makeText(SignActivity.this,getResources().getString(R.string.no_video_ad),Toast.LENGTH_SHORT).show();
            }
        });
    }
}
