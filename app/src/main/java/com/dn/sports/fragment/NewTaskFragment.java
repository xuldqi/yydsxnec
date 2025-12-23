package com.dn.sports.fragment;

import android.content.Intent;
import android.os.Bundle;
import android.text.format.DateFormat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AnimationUtils;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.dn.sports.AdActivity;
import com.dn.sports.R;
import com.dn.sports.SignActivity;
import com.dn.sports.StepApplication;
import com.dn.sports.adcoinLogin.StepUserManager;
import com.dn.sports.adcoinLogin.chuanshanjia.VideoAd;
import com.dn.sports.adcoinLogin.common.AdListener;
import com.dn.sports.adcoinLogin.model.SignRecord;
import com.dn.sports.adcoinLogin.model.TaskModel;
import com.dn.sports.adcoinLogin.model.User;
import com.dn.sports.common.EyeLog;
import com.dn.sports.common.UmengLog;
import com.dn.sports.utils.DateTest;
import com.dn.sports.view.MasonItemView;
import com.dn.sports.view.SignItem;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class NewTaskFragment extends BaseFragment {
    private List<SignItem> signItems = new ArrayList<>();
    private LinearLayout masonList;
    private TaskModel currentGetCoinTask;
    private TextView continueSignTest;
    private TextView totalSignText;
    private ProgressBar pb;
    private boolean isProgressing = true;

    @Override
    public View getViewByLayout(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_new_task,null);
    }

    @Override
    public void initViewAction(View view) {
        initShowVideoAd();
        initShowVideoAd2();
        initTaskVideoAd();
        signItems.add(view.findViewById(R.id.sign_item_1));
        signItems.add(view.findViewById(R.id.sign_item_2));
        signItems.add(view.findViewById(R.id.sign_item_3));
        signItems.add(view.findViewById(R.id.sign_item_4));
        signItems.add(view.findViewById(R.id.sign_item_5));
        signItems.add(view.findViewById(R.id.sign_item_6));
        signItems.add(view.findViewById(R.id.sign_item_7));
        masonList = view.findViewById(R.id.mason_list);
        continueSignTest = view.findViewById(R.id.sign_day_num);
        totalSignText = view.findViewById(R.id.sign_day_total_num);

        pb = view.findViewById(R.id.progress_bar);
        pb.startAnimation(AnimationUtils.loadAnimation(getActivity(),R.anim.progress_anim));
        isProgressing = true;


        String todayDate = DateFormat.format("MM-dd", Calendar.getInstance().getTime()).toString();
        EyeLog.logi("todayDate:"+todayDate);
        List<DateTest.WeekDay> weekDays = DateTest.getWeekDay();
        int i = 0;
        boolean isToToday = false;
        for(DateTest.WeekDay item:weekDays){
            signItems.get(i).setWeekDay(item,isToToday);
            if(item.day.equals(todayDate)){
                isToToday = true;
            }
            i = i+1;
        }

        for(SignItem item:signItems){
            if(item.isSameDate(todayDate)) {
                item.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        //不展示广告直接签到
                        if(!StepApplication.getInstance().isShowAd()){
                            Intent it = new Intent(getActivity(), AdActivity.class);
                            it.putExtra(AdActivity.AD_TYPE,AdActivity.SIGN_REQUEST);
                            it.putExtra(AdActivity.COIN_NUM,120);
                            startActivity(it);
                            return;
                        }

                        if(videoAd.isAdLoaded()){
                            UmengLog.logEvent(getActivity(),UmengLog.ID.SIGN_REQUEST);
                            videoAd.showAd(getActivity(),0);
                        }else{
                            Toast.makeText(getActivity(),getResources().getString(R.string.no_video_ad),Toast.LENGTH_SHORT).show();
                        }
                    }
                });
            }
        }
    }

    public void onSign(){
        StepUserManager.getInstance().getUserInfoBYUserId(getActivity());
        Toast.makeText(StepApplication.getInstance(),getResources().getString(R.string.sign_ok),Toast.LENGTH_SHORT).show();

        String todayDate = DateFormat.format("MM-dd",Calendar.getInstance().getTime()).toString();
        for(SignItem item:signItems){
            if(item.isSameDate(todayDate)) {
                item.setTodayIsSign(true);
            }
        }
    }

    public void onSignList(List<SignRecord> datas) {
        for(SignRecord signRecord:datas){
            EyeLog.logi(signRecord.toString());
            for(SignItem item:signItems){
                item.checkIsSign(signRecord);
            }
        }
    }


    public void updateSingleTask(TaskModel taskModel){

        int count = masonList.getChildCount();
        for (int i = 0;i<count;i++){
            View view = masonList.getChildAt(i);
            if(view instanceof MasonItemView){
                MasonItemView masonItemView = isMasonListViewContainTask(taskModel.getTaskId());
                if(masonItemView == null)
                    return;
                TaskModel mm = masonItemView.getTaskModel();
                if(taskModel.getTaskId() == mm.getTaskId()){
                    masonItemView.setTaskModel(taskModel);

                    if(taskModel.getState() == 0){
                        masonList.removeView(masonItemView);
                        masonList.post(new Runnable() {
                            @Override
                            public void run() {
                                masonList.addView(masonItemView,1);
                            }
                        });
                    }else if(taskModel.getState() == 1){
                        masonList.removeView(masonItemView);
                        masonList.post(new Runnable() {
                            @Override
                            public void run() {
                                masonList.addView(masonItemView);
                            }
                        });
                    }
                    return;
                }
            }
        }
    }

    public void updateTaskList(){
        if(isProgressing){
            pb.clearAnimation();
            masonList.removeView(pb);
            isProgressing = false;
        }
        List<TaskModel> mTasks = StepUserManager.getInstance().getmTasks();
        if(mTasks == null)
            return;
        for (TaskModel task:mTasks){
            if(task.getTaskId() == StepUserManager.TaskID.TASK_ID_SLOT){
                continue;
            }
            //不显示看广告领金币
            if(!StepApplication.getInstance().isShowAd()) {
                if(task.getTaskId() == StepUserManager.TaskID.TASK_ID_WATCH_AD){
                    continue;
                }
            }
            final MasonItemView masonItemView = isMasonListViewContainTask(task.getTaskId());
            if(masonItemView == null){
                MasonItemView itemView = new MasonItemView(getActivity());
                itemView.setTaskModel(task);
                itemView.setMasonListener(new MasonItemView.MasonListener() {
                    @Override
                    public void onClick() {

                    }

                    @Override
                    public void watchAdTaskGetCoin(MasonItemView view, TaskModel taskModel) {
                        Intent it = new Intent(getActivity(),AdActivity.class);
                        it.putExtra(AdActivity.AD_TYPE,AdActivity.TASK_COIN);
                        it.putExtra("ad_task_id",taskModel.getTaskId());
                        it.putExtra("ad_task_title",taskModel.getTaskName());
                        it.putExtra("ad_task_coin",taskModel.getAmount());
                        startActivity(it);
                    }

                    @Override
                    public void watchAdGetCoin(MasonItemView view,TaskModel taskModel) {
                        if(taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_INVITE1){
                            UmengLog.logEvent(getContext(),UmengLog.ID.TASK_FRIEND_1);
                        }else if(taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_INVITE2){
                            UmengLog.logEvent(getContext(),UmengLog.ID.TASK_FRIEND_2);
                        }else if(taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_INVITE3){
                            UmengLog.logEvent(getContext(),UmengLog.ID.TASK_FRIEND_3);
                        }else if(taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_INVITE4){
                            UmengLog.logEvent(getContext(),UmengLog.ID.TASK_FRIEND_4);
                        }else if(taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_FIRST_LOGIN){
                            UmengLog.logEvent(getContext(),UmengLog.ID.TASK_FIRST_LOGIN);
                        }else if(taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_SYNC_STEP){
                            UmengLog.logEvent(getContext(),UmengLog.ID.TASK_SYNC_STEP);
                        }else if(taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_STEP_TOTAL_TARGET){
                            UmengLog.logEvent(getContext(),UmengLog.ID.TASK_STEP_1);
                        }else if(taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_STEP_TARGET1){
                            UmengLog.logEvent(getContext(),UmengLog.ID.TASK_STEP_2);
                        }else if(taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_STEP_TARGET2){
                            UmengLog.logEvent(getContext(),UmengLog.ID.TASK_STEP_3);
                        }else if(taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_STEP_TARGET3){
                            UmengLog.logEvent(getContext(),UmengLog.ID.TASK_STEP_4);
                        }

                        //不看广告，直接领金币
                        if(!StepApplication.getInstance().isShowAd()) {
                            Intent it = new Intent(getActivity(),AdActivity.class);
                            it.putExtra(AdActivity.AD_TYPE,AdActivity.TASK_COIN);
                            it.putExtra("ad_task_id",taskModel.getTaskId());
                            it.putExtra("ad_task_title",taskModel.getTaskName());
                            it.putExtra("ad_task_coin",taskModel.getAmount());
                            startActivity(it);
                            return;
                        }

                        if(videoAd2.isAdLoaded()){
                            currentGetCoinTask = taskModel;
                            videoAd2.showAd(getActivity(),0);
                            Toast.makeText(getActivity(),getResources().getString(R.string.watch_all_ad_get_coin),Toast.LENGTH_SHORT).show();
                        }else{
                            Intent it = new Intent(getActivity(),AdActivity.class);
                            it.putExtra(AdActivity.AD_TYPE,AdActivity.TASK_COIN);
                            it.putExtra("ad_task_id",taskModel.getTaskId());
                            it.putExtra("ad_task_title",taskModel.getTaskName());
                            it.putExtra("ad_task_coin",taskModel.getAmount());
                            startActivity(it);
                        }
                    }

                    @Override
                    public void watchAdTask(MasonItemView view,TaskModel taskModel) {
                        if(videoTaskAd.isAdLoaded()){
                            videoTaskAd.showAd(getActivity(),0);
                        }else{
                            Toast.makeText(getActivity(),getResources().getString(R.string.no_video_ad),Toast.LENGTH_SHORT).show();
                        }
                    }
                });
                masonList.addView(itemView);
            }else{
                if(task.getState() == 0){
                    masonList.removeView(masonItemView);
                    masonItemView.setTaskModel(task);
                    masonList.post(new Runnable() {
                        @Override
                        public void run() {
                            masonList.addView(masonItemView,0);
                        }
                    });
                }else if(task.getState() == 1){
                    masonList.removeView(masonItemView);
                    masonItemView.setTaskModel(task);
                    masonList.post(new Runnable() {
                        @Override
                        public void run() {
                            masonList.addView(masonItemView);
                        }
                    });
                }else{
                    masonItemView.setTaskModel(task);
                }
            }
        }

        if(isMasonListViewContainTask(Integer.MIN_VALUE) == null && StepApplication.getInstance().isShowProduct()) {
            MasonItemView itemView = new MasonItemView(getActivity());
            TaskModel taskModel = new TaskModel();
            taskModel.setTaskId(Integer.MIN_VALUE);
            itemView.setTaskModel(taskModel);
            masonList.addView(itemView,0);
            //更多任务的State
            taskModel.setState(1000);
        }
    }

    private synchronized MasonItemView isMasonListViewContainTask(int taskId){
        int count = masonList.getChildCount();
        for (int i = 0;i<count;i++){
            View view = masonList.getChildAt(i);
            if(view instanceof MasonItemView){
                TaskModel taskModel = ((MasonItemView)view).getTaskModel();
                if(taskModel.getTaskId() == taskId){
                    return ((MasonItemView)view);
                }
            }
        }
        return null;
    }

    @Override
    public void updateUserInfo() {
        User user = StepUserManager.getInstance().getUserInfo();
        if(user != null && continueSignTest != null && totalSignText != null) {
            continueSignTest.setText("连续签到"+user.getContinueSign()+"天");
            totalSignText.setText("累计签到"+user.getContinueSign()+"天");
        }
    }

    @Override
    public void clearUserInfo() {

    }

    private VideoAd videoAd;
    private boolean isSigned = false;

    public void initShowVideoAd(){
        videoAd = new VideoAd();
        videoAd.setAdId("944570768",0,0);
        videoAd.initAd(getActivity(),new AdListener(){

            @Override
            public void adLoad() {
                super.adLoad();
            }

            @Override
            public void onRewarded() {
                super.onRewarded();
                UmengLog.logEvent(getActivity(),UmengLog.ID.SIGN);
                isSigned = true;
            }

            @Override
            public void adClose() {
                super.adClose();
                if(isSigned){
                    isSigned = false;
                    Intent it = new Intent(getActivity(), AdActivity.class);
                    it.putExtra(AdActivity.AD_TYPE,AdActivity.SIGN_REQUEST);
                    it.putExtra(AdActivity.COIN_NUM,120);
                    startActivity(it);
                }else{
                    Toast.makeText(getActivity(),getResources().getString(R.string.sgin_failed),Toast.LENGTH_SHORT).show();
                }
            }

            @Override
            public void adError(String error) {
                super.adError(error);
                Toast.makeText(getActivity(),getResources().getString(R.string.no_video_ad),Toast.LENGTH_SHORT).show();
            }
        });
    }


    private VideoAd videoAd2;
    private VideoAd videoTaskAd;
    private boolean isWatchAllAd = false;

    public void initShowVideoAd2(){
        videoAd2 = new VideoAd();
        videoAd2.setAdId("945023671",0,0);
        videoAd2.initAd(getActivity(),new AdListener(){

            @Override
            public void adLoad() {
                super.adLoad();
            }

            @Override
            public void onRewarded() {
                super.onRewarded();
                isWatchAllAd = true;
            }

            @Override
            public void adClose() {
                super.adClose();
                initShowVideoAd2();
                if(isWatchAllAd){
                    isWatchAllAd = false;
                    if(currentGetCoinTask != null) {
                        Intent it = new Intent(getActivity(), AdActivity.class);
                        it.putExtra(AdActivity.AD_TYPE,AdActivity.TASK_COIN);
                        it.putExtra("ad_task_id", currentGetCoinTask.getTaskId());
                        it.putExtra("ad_task_title",currentGetCoinTask.getTaskName());
                        it.putExtra("ad_task_coin",currentGetCoinTask.getAmount());
                        startActivity(it);
                    }
                }
            }

            @Override
            public void adError(String error) {
                super.adError(error);
            }
        });
    }

    private void initTaskVideoAd(){
        videoTaskAd = new VideoAd();
        videoTaskAd.setAdId("945030678",0,StepUserManager.TaskID.TASK_ID_WATCH_AD);
        videoTaskAd.initAd(getActivity(),new AdListener(){

            @Override
            public void onRewarded() {
                super.onRewarded();
                StepUserManager.getInstance().getTaskList(getActivity());
            }

            @Override
            public void adClose() {
                super.adClose();
                initTaskVideoAd();
            }
        });
    }
}
