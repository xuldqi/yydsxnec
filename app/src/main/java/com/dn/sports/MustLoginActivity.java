package com.dn.sports;

import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.Nullable;

import com.dn.sports.adcoinLogin.LoginListener;
import com.dn.sports.adcoinLogin.StepUserManager;
import com.dn.sports.adcoinLogin.model.User;
import com.dn.sports.common.BaseActivity;
import com.dn.sports.common.Constant;
import com.dn.sports.utils.Utils;
import com.tencent.mm.opensdk.modelmsg.SendAuth;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

public class MustLoginActivity extends BaseActivity {

    private IWXAPI api;

    private LoginListener loginListener = new LoginListener(){
        @Override
        public void onLogin(User info, boolean needUpdate) {
            super.onLogin(info, needUpdate);
            finish();
            StepUserManager.getInstance().setIsMustNeedLogin(false);
        }
    };

    private void initWXLogin(){
        api = WXAPIFactory.createWXAPI(this, Constant.WX_LOGIN.getWxAppId(this),true);
        api.registerApp( Constant.WX_LOGIN.getWxAppId(this));
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_must_login);
//        initWXLogin();
//        StepUserManager.getInstance().setLoginListener(loginListener);
//        ((TextView)findViewById(R.id.app_title)).setText(Utils.getTopTitleName(this));
//        findViewById(R.id.wx_login).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                final SendAuth.Req req = new SendAuth.Req();
//                req.scope = "snsapi_userinfo";
//                req.state = "wechat_sdk_demo_test";
//                api.sendReq(req);
//            }
//        });
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        StepApplication.getInstance().exit();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        StepUserManager.getInstance().removeLoginListener(loginListener);
    }
}
