package com.dn.sports.fragment;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Rect;
import android.net.Uri;
import android.os.Bundle;
import android.os.Message;
import android.provider.MediaStore;
import android.provider.Settings;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.viewpager.widget.ViewPager;

import com.dn.sports.BodyRecordActivity;
import com.dn.sports.CountTimeActivity;
import com.dn.sports.CustomTargetActivity;
import com.dn.sports.R;
import com.dn.sports.ShareFirendActivity;
import com.dn.sports.adapter.MViewPagerAdapter;
import com.dn.sports.adcoinLogin.StepUserManager;
import com.dn.sports.adcoinLogin.model.User;
import com.dn.sports.common.UIHandler;
import com.dn.sports.common.UmengLog;
import com.dn.sports.dialog.HintDialog;
import com.dn.sports.dialog.WXHintDialog;
//import com.dn.sports.map.BDMapTraceActivity;
import com.dn.sports.map.MapHelper;
import com.dn.sports.map.TraceHistoryListActivity;
import com.dn.sports.utils.Utils;
import com.dn.sports.view.NoSlidingViewPager;

import java.text.NumberFormat;
import java.util.ArrayList;

public class NewHomeFragment extends BaseFragment {
    private View root;
    private TextView stepData;
    private TextView stepKal;

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

//    @Override
//    public View getViewByLayout(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
//        return inflater.inflate(R.layout.fragment_new_home,container,false);
//    }
//
//    @Override
//    public void initViewAction(View view) {
//        root = view;
//        stepData = view.findViewById(R.id.step_data);
//        stepKal = view.findViewById(R.id.step_kal);
//        view.findViewById(R.id.body_record).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                Intent it = new Intent(getActivity(), BodyRecordActivity.class);
//                startActivity(it);
//            }
//        });
//
//        view.findViewById(R.id.target_record).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                Intent it = new Intent(getActivity(), CustomTargetActivity.class);
//                startActivity(it);
//            }
//        });
//
//        view.findViewById(R.id.sport_record).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                Intent it = new Intent(getActivity(), CountTimeActivity.class);
//                startActivity(it);
//            }
//        });
//
//        view.findViewById(R.id.sync_wx_step).setOnClickListener(new View.OnClickListener() {
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
//        view.findViewById(R.id.new_home_share_friend).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                UmengLog.logEvent(getActivity(),UmengLog.ID.INVITE_FRIEND);
//                User user = StepUserManager.getInstance().getUserInfo();
//                //由文件得到uri
//                Bitmap bp = BitmapFactory.decodeResource(getResources(),R.mipmap.invite_friend_page);
//                bp = Utils.addTextWatermark(getActivity(),bp,user.getInviteCode(),60, Color.RED,
//                        bp.getHeight()/2-20 ,true);
//                Uri imageUri = Uri.parse(MediaStore.Images.Media.insertImage(getActivity().getContentResolver(), bp, null, null));
//                Intent shareIntent = new Intent();
//                shareIntent.setAction(Intent.ACTION_SEND);
//                shareIntent.putExtra(Intent.EXTRA_STREAM, imageUri);
//                shareIntent.setType("image/*");
//                startActivity(Intent.createChooser(shareIntent, "分享到"));
//            }
//        });
//
//        view.findViewById(R.id.map).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                showTraceHint();
//            }
//        });
//
//        view.findViewById(R.id.trace_history).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                Intent it = new Intent(getActivity(), TraceHistoryListActivity.class);
//                startActivity(it);
//            }
//        });
//        initLoopPager(null);
//    }
//
//    private void showTraceHint(){
//        HintDialog hintDialog = new HintDialog(getActivity(),false);
//        hintDialog.setCommonHint("使用轨迹记录提示", "手机位置来源GPS信号，请先打开GPS开关" +
//                "。请在开阔地带使用其功能，室内、隧道等有遮挡物的地方可能会发生位置偏移或者不更新的问题。", new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
////                if(!MapHelper.isGPSPen(getActivity())){
////                    Toast.makeText(getActivity(),"请先打开GPS选项。",Toast.LENGTH_SHORT).show();
////                    MapHelper.openGps(getActivity());
////                    return;
////                }
////
////                Intent it = new Intent(getActivity(), BDMapTraceActivity.class);
////                startActivity(it);
////                hintDialog.dismissDialog();
//            }
//        });
//        hintDialog.showDialogAtCenter();
//    }
//
//
//    private void showWXHint(){
//        WXHintDialog dialog = new WXHintDialog(getActivity());
//        dialog.showDialogAtCenter();
//    }
//
//
//    //todo xuyimin
//    //更新步数并检查步数是否达标
//    public void setStepText(int steps){
//        if(stepData == null || stepKal == null)
//            return;
//
//        NumberFormat nf = NumberFormat.getNumberInstance();
//        nf.setMaximumFractionDigits(2);
//        float kmiles = ((float)steps)*0.6f/1000;
//        float times = kmiles*14;
//        stepData.setText("里程 "+nf.format(kmiles)+"公里  "+"时常  "+nf.format(times/60)+"小时");
//        stepKal.setText("消耗卡路里 "+(int)((times/60)*240)+"千卡");
//    }
//
//    @Override
//    public void updateUserInfo() {
//
//    }
//
//    @Override
//    public void clearUserInfo() {
//
//    }
//
//    private LinearLayout loopPagerHint;
//    private NoSlidingViewPager loopPager;
//    private final static int UPDATE_LOOP = 9999;
//    private UIMyHandler updateHandler = new UIMyHandler(this);
//
//    private static class UIMyHandler extends UIHandler<NewHomeFragment> {
//        UIMyHandler(NewHomeFragment cls) {
//            super(cls);
//        }
//
//        @Override
//        public void handleMessage(Message msg) {
//            super.handleMessage(msg);
//            NewHomeFragment root = ref.get();
//            if(root == null)
//                return;
//            if(msg.what == UPDATE_LOOP){
//                if(msg.arg1 >= (msg.arg2 -1)){
//                    root.loopPager.setCurrentItem(0,false);
//                }else{
//                    root.loopPager.setCurrentItem(msg.arg1+1,true);
//                }
//                root.sendMessageUpdateLoop();
//            }
//        }
//    }
//
//    private void sendMessageUpdateLoop(){
//        if(loopPager == null)
//            return;
//        Message msg = updateHandler.obtainMessage();
//        msg.what = UPDATE_LOOP;
//        msg.arg1 = loopPager.getCurrentItem();
//        msg.arg2 = loopPager.getChildCount();
//        updateHandler.sendMessageDelayed(msg,8000);
//    }
//
//    private void initLoopPager(View adView){
//        loopPagerHint = root.findViewById(R.id.loop_pager_hint);
//        loopPager = root.findViewById(R.id.loop_pager);
//        View loopRoot = root.findViewById(R.id.loop_pager_root);
//        int width = Utils.getWidth(getActivity());
//        LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) loopRoot.getLayoutParams();
//        params.width = width;
//        params.height = (params.width*288)/660;
//        params.gravity = Gravity.CENTER;
//        loopRoot.setLayoutParams(params);
//        ArrayList<View> aList = new ArrayList<>();
//        aList.add(getViewPagerItem(getActivity(), R.mipmap.banner_1, new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//
//            }
//        }));
//        aList.add(getViewPagerItem(getActivity(), R.mipmap.banner_2, new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//            }
//        }));
//        if(adView != null){
//            FrameLayout frameLayout = new FrameLayout(getActivity());
//            FrameLayout.LayoutParams params1 = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.WRAP_CONTENT,FrameLayout.LayoutParams.WRAP_CONTENT);
//            params1.gravity = Gravity.CENTER;
//            frameLayout.addView(adView,params1);
//            aList.add(frameLayout);
//        }
//        MViewPagerAdapter mAdapter = new MViewPagerAdapter(aList);
//        loopPager.setAdapter(mAdapter);
//        loopPager.setScrollable(false);
//        addTheItemHint(getActivity(),aList.size(),loopPager);
//        loopPager.setCurrentItem(0);
//        setItemFocus(0);
//        updateHandler.removeCallbacksAndMessages(null);
//        sendMessageUpdateLoop();
//    }
//
//    private View getViewPagerItem(Context ctx, int res, View.OnClickListener listener){
//        ImageView view = new ImageView(ctx);
//        view.setImageResource(res);
//        if(listener != null){
//            view.setOnClickListener(listener);
//        }
//        return view;
//    }
//
//    private void addTheItemHint(Context context, int num, ViewPager viewPager){
//        for (int i = 0;i<num;i++){
//            View hint = new View(context);
//            int w = (int)context.getResources().getDimension(R.dimen.padding_10);
//            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(w,w);
//            params.leftMargin  = w/3;
//            params.rightMargin = w/3;
//            hint.setLayoutParams(params);
//            loopPagerHint.addView(hint);
//        }
//
//        viewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
//            @Override
//            public void onPageScrolled(int i, float v, int i1) {
//
//            }
//
//            @Override
//            public void onPageSelected(int i) {
//                setItemFocus(i);
//            }
//
//            @Override
//            public void onPageScrollStateChanged(int i) {
//
//            }
//        });
//    }
//
//    private void setItemFocus(int i){
//        for (int j = 0;j<loopPagerHint.getChildCount();j++){
//            View view = loopPagerHint.getChildAt(j);
//            if (j == i){
//                view.setBackgroundResource(R.drawable.permission_pager_hint_n);
//            }else{
//                view.setBackgroundResource(R.drawable.permission_pager_hint_f);
//            }
//        }
//    }
}
