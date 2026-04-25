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
        finish();
        return;
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        StepUserManager.getInstance().removeLoginListener(loginListener);
    }
}
