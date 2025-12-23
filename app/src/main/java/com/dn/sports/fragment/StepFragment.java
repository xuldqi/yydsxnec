package com.dn.sports.fragment;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.core.content.ContextCompat;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;
import androidx.viewpager.widget.ViewPager;
import com.dn.sports.R;
import com.dn.sports.utils.DisplayUtils;
import com.dn.sports.utils.Utils;

import net.lucode.hackware.magicindicator.MagicIndicator;
import net.lucode.hackware.magicindicator.ViewPagerHelper;
import net.lucode.hackware.magicindicator.buildins.commonnavigator.CommonNavigator;
import net.lucode.hackware.magicindicator.buildins.commonnavigator.abs.CommonNavigatorAdapter;
import net.lucode.hackware.magicindicator.buildins.commonnavigator.abs.IPagerIndicator;
import net.lucode.hackware.magicindicator.buildins.commonnavigator.abs.IPagerTitleView;
import net.lucode.hackware.magicindicator.buildins.commonnavigator.titles.CommonPagerTitleView;

import java.util.ArrayList;
import java.util.List;

public class StepFragment extends BaseFragment {

    private List<String> tabIndicators;

    private List<Integer> resIds;
    private final List<StepSubFragment> tabFragments = new ArrayList<>();

    @Override
    public View getViewByLayout(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_steps,container,false);
    }

    @Override
    public void initViewAction(View view) {
        view.findViewById(R.id.root).setPadding(0, Utils.getStatusBarHeight(getActivity()),0,0);

        tabIndicators = new ArrayList<>();
        tabIndicators.add("室外跑");
        tabIndicators.add("室内跑");
        tabIndicators.add("健走");
        tabIndicators.add("徒步");
        tabIndicators.add("登山");

        resIds = new ArrayList<>();
        resIds.add(R.mipmap.icon_room_out_run);
        resIds.add(R.mipmap.icon_room_in_run);
        resIds.add(R.mipmap.icon_walking);
        resIds.add(R.mipmap.icon_on_foot);
        resIds.add(R.mipmap.icon_climb);

        ViewPager viewPager = view.findViewById(R.id.viewPager);
        viewPager.setKeepScreenOn(true);
        MagicIndicator magicIndicator = view.findViewById(R.id.magicIndicator);
        CommonNavigator commonNavigator = new CommonNavigator(getContext());
        commonNavigator.setAdapter(new CommonNavigatorAdapter() {
            @Override
            public int getCount() {
                return tabIndicators.size();
            }

            @Override
            public IPagerTitleView getTitleView(Context context, int index) {
                CommonPagerTitleView commonPagerTitleView = new CommonPagerTitleView(context);
                commonPagerTitleView.setContentView(R.layout.item_sport_indicator);
                commonPagerTitleView.setPadding(DisplayUtils.INSTANCE.dp2px(8), 0, DisplayUtils.INSTANCE.dp2px(8), 0);
                ImageView bgImageView = commonPagerTitleView.findViewById(R.id.bgImageView);
                ImageView titleImageView = commonPagerTitleView.findViewById(R.id.titleImageView);
                titleImageView.setImageResource(resIds.get(index));
                TextView titleTextView = commonPagerTitleView.findViewById(R.id.titleTextView);
                titleTextView.setText(tabIndicators.get(index));
                commonPagerTitleView.setOnPagerTitleChangeListener(new CommonTitleChangeListener(bgImageView, titleTextView, context));
                commonPagerTitleView.setOnClickListener(view1 -> viewPager.setCurrentItem(index));
                return commonPagerTitleView;
            }

            @Override
            public IPagerIndicator getIndicator(Context context) {
                return null;
            }
        });
        magicIndicator.setNavigator(commonNavigator);
        ViewPagerHelper.bind(magicIndicator, viewPager);
        tabFragments.add(new StepSubFragment());
        tabFragments.get(tabFragments.size() - 1).setType(StepSubFragment.TYPE_RUN_OUTDOOR);
        tabFragments.add(new StepSubFragment());
        tabFragments.get(tabFragments.size() - 1).setType(StepSubFragment.TYPE_RUN_INDOOR);
        tabFragments.add(new StepSubFragment());
        tabFragments.get(tabFragments.size() - 1).setType(StepSubFragment.TYPE_FAST_WALK);
        tabFragments.add(new StepSubFragment());
        tabFragments.get(tabFragments.size() - 1).setType(StepSubFragment.TYPE_ON_FOOT);
        tabFragments.add(new StepSubFragment());
        tabFragments.get(tabFragments.size() - 1).setType(StepSubFragment.TYPE_MOUNTAIN_CLIMBING);
        StepFragment.ContentPagerAdapter contentAdapter = new StepFragment.ContentPagerAdapter(getActivity().getSupportFragmentManager());
        viewPager.setAdapter(contentAdapter);
        viewPager.setOffscreenPageLimit(4);
        viewPager.setCurrentItem(0);
    }

    public boolean isCountDowning(){
        for(StepSubFragment item:tabFragments){
            if(item.isCountDowning())
                return true;
        }
        return false;
    }

    @Override
    public void updateUserInfo() {

    }

    @Override
    public void clearUserInfo() {

    }

    public static class CommonTitleChangeListener implements CommonPagerTitleView.OnPagerTitleChangeListener {

        private final ImageView bgImageView;
        private final TextView titleTextView;
        private final Context context;

        public CommonTitleChangeListener(ImageView bgImageView, TextView titleTextView, Context context) {
            this.bgImageView = bgImageView;
            this.titleTextView = titleTextView;
            this.context = context;
        }
        @Override
        public void onSelected(int index, int totalCount) {
            bgImageView.setImageResource(R.mipmap.icon_indicator_selected);
            titleTextView.setTextColor(ContextCompat.getColor(context, R.color.color_F37866));
        }

        @Override
        public void onDeselected(int index, int totalCount) {
            bgImageView.setImageResource(R.mipmap.icon_indicator_unselected);
            titleTextView.setTextColor(ContextCompat.getColor(context, R.color.color_494949));
        }

        @Override
        public void onLeave(int index, int totalCount, float leavePercent, boolean leftToRight) {

        }

        @Override
        public void onEnter(int index, int totalCount, float enterPercent, boolean leftToRight) {

        }
    }

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
