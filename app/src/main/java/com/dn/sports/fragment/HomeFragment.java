package com.dn.sports.fragment;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.Message;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.AnimationSet;
import android.view.animation.AnimationUtils;
import android.view.animation.ScaleAnimation;
import android.view.animation.TranslateAnimation;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.github.lzyzsd.circleprogress.ArcProgress;
import com.dn.sports.AdActivity;
import com.dn.sports.CountTimeActivity;
import com.dn.sports.LuckRewardActivity;
import com.dn.sports.R;
import com.dn.sports.ShareFirendActivity;
import com.dn.sports.SignActivity;
import com.dn.sports.StepApplication;
import com.dn.sports.TargetActivity;
import com.dn.sports.adcoinLogin.StepUserManager;
import com.dn.sports.adcoinLogin.model.RandomCoin;
import com.dn.sports.adcoinLogin.model.User;
import com.dn.sports.common.CheckPermission;
import com.dn.sports.common.EyeLog;
import com.dn.sports.common.UIHandler;
import com.dn.sports.common.UmengLog;
import com.dn.sports.dialog.WXHintDialog;
import com.dn.sports.utils.Utils;
import com.dn.sports.view.RandomCoinView;

import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;

import pl.droidsonroids.gif.AnimationListener;

public class HomeFragment extends BaseFragment {

    private TextView mCurrentStepsTextView;
    private List<RandomCoinView> randomCoinViews = new ArrayList<>();
    private StepUserManager stepUserManager;
    private TextView data1;
    private TextView data2;
    private TextView data3;
    private ArcProgress arcProgress;
    private TextView getCoin;

    @Override
    public View getViewByLayout(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return null;
    }

    @Override
    public void initViewAction(View view) {

    }

    @Override
    public void updateUserInfo() {

    }

    @Override
    public void clearUserInfo() {

    }

//    private static class UIMyHandler extends UIHandler<HomeFragment> {
//        UIMyHandler(HomeFragment cls) {
//            super(cls);
//        }
//
//        @Override
//        public void handleMessage(Message msg) {
//            super.handleMessage(msg);
//            HomeFragment root = ref.get();
//            if(root == null)
//                return;
//            if(msg.what == 1){
//                if(root == null)
//                    return;
//            }
//        }
//    }
//
//    @Override
//    public View getViewByLayout(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
//        stepUserManager = StepUserManager.getInstance();
//        return inflater.inflate(R.layout.fragment_home,container,false);
//    }
//
//    @Override
//    public void initViewAction(View view) {
//        int stateBarH = Utils.getStatusBarHeight(getActivity());
//        view.findViewById(R.id.root).setPadding(0,stateBarH,0,0);
//        view.findViewById(R.id.back_btn).setVisibility(View.GONE);
//        ((TextView)view.findViewById(R.id.title)).setText(getResources().getString(R.string.today_target_steps));
//        mCurrentStepsTextView = view.findViewById(R.id.today_current_steps);
//        setStepText(stepUserManager.getTodaySteps());
//        arcProgress = view.findViewById(R.id.donut_progress);
//
//        FrameLayout.LayoutParams lp = (FrameLayout.LayoutParams)arcProgress.getLayoutParams();
//        lp.width = (Utils.getWidth(getActivity())*4)/7;
//        lp.height = lp.width;
//        arcProgress.setLayoutParams(lp);
//
//        view.findViewById(R.id.right_btn).setVisibility(View.INVISIBLE);
//        view.findViewById(R.id.right_btn).setBackgroundResource(R.mipmap.everyday_reward);
//        view.findViewById(R.id.right_btn).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                Intent it = new Intent(getActivity(), AdActivity.class);
//                it.putExtra(AdActivity.AD_TYPE,AdActivity.SIGN_COIN);
//                it.putExtra("ad_coin",1);
//                it.putExtra("ad_coin_id",1);
//                startActivity(it);
//            }
//        });
//
//        TextView wxSyncSteps = (TextView)view.findViewById(R.id.wx_get_steps);
//        wxSyncSteps.getPaint().setFlags(Paint.UNDERLINE_TEXT_FLAG); //下划线
//        wxSyncSteps.getPaint().setAntiAlias(true);
//        wxSyncSteps.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                if(Utils.isOpenWXHint(getActivity())){
//                    showWXHint();
//                }else{
//                    StepUserManager.getInstance().launchMiniPro(getActivity());
//                }
//            }
//        });
//
//        getCoin = view.findViewById(R.id.get_coin);
//        getCoin.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                int steps = StepUserManager.getInstance().getTodaySteps();
//                StepUserManager.getInstance().syncSteps(getActivity(),steps+"");
//            }
//        });
//
//        view.findViewById(R.id.target_count_time).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                Intent it = new Intent(getActivity(), CountTimeActivity.class);
//                startActivity(it);
//            }
//        });
//
//        view.findViewById(R.id.target_record).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                Intent it = new Intent(getActivity(), TargetActivity.class);
//                startActivity(it);
//            }
//        });
//
//        RandomCoinView mCoinTextOne = view.findViewById(R.id.coin_one);
//        RandomCoinView mCoinTextTwo = view.findViewById(R.id.coin_two);
//        RandomCoinView mCoinTextThree = view.findViewById(R.id.coin_three);
//        //RandomCoinView mCoinTextFour = view.findViewById(R.id.coin_four);
//        RandomCoinView mCoinTextFive = view.findViewById(R.id.coin_five);
//        randomCoinViews.add(mCoinTextOne);
//        randomCoinViews.add(mCoinTextTwo);
//        randomCoinViews.add(mCoinTextThree);
//        //randomCoinViews.add(mCoinTextFour);
//        randomCoinViews.add(mCoinTextFive);
//
//        view.findViewById(R.id.sign_page).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                Intent it = new Intent(getActivity(), SignActivity.class);
//                startActivity(it);
//            }
//        });
//        view.findViewById(R.id.home_invite_friend).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                if(StepUserManager.getInstance().isNeedLogin()){
//                    Toast.makeText(getActivity(),"请先登录，再邀请好友",Toast.LENGTH_SHORT).show();
//                    return;
//                }
//                Intent it = new Intent(getActivity(), ShareFirendActivity.class);
//                it.putExtra("share_app",true);
//                startActivity(it);
//            }
//        });
//        view.findViewById(R.id.home_luck_reward).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                Intent it = new Intent(getActivity(), LuckRewardActivity.class);
//                startActivity(it);
//            }
//        });
//
//        if(!StepApplication.getInstance().isShowMasonTask()){
//            view.findViewById(R.id.home_luck_reward).setVisibility(View.GONE);
//            view.findViewById(R.id.home_invite_friend).setVisibility(View.GONE);
//            view.findViewById(R.id.sign_page).setVisibility(View.GONE);
//            view.findViewById(R.id.more_task_title).setVisibility(View.GONE);
//            view.findViewById(R.id.sign_page_title).setVisibility(View.GONE);
//            view.findViewById(R.id.today_current_steps_hint).setVisibility(View.GONE);
//        }
//
//        TextView textView1 = view.findViewById(R.id.data_title_1);
//        TextView textView2 = view.findViewById(R.id.data_title_2);
//        TextView textView3 = view.findViewById(R.id.data_title_3);
//        textView1.setText(getResources().getString(R.string.data_title_1));
//        textView2.setText(getResources().getString(R.string.data_title_2));
//        textView3.setText(getResources().getString(R.string.data_title_3));
//        setBtnDrawableLeft(R.mipmap.data_icon_1,textView1);
//        setBtnDrawableLeft(R.mipmap.data_icon_2,textView2);
//        setBtnDrawableLeft(R.mipmap.data_icon_3,textView3);
//        data1 = view.findViewById(R.id.data_content_1);
//        data2 = view.findViewById(R.id.data_content_2);
//        data3 = view.findViewById(R.id.data_content_3);
//
//        data1.setText("50公里");
//        data2.setText("1小时5分");
//        data3.setText("15587千卡");
//
//        showRepeatBtn();
//        StepUserManager.getInstance().checkIsFirstOpenToday(getActivity());
//    }
//
//    @Override
//    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
//        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
//    }
//
//    private void playGetCoinAnim(final View view){
//        view.setClickable(false);
//        TranslateAnimation animation = new TranslateAnimation(0,0, 0, -view.getMeasuredWidth());
//        animation.setDuration(1000);
//        AlphaAnimation alphaAnimation = new AlphaAnimation(1.0f, 0.0f);//第一个参数开始的透明度，第二个参数结束的透明度
//        alphaAnimation.setDuration(1000);
//        AnimationSet set=new AnimationSet(false);
//        set.addAnimation(animation);
//        set.addAnimation(alphaAnimation);
//        set.setAnimationListener(new Animation.AnimationListener() {
//            @Override
//            public void onAnimationStart(Animation animation) {
//
//            }
//
//            @Override
//            public void onAnimationEnd(Animation animation) {
//                view.setVisibility(View.GONE);
//            }
//
//            @Override
//            public void onAnimationRepeat(Animation animation) {
//
//            }
//        });
//        view.startAnimation(set);
//    }
//
//    private void showWXHint(){
//        WXHintDialog dialog = new WXHintDialog(getActivity());
//        dialog.showDialogAtCenter();
//    }
//
//    //更新步数并检查步数是否达标
//    public void setStepText(int steps){
//        if(mCurrentStepsTextView == null || getCoin == null)
//            return;
//        int limitStepNum = StepUserManager.getInstance().getSyncStepNumLimit();
//        mCurrentStepsTextView.setText(steps+getActivity().getResources().getString(R.string.step));
//        if(arcProgress != null) {
//            arcProgress.setMax(6000);
//            if(steps<=6000) {
//                arcProgress.setProgress(steps);
//            }else{
//                arcProgress.setProgress(6000);
//            }
//        }
//        EyeLog.logi("setStepText limitStepNum:"+limitStepNum);
//        if(steps<limitStepNum){
//            if(limitStepNum != Integer.MAX_VALUE){
//                getCoin.setEnabled(false);
//                getCoin.setBackgroundResource(R.drawable.press_background_already_get);
//                getCoin.setText("继续努力");
//            }else{
//                getCoin.setEnabled(false);
//                getCoin.setText("今日金币已领完");
//                getCoin.setBackgroundResource(R.drawable.press_background_already_get);
//            }
//        }else{
//            getCoin.setEnabled(true);
//            getCoin.setBackgroundResource(R.drawable.press_background);
//            getCoin.setText(getResources().getString(R.string.get_coin));
//        }
//
//        NumberFormat nf = NumberFormat.getNumberInstance();
//        nf.setMaximumFractionDigits(2);
//        float kmiles = ((float)steps)*0.6f/1000;
//        if(data1 != null)
//            data1.setText(nf.format(kmiles)+"公里");
//        float times = kmiles*14;
//        if(data2 != null)
//            data2.setText(nf.format(times/60)+"小时");
//        if(data3 != null)
//            data3.setText((int)((times/60)*240)+"千卡");
//    }
//
//    @Override
//    public void updateUserInfo() {
//        StepUserManager stepUserManager = StepUserManager.getInstance();
//        User user = stepUserManager.getUserInfo();
//        if(user != null && view != null) {
//            ((TextView) view.findViewById(R.id.title))
//                    .setText(getResources().getString(R.string.today_target_steps)+user.getStepTarget());
//        }
//        int steps = stepUserManager.getTodaySteps();
//        setStepText(steps);
//    }
//
//    public void setRandomCoinList(List<RandomCoin> datas){
//        for (RandomCoinView item:randomCoinViews){
//            item.setVisibility(View.GONE);
//        }
//        for(int i = 0;i<datas.size();i++){
//            if(i == randomCoinViews.size()){
//                break;
//            }
//            randomCoinViews.get(i).setRandomCoin(datas.get(i));
//            randomCoinViews.get(i).setVisibility(View.VISIBLE);
//            randomCoinViews.get(i).setOnClickListener(new View.OnClickListener() {
//                @Override
//                public void onClick(View v) {
//                    view.clearAnimation();
//                    UmengLog.logEvent(getContext(),UmengLog.ID.GET_RANDOM_COIN);
//                    playGetCoinAnim(v);
//                    Intent it = new Intent(getActivity(), AdActivity.class);
//                    it.putExtra(AdActivity.AD_TYPE,AdActivity.RANDOM_COIN);
//                    it.putExtra("ad_coin",((RandomCoinView)v).getRandomCoin().getAmount());
//                    it.putExtra("ad_coin_id",((RandomCoinView)v).getRandomCoin().getId());
//                    startActivity(it);
//                }
//            });
//            Animation shakeAnim = AnimationUtils.loadAnimation(getActivity(), R.anim.shake_y);
//            randomCoinViews.get(i).startAnimation(shakeAnim);
//        }
//    }
//
//    private void setBtnDrawableLeft(int resId, TextView btn){
//        Drawable drawable = getResources().getDrawable(resId);
//        drawable.setBounds(0, 0, drawable.getMinimumWidth(),drawable.getMinimumHeight());
//        btn.setCompoundDrawables(drawable, null, null, null);
//        btn.setCompoundDrawablePadding(10);
//    }
//
//    @Override
//    public void clearUserInfo() {
//        for(int i = 0;i<randomCoinViews.size();i++) {
//            randomCoinViews.get(i).setVisibility(View.INVISIBLE);
//        }
//        if(data1 != null)
//            data1.setText("0公里");
//        if(data2 != null)
//            data2.setText("0小时");
//        if(data3 != null)
//            data3.setText("0千卡");
//    }
//
//
//    /**
//     * 显示呼吸效果动画
//     */
//    private void showRepeatBtn() {
//        getCoin.setOnTouchListener(new View.OnTouchListener() {
//            @Override
//            public boolean onTouch(View v, MotionEvent event) {
//                // 触摸时取消动画，并缩小，有按下的感觉
//                if (event.getAction() == MotionEvent.ACTION_DOWN) {
//                    getCoin.setScaleX(0.9f);
//                    getCoin.setScaleY(0.9f);
//                    getCoin.clearAnimation();
//                } else if (event.getAction() == MotionEvent.ACTION_UP){ // 松手后，恢复大小，并继续呼吸效果
//                    getCoin.setScaleX(1.0f);
//                    getCoin.setScaleY(1.0f);
//                    showRepeatBtn();
//                }
//
//                return false;
//            }
//        });
//        // 放大小时view，完全显示后开始呼吸效果
//        ScaleAnimation enterAnim = new ScaleAnimation(0f, 1.1f, 0f, 1.1f, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
//        enterAnim.setDuration(300); // 默认只执行一遍
//        enterAnim.setAnimationListener(new Animation.AnimationListener() {
//            @Override
//            public void onAnimationStart(Animation animation) { }
//            @Override
//            public void onAnimationRepeat(Animation animation) { }
//
//            @Override
//            public void onAnimationEnd(Animation animation) {
//                ScaleAnimation anim = new ScaleAnimation(1.0f, 1.1f, 1.0f, 1.1f, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
//                anim.setDuration(750);
//                anim.setRepeatMode(Animation.REVERSE); // 放大并缩小，时间为750*2
//                anim.setRepeatCount(Animation.INFINITE); // 无限循环
//                getCoin.setAnimation(anim);
//                getCoin.startAnimation(getCoin.getAnimation());
//            }
//        });
//        getCoin.startAnimation(enterAnim);
//    }
//
//    /**
//     * 动画隐藏连发按钮
//     */
//    private void hideRepeatBtn() {
//        // 缩小退出
//        ScaleAnimation anim = new ScaleAnimation(1.1f, 0f, 1.1f, 0f, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
//        anim.setDuration(300);
//        anim.setAnimationListener(new Animation.AnimationListener() {
//            @Override
//            public void onAnimationStart(Animation animation) { }
//            @Override
//            public void onAnimationRepeat(Animation animation) { }
//
//            @Override
//            public void onAnimationEnd(Animation animation) {
//                if (getCoin.getAnimation() != null) {
//                    getCoin.getAnimation().cancel();
//                }
//            }
//        });
//        getCoin.startAnimation(anim);
//    }
}
