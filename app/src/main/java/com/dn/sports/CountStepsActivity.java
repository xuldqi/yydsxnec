package com.dn.sports;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.Nullable;

import com.dn.sports.adcoinLogin.LoginListener;
import com.dn.sports.adcoinLogin.StepUserManager;
import com.dn.sports.common.BaseActivity;
import com.dn.sports.common.EyeLog;
import com.dn.sports.database.StepsCountModel;
import com.dn.sports.dialog.HintDialog;
import com.dn.sports.fragment.StepSubFragment;
import com.dn.sports.fragment.SubCountTimeFragment;
import com.dn.sports.greendao.DbHelper;
import com.dn.sports.ormbean.StepCountRecord;
import com.dn.sports.utils.RingProgressBar;
import com.dn.sports.utils.Utils;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class CountStepsActivity extends BaseActivity {

    public class StepModel{
        int startStep;
        int endStep;
    }

    private TextView distanceData;

    private RingProgressBar ringProgressBar;
    public static final String STEP_TYPE = "STEP_TYPE";
    private int stepType;
    private int sportTarget;
    private int stepSubType = 0;
    private long startTime;
    private ImageView seepStep;
    private TextView seepStepText;
    private TextView seepStepHintText;
    private boolean isNeedAlarm = false;
    private TextView timeText;
    private TextView kalText;
    private ImageView pauseOrStart;
    private ImageView stop;
    private boolean isStart = false;
    private boolean isPause = false;
    private long timeMILLISECONDS = 0;
    private int stepRecord = 0;
    private ScheduledExecutorService scheduledExecutorService;
    private List<StepModel> stepModels= new ArrayList<>();

    float targetStepNum = 3000;

    private Handler handler = new Handler(Looper.getMainLooper()){
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            if(msg.what == 1){
                timeText.setText((String)msg.obj);
            }else if(msg.what == 2){
                if(isStart && !isPause){
                    int steps = 0;
                    for(int i = 0;i<stepModels.size();i++){
                        StepModel stepModel = stepModels.get(i);
                        if(i == stepModels.size() - 1) {
                            steps = steps + StepUserManager.getInstance().getTodaySteps() - stepModel.startStep;
                        }else{
                            steps = steps + stepModel.endStep - stepModel.startStep;
                        }
                    }
                    stepRecord = steps;
                    seepStepText.setText(steps+"步");
                    kalText.setText(Utils.getKalByStep(steps)+"千卡");
                    distanceData.setText(Utils.getDistanceByStep(steps));
                    ringProgressBar.setProgress(Utils.getFloatDistanceByStep(steps));
                    ringProgressBar.setMaxProgress(targetStepNum);
                    if(isNeedAlarm){
                        float data = ((float)stepRecord)*0.6f;
                        if(data > sportTarget){
                            isNeedAlarm = false;
                            Utils.reachSportTarget(CountStepsActivity.this);
                        }
                    }
                }
            }
        }
    };

    private LoginListener loginListener = new LoginListener(){
        @Override
        public void onStepChange() {
            super.onStepChange();
            Message msg = handler.obtainMessage();
            msg.what = 2;
            msg.sendToTarget();
        }
    };

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_count_step);
        findViewById(R.id.back_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                checkExit();
            }
        });
        if(getIntent() != null){
            stepType = getIntent().getIntExtra(STEP_TYPE, -1);
            sportTarget = getIntent().getIntExtra("set_sport_target_type",0);
            if(sportTarget > 0){
                isNeedAlarm = true;
            }
            EyeLog.logi("CountStepsActivity:"+stepType+","+stepSubType);
        }
        targetStepNum = StepUserManager.getInstance().getSportTargetNum(this,stepType);
        findViewById(R.id.root).setPadding(0, Utils.getStatusBarHeight(this),0,0);
        distanceData = findViewById(R.id.step_data);
        ringProgressBar = findViewById(R.id.ringProgressBar);
        ringProgressBar.setBgColor("#F5F5F5");
        seepStep = findViewById(R.id.speed_step);
        seepStepText = findViewById(R.id.speed_step_text);
        seepStepHintText = findViewById(R.id.speed_step_hint_text);
        seepStepHintText.setText("步数");
        timeText = findViewById(R.id.time_text);
        kalText = findViewById(R.id.kal_text);
        stop = findViewById(R.id.stop);
        pauseOrStart = findViewById(R.id.start_or_pause);
        pauseOrStart.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(isStart){
                    if(isPause){
                        isPause = false;
                        stop.setVisibility(View.GONE);
                        pauseOrStart.setImageResource(R.mipmap.pause);

                        StepModel stepModel = new StepModel();
                        stepModel.startStep = StepUserManager.getInstance().getTodaySteps();
                        stepModel.endStep = -1000;
                        stepModels.add(stepModel);

                        scheduledExecutorService =  Executors.newScheduledThreadPool(1);
                        scheduledExecutorService.scheduleAtFixedRate(new CountStepsActivity.MiaoBiaoRunnable(),0,1000, TimeUnit.MILLISECONDS);
                    }else{
                        isPause = true;
                        handler.removeCallbacksAndMessages(null);
                        pauseOrStart.setImageResource(R.mipmap.start);
                        stop.setVisibility(View.VISIBLE);

                        StepModel stepModel = stepModels.get(stepModels.size()-1);
                        stepModel.endStep = StepUserManager.getInstance().getTodaySteps();

                        if(scheduledExecutorService != null) {
                            scheduledExecutorService.shutdownNow();
                        }
                    }
                }
            }
        });
        stop.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                final HintDialog hintDialog = new HintDialog(CountStepsActivity.this,false);

                String msg = "";
                if (stepType == StepSubFragment.TYPE_RUN_INDOOR) {
                    msg = ("室内跑步");
                } else if (stepType == StepSubFragment.TYPE_RUN_OUTDOOR) {
                    msg = ("室外跑步");
                } else if (stepType == StepSubFragment.TYPE_FAST_WALK) {
                    msg = ("健走");
                } else if (stepType == StepSubFragment.TYPE_ON_FOOT) {
                    msg = ("徒步");
                } else if (stepType == StepSubFragment.TYPE_MOUNTAIN_CLIMBING) {
                    msg = ("登山");
                }
                hintDialog.setExitCountTime(msg+"中，是否退出？", new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        StepUserManager.getInstance().removeLoginListener(loginListener);
                        isStart = false;
                        isPause = false;
                        stepModels.clear();

                        {
                            //存储
                            StepCountRecord stepsCountModel = new StepCountRecord();
                            stepsCountModel.id = System.currentTimeMillis();
                            stepsCountModel.type = stepType;
                            stepsCountModel.subType = stepSubType;
                            stepsCountModel.startTime = startTime;
                            stepsCountModel.useTime = timeMILLISECONDS;
                            stepsCountModel.steps = stepRecord;
                            DbHelper.INSTANCE.getDaoSession().getStepCountRecordDao().insert(stepsCountModel);
                        }

                        stepRecord = 0;
                        pauseOrStart.setKeepScreenOn(false);
                        pauseOrStart.setImageResource(R.mipmap.start);
                        timeMILLISECONDS = 0;
                        if(scheduledExecutorService != null) {
                            scheduledExecutorService.shutdownNow();
                        }
                        stop.setVisibility(View.GONE);
                        hintDialog.dismissDialog();
                        finish();
                    }
                });
                hintDialog.showDialogAtCenter();
            }
        });


        //打开立马开始计时
        StepUserManager.getInstance().setLoginListener(loginListener);
        isStart = true;
        timeMILLISECONDS = 0;
        pauseOrStart.setKeepScreenOn(true);
        startTime = System.currentTimeMillis();

        StepModel stepModel = new StepModel();
        stepModel.startStep = StepUserManager.getInstance().getTodaySteps();
        stepModel.endStep = -1000;
        stepModels.add(stepModel);

        pauseOrStart.setImageResource(R.mipmap.pause);
        scheduledExecutorService =  Executors.newScheduledThreadPool(1);
        scheduledExecutorService.scheduleAtFixedRate(new CountStepsActivity.MiaoBiaoRunnable(),0,1000, TimeUnit.MILLISECONDS);
    }

    private class MiaoBiaoRunnable implements Runnable {
        @Override
        public void run() {
            timeMILLISECONDS = timeMILLISECONDS + 1000;

            long timeNum = timeMILLISECONDS;
            String text = "";
            int hour = (int)(timeNum/(60*60*1000));
            if(hour > 1) {
                text = hour + ":";
            }
            timeNum = timeNum - 60*60*1000*hour;
            int min = (int)(timeNum/(60*1000));
            if(min > 9) {
                text = text + min + ":";
            }else{
                text = text + "0" + min + ":";
            }
            timeNum = timeNum - 60*1000*min;
            int second = (int)(timeNum/1000);
            if(second > 9) {
                text = text + second;
            }else{
                text = text + "0" + second;
            }

            Message msg = handler.obtainMessage();
            msg.what = 1;
            msg.obj = text;
            msg.sendToTarget();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        StepUserManager.getInstance().removeLoginListener(loginListener);
    }

    @Override
    public void onBackPressed() {
        checkExit();
    }

    private void checkExit(){
        if(isStart){
            String msg = "";
            if (stepType == StepSubFragment.TYPE_RUN_INDOOR) {
                msg = ("室内跑步");
            } else if (stepType == StepSubFragment.TYPE_RUN_OUTDOOR) {
                msg = ("室外跑步");
            } else if (stepType == StepSubFragment.TYPE_FAST_WALK) {
                msg = ("健走");
            } else if (stepType == StepSubFragment.TYPE_ON_FOOT) {
                msg = ("徒步");
            } else if (stepType == StepSubFragment.TYPE_MOUNTAIN_CLIMBING) {
                msg = ("登山");
            }
            showExitHint(msg + "中，是否退出？");
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
}
