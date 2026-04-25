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
        Toast.makeText(this, "当前版本已关闭签到广告页", Toast.LENGTH_SHORT).show();
        finish();
        return;
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
