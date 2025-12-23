package com.dn.sports;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.graphics.Color;
import android.os.Bundle;
import android.os.IBinder;
import android.os.PersistableBundle;
import android.view.View;
import android.view.WindowManager;

import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;
import androidx.viewpager.widget.ViewPager;

import com.google.android.material.tabs.TabLayout;
import com.dn.sports.common.BaseActivity;
import com.dn.sports.dialog.HintDialog;
import com.dn.sports.fragment.SubCountTimeFragment;
import com.dn.sports.fragment.SubMiaoBiaoFragment;
import com.dn.sports.target.CountTimeServices;
import com.dn.sports.utils.DisplayUtils;
import com.dn.sports.utils.MagicIndicatorHelper;
import com.dn.sports.utils.Utils;

import net.lucode.hackware.magicindicator.MagicIndicator;
import net.lucode.hackware.magicindicator.buildins.commonnavigator.CommonNavigator;
import net.lucode.hackware.magicindicator.buildins.commonnavigator.abs.CommonNavigatorAdapter;
import net.lucode.hackware.magicindicator.buildins.commonnavigator.abs.IPagerIndicator;
import net.lucode.hackware.magicindicator.buildins.commonnavigator.abs.IPagerTitleView;
import net.lucode.hackware.magicindicator.buildins.commonnavigator.indicators.LinePagerIndicator;
import net.lucode.hackware.magicindicator.buildins.commonnavigator.titles.SimplePagerTitleView;

import java.util.ArrayList;
import java.util.List;

public class CountTimeActivity extends BaseActivity {

    private MagicIndicator mTabTl;


    private ViewPager mContentVp;
    private List<String> tabIndicators;
    private List<Fragment> tabFragments = new ArrayList<>();
    private SubCountTimeFragment subCountTimeFragment;
    private SubMiaoBiaoFragment subMiaoBiaoFragment;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED
                | WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON);
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_count_time);
        setTitle("时间计时");

        findViewById(R.id.root).setPadding(0, Utils.getStatusBarHeight(this),0,0);
        mContentVp = findViewById(R.id.vp_content);
        mContentVp.setKeepScreenOn(true);
        setShowWhenLocked(true);
        mTabTl = findViewById(R.id.tl_tab);
        tabIndicators = new ArrayList<>();
        tabIndicators.add("秒表计时");
        tabIndicators.add("倒计时");

        CommonNavigator commonNavigator = new CommonNavigator(this);
        commonNavigator. setAdapter(new CommonNavigatorAdapter() {
            @Override
            public int getCount() {
                return tabIndicators.size();
            }

            @Override
            public IPagerTitleView getTitleView(Context context, int index) {
                SimplePagerTitleView simplePagerTitleView = new SimplePagerTitleView(context);
                String title = tabIndicators.get(index);
                simplePagerTitleView.setText(title);
                simplePagerTitleView.setPadding(DisplayUtils.INSTANCE.dp2px(33),0,DisplayUtils.INSTANCE.dp2px(33),0);
                simplePagerTitleView.setTextSize(16f);
                simplePagerTitleView.setSelectedColor(Color.parseColor("#F37866"));
                simplePagerTitleView.setNormalColor(Color.parseColor("#44464D"));
                simplePagerTitleView.setOnClickListener(v->mContentVp.setCurrentItem(index));
                return simplePagerTitleView;
            }

            @Override
            public IPagerIndicator getIndicator(Context context) {
                LinePagerIndicator indicator = new LinePagerIndicator(context);
                indicator.setMode(LinePagerIndicator.MODE_WRAP_CONTENT);
                indicator.setRoundRadius(DisplayUtils.INSTANCE.dp2px(1.6f));
                indicator.setColors(
                        Color.parseColor("#F37866")
                );
                return indicator;
            }
        });


        subCountTimeFragment = new SubCountTimeFragment();
        subMiaoBiaoFragment = new SubMiaoBiaoFragment();
        tabFragments.add(subMiaoBiaoFragment);
        tabFragments.add(subCountTimeFragment);

        ContentPagerAdapter contentAdapter = new ContentPagerAdapter(getSupportFragmentManager());
        mContentVp.setAdapter(contentAdapter);
        mContentVp.setOffscreenPageLimit(2);
//        mTabTl.setupWithViewPager(mContentVp);

        mTabTl.setNavigator(commonNavigator);
        MagicIndicatorHelper.INSTANCE.bind(mTabTl,mContentVp,null,null);

        mContentVp.setCurrentItem(0);

        Intent intent = new Intent(this, CountTimeServices.class);
        bindService(intent, connection, Context.BIND_AUTO_CREATE);


        findViewById(R.id.back_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                checkExit();
            }
        });
    }

    @Override
    public void onBackPressed() {
        checkExit();
    }

    private void checkExit(){
        if(subMiaoBiaoFragment.isStart()){
            showExitHint("运动计时中，是否退出？");
            return;
        }

        if(subCountTimeFragment.isStart()){
            showExitHint("运动计时中，是否退出？");
            return;
        }
        finish();
    }

    private void showExitHint(String msg){
        HintDialog hintDialog = new HintDialog(this,false);
        hintDialog.setExitCountTime(msg, new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });
        hintDialog.showDialogAtCenter();
    }

    @Override
    public void onSaveInstanceState(Bundle outState, PersistableBundle outPersistentState) {

    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        subMiaoBiaoFragment.stop();
        subCountTimeFragment.stop();
        try {
            unbindService(connection);
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    private CountTimeServices service;

    private ServiceConnection connection = new ServiceConnection() {
        public void onServiceConnected(ComponentName className, IBinder iBinder) {

            CountTimeServices.CountTimeServicesBinder binder = (CountTimeServices.CountTimeServicesBinder) iBinder;
            service = binder.getCountTimeService();
        }

        @Override
        public void onServiceDisconnected(ComponentName componentName) {

        }
    };

     class ContentPagerAdapter extends FragmentPagerAdapter {
        public ContentPagerAdapter(FragmentManager fm) {
            super(fm);
        }

        @Override
        public Fragment getItem(int position) {
            return tabFragments.get(position);
        }

        @Override
        public int getCount() {
            return tabIndicators.size();
        }

        @Override
        public CharSequence getPageTitle(int position) {
            return tabIndicators.get(position);

        }
    }
}
