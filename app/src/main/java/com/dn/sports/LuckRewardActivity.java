package com.dn.sports;

import android.content.Intent;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;

import com.dn.sports.adcoinLogin.LoginListener;
import com.dn.sports.adcoinLogin.StepUserManager;
import com.dn.sports.adcoinLogin.model.TaskModel;
import com.dn.sports.common.BaseActivity;
import com.dn.sports.common.EyeLog;
import com.dn.sports.common.UmengLog;
import com.dn.sports.utils.Utils;
import com.dn.sports.view.PieView;
import com.dn.sports.view.lottery.AdminHelper;
import com.dn.sports.view.lottery.DiskEntity;
import com.dn.sports.view.lottery.DiskView;

import java.util.ArrayList;
import java.util.List;

public class LuckRewardActivity extends BaseActivity {
    private PieView pieView;
    private ImageView startPieView;
    private TextView lunckRewardTimes;
    private int amountIndex;
    private boolean canLuckReward = true;

    private LoginListener loginListener = new LoginListener() {
        @Override
        public void onGetTaskReward(TaskModel taskModel) {
            super.onGetTaskReward(taskModel);

            if(taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_SLOT){
                if(taskModel.getState() != 0){
                    String coinText = getResources().getString(R.string.luck_reward_times);
                    canLuckReward = false;
                    coinText = String.format(coinText, String.valueOf(0));
                    lunckRewardTimes.setText(coinText);
                }
            }
        }
    };

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_luck_reward);
//        findViewById(R.id.ll_content).setPadding(0, Utils.getStatusBarHeight(this),0,0);
//        ((TextView) findViewById(R.id.title)).setText(getResources().getString(R.string.luck_reward));
//        ((TextView) findViewById(R.id.title)).setTextColor(Color.WHITE);
//
//        pieView = findViewById(R.id.PieView);
//        startPieView = findViewById(R.id.start_luck_reward);
//        pieView.setListener(new PieView.RotateListener() {
//            @Override
//            public void value(String s) {
//                startPieView.setImageResource(R.mipmap.start_luck_reward);
//                startPieView.setClickable(true);
//                EyeLog.logi("end luck reward");
//                Intent it = new Intent(LuckRewardActivity.this,AdActivity.class);
//                it.putExtra(AdActivity.AD_TYPE,AdActivity.PIE_COIN);
//                it.putExtra("coin",s);
//                startActivity(it);
//            }
//        });
//        ((ImageView)findViewById(R.id.back_btn)).setImageResource(R.mipmap.back_btn_white);
//        findViewById(R.id.back_btn).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                finish();
//            }
//        });
//
//        startPieView.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                if(!canLuckReward){
//                    Toast.makeText(getApplicationContext(),getResources().getString(R.string.already_luck_reward),Toast.LENGTH_SHORT).show();
//                    return;
//                }
//
//                startPieView.setImageResource(R.mipmap.playing_luck_reward);
//                startPieView.setClickable(false);
//                pieView.rotate(amountIndex);
//                EyeLog.logi("start luck reward");
//                UmengLog.logEvent(getApplicationContext(),UmengLog.ID.LUCK_REWARD);
//            }
//        });
//
//        TaskModel taskModel = StepUserManager.getInstance().getSlotTask();
//        if(taskModel == null){
//            Toast.makeText(this,getResources().getString(R.string.task_error),Toast.LENGTH_SHORT).show();
//            return;
//        }
//        int amount = taskModel.getAmount();
//        if(amount == 0){
//            amountIndex = 2;
//        }else if(amount == 20){
//            amountIndex = 0;
//        }else if(amount == 30){
//            amountIndex = 1;
//        }else if(amount == 40){
//            amountIndex = 5;
//        }else if(amount == 60){
//            amountIndex = 6;
//        }else if(amount == 80){
//            amountIndex = 7;
//        }else if(amount == 100){
//            amountIndex = 8;
//        }else if(amount == 120){
//            amountIndex = 9;
//        }
//        EyeLog.logi(taskModel.toString());
//        lunckRewardTimes = findViewById(R.id.luck_reward_times);
//        String coinText = getResources().getString(R.string.luck_reward_times);
//
//        if(taskModel.getState() != 0 ){
//            canLuckReward = false;
//            coinText = String.format(coinText, String.valueOf(0));
//        }else{
//            coinText = String.format(coinText, String.valueOf(1));
//        }
//
//        lunckRewardTimes.setText(coinText);
//
//        StepUserManager.getInstance().setLoginListener(loginListener);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        StepUserManager.getInstance().removeLoginListener(loginListener);
    }
}
