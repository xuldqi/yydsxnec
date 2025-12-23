package com.dn.sports.wxapi;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;

import com.dn.sports.MainActivity;
import com.dn.sports.R;
import com.dn.sports.adcoinLogin.StepUserManager;
import com.dn.sports.common.CheckPermission;
import com.dn.sports.common.Constant;
import com.dn.sports.common.UmengLog;
import com.dn.sports.utils.Utils;
import com.tencent.mm.opensdk.constants.ConstantsAPI;
import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.modelbiz.WXLaunchMiniProgram;
import com.tencent.mm.opensdk.modelmsg.SendAuth;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

public class WXEntryActivity extends Activity implements IWXAPIEventHandler {

    private IWXAPI api;

    @Override
    protected void onCreate( Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        api = WXAPIFactory.createWXAPI(this,  Constant.WX_LOGIN.getWxAppId(this),true);
        api.registerApp(Constant.WX_LOGIN.getWxAppId(this));
        //注意：
        //第三方开发者如果使用透明界面来实现WXEntryActivity，需要判断handleIntent的返回值，如果返回值为false，则说明入参不合法未被SDK处理，应finish当前透明界面，避免外部通过传递非法参数的Intent导致停留在透明界面，引起用户的疑惑
        try {
            boolean result =  api.handleIntent(getIntent(), this);
            if(!result){
                Log.d("WXEntryActivity","参数不合法，未被SDK处理，退出");
                finish();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        api.handleIntent(data,this);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        api.handleIntent(intent, this);
        finish();
    }

    @Override
    public void onReq(BaseReq resp) {
    }

    @Override
    public void onResp(BaseResp baseResp) {
        Log.i("WXEntryActivity", "onResp:"+baseResp.errCode+","+baseResp.getClass());
        //Toast.makeText(this, "onResp:"+baseResp.errCode+","+baseResp.getClass(), Toast.LENGTH_SHORT).show();
        if (baseResp instanceof WXLaunchMiniProgram.Resp) {
            WXLaunchMiniProgram.Resp launchMiniProResp = (WXLaunchMiniProgram.Resp) baseResp;
            String extraData = launchMiniProResp.extMsg;
            Log.d("WXEntryActivity","extraData:"+extraData);
            UmengLog.logEvent(getApplicationContext(),UmengLog.ID.SYNC_STEP);
            try {
                StepUserManager.getInstance().checkWXSteps(extraData);
                if(Integer.parseInt(extraData)>StepUserManager.getInstance().getTodaySteps()){
                    StepUserManager.getInstance().setTodaySteps(this,extraData);


                    Intent intent = new Intent(this, MainActivity.class);
                    this.startActivity(intent);
                }else{
                    finish();
                }
                //StepUserManager.getInstance().syncSteps(getApplicationContext(),StepUserManager.getInstance().getTodaySteps()+"");
            }catch (Exception e){
                e.printStackTrace();
            }
            return;
        }
        //登录回调
        switch (baseResp.errCode) {
            case BaseResp.ErrCode.ERR_OK:
                String code = ((SendAuth.Resp) baseResp).code;
                getAccessToken(code);
                Log.d("WXEntryActivity", code.toString()+ "");
                finish();
                break;
            case BaseResp.ErrCode.ERR_AUTH_DENIED://用户拒绝授权
            case BaseResp.ErrCode.ERR_USER_CANCEL://用户取消
                finish();
                break;
            case ConstantsAPI.COMMAND_LAUNCH_WX_MINIPROGRAM:
                Log.d("WXEntryActivity", "COMMAND_LAUNCH_WX_MINIPROGRAM："+baseResp.getClass());
//                WXLaunchMiniProgram.Resp launchMiniProResp = (WXLaunchMiniProgram.Resp) baseResp;
//                String extraData = launchMiniProResp.extMsg;

                //Log.d("WXEntryActivity","extraData:"+extraData);
                break;
            default:
                finish();
                break;
        }
    }

    private void getAccessToken(String code){
        UmengLog.logEvent(getApplicationContext(),UmengLog.ID.LOGIN);
        String deviceId = (String)Utils.get(this,StepUserManager.USER_ID_KEY,"");
        if(TextUtils.isEmpty(deviceId)){
            StepUserManager.getInstance().registerByCodeOrAndroidId(this,code);
        }else {
            StepUserManager.getInstance().register(this, code, deviceId);
        }
    }
}
