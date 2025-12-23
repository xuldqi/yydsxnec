package com.dn.sports;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import androidx.annotation.Nullable;

import com.dn.sports.adcoinLogin.CommonUtil;
import com.dn.sports.adcoinLogin.TaskAdManager;
import com.dn.sports.adcoinLogin.model.TaskModel;
import com.dn.sports.common.BaseActivity;
import com.dn.sports.common.EyeLog;
import com.dn.sports.dialog.HintDialog;
import com.dn.sports.dialog.ProgressDialog;
import com.dn.sports.utils.Utils;
import com.dn.sports.view.MasonItemView;
import com.dn.sports.view.TaskAdItem;
import com.tmsdk.module.ad.StyleAdEntity;
import com.tmsdk.module.coin.CoinTask;
import com.tmsdk.module.coin.ErrorCode;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class TaskAdActivity extends BaseActivity {
    private Map<StyleAdEntity, CoinTask> mAdKeyTaskValue = new HashMap<>();
    private TaskAdManager taskAdManager;
    public LinearLayout mListView;
    private ProgressDialog dialog = null;
    private boolean isAdLoaded = false;
    private Handler handler = new Handler(Looper.getMainLooper());


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_ad);
        findViewById(R.id.root_layout).setPadding(0, Utils.getStatusBarHeight(this),0,0);
        findViewById(R.id.back_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        TextView title = findViewById(R.id.title);
        title.setText(getResources().getString(R.string.task_ad));
        taskAdManager = TaskAdManager.getInstance(this);
        mListView = findViewById(R.id.coin_ad_lv);
        taskAdManager.setTaskAdListener(new TaskAdManager.TaskAdListener() {
            @Override
            public void onTaskAdList(List<StyleAdEntity> data, Map<StyleAdEntity, CoinTask> adKeyTaskValue) {
                isAdLoaded = true;
                if(dialog != null&&dialog.isShowing())
                    dialog.dismiss();
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        for (StyleAdEntity mStyleAdEntity : data) {
                            if(isMasonListViewContainTask(mStyleAdEntity.mUniqueKey) == null) {
                                CoinTask coinTask = adKeyTaskValue.get(mStyleAdEntity);
                                taskAdManager.reportAdDisplay(mStyleAdEntity);
                                TaskAdItem taskAdItem = new TaskAdItem(TaskAdActivity.this);
                                mListView.addView(taskAdItem);
                                taskAdItem.showItem(mStyleAdEntity, coinTask);
                            }
                        }
                    }
                });
            }

            @Override
            public void onTaskAdError(int code, String errorMsg) {
                isAdLoaded = true;
                if(dialog != null&&dialog.isShowing())
                    dialog.dismiss();
            }

            @Override
            public void onDownloadAppResult(StyleAdEntity mStyleAdEntity, int type,String path) {

            }

            @Override
            public void onOpenAppResult(StyleAdEntity mStyleAdEntity, int type) {
                if(type == ErrorCode.EC_SUCCESS){
                    int count = mListView.getChildCount();
                    for (int i = 0;i<count;i++){
                        View view = mListView.getChildAt(i);
                        if(view instanceof TaskAdItem){
                            ((TaskAdItem)view).checkOpenSuccess(mStyleAdEntity);
                        }
                    }
                }
            }

            @Override
            public void onInstallAppResult(String pkg, int type) {

            }
        });

        taskAdManager.getTaskAndAd();
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                if(!isAdLoaded) {
                    dialog = ProgressDialog.createDialog(TaskAdActivity.this);
                    dialog.show();
                }
            }
        },100);

        // 已移除：应用安装监听广播注册 (隐私合规整改)
        // 原因：监听PACKAGE_ADDED属于超范围收集个人信息
    }

    private BroadcastReceiver installedReceiver;

    @Override
    protected void onDestroy() {
        super.onDestroy();
        // 已移除广播注销代码 (隐私合规整改)
    }

    private TaskAdItem isMasonListViewContainTask(String taskId){
        int count = mListView.getChildCount();
        for (int i = 0;i<count;i++){
            View view = mListView.getChildAt(i);
            if(view instanceof TaskAdItem){
                String onlyId = ((TaskAdItem)view).getOnlyId();
                if(onlyId.equals(taskId)){
                    return ((TaskAdItem)view);
                }
            }
        }
        return null;
    }


    public static class BootReceiver extends BroadcastReceiver {
        private TaskAdActivity taskAdActivity;

        public BootReceiver(TaskAdActivity activity){
            taskAdActivity = activity;
        }

        @Override
        public void onReceive(Context context, Intent intent) {
            if(intent == null || intent.getData() == null)
                return;
            String packageName = intent.getData().getSchemeSpecificPart();
            EyeLog.logi("BootReceiver install："+packageName);
            if(!TextUtils.isEmpty(packageName)) {
                int count = taskAdActivity.mListView.getChildCount();
                for (int i = 0; i < count; i++) {
                    View view = taskAdActivity.mListView.getChildAt(i);
                    if (view instanceof TaskAdItem) {
                        ((TaskAdItem)view).checkIsInstall();
                    }
                }
            }
        }
    }

    @Override
    public void onBackPressed() {
        int count = mListView.getChildCount();
        for (int i = 0;i<count;i++){
            View view = mListView.getChildAt(i);
            if(view instanceof TaskAdItem){
                boolean isCanGetCoin = ((TaskAdItem)view).isCanGetCoin();
                if(isCanGetCoin){
                    HintDialog hintDialog = new HintDialog(this,false);
                    hintDialog.setTaskAdHint(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            finish();
                        }
                    });
                    hintDialog.showDialogAtCenter();
                    return;
                }
            }
        }
        super.onBackPressed();
    }
}
