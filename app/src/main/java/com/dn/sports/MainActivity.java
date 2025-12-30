package com.dn.sports;

import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Bundle;
import android.os.Message;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;
import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentPagerAdapter;
import androidx.viewpager.widget.ViewPager;

import com.bytedance.sdk.openadsdk.TTAdManager;
import com.dn.sports.adcoinLogin.Ad;
import com.dn.sports.adcoinLogin.LoginListener;
import com.dn.sports.adcoinLogin.StepUserManager;
import com.dn.sports.adcoinLogin.chuanshanjia.AdManagerImpl;
import com.dn.sports.adcoinLogin.model.RandomCoin;
import com.dn.sports.adcoinLogin.model.SignRecord;
import com.dn.sports.adcoinLogin.model.TaskModel;
import com.dn.sports.adcoinLogin.model.User;
import com.dn.sports.common.BaseActivity;
import com.dn.sports.common.CheckPermission;
import com.dn.sports.common.UIHandler;
import com.dn.sports.dialog.HintDialog;
import com.dn.sports.fragment.BaseFragment;
import com.dn.sports.fragment.HealthFragment;
import com.dn.sports.fragment.NewHomeFragment;
import com.dn.sports.fragment.NewTaskFragment;
import com.dn.sports.fragment.SettingFragment;
import com.dn.sports.fragment.StepFragment;
import com.dn.sports.utils.SharedPreferenceUtil;
import com.dn.sports.utils.Utils;
import java.util.ArrayList;
import java.util.List;

public class MainActivity extends BaseActivity {


    private BaseFragment homeFragment;
    private BaseFragment dailyFragment;
    private BaseFragment stepsFragment;
    private BaseFragment settingFragment;
    private ViewPager viewPager;
    private List<BaseFragment> fragments;
    private UIMyHandler msgHandler = new UIMyHandler(this);
    private Button mBtnHome;
//    private Button mBtnPrsion;
    private Button mBtnData;
    private Button mBtnSettings;
    private boolean isNeedGetInfoAfterLogin = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        initView();

        StepUserManager.getInstance().setLoginListener(loginListener);

//        if(!CheckPermission.checkMustPermission(this)){
//            CheckPermission.requestMustPermission(this,10001);
//        }else{
            if(!Utils.isNetworkAvailable(this)){
                return;
            }
            // todo 注册登陆
            if(StepUserManager.getInstance().isNeedRegister(MainActivity.this)) {
                StepUserManager.getInstance().registerByCodeOrAndroidId(this, null);
                isNeedGetInfoAfterLogin = true;
            }else{
                if(StepUserManager.getInstance().getUserInfo() == null){
                    StepUserManager.getInstance().getUserInfoBYUserId(this);
                    isNeedGetInfoAfterLogin = true;
                }else {
                    if(StepApplication.getInstance().isShowMasonTask()) {
                        StepUserManager.getInstance().getTaskList(this);
                        StepUserManager.getInstance().signRequestList(this);
                    }
                }
            }
//        }
    }


    private static class UIMyHandler extends UIHandler<MainActivity> {
        UIMyHandler(MainActivity cls) {
            super(cls);
        }

        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            MainActivity activity = ref.get();
            if (activity != null){
                if (activity.isFinishing())
                    return;
                switch (msg.what){
                }
            }
        }
    }

    private void refreshFragment(){
        if(homeFragment != null){
            homeFragment.updateUserInfo();
        }
        if(dailyFragment != null){
            dailyFragment.updateUserInfo();
        }
        if(settingFragment != null){
            settingFragment.updateUserInfo();
        }

    }

    private LoginListener loginListener = new LoginListener(){

        @Override
        public void onHintUserNew(final User user) {
            super.onHintUserNew(user);
        }

        @Override
        public void onClearLogin() {
            super.onClearLogin();
        }

        @Override
        public void onRegisterError(String state, String message) {
            super.onRegisterError(state, message);
            msgHandler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    final HintDialog hintDialog = new HintDialog(MainActivity.this,false);
                    hintDialog.setRegisterHint(message);
                    hintDialog.showDialogAtCenter();
                }
            },500);
        }

        @Override
        public void onSyncTaskAdResult(final int reward) {
            super.onSyncTaskAdResult(reward);
            Toast.makeText(MainActivity.this,
                    getResources().getString(R.string.sync_task_ad_title)+reward,Toast.LENGTH_SHORT).show();
        }

        @Override
        public void onLogin(User info,boolean needUpdate) {
            super.onLogin(info,needUpdate);
            if(needUpdate) {
                refreshFragment();
                if(StepApplication.getInstance().isShowMasonTask()) {
                    StepUserManager.getInstance().getRandomCoinList(MainActivity.this);
                    StepUserManager.getInstance().signRequestList(MainActivity.this);
                }
            }
        }

        @Override
        public void onUserInfoUpdate(int msg, User info) {
            super.onUserInfoUpdate(msg,info);
            refreshFragment();

            if(isNeedGetInfoAfterLogin){
                isNeedGetInfoAfterLogin = false;
                if(StepApplication.getInstance().isShowMasonTask()) {
                    StepUserManager.getInstance().signRequestList(MainActivity.this);
                    StepUserManager.getInstance().getTaskList(MainActivity.this);
                }
            }
        }

        @Override
        public void onRandomList(List<RandomCoin> datas) {
            super.onRandomList(datas);
//            if(homeFragment != null){
//                ((HomeFragment) homeFragment).setRandomCoinList(datas);
//            }
        }

        @Override
        public void onSyncSteps() {
            super.onSyncSteps();
            refreshFragment();
            Toast.makeText(getApplicationContext(),"同步步数成功",Toast.LENGTH_SHORT).show();

//            Intent it = new Intent(MainActivity.this,AdActivity.class);
//            it.putExtra(AdActivity.AD_TYPE,AdActivity.SYNC_STEP);
//            startActivity(it);

//            if(homeFragment != null){
//                ((NewHomeFragment)homeFragment).setStepText(StepUserManager.getInstance().getTodaySteps());
//            }
        }

        @Override
        public void onSign() {
            super.onSign();
            if(dailyFragment != null){
                ((NewTaskFragment)dailyFragment).onSign();
            }
            refreshFragment();
        }

        @Override
        public void onSignList(List<SignRecord> datas) {
            super.onSignList(datas);
            if(dailyFragment != null){
                ((NewTaskFragment)dailyFragment).onSignList(datas);
            }
        }

        @Override
        public void onAlreadySign() {
            super.onAlreadySign();
        }

        @Override
        public void onTaskList(List<TaskModel> datas) {
            super.onTaskList(datas);
            if(dailyFragment != null){
                ((NewTaskFragment)dailyFragment).updateTaskList();
            }
        }

        @Override
        public void onGetTaskReward(TaskModel taskModel) {
            super.onGetTaskReward(taskModel);
            if(dailyFragment != null){
                ((NewTaskFragment)dailyFragment).updateSingleTask(taskModel);
            }
        }

        @Override
        public void onUpdateTask(TaskModel taskModel) {
            super.onUpdateTask(taskModel);
            if(dailyFragment != null){
                ((NewTaskFragment)dailyFragment).updateSingleTask(taskModel);
            }
        }

        @Override
        public void onError(int msg, String info) {
            super.onError(msg, info);

            msgHandler.post(new Runnable() {
                @Override
                public void run() {
                    if(msg == Ad.Login.MSG_INVITE_FRIEND){
                        Toast.makeText(MainActivity.this,info,Toast.LENGTH_SHORT).show();
                    }else if(msg == Ad.Login.MSG_SYNC_TASK_RESULT){
                        Toast.makeText(MainActivity.this,"任务同步错误，获取积分失败",Toast.LENGTH_SHORT).show();
                    }
                }
            });
        }

        @Override
        public void onInviteFirend() {
            super.onInviteFirend();
            Toast.makeText(MainActivity.this,"绑定成功",Toast.LENGTH_SHORT).show();
        }

        @Override
        public void onExitLogin() {
            super.onExitLogin();
            isNeedGetInfoAfterLogin = true;
            if(homeFragment != null){
                homeFragment.clearUserInfo();
            }
            if(dailyFragment != null){
                dailyFragment.clearUserInfo();
            }
            if(settingFragment != null){
                settingFragment.clearUserInfo();
            }
        }

        @Override
        public void onStepChange() {
            super.onStepChange();

            //todo update
//            if(homeFragment != null){
//                ((NewHomeFragment)homeFragment).setStepText(StepUserManager.getInstance().getTodaySteps());
//            }
        }
    };

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
    }

    @Override
    protected void onRestoreInstanceState(Bundle savedInstanceState) {
        super.onRestoreInstanceState(savedInstanceState);
    }


    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if(requestCode == 10001){
            for(int result:grantResults){
                if(result != PackageManager.PERMISSION_GRANTED){
                    Toast.makeText(this,getResources().getString(R.string.deny_permission),Toast.LENGTH_SHORT).show();
                    return;
                }
            }
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if(dailyFragment != null){
            dailyFragment.updateUserInfo();
        }
        if(settingFragment != null){
            settingFragment.updateUserInfo();
        }
        StepUserManager.getInstance().checkIsFirstOpenToday(this);
        if(StepUserManager.getInstance().isMustNeedLogin()){
            Intent it = new Intent(MainActivity.this,MustLoginActivity.class);
            startActivity(it);
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        //StepUserManager.getInstance().unRegisterStepListener(this);
    }

    private static final int TIME_EXIT=2000;
    private long mBackPressed;

    @Override
    public void onBackPressed() {
        if(((StepFragment)stepsFragment).isCountDowning()){
            return;
        }
        if (mBackPressed + TIME_EXIT > System.currentTimeMillis()) {
            Intent it = new Intent(this,StepServices.class);
            stopService(it);

            StepApplication.getInstance().exit();
        } else {
            Toast.makeText(this, getResources().getString(R.string.exit_app), Toast.LENGTH_SHORT).show();
            mBackPressed = System.currentTimeMillis();
        }
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        StepUserManager.getInstance().removeLoginListener(loginListener);
    }

    private void initView(){

        homeFragment = new HealthFragment();
        stepsFragment = new StepFragment();
        settingFragment = new SettingFragment();



        mBtnHome = findViewById(R.id.home);
        mBtnData = findViewById(R.id.data);
        mBtnSettings = findViewById(R.id.settings);
        homeFragment.setActivityHandler(msgHandler);
        dailyFragment = new NewTaskFragment();
        dailyFragment.setActivityHandler(msgHandler);
        stepsFragment.setActivityHandler(msgHandler);
        settingFragment.setActivityHandler(msgHandler);
        viewPager = findViewById(R.id.fragment_area);
        fragments = new ArrayList<>();
        fragments.add(homeFragment);
        fragments.add(stepsFragment);
//        if(StepApplication.getInstance().isShowMasonTask()) {
//            fragments.add(dailyFragment);
//        }
        fragments.add(settingFragment);
        viewPager.setOffscreenPageLimit(3);
        viewPager.setAdapter(new FragmentPagerAdapter(getSupportFragmentManager()) {
            @Override
            public int getCount() {
                return fragments.size();
            }

            @Override
            public Fragment getItem(int arg0) {
                return fragments.get(arg0);
            }
        });
        viewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int i, float v, int i1) {

            }

            @Override
            public void onPageSelected(int i) {
                if(i == 2 && !StepApplication.getInstance().isShowMasonTask()){
                    setFocusItem(2);
                }else{
                    setFocusItem(i);
                }
                if(i == 1){
                    dailyFragment.updateUserInfo();
                }
            }

            @Override
            public void onPageScrollStateChanged(int i) {

            }
        });
        mBtnHome.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                viewPager.setCurrentItem(0);
            }
        });
//        mBtnPrsion.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                viewPager.setCurrentItem(2);
//            }
//        });
        mBtnData.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                viewPager.setCurrentItem(1);
            }
        });
        mBtnSettings.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                viewPager.setCurrentItem(2);
            }
        });
        viewPager.setCurrentItem(0);
        setFocusItem(0);
        Boolean firstOpen = (Boolean) SharedPreferenceUtil.Companion.getInstance(this).get("firstOpen", true);
        boolean open = (boolean) SharedPreferenceUtil.Companion.getInstance(this).get("testFeedMessage", true);
        if (open && Boolean.FALSE.equals(firstOpen)) {
            Intent it = new Intent(this,StepServices.class);
            if (Build.VERSION.SDK_INT >= 26) {
                startForegroundService(it);
            } else {
                startService(it);
            }
        }
//        showAds();
        SharedPreferenceUtil.Companion.getInstance(this).put("firstOpen", false);
    }


    private  void  showAds(){
//        Boolean firstOpen = (Boolean) SharedPreferenceUtil.Companion.getInstance(this).get("firstOpen", true);
//        if(Boolean.FALSE.equals(firstOpen) || BuildConfig.DEBUG){
            AdManagerImpl adManager= AdManagerImpl.INSTANCE;
            adManager.showAd(this,"953473682",false);
//        }
    }

    private void setFocusItem(int item){
        if (item == 0) {
            setBtnDrawableTop(R.mipmap.love_icon_select, mBtnHome, true);
            setBtnDrawableTop(R.mipmap.sport_icon, mBtnData, false);
            setBtnDrawableTop(R.mipmap.mine_icon, mBtnSettings, false);
        } else if (item == 1) {
            setBtnDrawableTop(R.mipmap.love_icon, mBtnHome, false);
            setBtnDrawableTop(R.mipmap.sport_icon_select, mBtnData, true);
            setBtnDrawableTop(R.mipmap.mine_icon, mBtnSettings, false);
        } else if (item == 2) {
            setBtnDrawableTop(R.mipmap.love_icon, mBtnHome, false);
            setBtnDrawableTop(R.mipmap.sport_icon, mBtnData, false);
            setBtnDrawableTop(R.mipmap.mine_icon_select, mBtnSettings, true);
        }
    }

    private void setBtnDrawableTop(int resId,Button btn,boolean isFocus){
        Drawable drawable = getResources().getDrawable(resId);
        drawable.setBounds(0, 0, drawable.getMinimumWidth(),drawable.getMinimumHeight());
        btn.setCompoundDrawables(null, drawable, null, null);

//        btn.setBackgroundResource(resId);

        if (isFocus) {
            btn.setTextColor(Color.parseColor("#FF846C"));
        }else{
            btn.setTextColor(Color.GRAY);
        }
    }
}
