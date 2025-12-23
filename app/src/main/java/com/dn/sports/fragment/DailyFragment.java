package com.dn.sports.fragment;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.dn.sports.AdActivity;
import com.dn.sports.R;
import com.dn.sports.ShareFirendActivity;
import com.dn.sports.StepApplication;
import com.dn.sports.TaskAdActivity;
import com.dn.sports.adcoinLogin.LoginListener;
import com.dn.sports.adcoinLogin.StepUserManager;
import com.dn.sports.adcoinLogin.TaskAdManager;
import com.dn.sports.adcoinLogin.chuanshanjia.VideoAd;
import com.dn.sports.adcoinLogin.common.AdListener;
import com.dn.sports.adcoinLogin.model.TaskModel;
import com.dn.sports.adcoinLogin.model.User;
import com.dn.sports.common.EyeLog;
import com.dn.sports.common.UmengLog;
import com.dn.sports.utils.Utils;
import com.dn.sports.view.MasonItemView;

import java.util.List;

public class DailyFragment extends BaseFragment {
    private TextView myCoinTextView;
    private TextView myCoinTextViewToMoney;
    private LinearLayout masonList;
    private TaskModel currentGetCoinTask;

    private LoginListener loginListener = new LoginListener() {

        @Override
        public void onGetTaskReward(TaskModel taskModel) {
            super.onGetTaskReward(taskModel);

            updateSingleTask(taskModel);
        }

        @Override
        public void onUpdateTask(TaskModel taskModel) {
            super.onGetTaskReward(taskModel);


            updateSingleTask(taskModel);
        }
    };

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

    @Override
    public View getViewByLayout(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_daily,container,false);
    }

    @Override
    public void initViewAction(View view) {
        int stateBarH = Utils.getStatusBarHeight(getActivity());
        view.findViewById(R.id.root).setPadding(0,stateBarH,0,0);
        initShowVideoAd();
        initTaskVideoAd();
        myCoinTextView = view.findViewById(R.id.my_coin_number);
        myCoinTextViewToMoney = view.findViewById(R.id.my_coin_number_to_money);
        masonList = view.findViewById(R.id.mason_list);
        StepUserManager.getInstance().setLoginListener(loginListener);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        StepUserManager.getInstance().removeLoginListener(loginListener);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

    }

    public void setCoinText(float coins){
        if(myCoinTextView != null)
            myCoinTextView.setText((int)coins+getResources().getString(R.string.coin));
        if(myCoinTextViewToMoney != null)
            myCoinTextViewToMoney.setText("≈"+StepUserManager.coinToMoney(coins)+getResources().getString(R.string.unit_money));
    }

    @Override
    public synchronized void updateUserInfo() {
        User user = StepUserManager.getInstance().getUserInfo();
        if(user != null) {
            setCoinText(user.getBalance());
        }
    }

    public void updateTaskList(){
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

                        if(videoAd.isAdLoaded()){
                            currentGetCoinTask = taskModel;
                            videoAd.showAd(getActivity(),0);
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

    private VideoAd videoAd;
    private VideoAd videoTaskAd;
    private boolean isWatchAllAd = false;

    public void initShowVideoAd(){
        videoAd = new VideoAd();
        videoAd.setAdId("945023671",0,0);
        videoAd.initAd(getActivity(),new AdListener(){

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
                initShowVideoAd();
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

    @Override
    public void clearUserInfo() {
    }
}
