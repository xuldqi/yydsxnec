package com.dn.sports.adcoinLogin;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.Log;

import com.alibaba.fastjson.JSON;
import com.google.gson.Gson;
import com.dn.sports.MainActivity;
import com.dn.sports.StepApplication;
import com.dn.sports.adcoinLogin.http.HttpManager;
import com.dn.sports.adcoinLogin.http.HttpRequester;
import com.dn.sports.adcoinLogin.model.CoinRecord;
import com.dn.sports.adcoinLogin.model.RandomCoin;
import com.dn.sports.adcoinLogin.model.ShareRecord;
import com.dn.sports.adcoinLogin.model.SignRecord;
import com.dn.sports.adcoinLogin.model.StepsRecord;
import com.dn.sports.adcoinLogin.model.TaskModel;
import com.dn.sports.adcoinLogin.model.User;
import com.dn.sports.common.CheckPermission;
import com.dn.sports.common.Constant;
import com.dn.sports.common.EyeLog;
import com.dn.sports.common.LogUtils;
import com.dn.sports.greendao.DbHelper;
import com.dn.sports.utils.DateUtils;
import com.dn.sports.utils.Utils;
import com.tencent.mm.opensdk.modelbiz.WXLaunchMiniProgram;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.Serializable;
import java.text.NumberFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Random;
import java.util.UUID;
import java.util.concurrent.CopyOnWriteArrayList;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.internal.Util;
import retrofit2.Retrofit;

public class StepUserManager {

    public static class TaskID {
        public static final int TASK_ID_FIRST_LOGIN = 1;
        public static final int TASK_ID_SYNC_STEP = 2;
        public static final int TASK_ID_WATCH_AD = 3;
        public static final int TASK_ID_STEP_TOTAL_TARGET = 4;
        public static final int TASK_ID_STEP_TARGET1 = 5;
        public static final int TASK_ID_STEP_TARGET2 = 6;
        public static final int TASK_ID_STEP_TARGET3 = 7;
        public static final int TASK_ID_INVITE1 = 8;
        public static final int TASK_ID_INVITE2 = 9;
        public static final int TASK_ID_INVITE3 = 10;
        public static final int TASK_ID_INVITE4 = 11;
        public static final int TASK_ID_INVITE5 = 12;
        public static final int TASK_ID_SHARE_APP = 13;
        public static final int TASK_ID_FIRST_SIGN = 14;
        public static final int TASK_ID_CON_SIGN_CONTNUE1 = 15;
        public static final int TASK_ID_CON_SIGN_CONTNUE2 = 16;
        public static final int TASK_ID_TOTAL_GOLD1 = 17;
        public static final int TASK_ID_TOTAL_GOLD2 = 18;
        public static final int TASK_ID_TOTAL_GOLD3 = 19;
        public static final int TASK_ID_WRITE_INVITE = 20;
        public static final int TASK_ID_FIRST_GET_CASH = 21;
        public static final int TASK_ID_SLOT = 22;
        public static final int TASK_ID_STEP_DAY_TARGET1= 23;//1500步
        public static final int TASK_ID_STEP_DAY_TARGET2= 24;//3000步
        public static final int TASK_ID_STEP_DAY_TARGET3= 25;//4500步
        public static final int TASK_ID_STEP_DAY_TARGET4= 26;//6000步
    }

    private static StepUserManager stepUserManager;
    //今天的步数
    private int todaySteps = 0;
    //App打开的第一次读取到的步数
    private int appFirstOpenTodaySteps = 0;
    //今天第一次打开App的系统步数，方便计算今天的步数
    private int todayFirstSteps = 0;
    // 自系统开机以来STEP_COUNTER检测到的步数
    private int mStepCounter = 0;
    //是不是App进程刚刚打开
    private boolean reCheckSteps = true;
    public static final String TODAY_FIRST_STEP_NUM = "TODAY_FIRST_STEP_NUM";
    public static final String TODAY_TODAY_STEP_NUM = "TODAY_TODAY_STEP_NUM";
    private User mUser;
    private static final String MINI_PRO_ID = "gh_ede3585ca91c";
    public static final String USER_ID_KEY = "USER_ID_KEY";
    private static final String IS_ALREADY_EXIT_LOGIN = "IS_ALREADY_EXIT_LOGIN";
    private String WX_APP_ID = "";
    private String WX_APP_SECRET = "";
    private CopyOnWriteArrayList<TaskModel> mTasks = new CopyOnWriteArrayList<>();
    private CopyOnWriteArrayList<LoginListener> loginListeners = new CopyOnWriteArrayList<>();
    private SensorManager mSensorManager;
    private MySensorEventListener mListener;
    //是不是今天第一次打开App的标志位
    private boolean isTodayFirstTime = true;
    public static final String IS_TODAY_FIRST_TIME = "is_today_first_time";
    private static final String STEP_NUM_LIMIT = "STEP_NUM_LIMIT";

    //领取金币的步数限制
    public void setSyncStepNumLimit(int num){
        Utils.put(StepApplication.getInstance(),STEP_NUM_LIMIT,num);
    }

    //领取金币的步数限制
    public int getSyncStepNumLimit(){
        return (int)Utils.get(StepApplication.getInstance(),STEP_NUM_LIMIT,1500);
    }

    //步数更新回调
    class MySensorEventListener implements SensorEventListener {
        @Override
        public void onSensorChanged(SensorEvent event) {
            if (event.sensor.getType() == Sensor.TYPE_STEP_COUNTER) {
                mStepCounter = (int) event.values[0];

                //是第一次打开的话需要记录状态值
                if (isTodayFirstTime) {
                    isTodayFirstTime = false;
                    String currentDate = DateUtils.getYMD(0);
                    todayFirstSteps = mStepCounter;
                    Utils.put(StepApplication.getInstance(), IS_TODAY_FIRST_TIME, currentDate);
                    Utils.put(StepApplication.getInstance(), TODAY_FIRST_STEP_NUM, todayFirstSteps);
//                    EyeLog.logi("a今天的步数:"+todaySteps+",当前系统步数:"+mStepCounter+",App第一打开系统步数:"+todayFirstSteps
//                            +",App第一次打开步数:"+appFirstOpenTodaySteps+",随机步数:"+todayRandomSteps);
                }

                if(reCheckSteps){
                    reCheckSteps = false;
                    //本次App打开的的时候的系统步数
                    todayFirstSteps = (int)Utils.get(StepApplication.getInstance(),TODAY_FIRST_STEP_NUM,0);
                    appFirstOpenTodaySteps = (int)Utils.get(StepApplication.getInstance(),TODAY_TODAY_STEP_NUM,0);
                    if(mStepCounter < todayFirstSteps){
                        todayFirstSteps = mStepCounter;
                        Utils.put(StepApplication.getInstance(),TODAY_FIRST_STEP_NUM,todayFirstSteps);
                    }
                    todaySteps = appFirstOpenTodaySteps + mStepCounter - todayFirstSteps;
                    todayFirstSteps = mStepCounter;
                    Utils.put(StepApplication.getInstance(), TODAY_TODAY_STEP_NUM, todaySteps);
                    Utils.put(StepApplication.getInstance(), TODAY_FIRST_STEP_NUM, mStepCounter);
                    EyeLog.logi("StepsNum c今天的步数:" + todaySteps + ",当前系统步数:" + mStepCounter + ",App第一打开系统步数:" + todayFirstSteps
                            + ",App第一次打开步数:" + appFirstOpenTodaySteps);
                }else {
                    //当前的系统步数-打开App时的系统步数+打开App时候的步数记录=当前步数
                    todaySteps = appFirstOpenTodaySteps + mStepCounter - todayFirstSteps;
                    EyeLog.logi("StepsNum b今天的步数:" + todaySteps + ",当前系统步数:" + mStepCounter + ",App第一打开系统步数:" + todayFirstSteps
                            + ",App第一次打开步数:" + appFirstOpenTodaySteps);
                    Utils.put(StepApplication.getInstance(), TODAY_TODAY_STEP_NUM, todaySteps);
                    Utils.put(StepApplication.getInstance(), TODAY_FIRST_STEP_NUM, mStepCounter);
                }
                DbHelper.saveTodayCount(todaySteps);
                taskHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        for(LoginListener listener:loginListeners) {
                            listener.onStepChange();
                        }
                    }
                });

            }
        }

        @Override
        public void onAccuracyChanged(Sensor sensor, int accuracy) {
        }
    }

    //判断是不是今天第一次打开，同步检查步数
    public void checkIsFirstOpenToday(Context context){
        String currentDate = DateUtils.getYMD(0);
        String m = (String)Utils.get(context,IS_TODAY_FIRST_TIME,"");
        reCheckSteps = true;
        if(!m.equals(currentDate)){
            //是第一次打开
            isTodayFirstTime = true;
            todaySteps = new Random().nextInt(450)+50;
            Utils.put(StepApplication.getInstance(),TODAY_TODAY_STEP_NUM,todaySteps);

            DbHelper.saveTodayCount(todaySteps);
            Utils.put(StepApplication.getInstance(),STEP_NUM_LIMIT,1500);
            EyeLog.logi("StepsNum a今天的步数1:"+todaySteps);
        }else{
            //不是第一次打开
            todaySteps = (int)Utils.get(context,TODAY_TODAY_STEP_NUM,0);
            todayFirstSteps = (int)Utils.get(StepApplication.getInstance(),TODAY_FIRST_STEP_NUM,0);
            isTodayFirstTime = false;
            EyeLog.logi("StepsNum a今天的步数2:"+todaySteps);
        }
        for(LoginListener listener:loginListeners) {
            listener.onStepChange();
        }
        registerStepListener(context);
    }

    private void registerStepListener(Context context){
        mSensorManager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
        if(mListener == null) {
            EyeLog.logi("---注册步数监听器---");
            mListener = new MySensorEventListener();
            mSensorManager.registerListener(mListener, mSensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER),
                    SensorManager.SENSOR_DELAY_FASTEST);
        }
    }

    public void unRegisterStepListener(Context context){
        mSensorManager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
        if(mListener != null) {
            EyeLog.logi("---注销步数监听器---");
            mSensorManager.unregisterListener(mListener);
        }
    }

    public void checkWXSteps(String step){
        try {
            int data = Integer.parseInt(step);
            if(data > todaySteps){
                appFirstOpenTodaySteps = data;
                todaySteps = data;
                todayFirstSteps = mStepCounter;
                Utils.put(StepApplication.getInstance(),TODAY_TODAY_STEP_NUM,data);
                DbHelper.saveTodayCount(todaySteps);

                for(LoginListener listener:loginListeners) {
                    listener.onStepChange();
                }
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }

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

    public void setIsMustNeedLogin(boolean needLogin){
        Utils.put(StepApplication.getInstance(),IS_ALREADY_EXIT_LOGIN,needLogin);
    }

    public boolean isMustNeedLogin(){
//        return (boolean)Utils.get(StepApplication.getInstance(),IS_ALREADY_EXIT_LOGIN,false);
        return false;
    }

    public CopyOnWriteArrayList<TaskModel> getmTasks() {
        return mTasks;
    }

    public TaskModel getSlotTask() {
        if(mTasks == null)
            return null;
        for (TaskModel taskModel:mTasks){
            if(taskModel.getTaskId() == TaskID.TASK_ID_SLOT){
                return taskModel;
            }
        }
        return null;
    }

    private StepUserManager(){

    }

    public synchronized static StepUserManager getInstance(){
        if(stepUserManager == null){
            stepUserManager = new StepUserManager();
        }
        return stepUserManager;
    }

    public User getUserInfo(){
        return mUser;
    }

    public void initWXLoginID(String appID,String appSecret){
        WX_APP_ID = appID;
        WX_APP_SECRET = appSecret;
    }

    public int getTodaySteps() {
        return todaySteps;
    }

    private void setTodaySteps(Context context,int todaySteps) {
        this.todaySteps = todaySteps;
        syncSteps(context,String.valueOf(todaySteps));
    }

    public void setTodaySteps(Context context,String todaySteps) {
        try {
            setTodaySteps(context,Integer.valueOf(todaySteps));
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    public static String coinToMoney(float coin){
        NumberFormat nf = NumberFormat.getNumberInstance();
        nf.setMaximumFractionDigits(2);
        return nf.format((coin)/((float)10000));
    }

    public void launchMiniPro(Context context){
        String appId = WX_APP_ID; // 填应用AppId
        IWXAPI api = WXAPIFactory.createWXAPI(context, appId);

        WXLaunchMiniProgram.Req req = new WXLaunchMiniProgram.Req();
        req.userName = MINI_PRO_ID; // 填小程序原始id
        req.path = "pages/daka/daka?isapp=1";                  ////拉起小程序页面的可带参路径，不填默认拉起小程序首页
        req.miniprogramType = WXLaunchMiniProgram.Req.MINIPTOGRAM_TYPE_RELEASE;// 可选打开 开发版，体验版和正式版
        api.sendReq(req);
        Log.i("StepsUserManager","launchMiniPro mini:"+req.userName+",appId:"+appId);
    }

    public boolean isNeedRegister(Context context){
        String userId = (String)Utils.get(context,USER_ID_KEY,"");
        boolean isAlreadyExit = (boolean) Utils.get(context,IS_ALREADY_EXIT_LOGIN,false);
        return TextUtils.isEmpty(userId) && !isAlreadyExit;
    }

    //a721919b-7b24-46cc-85fe-b4a515b2002e
    public boolean isNeedLogin(){
        if(mUser == null || mUser.getLoginType() == 0){
            return true;
        }
        return false;
    }

    public String getUserId(Context context){
        return  (String)Utils.get(context,USER_ID_KEY,"");
    }

    public void registerByCodeOrAndroidId(Context act,String code){
        String userId = (String)Utils.get(act,USER_ID_KEY,"");
        if(TextUtils.isEmpty(userId)){
            String DEVICE_ID = UUID.randomUUID().toString();
            DEVICE_ID = DEVICE_ID.replace("-","");
            DEVICE_ID = DEVICE_ID.replace("_","");
            Utils.put(act,USER_ID_KEY,DEVICE_ID);
            EyeLog.logd("registerByCodeOrAndroidId DEVICE_ID:"+DEVICE_ID);
            register(act,code,DEVICE_ID);
        }
    }

    public void register(Context context,String code,String devId){
        HashMap<String,Object> params = new HashMap<>();
        params.put("devId",devId);
        params.put("loginToken",code);

        sendTaskToHandler(Ad.Login.MSG_REGISTER,params);
    }

    public void getUserInfoBYUserId(Context context){
        String userId = (String)Utils.get(context,USER_ID_KEY,"");
        HashMap<String,Object> params = new HashMap<>();
        params.put("userId",userId);

        sendTaskToHandler(Ad.Login.MSG_GET_USER_INFO,params);
    }

    public void getCoinRecordList(Context context){
        String userId = (String)Utils.get(context,USER_ID_KEY,"");
        HashMap<String,Object> params = new HashMap<>();
        params.put("userId",userId);

        sendTaskToHandler(Ad.Login.MSG_COIN_RECORD_LIST,params);
    }

    public void modifyUserInfo(Context context,String nickname,String birthday,String tips,int sex,String mobile,String address,int stepTarget){
        String userId = (String)Utils.get(context,USER_ID_KEY,"");
        HashMap<String,Object> params = new HashMap<>();
        params.put("userId",userId);
        params.put("nickname",nickname);
        params.put("birthday",birthday);
        params.put("tips",tips);
        params.put("sex",sex);
        params.put("mobile",mobile);
        params.put("address",address);
        params.put("stepTarget",stepTarget);

        sendTaskToHandler(Ad.Login.MSG_MODIFY_USER_INFO,params);
    }

    public void signRequest(Context context){
        String userId = (String)Utils.get(context,USER_ID_KEY,"");
        HashMap<String,Object> params = new HashMap<>();
        params.put("userId",userId);

        sendTaskToHandler(Ad.Login.MSG_SIGN,params);
    }

    public void signRequestList(Context context){
        String userId = (String)Utils.get(context,USER_ID_KEY,"");
        HashMap<String,Object> params = new HashMap<>();
        params.put("userId",userId);

        sendTaskToHandler(Ad.Login.MSG_SIGN_LIST,params);
    }

    public void inviteFriend(Context context,String otherCode){
        String userId = (String)Utils.get(context,USER_ID_KEY,"");
        HashMap<String,Object> params = new HashMap<>();
        params.put("userId",userId);
        params.put("inviteId",otherCode);

        sendTaskToHandler(Ad.Login.MSG_INVITE_FRIEND,params);
    }

    public void inviteFriendList(Context context,String otherCode){
        String userId = (String)Utils.get(context,USER_ID_KEY,"");
        HashMap<String,Object> params = new HashMap<>();
        params.put("userId",userId);

        sendTaskToHandler(Ad.Login.MSG_INVITE_FRIEND_LIST,params);
    }

    public void getRandomCoinList(Context context){
        String userId = (String)Utils.get(context,USER_ID_KEY,"");
        HashMap<String,Object> params = new HashMap<>();
        params.put("userId",userId);

        sendTaskToHandler(Ad.Login.MSG_GET_RANDOM_COIN_LIST,params);
    }

    public void getRandomCoin(Context context,int goldId){
        String userId = (String)Utils.get(context,USER_ID_KEY,"");
        HashMap<String,Object> params = new HashMap<>();
        params.put("userId",userId);
        params.put("goldId",goldId);

        sendTaskToHandler(Ad.Login.MSG_GET_RANDOM_COIN,params);
    }

    public void uploadShareAction(Context context){
        String userId = (String)Utils.get(context,USER_ID_KEY,"");
        HashMap<String,Object> params = new HashMap<>();
        params.put("userId",userId);

        sendTaskToHandler(Ad.Login.MSG_UPLOAD_SHARE_ACTION,params);
    }

    public void getShareActionList(Context context){
        String userId = (String)Utils.get(context,USER_ID_KEY,"");
        HashMap<String,Object> params = new HashMap<>();
        params.put("userId",userId);

        sendTaskToHandler(Ad.Login.MSG_GET_SHARE_RECORD,params);
    }


    public void syncSteps(Context context,String steps){
        String userId = (String)Utils.get(context,USER_ID_KEY,"");
        HashMap<String,Object> params = new HashMap<>();
        params.put("userId",userId);
        params.put("step",steps);
        sendTaskToHandler(Ad.Login.MSG_SYNC_STEPS,params);
    }

    public void syncStepsList(Context context){
        String userId = (String)Utils.get(context,USER_ID_KEY,"");
        HashMap<String,Object> params = new HashMap<>();
        params.put("userId",userId);

        sendTaskToHandler(Ad.Login.MSG_GET_STEPS_RECORD,params);
    }

    public void getCash(Context context,int mount,String account,String name){
        String userId = (String)Utils.get(context,USER_ID_KEY,"");
        HashMap<String,Object> params = new HashMap<>();
        params.put("userId",userId);
        params.put("mount",mount);
        params.put("account",account);
        params.put("name",name);

        sendTaskToHandler(Ad.Login.MSG_GET_MONEY,params);
    }

    public void getTaskList(Context context){
        String userId = (String)Utils.get(context,USER_ID_KEY,"");
        HashMap<String,Object> params = new HashMap<>();
        params.put("userId",userId);

        sendTaskToHandler(Ad.Login.MSG_GET_TASK_LIST,params);
    }

    public void getTaskReward(Context context,int taskId){
        String userId = (String)Utils.get(context,USER_ID_KEY,"");
        HashMap<String,Object> params = new HashMap<>();
        params.put("userId",userId);
        params.put("taskId",taskId);

        sendTaskToHandler(Ad.Login.MSG_GET_REWARD,params);
    }

    public void getUpdateTask(Context context,int taskId){
        String userId = (String)Utils.get(context,USER_ID_KEY,"");
        HashMap<String,Object> params = new HashMap<>();
        params.put("userId",userId);
        params.put("taskId",taskId);

        sendTaskToHandler(Ad.Login.MSG_UPDATE_TASK,params);
    }

    public void syncTaskResult(Context context,String orderId){
        String userId = (String)Utils.get(context,USER_ID_KEY,"");
        HashMap<String,Object> params = new HashMap<>();
        params.put("userId",userId);
        params.put("orderId",orderId);

        sendTaskToHandler(Ad.Login.MSG_SYNC_TASK_RESULT,params);
    }

    public void exitLogin(Context context){
        String userId = (String)Utils.get(context,USER_ID_KEY,"");
        if(!TextUtils.isEmpty(userId)){
            Utils.put(context,USER_ID_KEY,"");
        }
        if(mUser != null){
            mUser = null;
        }
        Utils.put(context,IS_ALREADY_EXIT_LOGIN,true);
        for(LoginListener listener:loginListeners) {
            listener.onExitLogin();
        }
    }

    public void clearLogin(Context context){
        if(mUser != null){
            mUser = null;
        }
        Utils.put(context,USER_ID_KEY,"");
        Utils.put(context,IS_ALREADY_EXIT_LOGIN,true);
        for(LoginListener listener:loginListeners) {
            listener.onClearLogin();
        }
    }

    private void sendTaskToHandler(int what,HashMap<String,Object> params){
        Message msg = taskHandler.obtainMessage();
        msg.what = what;
        msg.obj = params;
        taskHandler.sendMessage(msg);
    }

    private Handler taskHandler = new Handler(Looper.getMainLooper()){
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            final int msgWhat = msg.what;
            HashMap<String,Object> params = (HashMap<String,Object>)msg.obj;
            final String url = Ad.Login.msgToUrl(msgWhat);
            if(!TextUtils.isEmpty(url) && params!= null){
                EyeLog.logi("Task:"+Ad.Login.msgToString(msgWhat)+",taskHandler url:"+url);
                HttpManager.requestForm(url, params, new HttpRequester.Callback() {
                    @Override
                    public void onFailure(Call call, IOException e) {
                        EyeLog.logi("taskHandler failed = " + e.getMessage() + "task:"+Ad.Login.msgToString(msgWhat));

                        for(LoginListener listener:loginListeners) {
                            listener.onError(msgWhat,e.getMessage());
                        }
                    }

                    @Override
                    public void onResponse(Call call, Response response) throws IOException {
                        try {
                            final String result = response.body().string();
                            EyeLog.logi("Task:"+Ad.Login.msgToString(msgWhat)+",taskHandler result:"+result);
                            Message message = new Message();
                            message.what = msgWhat;
                            message.obj = result;
                            if(msgWhat == Ad.Login.MSG_SYNC_STEPS){
                                message.arg1 = Integer.parseInt((String)params.get("step"));
                                LogUtils.i("syncSteps","arg1:"+message.arg1);
                            }
                            resultTask.sendMessage(message);
                        } catch (Exception e) {
                            EyeLog.loge("taskHandler exception: "+e.getLocalizedMessage());
                            e.printStackTrace();
                            for(LoginListener listener:loginListeners) {
                                listener.onError(msgWhat,e.getMessage());
                            }
                        }
                    }
                });
            }
        }
    };

    private Handler resultTask = new Handler(Looper.getMainLooper()){
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            final String result = (String)msg.obj;
            JSONObject jsonStr = null;
            String state = "-1";
            String errorMessage = "未知错误";
            try {
                jsonStr = new JSONObject(result);
                state = jsonStr.getString("state");
                if(msg.what != Ad.Login.MSG_GET_RANDOM_COIN_LIST) {
                    errorMessage = jsonStr.getString("msg");
                }
            }catch (JSONException e){
                e.printStackTrace();
                for(LoginListener listener:loginListeners) {
                    listener.onError(msg.what,e.getMessage());
                }
            }
            if(jsonStr == null){
                EyeLog.loge("resultTask jsonStr is null error:"+Ad.Login.msgToString(msg.what));
                for(LoginListener listener:loginListeners) {
                    listener.onError(msg.what,"jsonStr is null");
                }
                return;
            }
            if(state == null || !state.equals("0")){
                EyeLog.loge("resultTask state error:"+state);
                if(msg.what == Ad.Login.MSG_SIGN && state != null && state.equals("3")){
                    for(LoginListener listener:loginListeners) {
                        listener.onAlreadySign();
                    }
                    return;
                }
                if(msg.what == Ad.Login.MSG_REGISTER){
                    Utils.put(StepApplication.getInstance(),USER_ID_KEY,"");
                    for(LoginListener listener:loginListeners) {
                        listener.onRegisterError(state,errorMessage);
                    }
                    return;
                }
                for(LoginListener listener:loginListeners) {
                    listener.onError(msg.what,errorMessage);
                }
            }
            switch (msg.what) {
                case Ad.Login.MSG_REGISTER:
                    updateUserInfo(msg.what,jsonStr,"user");
                    boolean needUpdate = checkUserId(mUser);
                    for(LoginListener listener:loginListeners) {
                        listener.onLogin(mUser,needUpdate);
                    }
                    break;
                case Ad.Login.MSG_SYNC_TASK_RESULT:
                    updateUserInfo(msg.what,jsonStr,"data");
                    try {
                        int reward = jsonStr.getInt("reward");
                        for(LoginListener listener:loginListeners) {
                            listener.onSyncTaskAdResult(reward);
                        }
                    }catch (JSONException e){
                        for(LoginListener listener:loginListeners) {
                            listener.onError(msg.what,e.getLocalizedMessage());
                        }
                    }
                    for(LoginListener listener:loginListeners) {
                        listener.onUserInfoUpdate(msg.what,mUser);
                    }
                    break;
                case Ad.Login.MSG_COIN_RECORD_LIST:
                    try {
                        String data = jsonStr.getString("data");
                        List<CoinRecord> users = com.alibaba.fastjson.JSONObject.parseArray(data,CoinRecord.class);
                        for(LoginListener listener:loginListeners) {
                            listener.onCoinRecordList(users);
                        }
                    }catch (JSONException e){
                        e.printStackTrace();
                        for(LoginListener listener:loginListeners) {
                            listener.onError(msg.what,e.getMessage());
                        }
                    }
                    break;
                case Ad.Login.MSG_GET_RANDOM_COIN:
                case Ad.Login.MSG_GET_USER_INFO:
                    updateUserInfo(msg.what,jsonStr,"data");
                    for(LoginListener listener:loginListeners) {
                        listener.onUserInfoUpdate(msg.what,mUser);
                    }
                    break;
                case Ad.Login.MSG_MODIFY_USER_INFO:
                    updateUserInfo(msg.what,jsonStr,"user");
                    for(LoginListener listener:loginListeners) {
                        listener.onUserInfoUpdate(msg.what,mUser);
                    }
                    break;
                case Ad.Login.MSG_SIGN:
                    updateUserInfo(msg.what,jsonStr,"data");
                    for(LoginListener listener:loginListeners) {
                        listener.onSign();
                    }
                    break;
                case Ad.Login.MSG_SIGN_LIST:
                    try {
                        String data = jsonStr.getString("data");
                        List<SignRecord> users = com.alibaba.fastjson.JSONObject.parseArray(data,SignRecord.class);
                        for(LoginListener listener:loginListeners) {
                            listener.onSignList(users);
                        }
                    }catch (JSONException e){
                        e.printStackTrace();
                        for(LoginListener listener:loginListeners) {
                            listener.onError(msg.what,e.getMessage());
                        }
                    }
                    break;
                case Ad.Login.MSG_INVITE_FRIEND:
                    getUpdateTask(StepApplication.getInstance(),TaskID.TASK_ID_WRITE_INVITE);
                    if(state.equals("0")){
                        for(LoginListener listener:loginListeners) {
                            listener.onInviteFirend();
                        }
                    }
                    break;
                case Ad.Login.MSG_GET_REWARD:
                    try {
                        String data = jsonStr.getString("data");
                        TaskModel taskModel = JSON.parseObject(data, TaskModel.class);
                        for (TaskModel taskModelItem:mTasks){
                            if(taskModelItem.getTaskId() == taskModel.getTaskId()){
                                mTasks.remove(taskModelItem);
                                if(taskModel.getState() == 0){
                                    mTasks.add(0,taskModel);
                                }else{
                                    mTasks.add(taskModel);
                                }
                                break;
                            }
                        }
                        for(LoginListener listener:loginListeners) {
                            listener.onGetTaskReward(taskModel);
                        }

                        String userStr = jsonStr.getString("user");
                        User user = JSON.parseObject(userStr, User.class);
                        mUser = user;
                        Utils.put(StepApplication.getInstance(),USER_ID_KEY,user.getUserId());
                        for(LoginListener listener:loginListeners) {
                            listener.onUserInfoUpdate(msg.what,mUser);
                        }
                    }catch (JSONException e){
                        e.printStackTrace();
                        for(LoginListener listener:loginListeners) {
                            listener.onError(msg.what,e.getMessage());
                        }
                    }
                    break;
                case Ad.Login.MSG_INVITE_FRIEND_LIST:
                    break;
                case Ad.Login.MSG_GET_RANDOM_COIN_LIST:
                    try {
                        String data = jsonStr.getString("data");
                        List<RandomCoin> users = com.alibaba.fastjson.JSONObject.parseArray(data,RandomCoin.class);
                        for(LoginListener listener:loginListeners) {
                            listener.onRandomList(users);
                        }
                    }catch (JSONException e){
                        e.printStackTrace();
                        for(LoginListener listener:loginListeners) {
                            listener.onError(msg.what,e.getMessage());
                        }
                    }
                    break;
                case Ad.Login.MSG_UPLOAD_SHARE_ACTION:
                    getUpdateTask(StepApplication.getInstance(),TaskID.TASK_ID_SHARE_APP);
                    for(LoginListener listener:loginListeners) {
                        listener.onShare();
                    }
                    break;
                case Ad.Login.MSG_GET_SHARE_RECORD:
                    try {
                        String data = jsonStr.getString("data");
                        List<ShareRecord> users = com.alibaba.fastjson.JSONObject.parseArray(data,ShareRecord.class);
                        for(LoginListener listener:loginListeners) {
                            listener.onShareList(users);
                        }
                    }catch (JSONException e){
                        e.printStackTrace();
                        for(LoginListener listener:loginListeners) {
                            listener.onError(msg.what,e.getMessage());
                        }
                    }
                    break;
                case Ad.Login.MSG_SYNC_STEPS:
                    try {
                        int step = msg.arg1;
                        EyeLog.logi("MSG_SYNC_STEPS:"+step);
                        Utils.put(StepApplication.getInstance(), TODAY_TODAY_STEP_NUM, step);
                        DbHelper.saveTodayCount(step);

                        if(step>=1500 && step < 3000){
                            setSyncStepNumLimit(3000);
                        }else if(step>=3000 && step < 4500){
                            setSyncStepNumLimit(4500);
                        }else if(step>=4500 && step < 6000){
                            setSyncStepNumLimit(6000);
                        }else if(step>=6000){
                            setSyncStepNumLimit(Integer.MAX_VALUE);
                        }
                        getTaskList(StepApplication.getInstance());
                        syncStepsList(StepApplication.getInstance());
                        for(LoginListener listener:loginListeners) {
                            listener.onSyncSteps();
                        }
                    }catch (Exception e){
                        e.printStackTrace();
                        for(LoginListener listener:loginListeners) {
                            listener.onError(msg.what,e.getMessage());
                        }
                    }

                    break;
                case Ad.Login.MSG_GET_STEPS_RECORD:
                    try {
                        String data = jsonStr.getString("data");
                        List<StepsRecord> datas = com.alibaba.fastjson.JSONObject.parseArray(data,StepsRecord.class);
                        for(LoginListener listener:loginListeners) {
                            listener.onSyncStepsList(datas);
                        }
                    }catch (JSONException e){
                        e.printStackTrace();
                        for(LoginListener listener:loginListeners) {
                            listener.onError(msg.what,e.getMessage());
                        }
                    }
                    break;
                case Ad.Login.MSG_GET_TASK_LIST:
                    try {
                        String data = jsonStr.getString("data");
                        List<TaskModel> tasks = com.alibaba.fastjson.JSONObject.parseArray(data,TaskModel.class);
                        mTasks.clear();
                        mTasks.addAll(tasks);
                        for(TaskModel task:mTasks){
                            if(task.getState() == 0){
                                mTasks.remove(task);
                                mTasks.add(0,task);
                            }else if(task.getState() == 1){
                                mTasks.remove(task);
                                mTasks.add(task);
                            }
                        }
                        for(LoginListener listener:loginListeners) {
                            listener.onTaskList(tasks);
                        }
                    }catch (JSONException e){
                        e.printStackTrace();
                        for(LoginListener listener:loginListeners) {
                            listener.onError(msg.what,e.getMessage());
                        }
                    }
                    break;
                case Ad.Login.MSG_GET_MONEY:
                    updateUserInfo(msg.what,jsonStr,"data");
                    getUpdateTask(StepApplication.getInstance(),TaskID.TASK_ID_FIRST_GET_CASH);
                    for(LoginListener listener:loginListeners) {
                        listener.onUserInfoUpdate(msg.what,mUser);
                        listener.onGetCash();
                    }
                    break;
                case Ad.Login.MSG_UPDATE_TASK:
                    try {
                        String data = jsonStr.getString("data");
                        TaskModel taskModel = JSON.parseObject(data, TaskModel.class);
                        if(mTasks == null)
                            return;
                        for (TaskModel taskModelItem:mTasks){
                            if(taskModelItem.getTaskId() == taskModel.getTaskId()){
                                taskModelItem.replaceTaskData(taskModel);
                                break;
                            }
                        }
                        for(LoginListener listener:loginListeners) {
                            listener.onUpdateTask(taskModel);
                        }
                    }catch (JSONException e){
                        e.printStackTrace();
                        for(LoginListener listener:loginListeners) {
                            listener.onError(msg.what,e.getMessage());
                        }
                    }
                    break;
            }
        }
    };

    private void updateUserInfo(int message,JSONObject jsonStr,String key){
        try {
            String data = jsonStr.getString(key);
            User user = JSON.parseObject(data, User.class);
            //EyeLog.logi("message:"+Ad.Login.msgToString(message)+",updateUserInfo data: " + user.toString());
            mUser = user;
        }catch (JSONException e){
            e.printStackTrace();
        }
    }

    private boolean checkUserId(User user){
        if(user == null)
            return false;
        String oldUserId = (String)Utils.get(StepApplication.getInstance(),USER_ID_KEY,"");
        if(TextUtils.isEmpty(oldUserId)) {
            Utils.put(StepApplication.getInstance(), USER_ID_KEY, user.getUserId());
            return true;
        }else{
            if(!oldUserId.equals(user.getUserId())){
                for(LoginListener listener:loginListeners) {
                    listener.onHintUserNew(user);
                }
                return false;
            }
            return true;
        }
    }

    public int getTargetStepNum(Context context){
        return (int)Utils.get(context,"target_step_num",5000);
    }

    public void setTargetStepNum(Context context,int num){
        Utils.put(context,"target_step_num",num);
    }

    public float getTargetWeightNum(Context context){
        return (float)Utils.get(context,"target_weight_num",50f);
    }


    public int getTargeHeatNum(Context context) {
        return (int) Utils.get(context, "target_heat_num", 2000);
    }

    public void setTargetHeatNum(Context context, int num) {
        Utils.put(context, "target_heat_num", num);
    }


    public void setTargetWeightNum(Context context,float num){
        Utils.put(context,"target_weight_num",num);
    }

    public float getTargetDistanceNum(Context context){
        return (float)Utils.get(context,"target_distance_num",3000f);
    }

    public void setSportTargetNum(Context context, float num, float type) {
        Utils.put(context, "target_sport_num_" + type, num);
    }

    public float getSportTargetNum(Context context, float type){
        return (float)Utils.get(context,"target_sport_num_"+ type,3000f);
    }

}
