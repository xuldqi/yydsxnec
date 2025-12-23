package com.dn.sports.view;

import android.content.Context;
import android.content.Intent;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.dn.sports.AdActivity;
import com.dn.sports.LuckRewardActivity;
import com.dn.sports.MainActivity;
import com.dn.sports.MyMoneyActivity;
import com.dn.sports.R;
import com.dn.sports.ShareFirendActivity;
import com.dn.sports.SignActivity;
import com.dn.sports.TaskAdActivity;
import com.dn.sports.WriteInviteCodeActivity;
import com.dn.sports.adcoinLogin.Ad;
import com.dn.sports.adcoinLogin.StepUserManager;
import com.dn.sports.adcoinLogin.model.TaskModel;
import com.dn.sports.common.Constant;
import com.dn.sports.common.EyeLog;
import com.dn.sports.common.UmengLog;
import com.dn.sports.utils.Utils;
import com.tencent.mm.opensdk.modelmsg.SendAuth;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

public class MasonItemView extends LinearLayout {

    public interface MasonListener{
        void onClick();

        void watchAdGetCoin(MasonItemView view,TaskModel taskModel);

        void watchAdTask(MasonItemView view,TaskModel taskModel);

        void watchAdTaskGetCoin(MasonItemView view,TaskModel taskModel);
    }
    private IWXAPI api;
    private Context context;
    private TextView titleTextView;
    private TextView hintTextView;
    private ImageView icon;
    private TextView coinTextView;
    private TextView goSetting;
    private TaskModel taskModel;
    private MasonListener masonListener;
    private ImageView masonIcon;

    public MasonListener getMasonListener() {
        return masonListener;
    }

    public void setMasonListener(MasonListener masonListener) {
        this.masonListener = masonListener;
    }

    public MasonItemView(Context context){
        super(context);
        init(context);
    }

    public MasonItemView(Context context, AttributeSet attributeSet){
        super(context,attributeSet);
        init(context);
    }

    public TaskModel getTaskModel() {
        return taskModel;
    }

    public void setTaskModel(TaskModel taskModel) {
        this.taskModel = taskModel;
        if(taskModel.getTaskId() == Integer.MIN_VALUE){
            setTitle("做任务领金币");
            setHint("更多的任务领取积分");
            icon.setImageResource(R.mipmap.task_more);
            setGoSetting(getResources().getString(R.string.go_to_achieve),R.drawable.press_background,new View.OnClickListener(){
                @Override
                public void onClick(View view) {
                    Intent it = new Intent(context, TaskAdActivity.class);
                    context.startActivity(it);
                }
            });
            return;
        }

        String name = taskModel.getTaskName();
        if(taskModel.getLimite() > 1){
            name = name + "("+taskModel.getFinishCount()+"/"+taskModel.getLimite()+")";
        }
        setTitle(name);
        setHint(taskModel.getDes());
        setCoinNumber(taskModel.getAmount());
        String btnName;
        int res;
        if(taskModel.getState() == 0){
            btnName = getResources().getString(R.string.mason_get_coin);
            res = R.drawable.press_background_get;
        }else if(taskModel.getState() == 1){
            btnName = getResources().getString(R.string.already_get_coin);
            res = R.drawable.press_background_already_get;
        }else{
            btnName = getResources().getString(R.string.go_to_achieve);
            res = R.drawable.press_background;
        }

        if(StepUserManager.TaskID.TASK_ID_FIRST_LOGIN == taskModel.getTaskId()){
            icon.setImageResource(R.mipmap.task_first_login);
        }else if(StepUserManager.TaskID.TASK_ID_SYNC_STEP == taskModel.getTaskId()){
            icon.setImageResource(R.mipmap.task_sync_wx);
        }else if(StepUserManager.TaskID.TASK_ID_WATCH_AD == taskModel.getTaskId()){
            icon.setImageResource(R.mipmap.task_video);
        }else if(StepUserManager.TaskID.TASK_ID_STEP_TARGET1 == taskModel.getTaskId()
                ||StepUserManager.TaskID.TASK_ID_STEP_TARGET2 == taskModel.getTaskId()
                ||StepUserManager.TaskID.TASK_ID_STEP_TARGET3 == taskModel.getTaskId()){
            icon.setImageResource(R.mipmap.task_step);
        }else if(StepUserManager.TaskID.TASK_ID_STEP_TOTAL_TARGET == taskModel.getTaskId()){
//            icon.setImageResource(R.mipmap.task_step_10000);
        }else if(StepUserManager.TaskID.TASK_ID_INVITE1 == taskModel.getTaskId()
                ||StepUserManager.TaskID.TASK_ID_INVITE2 == taskModel.getTaskId()
                ||StepUserManager.TaskID.TASK_ID_INVITE3 == taskModel.getTaskId()
                ||StepUserManager.TaskID.TASK_ID_INVITE4 == taskModel.getTaskId()
                ||StepUserManager.TaskID.TASK_ID_INVITE5 == taskModel.getTaskId()){
//            icon.setImageResource(R.mipmap.task_firend);
        }else if(StepUserManager.TaskID.TASK_ID_SHARE_APP == taskModel.getTaskId()){
//            icon.setImageResource(R.mipmap.task_share);
        }else if(StepUserManager.TaskID.TASK_ID_TOTAL_GOLD1 == taskModel.getTaskId()
                ||StepUserManager.TaskID.TASK_ID_TOTAL_GOLD2 == taskModel.getTaskId()
                ||StepUserManager.TaskID.TASK_ID_TOTAL_GOLD3 == taskModel.getTaskId()){
            icon.setImageResource(R.mipmap.task_money);
        }else if(StepUserManager.TaskID.TASK_ID_WRITE_INVITE == taskModel.getTaskId()){
            icon.setImageResource(R.mipmap.task_write_code);
        }else if(StepUserManager.TaskID.TASK_ID_FIRST_GET_CASH == taskModel.getTaskId()){
            icon.setImageResource(R.mipmap.task_get_money);
        }else if(StepUserManager.TaskID.TASK_ID_FIRST_SIGN == taskModel.getTaskId()
                ||StepUserManager.TaskID.TASK_ID_CON_SIGN_CONTNUE1 == taskModel.getTaskId()
                ||StepUserManager.TaskID.TASK_ID_CON_SIGN_CONTNUE2 == taskModel.getTaskId()){
//            icon.setImageResource(R.mipmap.task_sign);
        }
        setGoSetting(btnName, res, new OnClickListener() {
            @Override
            public void onClick(View view) {
                if(taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_SLOT&&taskModel.getState() == 0){
                    Intent it = new Intent(context, LuckRewardActivity.class);
                    context.startActivity(it);
                    return;
                }


                if(taskModel.getState() == 1){
                    Toast.makeText(getContext(),getResources().getString(R.string.already_get_coin_hint),Toast.LENGTH_SHORT).show();
                    return;
                }

                if(taskModel.getState() == 0){
                    if(taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_STEP_DAY_TARGET1
                        ||taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_STEP_DAY_TARGET2
                        ||taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_STEP_DAY_TARGET3
                        ||taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_STEP_DAY_TARGET4){
                        Intent it = new Intent(getContext(), AdActivity.class);
                        it.putExtra(AdActivity.AD_TYPE,AdActivity.SYNC_STEP_TASK);
                        it.putExtra(AdActivity.TASK_ID,taskModel.getTaskId());
                        it.putExtra(AdActivity.COIN_NUM,taskModel.getAmount());
                        getContext().startActivity(it);
                        return;
                    }

                    if(taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_WATCH_AD){
                        UmengLog.logEvent(getContext(),UmengLog.ID.TASK_VIDEO_AD);
                        if(masonListener != null){
                            masonListener.watchAdTaskGetCoin(MasonItemView.this,taskModel);
                        }
                        return;
                    }

                    if(masonListener != null){
                        masonListener.watchAdGetCoin(MasonItemView.this,taskModel);
                        return;
                    }
                }

                //完成任务的动作
                if(taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_FIRST_LOGIN){
                    final SendAuth.Req req = new SendAuth.Req();
                    req.scope = "snsapi_userinfo";
                    req.state = "wechat_sdk_demo_test";
                    api.sendReq(req);
                }else if(taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_WATCH_AD){
                    long currentTime = System.currentTimeMillis();
                    long lastTime = (long)Utils.get(getContext(),"TASK_VIDEO_AD",0L);
                    if(currentTime - lastTime > 300000){
                        //看广告领金币
                        if(masonListener != null){
                            Utils.put(getContext(),"TASK_VIDEO_AD",currentTime);
                            masonListener.watchAdTask(MasonItemView.this,taskModel);
                        }
                    }else{
                        String hint = "刚看完，请稍片刻：";
                        int m = 300 - (int)((currentTime - lastTime)/1000);
                        if(m < 60){
                            hint = hint + m+"秒";
                        }else{
                            int n = m%60;
                            int l = m/60;
                            hint = hint +l+"分"+ n+"秒";
                        }
                        Toast.makeText(getContext(),hint,Toast.LENGTH_SHORT).show();
                    }
                }else if(taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_SYNC_STEP){
                    StepUserManager.getInstance().launchMiniPro(getContext());
                }else if(taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_STEP_TOTAL_TARGET) {
                    StepUserManager.getInstance().launchMiniPro(getContext());
                }else if(taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_INVITE1
                        ||taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_INVITE2
                        ||taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_INVITE3
                        ||taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_INVITE4
                        ||taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_INVITE5) {
                    if(StepUserManager.getInstance().isNeedLogin()){
                        Toast.makeText(getContext(),"请先登录，再邀请好友",Toast.LENGTH_SHORT).show();
                        return;
                    }
                    Intent it = new Intent(context, ShareFirendActivity.class);
                    context.startActivity(it);
                }else if(taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_STEP_TARGET1
                        ||taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_STEP_TARGET2
                        ||taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_STEP_TARGET3) {
                    Toast.makeText(context,context.getResources().getString(R.string.wx_steps_hint),Toast.LENGTH_SHORT).show();
                    StepUserManager.getInstance().launchMiniPro(getContext());
                }else if(taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_SHARE_APP){
                    if(StepUserManager.getInstance().isNeedLogin()){
                        Toast.makeText(getContext(),"请先登录，再邀请好友",Toast.LENGTH_SHORT).show();
                        return;
                    }
                    Intent it = new Intent(context, ShareFirendActivity.class);
                    it.putExtra("share_app",true);
                    context.startActivity(it);
                }else if(taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_FIRST_SIGN
                        ||taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_CON_SIGN_CONTNUE1
                        ||taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_CON_SIGN_CONTNUE2){
                    Intent it = new Intent(context, SignActivity.class);
                    context.startActivity(it);
                }else if(taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_FIRST_GET_CASH){
                    Intent it = new Intent(context, MyMoneyActivity.class);
                    context.startActivity(it);
                }else if(taskModel.getTaskId() == StepUserManager.TaskID.TASK_ID_WRITE_INVITE){
                    if(StepUserManager.getInstance().isNeedLogin()){
                        Toast.makeText(getContext(),"请先登录，再填写邀请码",Toast.LENGTH_SHORT).show();
                        return;
                    }
                    Intent it = new Intent(context, WriteInviteCodeActivity.class);
                    context.startActivity(it);
                }
            }
        });
    }

    private void init(Context context){
        this.context = context;
        LayoutInflater inflater = LayoutInflater.from(context);
        View view = inflater.inflate(R.layout.mason_item_view, this);
        titleTextView = view.findViewById(R.id.mason_name);
        hintTextView = view.findViewById(R.id.mason_hint);
        icon = view.findViewById(R.id.mason_icon);
        coinTextView = view.findViewById(R.id.coin_text_number);
        goSetting = view.findViewById(R.id.go_achieve_mason);
        api = WXAPIFactory.createWXAPI(context, Constant.WX_LOGIN.getWxAppId(context),true);
        api.registerApp( Constant.WX_LOGIN.getWxAppId(context));
    }

    public void setTitle(String title){
        titleTextView.setText(title);
    }

    public void setHint(String title){
        hintTextView.setText(title);
    }

    public void setIcon(int res){
        icon.setImageResource(res);
    }

    public void setCoinNumber(int coin){
        if(coin == 0){
            coinTextView.setText("");
            return;
        }
        coinTextView.setText("+"+coin);
    }

    public void setGoSetting(String title,int res,OnClickListener listener){
        goSetting.setText(title);
        goSetting.setBackgroundResource(res);
        goSetting.setOnClickListener(listener);
    }
}
