package com.example.adcoinlogin.user;

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
    private static final String ACCOUNT_ID = "3333";
    private static final String LOGIN_KEY = "3333333";
    private ArrayList<CoinTaskType> mRetTasks;
    private Handler mUpdateUIHandler = new Handler(Looper.getMainLooper());
    private BroadcastReceiver downloadBroadcastReceiver, installBroadcastReceiver;
    private Map<StyleAdEntity, CoinTask> mAdKeyTaskValue = new HashMap<>();
    private Context mContext;

    private TaskAdManager(Context context){
        mContext = context.getApplicationContext();
        mCoinManager = ManagerCreator.getManager(CoinManager.class);
        Log.i(TAG, mCoinManager.GetCoinProductId() + "," + mCoinManager.GetCoinVersion());
        mAdManager = ManagerCreator.getManager(AdManager.class);
        mAdManager.init();
    }

    public synchronized static TaskAdManager getInstance(Context context){
        if(taskAdManager == null){
            taskAdManager = new TaskAdManager(context);
        }
        return taskAdManager;
    }

    public void initApplication(Application application){
        TMSDKContext.setTMSDKLogEnable(true);

        //TMSDKContext.setAutoConnectionSwitch(this,true);
        boolean initTM = TMSDKContext.init(application, new AbsTMSConfig() {
            @Override
            public String getServerAddress() {
                return TCP_SERVER_TEST;
            }
        });
        Log.i("StepApplication","------------initTM:"+initTM+"------------");
    }

    public void getTasks(){
       Runnable runnable = new Runnable() {
            @Override
            public void run() {
                CoinRequestInfo coinRequestInfo = new CoinRequestInfo();
                coinRequestInfo.accountId = ACCOUNT_ID;
                coinRequestInfo.loginKey = LOGIN_KEY;
                ArrayList<CoinTaskType> coinTaskTypes = new ArrayList<CoinTaskType>();
                final Coin coin = new Coin();
                int ret =  mCoinManager.GetTasks(coinRequestInfo, null, coin, coinTaskTypes);
                mUpdateUIHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        Log.i(TAG,"getTasks总分:" + coin.totalCoin);
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
                coinRequestInfo.accountId = ACCOUNT_ID;
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
                            Log.i(TAG,"submitTasks总分:" + coin.totalCoin);
                        }
                    });
                    if (submitResultItems.size() > 0) {
                        Message msg = mUpdateUIHandler.obtainMessage(101, 2, 0, submitResultItems);
                        mUpdateUIHandler.sendMessage(msg);
                    }
                    Log.i(TAG,"submitTasks错误码:"+ret);
                } else {
                    Log.i(TAG,"submitTasks没有拉到积分任务");
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
                coinRequestInfo.accountId = ACCOUNT_ID;
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
                    Log.i(TAG,"checkTasks错误码:"+ret);
                } else {
                    Log.i(TAG,"checkTasks没有拉到积分任务");
                }
            }
        };
        TaskManager.getManager().executeTask(runnable);
    }

    public void getMalls(){
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                CoinRequestInfo coinRequestInfo = new CoinRequestInfo();
                coinRequestInfo.accountId = ACCOUNT_ID;
                coinRequestInfo.loginKey = LOGIN_KEY;
                final MallData mallData = new MallData();
                int ret = mCoinManager.GetMallData(coinRequestInfo, 0, mallData);
                Log.i(TAG,"getMalls错误码:"+ret);
                mUpdateUIHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        StringBuilder sb = new StringBuilder();
                        sb.append("get malldata....\n\n");
                        sb.append("version:" + mallData.version + "\n");
                        sb.append("resource:" + mallData.resource + "\n");
                        sb.append("stock:" + mallData.stock + "\n");
                        sb.append("..........\n\n");
                        Log.i(TAG, sb.toString());
                    }
                });
            }
        };
        TaskManager.getManager().executeTask(runnable);
    }

    /**
     * 下载Apk, 并设置Apk地址,
     * 默认位置: /storage/sdcard0/Download
     *
     * @param infoName    通知名称
     * @param description 通知描述
     */
    private void downloadApk(final StyleAdEntity mStyleAdEntity, String description, String infoName) {
        AdAppReportResult reportResult= mAdManager.onAdAppDownloadStart(mStyleAdEntity);
        Log.i(TAG, "应用广告开始下载上报 reportResult:"+reportResult);

        DownloadManager.Request request;
        try {
            request = new DownloadManager.Request(Uri.parse(mStyleAdEntity.mDownloadUrl));
        } catch (Throwable e) {
            Log.e(TAG, "DownloadManager.Request (Throwable)", e);
            return;
        }

        request.setTitle(infoName);
        request.setDescription(description);

        //在通知栏显示下载进度
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
            request.allowScanningByMediaScanner();
            request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
        }

        //设置保存下载apk保存路径
        String apkName =
                System.currentTimeMillis() + "_" + CommonUtil.getMD5(mStyleAdEntity.mDownloadUrl) + ".apk";
        request.setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, apkName);
        DownloadManager manager = (DownloadManager) mContext.getSystemService(Context.DOWNLOAD_SERVICE);
        //进入下载队列
        long id = manager.enqueue(request);
        listenerDownLoad(id, mStyleAdEntity, apkName);
        notifyUIDownloadResult(1);
    }

    private void listenerDownLoad(final long Id, final StyleAdEntity mStyleAdEntity, final String apkName) {
        // 注册广播监听系统的下载完成事件。
        IntentFilter intentFilter = new IntentFilter(DownloadManager.ACTION_DOWNLOAD_COMPLETE);
        downloadBroadcastReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                mContext.unregisterReceiver(downloadBroadcastReceiver);
                Bundle mBundle = intent.getExtras();
                if(mBundle == null)
                    return;
                long ID = mBundle.getLong(DownloadManager.EXTRA_DOWNLOAD_ID);
                if (ID == Id) {
                    final String apkFilePath = new StringBuilder(Environment.getExternalStorageDirectory().getAbsolutePath())
                            .append(File.separator).append(Environment.DIRECTORY_DOWNLOADS).append(File.separator)
                            .append(apkName).toString();

                    AdAppReportResult reportResult= mAdManager.onAdAppDownloadSucceed(mStyleAdEntity, apkFilePath);
                    Log.i(TAG, "应用广告下载成功上报reportResult:"+reportResult);
                    listenerInstall(mStyleAdEntity);
                    CommonUtil.installApkByPath(mContext, apkFilePath);
                    notifyUIDownloadResult(0);
                }
            }
        };

        mContext.registerReceiver(downloadBroadcastReceiver, intentFilter);
    }

    private void listenerInstall(final StyleAdEntity mStyleAdEntity) {
        // 注册广播监听系统的下载完成事件。
        IntentFilter installFilter = new IntentFilter();
        installFilter.addAction(Intent.ACTION_PACKAGE_ADDED);
        installFilter.addAction(Intent.ACTION_PACKAGE_REPLACED);
        installFilter.addDataScheme("package");

        installBroadcastReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                mContext.unregisterReceiver(installBroadcastReceiver);
                AdAppReportResult reportResult = mAdManager.onAdAppInstall(mStyleAdEntity);
                Log.i(TAG, "应用广告安装成功上报reportResult:"+reportResult);
            }
        };
        mContext.registerReceiver(installBroadcastReceiver, installFilter);
    }

    private void startAdApp(final StyleAdEntity mStyleAdEntity,Context context) {
        try {
            AdAppReportResult reportResult = mAdManager.onAdAppActive(mStyleAdEntity);
            Log.i(TAG, "应用广告打开成功上报reportResult:"+reportResult);

            // 激活的时候加积分
            ArrayList<CoinTask> coinTasks = new ArrayList<CoinTask>();
            coinTasks.add(mAdKeyTaskValue.get(mStyleAdEntity));
            CoinRequestInfo coinRequestInfo = new CoinRequestInfo();
            coinRequestInfo.accountId = ACCOUNT_ID;
            coinRequestInfo.loginKey = LOGIN_KEY;
            ArrayList<SubmitResultItem> submitResultItems = new ArrayList<SubmitResultItem>();
            final Coin coin = new Coin();
            int ret = mCoinManager.SubmitBatchTask(coinRequestInfo, coinTasks, coin, submitResultItems);
            if (ret == ErrorCode.EC_SUCCESS) {
                Log.i(TAG, "错误码：" + submitResultItems.get(0).errorCode + ";加分：" + submitResultItems.get(0).coinNum);
            } else {
                Log.i(TAG, "加分错误码：" + ret);
            }

            PackageManager packageManager = context.getPackageManager();
            Intent intent = packageManager.getLaunchIntentForPackage(mStyleAdEntity.mPkgName);
            context.startActivity(intent);
        } catch (Throwable t) {
            //IGNORE
        }
    }

    public void releaseAdCoin(){
        if (mAdManager != null)
            mAdManager.release();
        if(installBroadcastReceiver != null)
            mContext.unregisterReceiver(installBroadcastReceiver);
        if(downloadBroadcastReceiver != null)
            mContext.unregisterReceiver(downloadBroadcastReceiver);
    }

    public void getTaskAndAd(){
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                Log.i(TAG, "ad加载中...");
                mAdKeyTaskValue = new HashMap<>();
                // 第一步：先拉取下载任务
                int taskType = 8; // 下载任务的ID
                CoinRequestInfo coinRequestInfo = new CoinRequestInfo();
                coinRequestInfo.accountId = ACCOUNT_ID;
                coinRequestInfo.loginKey = LOGIN_KEY;
                ArrayList<CoinTaskType> coinTaskTypes = new ArrayList<CoinTaskType>();
                final Coin coin = new Coin();
                ArrayList<Integer> taskTypes = new ArrayList<Integer>();
                taskTypes.add(taskType);
                int ret =  mCoinManager.GetTasks(coinRequestInfo, taskTypes, coin, coinTaskTypes);
                if (ret != ErrorCode.EC_SUCCESS) {
                    Log.i(TAG, "拉取任务出错...");
                    notifyUIError(ret,"拉取任务出错...");
                    return;
                }

                // 第二步：拉取未做任务的广告资源，可以多拉一点，因为广告有填充率问题
                List<AdConfig> adConfigs = new ArrayList<AdConfig>();
                Bundle inBundle1 = new Bundle();
                inBundle1.putInt(AdConfig.AD_KEY.AD_NUM.name(), 10);
                inBundle1.putString(AdConfig.AD_KEY.AD_CHANNEL_NO.name(), "渠道号");
                AdConfig aAdConfig1 = new AdConfig(taskType, inBundle1);
                adConfigs.add(aAdConfig1);
                HashMap<AdConfig, List<StyleAdEntity>> result = mAdManager.getMultPositionAdByList(adConfigs, 5 * 1000L);

                final List<StyleAdEntity> tmpList = new ArrayList<StyleAdEntity>();
                // 第三步：任务和资源关联起来
                List<StyleAdEntity> adList = result.get(aAdConfig1);
                CoinTaskType coinTaskType = coinTaskTypes.get(0);
                try {

                    for (CoinTask coinTask : coinTaskType.coinTasks) {
                        // 没做的任务
                        if (coinTask.task_status == CoinTask.TaskStatus.NEW) {
                            for (StyleAdEntity ad : adList) {
                                if (!CommonUtil.isPkgInstalled(mContext, ad.mPkgName) && !mAdKeyTaskValue.containsKey(ad)) {
                                    mAdKeyTaskValue.put(ad, coinTask);
                                    tmpList.add(ad);
                                    break;
                                }
                            }
                        }
                    }
                } catch (Throwable t) {
                    t.printStackTrace();
                }
                if (tmpList.size() == 0) {
                    Log.i(TAG, "未请求到广告信息...");
                    notifyUIError(10001,"未请求到广告信息...");
                    return;
                }
                for (StyleAdEntity mStyleAdEntity : tmpList) {
                    Log.d(TAG, "StyleAdEntity : " + mStyleAdEntity.toString());
                }
                notifyUITaskAdList(tmpList,mAdKeyTaskValue);
            }
        };
        TaskManager.getManager().executeTask(runnable);
    }

    public void adClickItem(StyleAdEntity mStyleAdEntity,Context context){
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
                startAdApp(mStyleAdEntity,context);
            } else {
                downloadApk(mStyleAdEntity, "下载应用", "广告应用");
            }
        }
    }

    public void reportAdDisplay(StyleAdEntity mStyleAdEntity){
        mAdManager.onAdDisplay(mStyleAdEntity);
    }

    private void notifyUITaskAdList(List<StyleAdEntity> data,Map<StyleAdEntity, CoinTask> mAdKeyTaskValue){
        for(TaskAdListener listener:mTaskAdListeners){
            listener.onTaskAdList(data,mAdKeyTaskValue);
        }
    }

    private void notifyUIDownloadResult(int type){
        for(TaskAdListener listener:mTaskAdListeners){
            listener.onDownloadAppResult(type);
        }
    }

    private void notifyUIInstallResult(int type){
        for(TaskAdListener listener:mTaskAdListeners){
            listener.onInstallAppResult(type);
        }
    }

    private void notifyUIError(int errorCode,String msg){
        for(TaskAdListener listener:mTaskAdListeners){
            listener.onTaskAdError(errorCode,msg);
        }
    }

    private void notifyOpenAppResult(int type){
        for(TaskAdListener listener:mTaskAdListeners){
            listener.onOpenAppResult(type);
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

        void onOpenAppResult(int type);

        void onDownloadAppResult(int type);

        void onInstallAppResult(int type);
    }
}
