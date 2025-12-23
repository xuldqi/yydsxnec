package com.dn.sports.view;

import android.annotation.SuppressLint;
import android.app.DownloadManager;
import android.content.Context;
import android.database.ContentObserver;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.dn.sports.R;
import com.dn.sports.TaskAdActivity;
import com.dn.sports.adcoinLogin.CommonUtil;
import com.dn.sports.adcoinLogin.TaskAdManager;
import com.dn.sports.common.EyeLog;
import com.dn.sports.utils.OpenFileUtils;
import com.dn.sports.utils.Utils;
import com.dn.sports.utils.YGlideModule;
import com.tmsdk.module.ad.AdAppReportResult;
import com.tmsdk.module.ad.StyleAdEntity;
import com.tmsdk.module.coin.CoinTask;

import java.io.File;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class TaskAdItem extends LinearLayout {

    private View convertView;
    private ProgressButton mBtn;
    private long downloadId = -1;
    public static final int HANDLE_DOWNLOAD = 0x001;
    public static final int UPDATE = 0x002;
    private DownloadManager downloadManager;
    private ScheduledExecutorService scheduledExecutorService;
    private boolean isCanGetCoin = false;
    private String path;
    private boolean isDownloadOver = false;
    private String apkName;

    @SuppressLint("HandlerLeak")
    public Handler downLoadHandler = new Handler() { //主线程的handler
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            if (HANDLE_DOWNLOAD == msg.what) {
                //被除数可以为0，除数必须大于0
                int state = (int)msg.obj;
                if(state == 8){

                    DownloadManager downloadManager = (DownloadManager)getContext().getSystemService(Context.DOWNLOAD_SERVICE);
                    Uri uri = downloadManager.getUriForDownloadedFile(downloadId);
                    String type = downloadManager.getMimeTypeForDownloadedFile(downloadId);

                    final String apkFilePath = new StringBuilder(Environment.getExternalStorageDirectory().getAbsolutePath())
                            .append(File.separator).append(Environment.DIRECTORY_DOWNLOADS).append(File.separator)
                            .append(apkName).toString();
                    AdAppReportResult reportResult= TaskAdManager.getInstance(getContext())
                            .getmAdManager().onAdAppDownloadSucceed(mStyleAdEntity, apkFilePath);
                    EyeLog.logi("TaskAdItem+应用广告下载成功上报reportResult:"+reportResult+",apkFilePath:"+apkFilePath);

                    OpenFileUtils.openFile(getContext(),uri,type);
                    isDownloadOver(mStyleAdEntity,apkFilePath);
                    isDownloadOver = true;
                    close();
                    return;
                }
                if (msg.arg1 >= 0 && msg.arg2 > 0) {
                    //EyeLog.logi("mi:"+msg.arg1+"m2:"+msg.arg2+",state:"+state);
                    mBtn.setMaxProgress(msg.arg2);
                    mBtn.setProgress(msg.arg1);
                    //onProgressListener.onProgress(msg.arg1 / (float) msg.arg2);
                }
            }else if (UPDATE == msg.what) {
                scheduledExecutorService.scheduleAtFixedRate(progressRunnable, 0, 1, TimeUnit.SECONDS);
            }
        }
    };

    public TaskAdItem(Context context){
        super(context);
        init(context);
    }

    private void init(Context context){
//        convertView = LayoutInflater.from(context).inflate(R.layout.item_ad_big_pic, this);
    }

    private StyleAdEntity mStyleAdEntity;
    private CoinTask mCoinTask;

    public void showItem(StyleAdEntity styleAdEntity, CoinTask coinTask){
        mStyleAdEntity = styleAdEntity;
        mCoinTask = coinTask;
        TextView name = (TextView)convertView.findViewById(R.id.name);
//        TextView mTitle = (TextView)convertView.findViewById(R.id.item_ad_big_pic_title);
//        TextView mSubTitle = (TextView)convertView.findViewById(R.id.item_ad_big_pic_sub_title);
//        ImageView mIcon = (ImageView)convertView.findViewById(R.id.item_ad_big_pic_icon);
//        mBtn = (ProgressButton) convertView.findViewById(R.id.button_progress_green);
//        ImageView mBigPic = (ImageView)convertView.findViewById(R.id.item_ad_big_pic_pic);
//        if(coinTask == null){
//            mTitle.setText(styleAdEntity.mMainTitle);
//        }else {
//            mTitle.setText(styleAdEntity.mMainTitle);
//            mSubTitle.setText("+" + coinTask.coin_num);
//        }
        name.setText(styleAdEntity.mSubTitle);
        if (styleAdEntity.mIconUrl != null && styleAdEntity.mIconUrl.length() > 0)
//            Glide.with(getContext())
//                    .load(styleAdEntity.mIconUrl)
//                    .into(mIcon);
        if (CommonUtil.isPkgInstalled(getContext(), styleAdEntity.mPkgName)) {
            if(coinTask == null){
                mBtn.setText("点击领取积分");
            }else{
                mBtn.setText("点击领取积分" + coinTask.coin_num);
            }
        } else {
            mBtn.setText("下载领奖励");
        }
        mBtn.setDrawableButtonColor(R.color.app_common_color);
        mBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (mStyleAdEntity.mAdType == StyleAdEntity.AD_TYPE.APP) {
                    boolean isInstall = CommonUtil.isPkgInstalled(getContext(), mStyleAdEntity.mPkgName);
                    if(isInstall){
                        EyeLog.logi("task ad coinTask.order_id:"+coinTask.order_id);
                        TaskAdManager.getInstance(getContext()).adClickItem(mStyleAdEntity,getContext(),mCoinTask.order_id);
                    }else if(isCanGetCoin){
                        if(isDownloadOver){
                            DownloadManager downloadManager = (DownloadManager)getContext().getSystemService(Context.DOWNLOAD_SERVICE);
                            Uri uri = downloadManager.getUriForDownloadedFile(downloadId);
                            String type = downloadManager.getMimeTypeForDownloadedFile(downloadId);

                            OpenFileUtils.openFile(getContext(),uri,type);
                        }else{
                            Toast.makeText(getContext(),"下载安装中",Toast.LENGTH_SHORT).show();
                        }
                    }else{
                        mBtn.setText("下载安装中");
                        downloadId = downloadApk(mStyleAdEntity,
                                mStyleAdEntity.mMainTitle, mStyleAdEntity.mSubTitle);
                        if(downloadId > 0){
                            if(scheduledExecutorService != null){
                                close();
                            }
                            scheduledExecutorService = Executors.newSingleThreadScheduledExecutor();
                            downLoadHandler.sendEmptyMessageDelayed(UPDATE,1000);
                            isCanGetCoin = true;
                        }
                    }
                }
            }
        });
    }

    private Runnable progressRunnable = new Runnable() {
        @Override
        public void run() {
            updateProgress();
        }
    };

    /**
     * 关闭定时器，线程等操作
     */
    private void close() {
        if (scheduledExecutorService != null && !scheduledExecutorService.isShutdown()) {
            scheduledExecutorService.shutdown();
        }

        if (downLoadHandler != null) {
            downLoadHandler.removeCallbacksAndMessages(null);
        }
    }

    private void updateProgress() {
        int[] bytesAndStatus = getBytesAndStatus(downloadId);
        downLoadHandler.sendMessage(downLoadHandler.obtainMessage(HANDLE_DOWNLOAD
                , bytesAndStatus[0], bytesAndStatus[1], bytesAndStatus[2]));
    }

    /**
     * 通过query查询下载状态，包括已下载数据大小，总大小，下载状态
     *
     * @param downloadId
     * @return
     */
    @SuppressLint("Range")
    private int[] getBytesAndStatus(long downloadId) {
        int[] bytesAndStatus = new int[]{
                -1, -1, 0
        };
        downloadManager = (DownloadManager)getContext().getSystemService(Context.DOWNLOAD_SERVICE);
        DownloadManager.Query query = new DownloadManager.Query().setFilterById(downloadId);
        Cursor cursor = null;
        try {
            cursor = downloadManager.query(query);
            if (cursor != null && cursor.moveToFirst()) {
                //已经下载文件大小
                bytesAndStatus[0] = cursor.getInt(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_BYTES_DOWNLOADED_SO_FAR));
                //下载文件的总大小
                bytesAndStatus[1] = cursor.getInt(cursor.getColumnIndexOrThrow(DownloadManager.COLUMN_TOTAL_SIZE_BYTES));
                //下载状态
                bytesAndStatus[2] = cursor.getInt(Math.min(cursor.getColumnIndex(DownloadManager.COLUMN_STATUS),0));
            }
        } finally {
            if (cursor != null) {
                cursor.close();
            }
        }
        return bytesAndStatus;
    }

    public String getOnlyId(){
        return mStyleAdEntity.mUniqueKey;
    }

    public void checkIsInstall(){
        if(mStyleAdEntity!=null){
            if(CommonUtil.isPkgInstalled(getContext(), mStyleAdEntity.mPkgName)) {
                mBtn.setText("打开领奖励");
                mBtn.setDrawableButtonColor(R.color.get_coin_back);
                isCanGetCoin = true;

                AdAppReportResult reportResult = TaskAdManager.getInstance(getContext())
                        .getmAdManager().onAdAppInstall(mStyleAdEntity);
                EyeLog.logi("+应用广告安装成功上报reportResult:"+reportResult+","+mStyleAdEntity.mPkgName);
            }

        }
    }

    public void checkOpenSuccess(StyleAdEntity styleAdEntity){
        if(mStyleAdEntity != null) {
            if (mStyleAdEntity.mUniqueKey.equals(styleAdEntity.mUniqueKey)) {
                mBtn.setEnabled(false);
                mBtn.setText("已领取");
                isCanGetCoin = false;
                mBtn.setDrawableButtonColor(R.color.gray);
            }
        }
    }

    public void isDownloadOver(StyleAdEntity styleAdEntity,String path){
        EyeLog.logi("isDownloadOver:"+path+",item:"+mStyleAdEntity.mPkgName);
        this.path = path;
        if(mStyleAdEntity != null) {
            if (mStyleAdEntity.mPkgName.equals(styleAdEntity.mPkgName)) {
                close();
                mBtn.setDrawableButtonColor(R.color.get_coin_back);
                downLoadHandler.removeCallbacksAndMessages(null);
                mBtn.setProgress(mBtn.getmMaxProgress());
                mBtn.setText("点击安装");
                isCanGetCoin = true;
            }
        }
    }

    public boolean isCanGetCoin() {
        return isCanGetCoin;
    }

    /**
     * 下载Apk, 并设置Apk地址,
     * 默认位置: /storage/sdcard0/Download
     *
     * @param infoName    通知名称
     * @param description 通知描述
     */
    public long downloadApk(final StyleAdEntity mStyleAdEntity, String description, String infoName) {
        AdAppReportResult reportResult= TaskAdManager.getInstance(getContext()).getmAdManager().onAdAppDownloadStart(mStyleAdEntity);
        EyeLog.logi("+应用广告开始下载上报 reportResult:"+reportResult);

        DownloadManager.Request request;
        try {
            request = new DownloadManager.Request(Uri.parse(mStyleAdEntity.mDownloadUrl));
        } catch (Throwable e) {
            EyeLog.loge("+DownloadManager.Request (Throwable)\n"+e);
            return -1;
        }

        request.setTitle(infoName);
        request.setDescription(description);

        //在通知栏显示下载进度
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
            request.allowScanningByMediaScanner();
            request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
        }

        apkName =
                System.currentTimeMillis() + "_" + CommonUtil.getMD5(mStyleAdEntity.mDownloadUrl) + ".apk";
        request.setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, apkName);
        request.setVisibleInDownloadsUi(true);  //显示下载界面
        request.allowScanningByMediaScanner();  //准许被系统扫描到
        DownloadManager manager = (DownloadManager) getContext().getSystemService(Context.DOWNLOAD_SERVICE);
        //进入下载队列
        downloadId = manager.enqueue(request);
        return downloadId;
    }
}
