package com.dn.sports;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.database.sqlite.SQLiteDatabase;
import android.os.Build;
import android.util.DisplayMetrics;
import android.util.Log;

import androidx.multidex.BuildConfig;
import androidx.multidex.MultiDex;
import androidx.multidex.MultiDexApplication;

//import com.baidu.mapapi.CoordType;
//import com.baidu.mapapi.SDKInitializer;
import com.bytedance.sdk.openadsdk.TTAdConfig;
import com.bytedance.sdk.openadsdk.TTAdConstant;
import com.bytedance.sdk.openadsdk.TTAdSdk;
import com.dn.sports.adcoinLogin.AdManager;
import com.dn.sports.adcoinLogin.StepUserManager;
import com.dn.sports.adcoinLogin.TaskAdManager;
import com.dn.sports.adcoinLogin.chuanshanjia.AdManagerImpl;
import com.dn.sports.adcoinLogin.chuanshanjia.TTLiveTokenHelper;
import com.dn.sports.common.BaseActivity;
import com.dn.sports.common.Constant;
import com.dn.sports.database.DbService;
import com.dn.sports.utils.DisplayUtils;
import com.dn.sports.utils.SharedPreferenceUtil;
import com.dn.sports.utils.ToastUtils;
import com.dn.sports.utils.Utils;
import com.meituan.android.walle.WalleChannelReader;
import com.umeng.analytics.MobclickAgent;
import com.umeng.commonsdk.UMConfigure;

import org.greenrobot.greendao.database.Database;

import java.util.ArrayList;
import java.util.List;

public class StepApplication extends MultiDexApplication {

    private static StepApplication instance;

    private List<Activity> activities = new ArrayList<>();

    private boolean showProduct = false;

    public boolean isShowProduct() {
        return showProduct;
    }

    public void setShowProduct(boolean showProduct) {
        this.showProduct = showProduct;
    }

    private boolean isShowAd = true;

    public void setShowAd(boolean showAd) {
        isShowAd = showAd;
    }

    public boolean isShowAd() {
        return isShowAd;
    }

    private DbService service;

    private boolean isShowMasonTask = false;

    public boolean isShowMasonTask() {
        return isShowMasonTask;
    }

    public synchronized DbService getService() {
        return service;
    }


    public static int screenWidth = 0;

    public static int screenHeight = 0;

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }

    @Override
    public void onCreate() {
        super.onCreate();
        instance = this;
//        TaskAdManager.initApplication(this);
//        StepUserManager.getInstance().initWXLoginID(Constant.WX_LOGIN.getWxAppId(this),Constant.WX_LOGIN.getWxSecret(this));
        DisplayUtils.INSTANCE.init(this);
        String channel = Utils.getMarket(this);
        Log.i("StepApplication","------------channel:"+channel+"------------");
        String myChannel = WalleChannelReader.getChannel(getApplicationContext());
        Boolean isAgree = (Boolean) SharedPreferenceUtil.Companion.getInstance(this).get("userAgree", false);
        if (isAgree) {
            UMConfigure.init(this, "649d44e7bd4b621232c3b6df",myChannel, UMConfigure.DEVICE_TYPE_PHONE, null);
            AdManagerImpl.INSTANCE.initSdk(this);
        }else {
            UMConfigure.preInit(this, "649d44e7bd4b621232c3b6df", myChannel);
        }
        service = new DbService(this);
//        SDKInitializer.initialize(this);
        //自4.3.0起，百度地图SDK所有接口均支持百度坐标和国测局坐标，用此方法设置您使用的坐标类型.
        //包括BD09LL和GCJ02两种坐标，默认是BD09LL坐标。
//        SDKInitializer.setCoordType(CoordType.BD09LL);
        ToastUtils.INSTANCE.init(this);
        getScreenSize();
    }

    /**
     * 获取屏幕尺寸
     */
    private void getScreenSize() {
        DisplayMetrics dm = getResources().getDisplayMetrics();
        screenHeight = dm.heightPixels;
        screenWidth = dm.widthPixels;
    }

    public static synchronized StepApplication getInstance(){
        return instance;
    }


    private static boolean sInit;
    private static final String TAG = "TTAdManagerHolder";







    public void addActivity(Activity activity) {
        if (activities != null) {
            if (activities.size() > 0) {
                if (!activities.contains(activity)) {
                    activities.add(activity);
                }
            } else {
                activities.add(activity);
            }
        }
    }

    public int getActivitySize() {
        if (activities != null) {
            return activities.size();
        }
        return 0;
    }

    public void removeActivity(Activity activity) {
        if (activities != null && activities.size() > 0) {
            if (activities.contains(activity)) {
                activities.remove(activity);
            }
        }
    }

    public void clearActivity() {
        if (activities != null) {
            activities.clear();
        }
    }

    public void exit() {
        if (activities != null && activities.size() > 0) {
            for (Activity activity : activities) {
                activity.finish();
            }
        }
        clearActivity();
    }
}
