package com.dn.sports.dialog;

import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.TextView;

import com.dn.sports.CountStepsActivity;
import com.dn.sports.R;
import com.dn.sports.common.EyeLog;

public class CountDownDialog extends BasePopup {

    private int count = 3;
    private TextView countDownText;
    private int stepType;
    private int sportTarget = 0;
    private Handler handler = new Handler(Looper.getMainLooper()){
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            if(count == 1){
                Animation animation = AnimationUtils.loadAnimation(context, R.anim.count_down);
                countDownText.startAnimation(animation);
                countDownText.setText("GO");
                handler.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                       dismissDialog();
                       Intent it = new Intent(context, CountStepsActivity.class);
                       it.putExtra(CountStepsActivity.STEP_TYPE,stepType);
                       it.putExtra("set_sport_target_type",sportTarget);
                       context.startActivity(it);
                    }
                },1000);
            }else{
                Animation animation = AnimationUtils.loadAnimation(context, R.anim.count_down);
                countDownText.startAnimation(animation);
                countDownText.setText((count-1)+"");
                count = count - 1;
                handler.sendEmptyMessageDelayed(0,1000);
            }
        }
    };

    public CountDownDialog(Context context){
        super(context, ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
        setBackBtnDismissDisenble();
    }

    public void setType(int type,int target){
        stepType = type;
        sportTarget = target;
    }

    @Override
    public void showDialogAtCenter() {
        super.showDialogAtCenter();
        count = 3;
        handler.removeCallbacksAndMessages(null);
        handler.sendEmptyMessageDelayed(0,1000);
        countDownText.setText("3");
        Animation animation = AnimationUtils.loadAnimation(context, R.anim.count_down);
        countDownText.startAnimation(animation);
    }

    @Override
    protected View createDialogView(Context context, LayoutInflater inflater) {
        View view = inflater.inflate(R.layout.dialog_count_down,null);
        countDownText = view.findViewById(R.id.text);
        return view;
    }

    @Override
    protected void onDismissDialog() {

    }
}
