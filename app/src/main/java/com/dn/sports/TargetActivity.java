package com.dn.sports;

import android.graphics.Paint;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;

import com.dn.sports.adcoinLogin.LoginListener;
import com.dn.sports.adcoinLogin.StepUserManager;
import com.dn.sports.adcoinLogin.model.StepsRecord;
import com.dn.sports.adcoinLogin.model.User;
import com.dn.sports.common.BaseActivity;
import com.dn.sports.common.EyeLog;
import com.dn.sports.common.UmengLog;
import com.dn.sports.dialog.ProgressDialog;
import com.dn.sports.dialog.TargetStepDialog;
import com.dn.sports.utils.DateUtils;
import com.dn.sports.utils.Utils;
import com.dn.sports.view.SunLineChartView;

import java.util.ArrayList;
import java.util.List;

public class TargetActivity extends BaseActivity {

    private TextView nowSteps;
    private SunLineChartView lineChartView;
    private TextView getTargetReward;
    private Handler handler = new Handler(Looper.getMainLooper());
    private ProgressDialog progressDialog;

    private LoginListener loginListener = new LoginListener(){
        @Override
        public void onSyncStepsList(List<StepsRecord> datas) {
            super.onSyncStepsList(datas);
            handler.removeCallbacksAndMessages(null);
            if(progressDialog != null)
                progressDialog.dismiss();
            updateSteps(datas);
        }

        @Override
        public void onStepChange() {
            super.onStepChange();
            updateSteps(StepUserManager.getInstance().getTodaySteps());
        }

        @Override
        public void onError(int msg, String info) {
            super.onError(msg, info);
            handler.removeCallbacksAndMessages(null);
            if(progressDialog != null)
                progressDialog.dismiss();
        }
    };

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_target);

        int stateBarH = Utils.getStatusBarHeight(this);
        findViewById(R.id.root).setPadding(0,stateBarH,0,0);
        findViewById(R.id.back_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });
        ((TextView)findViewById(R.id.title)).setText(getResources().getString(R.string.everyday_target_steps));

        nowSteps = findViewById(R.id.now_target_steps);
        TextView wxSyncSteps = (TextView)findViewById(R.id.set_step_target);
        wxSyncSteps.getPaint().setFlags(Paint.UNDERLINE_TEXT_FLAG); //下划线
        wxSyncSteps.getPaint().setAntiAlias(true);
        findViewById(R.id.set_step_target).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                final TargetStepDialog targetStepDialog = new TargetStepDialog(TargetActivity.this);
                targetStepDialog.setCurrentSteps(Integer.valueOf(nowSteps.getText().toString()));
                targetStepDialog.setOkClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        nowSteps.setText(String.valueOf(targetStepDialog.getCurrentSteps()));
                        User user = StepUserManager.getInstance().getUserInfo();
                        if(targetStepDialog.getCurrentSteps() <3000){
                            Toast.makeText(TargetActivity.this,"目标步数不能小于3000步",Toast.LENGTH_SHORT).show();
                            return;
                        }
                        if(targetStepDialog.getCurrentSteps() >10000){
                            Toast.makeText(TargetActivity.this,"目标步数不能大于100000步",Toast.LENGTH_SHORT).show();
                            return;
                        }
                        if(user != null){
                            UmengLog.logEvent(TargetActivity.this,UmengLog.ID.SET_STEP_TARGET);
                            StepUserManager.getInstance().modifyUserInfo(TargetActivity.this,user.getNickname()
                                    ,user.getBirthday(),user.getTips(),
                                    user.getSex(),user.getMobile(),
                                    user.getAddress(),targetStepDialog.getCurrentSteps());
                        }

                        targetStepDialog.dismissDialog();
                    }
                });
                targetStepDialog.showDialogAtCenter();
            }
        });

        lineChartView = findViewById(R.id.lineView);
        getTargetReward = findViewById(R.id.get_target_reward);

        updateSteps(StepUserManager.getInstance().getTodaySteps());
        StepUserManager.getInstance().setLoginListener(loginListener);
        StepUserManager.getInstance().syncStepsList(this);
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                try {
                    progressDialog = ProgressDialog.createDialog(TargetActivity.this);
                    progressDialog.show();
                }catch (Exception e){
                    e.printStackTrace();
                }
            }
        },500);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        StepUserManager.getInstance().removeLoginListener(loginListener);
    }

    public void updateSteps(final List<StepsRecord> datas){
        handler.removeCallbacksAndMessages(null);
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                List<Integer> steps = new ArrayList<>();
                for(int i = 0;i<30;i++){
                    String current = DateUtils.getMD(i-29);
                    boolean isAdd = false;
                    for(StepsRecord item:datas){
                        String stepDate = DateUtils.getDateMD(item.getDate());
                        if(current.equals(stepDate)){
                            steps.add(item.getStep());
                            isAdd = true;
                        }
                    }
                    if(!isAdd){
                        steps.add(0);
                    }
                }

                int max = 0;
                int min = Integer.MAX_VALUE;
                for(int item:steps){
                    if(max<item){
                        max = item;
                    }

                    if(min>item){
                        min = item;
                    }
                }

                if(min <= 0){
                    min = 0;
                }
                EyeLog.logi("--updateSteps--");
                lineChartView.setData(steps,max+max,min);
            }
        },500);
    }

    public void updateSteps(int steps) {
            ((TextView)findViewById(R.id.today_current_steps))
                    .setText("今日步数："+steps+getResources().getString(R.string.step));
    }
}
