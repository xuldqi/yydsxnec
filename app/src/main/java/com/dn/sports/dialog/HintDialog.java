package com.dn.sports.dialog;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.dn.sports.MainActivity;
import com.dn.sports.MustLoginActivity;
import com.dn.sports.R;
import com.dn.sports.adcoinLogin.StepUserManager;
import com.dn.sports.adcoinLogin.model.User;
import com.dn.sports.utils.Utils;

public class HintDialog extends BasePopup {

    private View view;

    public HintDialog(Context context,boolean isDisableBack){
        super(context, ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);

        if(isDisableBack)
            setBackBtnDismissDisenble();
    }

    @Override
    protected View createDialogView(Context context, LayoutInflater inflater) {
        view = inflater.inflate(R.layout.dialog_hint,null);
        return view;
    }

    @Override
    protected void onDismissDialog() {

    }

    public void setUserClickListener(final User user, View.OnClickListener listener){
        ((TextView)view.findViewById(R.id.title_tx)).setText("账号覆盖提示");
        ((TextView)view.findViewById(R.id.title)).setText("微信已绑定其他账号，登录将清空并覆盖本地数据，是否继续？");
        view.findViewById(R.id.ok).setOnClickListener(listener);
        view.findViewById(R.id.deny).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                StepUserManager.getInstance().clearLogin(context);
                dismissDialog();

                Intent it = new Intent(context, MustLoginActivity.class);
                context.startActivity(it);
            }
        });
    }

    public void setTaskAdHint(View.OnClickListener listener){
        ((TextView)view.findViewById(R.id.title_tx)).setText("未完成任务提示");
        ((TextView)view.findViewById(R.id.title)).setText("你有正在下载安装的任务没有完成，是否继续？");
        view.findViewById(R.id.deny).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dismissDialog();
            }
        });
        view.findViewById(R.id.ok).setOnClickListener(listener);
    }

    public void setNetworkHint(){
        ((TextView)view.findViewById(R.id.title_tx)).setText("网络错误");
        ((TextView)view.findViewById(R.id.title)).setText("网络不畅，请检查当前网络是否正常连接，重新连接。");
        view.findViewById(R.id.deny).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dismissDialog();
            }
        });
        view.findViewById(R.id.ok).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dismissDialog();
            }
        });
    }

    public void setRegisterHint(String message){
        ((TextView)view.findViewById(R.id.title_tx)).setText("注册失败");
        ((TextView)view.findViewById(R.id.title)).setText(message);
        view.findViewById(R.id.deny).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dismissDialog();
            }
        });
        view.findViewById(R.id.ok).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dismissDialog();
            }
        });
    }

    public void setExitCountTime(String message,View.OnClickListener listener){
        ((TextView)view.findViewById(R.id.title_tx)).setText("退出提示");
        ((TextView)view.findViewById(R.id.title)).setText(message);
        view.findViewById(R.id.deny).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dismissDialog();
            }
        });
        view.findViewById(R.id.ok).setOnClickListener(listener);
    }

    public void setCommonHint(String title,String message,View.OnClickListener listener){
        ((TextView)view.findViewById(R.id.title_tx)).setText(title);
        ((TextView)view.findViewById(R.id.title)).setText(message);
        view.findViewById(R.id.deny).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dismissDialog();
            }
        });
        view.findViewById(R.id.ok).setOnClickListener(listener);
    }
}
