package com.dn.sports.fragment;

import android.graphics.Paint;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.Toast;

import com.dn.sports.R;
import com.dn.sports.adcoinLogin.StepUserManager;
import com.dn.sports.adcoinLogin.model.StepsRecord;
import com.dn.sports.adcoinLogin.model.User;
import com.dn.sports.common.EyeLog;
import com.dn.sports.common.UmengLog;
import com.dn.sports.dialog.TargetStepDialog;
import com.dn.sports.utils.DateUtils;
import com.dn.sports.utils.Utils;
import com.dn.sports.view.LineChartView;
import com.dn.sports.view.SunLineChartView;

import org.w3c.dom.Text;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

public class DataFragment extends BaseFragment {

    private TextView nowSteps;
    private SunLineChartView lineChartView;
    private TextView getTargetReward;
    private Handler handler = new Handler(Looper.getMainLooper());

    @Override
    public View getViewByLayout(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_data,container,false);
    }

    @Override
    public void initViewAction(View view) {
        int stateBarH = Utils.getStatusBarHeight(getActivity());
        view.findViewById(R.id.root).setPadding(0,stateBarH,0,0);
        view.findViewById(R.id.back_btn).setVisibility(View.GONE);
        ((TextView)view.findViewById(R.id.title)).setText(getResources().getString(R.string.everyday_target_steps));

        nowSteps = view.findViewById(R.id.now_target_steps);
        TextView wxSyncSteps = (TextView)view.findViewById(R.id.set_step_target);
        wxSyncSteps.getPaint().setFlags(Paint.UNDERLINE_TEXT_FLAG); //下划线
        wxSyncSteps.getPaint().setAntiAlias(true);
        view.findViewById(R.id.set_step_target).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                final TargetStepDialog targetStepDialog = new TargetStepDialog(getActivity());
                targetStepDialog.setCurrentSteps(Integer.valueOf(nowSteps.getText().toString()));
                targetStepDialog.setOkClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        nowSteps.setText(String.valueOf(targetStepDialog.getCurrentSteps()));
                        User user = StepUserManager.getInstance().getUserInfo();
                        if(targetStepDialog.getCurrentSteps() <3000){
                            Toast.makeText(getContext(),"目标步数不能小于3000步",Toast.LENGTH_SHORT).show();
                            return;
                        }
                        if(targetStepDialog.getCurrentSteps() >10000){
                            Toast.makeText(getContext(),"目标步数不能大于100000步",Toast.LENGTH_SHORT).show();
                            return;
                        }
                        if(user != null){
                            UmengLog.logEvent(getActivity(),UmengLog.ID.SET_STEP_TARGET);
                            StepUserManager.getInstance().modifyUserInfo(getActivity(),user.getNickname()
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

        lineChartView = view.findViewById(R.id.lineView);
        getTargetReward = view.findViewById(R.id.get_target_reward);
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

    @Override
    public void updateUserInfo() {
        User user = StepUserManager.getInstance().getUserInfo();
        if(user == null){
            return;
        }
        nowSteps.setText(String.valueOf(user.getStepTarget()));
        if(user.getStepTarget() == 0){
            getTargetReward.setText("请先设置目标步数");
            getTargetReward.setTextColor(getResources().getColor(R.color.app_common_color));
            return;
        }

        int current = StepUserManager.getInstance().getTodaySteps();
        if(current < user.getStepTarget()){
            getTargetReward.setText("尚未达成目标，继续加油！");
            getTargetReward.setTextColor(getResources().getColor(R.color.orange));
        }else{
            getTargetReward.setText("恭喜你，目标步数达成！");
            getTargetReward.setTextColor(getResources().getColor(R.color.app_common_color));
        }
    }

    public void updateSteps(int steps) {
        if(view != null){
            ((TextView)view.findViewById(R.id.today_current_steps))
                    .setText("今日步数："+steps+getActivity().getResources().getString(R.string.step));
        }
    }

    @Override
    public void clearUserInfo() {
    }
}
