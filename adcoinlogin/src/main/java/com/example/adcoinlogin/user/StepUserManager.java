package com.example.adcoinlogin.user;

import android.content.Context;
import android.util.Log;

import com.tencent.mm.opensdk.modelbiz.WXLaunchMiniProgram;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.text.NumberFormat;
import java.util.concurrent.CopyOnWriteArrayList;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

public class StepUserManager {

    private static StepUserManager stepUserManager;
    private boolean logined = false;
    private int coinNumber = 600;
    private String moneyNumber = "";
    private String userId = "";
    private String userName = "";
    private int todaySteps = 6000;
    private static final String MINI_PRO_ID = "gh_ede3585ca91c";
    private String WX_APP_ID = "";
    private String WX_APP_SECRET = "";

    private StepUserManager(){

    }

    public synchronized static StepUserManager getInstance(){
        if(stepUserManager == null){
            stepUserManager = new StepUserManager();
        }
        return stepUserManager;
    }

    public void initWXLoginID(String appID,String appSecret){
        WX_APP_ID = appID;
        WX_APP_SECRET = appSecret;
    }

    public boolean isLogined() {
        return logined;
    }

    public void setLogined(boolean logined) {
        this.logined = logined;
    }

    public int getCoinNumber() {
        return coinNumber;
    }

    public void setCoinNumber(int coinNumber) {
        this.coinNumber = coinNumber;
    }

    public String getMoneyNumber() {
        return moneyNumber;
    }

    public void setMoneyNumber(String moneyNumber) {
        this.moneyNumber = moneyNumber;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public int getTodaySteps() {
        return todaySteps;
    }

    public void setTodaySteps(int todaySteps) {
        this.todaySteps = todaySteps;
    }

    public static String coinToMoney(int coin){
        NumberFormat nf = NumberFormat.getNumberInstance();
        nf.setMaximumFractionDigits(2);
        return nf.format(((float)coin)/((float)10000));
    }

    public static int stepToCoin(int step){
        return (int)(((float)step/(float) 1500)*80);
    }




    public void getWXAccessToken(String code){
        StringBuffer loginUrl = new StringBuffer();
        loginUrl.append("https://api.weixin.qq.com/sns/oauth2/access_token")
                .append("?appid=")
                .append(WX_APP_ID)
                .append("&secret=")
                .append(WX_APP_SECRET)
                .append("&code=")
                .append(code)
                .append("&grant_type=authorization_code");
        Log.d("steps", loginUrl.toString());

        OkHttpClient okHttpClient = new OkHttpClient();
        final Request request = new Request.Builder()
                .url(loginUrl.toString())
                .get()//默认就是GET请求，可以不写
                .build();
        Call call = okHttpClient.newCall(request);
        call.enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                Log.d("steps", "onFailure: "+e.getMessage());
                for (LoginListener loginListener:loginListeners) {
                    if(loginListener != null)
                        loginListener.onWXLoginError(e.getMessage());
                }
            }

            @Override
            public void onResponse(Call call, Response response) throws IOException {
                String responseInfo= response.body().string();
                Log.d("steps", "onResponse: " +responseInfo);
                String access = null;
                String openId = null;
                try {
                    JSONObject jsonObject = new JSONObject(responseInfo);
                    access = jsonObject.getString("access_token");
                    openId = jsonObject.getString("openid");
                    for (LoginListener loginListener:loginListeners) {
                        if(loginListener != null)
                            loginListener.onGetToken(access,openId);
                    }
                } catch (JSONException e) {
                    for (LoginListener loginListener:loginListeners) {
                        if(loginListener != null)
                            loginListener.onWXLoginError(e.getMessage());
                    }
                    e.printStackTrace();
                }
                getUserInfo(access, openId);
            }
        });
    }

    public void getUserInfo(String access, String openid) {
        String getUserInfoUrl = "https://api.weixin.qq.com/sns/userinfo?access_token=" + access + "&openid=" + openid;
        OkHttpClient okHttpClient = new OkHttpClient();
        final Request request = new Request.Builder()
                .url(getUserInfoUrl)
                .get()
                .build();
        Call call = okHttpClient.newCall(request);
        call.enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                Log.d("steps", "onFailure: ");
                for (LoginListener loginListener:loginListeners) {
                    if (loginListener != null)
                        loginListener.onWXLoginError(e.getMessage());
                }
            }

            @Override
            public void onResponse(Call call, Response response) throws IOException {
                String responseInfo = response.body().string();
                Log.d("steps", "onResponse: " + responseInfo);
                for (LoginListener loginListener:loginListeners) {
                    if(loginListener != null)
                        loginListener.onWXLogin(responseInfo);
                }
            }
        });
    }

    public void launchMiniPro(Context context){
        String appId = WX_APP_ID; // 填应用AppId
        IWXAPI api = WXAPIFactory.createWXAPI(context, appId);

        WXLaunchMiniProgram.Req req = new WXLaunchMiniProgram.Req();
        req.userName = MINI_PRO_ID; // 填小程序原始id
        req.path = "pages/daka/daka?isapp=1";                  ////拉起小程序页面的可带参路径，不填默认拉起小程序首页
        req.miniprogramType = WXLaunchMiniProgram.Req.MINIPROGRAM_TYPE_PREVIEW;// 可选打开 开发版，体验版和正式版
        api.sendReq(req);
        Log.i("StepsUserManager","launchMiniPro mini:"+req.userName+",appId:"+appId);

    }

    private CopyOnWriteArrayList<LoginListener> loginListeners = new CopyOnWriteArrayList<>();

    public void setLoginListener(LoginListener loginListener){
        if(!loginListeners.contains(loginListener)){
            loginListeners.add(loginListener);
        }
    }

    public void removeLoginListener(LoginListener loginListener){
        if(loginListeners.contains(loginListener)){
            loginListeners.remove(loginListener);
        }
    }

    public interface LoginListener{
        void onWXLogin(String info);

        void onWXLoginError(String info);

        void onGetToken(String access, String openid);
    }
}
