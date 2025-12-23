package com.dn.sports;

import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;
import androidx.viewpager.widget.ViewPager;

import com.dn.sports.common.BaseActivity;
import com.dn.sports.common.LogUtils;
import com.dn.sports.database.BodyRecordModel;
import com.dn.sports.dialog.RulerViewPickDialog;
import com.dn.sports.fragment.RecordSubFragment;
import com.dn.sports.fragment.StepFragment;
import com.dn.sports.greendao.DbHelper;
import com.dn.sports.ormbean.BodyRecord;
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

public class BodyRecordActivity extends BaseActivity {

    private MagicIndicator magicIndicator;
    private ViewPager mContentVp;
    private List<String> tabIndicators;
    private int mCurrentType = 1;
    private ContentPagerAdapter contentAdapter;
    private List<RecordSubFragment> tabFragments = new ArrayList<>();
    private List<Integer> resIds;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_body_record);
        magicIndicator = findViewById(R.id.magicIndicator);
        findViewById(R.id.back_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });


//        findViewById(R.id.right_btn).setVisibility(View.VISIBLE);
        ((ImageView)findViewById(R.id.right_btn)).setImageResource(R.mipmap.body_record_info_btn);
        findViewById(R.id.right_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //todo 暂时去掉身体概览页面
//                Intent it = new Intent(BodyRecordActivity.this,BodyRecordInfoActivity.class);
//                startActivity(it);
            }
        });
        ((TextView) findViewById(R.id.title)).setText("身体数据");
        findViewById(R.id.root).setPadding(0, Utils.getStatusBarHeight(this),0,0);

        mContentVp = findViewById(R.id.vp_content);
        tabIndicators = new ArrayList<>();
        tabIndicators.add("身高");
        tabIndicators.add("体重");
        tabIndicators.add("胸围");
        tabIndicators.add("腰围");
        tabIndicators.add("臀围");
        tabIndicators.add("上臂围");
        tabIndicators.add("大腿围");
        tabIndicators.add("小腿围");


        resIds = new ArrayList<>();
        resIds.add(R.mipmap.icon_height);
        resIds.add(R.mipmap.bg_small_weight);
        resIds.add(R.mipmap.icon_xiongwei);
        resIds.add(R.mipmap.icon_yaowei);
        resIds.add(R.mipmap.icon_tunwei);
        resIds.add(R.mipmap.icon_shangbi);
        resIds.add(R.mipmap.bg_big_leg);
        resIds.add(R.mipmap.bg_small_leg);

        tabFragments.add(new RecordSubFragment(RecordSubFragment.TYPE_HEIGHT,tabIndicators.get(0)));
        tabFragments.add(new RecordSubFragment(RecordSubFragment.TYPE_WEIGHT,tabIndicators.get(1)));
        tabFragments.add(new RecordSubFragment(RecordSubFragment.TYPE_XW,tabIndicators.get(2)));
        tabFragments.add(new RecordSubFragment(RecordSubFragment.TYPE_YW,tabIndicators.get(3)));
        tabFragments.add(new RecordSubFragment(RecordSubFragment.TYPE_TW,tabIndicators.get(4)));
        tabFragments.add(new RecordSubFragment(RecordSubFragment.TYPE_SBW,tabIndicators.get(5)));
        tabFragments.add(new RecordSubFragment(RecordSubFragment.TYPE_DTW,tabIndicators.get(6)));
        tabFragments.add(new RecordSubFragment(RecordSubFragment.TYPE_XTW,tabIndicators.get(7)));

        contentAdapter = new ContentPagerAdapter(getSupportFragmentManager());
        mContentVp.setAdapter(contentAdapter);
        mContentVp.setOffscreenPageLimit(7);



        CommonNavigator commonNavigator = new CommonNavigator(this);
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
                commonPagerTitleView.setOnPagerTitleChangeListener(new StepFragment.CommonTitleChangeListener(bgImageView, titleTextView, context));
                commonPagerTitleView.setOnClickListener(view1 -> mContentVp.setCurrentItem(index));
                return commonPagerTitleView;
            }

            @Override
            public IPagerIndicator getIndicator(Context context) {
                return null;
            }
        });
        magicIndicator.setNavigator(commonNavigator);
        ViewPagerHelper.bind(magicIndicator, mContentVp);
        int scrollLeft=0;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            commonNavigator.findViewById(R.id.scroll_view).setOnScrollChangeListener(new View.OnScrollChangeListener() {
                @Override
                public void onScrollChange(View view, int i, int i1, int i2, int i3) {
                    int scrollLeft = 0;
                    scrollLeft = DisplayUtils.INSTANCE.px2dp(i);
                    LogUtils.d("xuyimin", "l:" + DisplayUtils.INSTANCE.px2dp(i));
                    setTagPosition(scrollLeft>50);
                }
            });
        }


        mContentVp.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                mCurrentType = tabFragments.get(position).getType();
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });

        mContentVp.setCurrentItem(0);
        left=findViewById(R.id.left);
        right=findViewById(R.id.right);
        findViewById(R.id.add_record).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                final RulerViewPickDialog rulerViewPickDialog = new RulerViewPickDialog(BodyRecordActivity.this);
                rulerViewPickDialog.initWithType(tabIndicators.get(mContentVp.getCurrentItem()),mCurrentType, new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        BodyRecord model = new BodyRecord();
                        model.setTime(System.currentTimeMillis());
                        model.setData(String.valueOf(rulerViewPickDialog.getRulerData()));
                        model.setType(mCurrentType);
                        model.setUnit(BodyRecordModel.getUnitByType(mCurrentType));
//                        long id = StepApplication.getInstance().getService().insertBodyRecord(model.getDbData());
//                        if(id >=0){
//                            Toast.makeText(getApplicationContext(),"保存成功",Toast.LENGTH_SHORT).show();
//                            contentAdapter.getItem(mContentVp.getCurrentItem()).updateList();
//                        }
                        DbHelper.INSTANCE.getDaoSession().getBodyRecordDao().insert(model);
                        Toast.makeText(getApplicationContext(),"保存成功",Toast.LENGTH_SHORT).show();
                        contentAdapter.getItem(mContentVp.getCurrentItem()).updateList();
                        LogUtils.d(DbHelper.INSTANCE.getTAG(), "insert"+model.toString());
                        rulerViewPickDialog.dismissDialog();
                        //todo chart data
                    }
                },0f);
                rulerViewPickDialog.showDialogAtBottom();
            }
        });
    }

    boolean lastIsLeft = false;

    ImageView left;
    ImageView right;




    private void setTagPosition(boolean isLeft) {
        if (lastIsLeft == isLeft) {
            return;
        }
        lastIsLeft = isLeft;
        left.setVisibility(!isLeft ? View.VISIBLE : View.GONE);
        right.setVisibility(!isLeft ? View.GONE : View.VISIBLE);
    }

    class ContentPagerAdapter extends FragmentPagerAdapter {
        public ContentPagerAdapter(FragmentManager fm) {
            super(fm);
        }

        @Override
        public RecordSubFragment getItem(int position) {
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
