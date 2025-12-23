package com.dn.sports.adcoinLogin;

import android.app.Application;
import android.app.DownloadManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.dn.sports.MainActivity;
import com.dn.sports.StepApplication;
import com.dn.sports.TaskAdActivity;
import com.dn.sports.common.EyeLog;
import com.dn.sports.utils.OpenFileUtils;
import com.dn.sports.utils.Utils;
import com.tmsdk.AbsTMSConfig;
import com.tmsdk.ManagerCreator;
import com.tmsdk.TMSDKContext;
import com.tmsdk.module.ad.AdAppReportResult;
import com.tmsdk.module.ad.AdConfig;
import com.tmsdk.module.ad.AdManager;
import com.tmsdk.module.ad.StyleAdEntity;
import com.tmsdk.module.coin.CheckTaskResultItem;
import com.tmsdk.module.coin.Coin;
import com.tmsdk.module.coin.CoinManager;
import com.tmsdk.module.coin.CoinRequestInfo;
import com.tmsdk.module.coin.CoinTask;
import com.tmsdk.module.coin.CoinTaskType;
import com.tmsdk.module.coin.ErrorCode;
import com.tmsdk.module.coin.MallData;
import com.tmsdk.module.coin.SubmitResultItem;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;

public class TaskAdManager {
    private static final String TCP_SERVER = "mazu.3g.qq.com"; // 正式环境
    private static final String TCP_SERVER_TEST = "mazutest.3g.qq.com"; // 测试环境
    private static final String TAG = "TaskAdManager";
    private static TaskAdManager taskAdManager;
    private CoinManager mCoinManager;
    private AdManager mAdManager;
    private static final String ACCOUNT_ID = "3839401@163.com";
    private static final String LOGIN_KEY = "3333333";
    private ArrayList<CoinTaskType> mRetTasks;
    private Handler mUpdateUIHandler = new Handler(Looper.getMainLooper());
    private Map<StyleAdEntity, CoinTask> mAdKeyTaskValue = new HashMap<>();
    private Context mContext;

    private TaskAdManager(Context context){
        mContext = context.getApplicationContext();
        mCoinManager = ManagerCreator.getManager(CoinManager.class);
        Log.i(TAG, mCoinManager.GetCoinProductId() + "," + mCoinManager.GetCoinVersion());
        mAdManager = ManagerCreator.getManager(AdManager.class);
        mAdManager.init();
    }

    public AdManager getmAdManager() {
        return mAdManager;
    }

    public synchronized static TaskAdManager getInstance(Context context){
        if(taskAdManager == null){
            taskAdManager = new TaskAdManager(context);
        }
        return taskAdManager;
    }

    public static void initApplication(Application application){
        TMSDKContext.setTMSDKLogEnable(true);

        //TMSDKContext.setAutoConnectionSwitch(this,true);
        boolean initTM = TMSDKContext.init(application, new AbsTMSConfig() {
            @Override
            public String getServerAddress() {
                return TCP_SERVER;
            }
        });
        EyeLog.logi("StepApplication"+"------------initTM:"+initTM+"------------");
    }

    public void getTasks(){
       Runnable runnable = new Runnable() {
            @Override
            public void run() {
                CoinRequestInfo coinRequestInfo = new CoinRequestInfo();
                coinRequestInfo.accountId = StepUserManager.getInstance().getUserId(StepApplication.getInstance());
                coinRequestInfo.loginKey = LOGIN_KEY;
                ArrayList<CoinTaskType> coinTaskTypes = new ArrayList<CoinTaskType>();
                final Coin coin = new Coin();
                int ret =  mCoinManager.GetTasks(coinRequestInfo, null, coin, coinTaskTypes);
                mUpdateUIHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        EyeLog.logi(TAG+"+getTasks总分:" + coin.totalCoin);
                    }
                });
                if(ret == ErrorCode.EC_SUCCESS && coinTaskTypes.size() > 0) {
                    mRetTasks = coinTaskTypes;
                    Message msg = mUpdateUIHandler.obtainMessage(100, 2, 0, coinTaskTypes);
                    mUpdateUIHandler.sendMessage(msg);
                }
            }
        };
        TaskManager.getManager().executeTask(runnable);
    }

    public void submitTasks(){
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                CoinRequestInfo coinRequestInfo = new CoinRequestInfo();
                coinRequestInfo.accountId = StepUserManager.getInstance().getUserId(StepApplication.getInstance());
                coinRequestInfo.loginKey = LOGIN_KEY;
                ArrayList<CoinTask> coinTasks = new ArrayList<CoinTask>();
                if (mRetTasks != null && mRetTasks.size() > 0) {
                    for (CoinTaskType coinTaskType : mRetTasks) {
                        for (CoinTask xxTask : coinTaskType.coinTasks) {
                            coinTasks.add(xxTask);
                        }
                    }
                    ArrayList<SubmitResultItem> submitResultItems = new ArrayList<SubmitResultItem>();
                    final Coin coin = new Coin();
                    int ret = mCoinManager.SubmitBatchTask(coinRequestInfo, coinTasks, coin, submitResultItems);
                    mUpdateUIHandler.post(new Runnable() {
                        @Override
                        public void run() {
                            EyeLog.logi(TAG+"+submitTasks总分:" + coin.totalCoin);
                        }
                    });
                    if (submitResultItems.size() > 0) {
                        Message msg = mUpdateUIHandler.obtainMessage(101, 2, 0, submitResultItems);
                        mUpdateUIHandler.sendMessage(msg);
                    }
                    EyeLog.logi(TAG+"+submitTasks错误码:"+ret);
                } else {
                    EyeLog.logi(TAG+"+submitTasks没有拉到积分任务");
                }
            }
        };
        TaskManager.getManager().executeTask(runnable);
    }

    public void checkTasks(){
       Runnable runnable = new Runnable() {
            @Override
            public void run() {
                CoinRequestInfo coinRequestInfo = new CoinRequestInfo();
                coinRequestInfo.accountId = StepUserManager.getInstance().getUserId(StepApplication.getInstance());
                coinRequestInfo.loginKey = LOGIN_KEY;
                ArrayList<CoinTask> coinTasks = new ArrayList<CoinTask>();
                if (mRetTasks != null && mRetTasks.size() > 0) {
                    for (CoinTaskType coinTaskType : mRetTasks) {
                        for (CoinTask xxTask : coinTaskType.coinTasks) {
                            coinTasks.add(xxTask);
                        }
                    }
                    ArrayList<CheckTaskResultItem> checkTaskResultItems = new ArrayList<CheckTaskResultItem>();
                    int ret = mCoinManager.CheckBatchTask(coinRequestInfo, coinTasks, checkTaskResultItems);
                    if (checkTaskResultItems.size() > 0) {
                        Message msg = mUpdateUIHandler.obtainMessage(102, 2, 0, checkTaskResultItems);
                        mUpdateUIHandler.sendMessage(msg);
                    }
                    EyeLog.logi(TAG+"+checkTasks错误码:"+ret);
                } else {
                    EyeLog.logi(TAG+"+checkTasks没有拉到" +
                            "积分任务");
                }
            }
        };
        TaskManager.getManager().executeTask(runnable);
    }

    @NonNull
    @Override
    public String toString() {
        return super.toString();
    }

    public void getMalls(){
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                CoinRequestInfo coinRequestInfo = new CoinRequestInfo();
                coinRequestInfo.accountId = StepUserManager.getInstance().getUserId(StepApplication.getInstance());
                coinRequestInfo.loginKey = LOGIN_KEY;
                final MallData mallData = new MallData();
                int ret = mCoinManager.GetMallData(coinRequestInfo, 0, mallData);
                EyeLog.logi(TAG+"+getMalls错误码:"+ret);
                mUpdateUIHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        StringBuilder sb = new StringBuilder();
                        sb.append("get malldata....\n\n");
                        sb.append("version:" + mallData.version + "\n");
                        sb.append("resource:" + mallData.resource + "\n");
                        sb.append("stock:" + mallData.stock + "\n");
                        sb.append("..........\n\n");
                        EyeLog.logi(TAG+sb.toString());
                    }
                });
            }
        };
        TaskManager.getManager().executeTask(runnable);
    }



    private void startAdApp(final StyleAdEntity mStyleAdEntity,Context context,String orderId) {
        try {
            AdAppReportResult reportResult = mAdManager.onAdAppActive(mStyleAdEntity);
            EyeLog.logi(TAG+"+应用广告打开成功上报reportResult:"+reportResult);

            // 激活的时候加积分
            ArrayList<CoinTask> coinTasks = new ArrayList<CoinTask>();
            coinTasks.add(mAdKeyTaskValue.get(mStyleAdEntity));
            CoinRequestInfo coinRequestInfo = new CoinRequestInfo();
            coinRequestInfo.accountId = StepUserManager.getInstance().getUserId(StepApplication.getInstance());
            coinRequestInfo.loginKey = LOGIN_KEY;
            ArrayList<SubmitResultItem> submitResultItems = new ArrayList<SubmitResultItem>();
            final Coin coin = new Coin();
            int ret = mCoinManager.SubmitBatchTask(coinRequestInfo, coinTasks, coin, submitResultItems);
            if (ret == ErrorCode.EC_SUCCESS) {
                EyeLog.logi(TAG+"+错误码：" + submitResultItems.get(0).errorCode + ";加分：" + submitResultItems.get(0).coinNum);

                StepUserManager.getInstance().syncTaskResult(context,orderId);

                notifyOpenAppResult(mStyleAdEntity,ret);
            } else {
                EyeLog.logi(TAG+"+加分错误码：" + ret);
                Toast.makeText(context,"获取积分失败，错误码："+ret,Toast.LENGTH_SHORT).show();
                notifyOpenAppResult(mStyleAdEntity,ret);
            }

            PackageManager packageManager = context.getPackageManager();
            Intent intent = packageManager.getLaunchIntentForPackage(mStyleAdEntity.mPkgName);
            context.startActivity(intent);
        } catch (Throwable t) {
            //IGNORE
            EyeLog.logi(TAG+ "+startAdApp error：" + t.getMessage());
        }
    }

    public void getTaskAndAd(){
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                EyeLog.logi(TAG+"+ad加载中...");
                mAdKeyTaskValue = new HashMap<>();
                // 第一步：先拉取下载任务
                int taskType1 = 103; // 下载任务的ID
                int taskType2 = 104; // 下载任务的ID
                CoinRequestInfo coinRequestInfo = new CoinRequestInfo();
                coinRequestInfo.accountId = StepUserManager.getInstance().getUserId(StepApplication.getInstance());
                coinRequestInfo.loginKey = "Steps"+System.currentTimeMillis();
                ArrayList<CoinTaskType> coinTaskTypes = new ArrayList<>();
                final Coin coin = new Coin();
                ArrayList<Integer> taskTypes = new ArrayList<>();
                taskTypes.add(taskType1);
                int ret =  mCoinManager.GetTasks(coinRequestInfo, taskTypes, coin, coinTaskTypes);
                if (ret != ErrorCode.EC_SUCCESS) {
                    EyeLog.logi(TAG+"+拉取任务出错..."+ret);
                    notifyUIError(ret,"拉取任务出错...");
                    return;
                }

                // 第二步：拉取未做任务的广告资源，可以多拉一点，因为广告有填充率问题
                List<AdConfig> adConfigs = new ArrayList<>();
                Bundle inBundle1 = new Bundle();
                inBundle1.putInt(AdConfig.AD_KEY.AD_NUM.name(),5);
                inBundle1.putString(AdConfig.AD_KEY.AD_CHANNEL_NO.name(), Utils.getMarket(StepApplication.getInstance()));
                AdConfig aAdConfig1 = new AdConfig(taskType1, inBundle1);
                adConfigs.add(aAdConfig1);
                HashMap<AdConfig, List<StyleAdEntity>> result = mAdManager.getMultPositionAdByList(adConfigs, 5 * 1000L);

                final List<StyleAdEntity> tmpList = new ArrayList<StyleAdEntity>();
                // 第三步：任务和资源关联起来
                List<StyleAdEntity> adList = result.get(aAdConfig1);
                if(adList == null){
                    return;
                }
                CoinTaskType coinTaskType = coinTaskTypes.get(0);
                try {
                    EyeLog.logi("11111111："+coinTaskType.coinTasks.size());
                    EyeLog.logi("22222222："+adList.size());
                    for (CoinTask coinTask : coinTaskType.coinTasks) {
                        // 没做的任务
                        if (coinTask.task_status == CoinTask.TaskStatus.NEW) {
                            EyeLog.logi("new  CoinTask："+coinTask);
                            for (StyleAdEntity ad : adList) {
                                if (!CommonUtil.isPkgInstalled(mContext, ad.mPkgName) && !mAdKeyTaskValue.containsKey(ad)) {
                                    mAdKeyTaskValue.put(ad, coinTask);
                                    tmpList.add(ad);
                                    break;
                                }
                            }
                        }else{
                            EyeLog.logi("old  CoinTask："+coinTask);
                        }
                    }
                } catch (Throwable t) {
                    t.printStackTrace();
                }
                if (tmpList.size() == 0) {
                    EyeLog.logi(TAG+"+未请求到广告信息...");
                    notifyUIError(10001,"未请求到广告信息...");
                    return;
                }
                EyeLog.logi(TAG+"+广告信息数目："+tmpList.size());
                notifyUITaskAdList(tmpList,mAdKeyTaskValue);
            }
        };
        TaskManager.getManager().executeTask(runnable);
    }

    public boolean adClickItem(StyleAdEntity mStyleAdEntity,Context context,String orderId){
        mAdManager.onAdClick(mStyleAdEntity);

        if (mStyleAdEntity.mAdType == StyleAdEntity.AD_TYPE.H5) {
            Intent intent = new Intent(Intent.ACTION_VIEW);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            intent.setData(Uri.parse(mStyleAdEntity.mJumpUrl));
            context.startActivity(intent);

            if(!TextUtils.isEmpty(mStyleAdEntity.mVideoUrl)){
                intent = new Intent(Intent.ACTION_VIEW);
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                intent.setData(Uri.parse(mStyleAdEntity.mVideoUrl));
                context.startActivity(intent);
            }
        } else if (mStyleAdEntity.mAdType == StyleAdEntity.AD_TYPE.APP) {
            boolean isInstall = CommonUtil.isPkgInstalled(context, mStyleAdEntity.mPkgName);
            if (isInstall) {
                EyeLog.logi("task ad adClickItem:"+orderId);
                startAdApp(mStyleAdEntity,context,orderId);
            }
        }
        return false;
    }

    public void reportAdDisplay(StyleAdEntity mStyleAdEntity){
        mAdManager.onAdDisplay(mStyleAdEntity);
        EyeLog.logi("+应用广告展示成功上报"+","+mStyleAdEntity.mPkgName);
    }

    private void notifyUITaskAdList(List<StyleAdEntity> data,Map<StyleAdEntity, CoinTask> mAdKeyTaskValue){
        for(TaskAdListener listener:mTaskAdListeners){
            listener.onTaskAdList(data,mAdKeyTaskValue);
        }
    }

    private void notifyUIDownloadResult(StyleAdEntity mStyleAdEntity,int type,String path){
        for(TaskAdListener listener:mTaskAdListeners){
            listener.onDownloadAppResult(mStyleAdEntity,type,path);
        }
    }

    private void notifyUIInstallResult(String pkg,int type){
        for(TaskAdListener listener:mTaskAdListeners){
            listener.onInstallAppResult(pkg,type);
        }
    }

    private void notifyUIError(int errorCode,String msg){
        for(TaskAdListener listener:mTaskAdListeners){
            listener.onTaskAdError(errorCode,msg);
        }
    }

    private void notifyOpenAppResult(StyleAdEntity mStyleAdEntity,int type){
        for(TaskAdListener listener:mTaskAdListeners){
            listener.onOpenAppResult(mStyleAdEntity,type);
        }
    }


    private CopyOnWriteArrayList<TaskAdListener> mTaskAdListeners = new CopyOnWriteArrayList<>();

    public void setTaskAdListener(TaskAdListener loginListener){
        if(!mTaskAdListeners.contains(loginListener)){
            mTaskAdListeners.add(loginListener);
        }
    }

    public void removeTaskAdListener(TaskAdListener loginListener){
        if(mTaskAdListeners.contains(loginListener)){
            mTaskAdListeners.remove(loginListener);
        }
    }

    public interface TaskAdListener{
        void onTaskAdList(List<StyleAdEntity> data, Map<StyleAdEntity, CoinTask> mAdKeyTaskValue);

        void onTaskAdError(int code, String errorMsg);

        void onOpenAppResult(StyleAdEntity mStyleAdEntity,int type);

        void onDownloadAppResult(StyleAdEntity mStyleAdEntity,int type,String path);

        void onInstallAppResult(String pkg,int type);
    }
}
