package com.dn.sports.dialog;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.dn.sports.MainActivity;
import com.dn.sports.R;
import com.dn.sports.StartLogoActivity;
import com.dn.sports.StepApplication;
import com.dn.sports.YSXYActivity;
import com.dn.sports.utils.SharedPreferenceUtil;

public class UserPrivateDialog extends BasePopup {

    private View view;

    public UserPrivateDialog(Context context, boolean isDisableBack) {
        super(context, ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
        if (isDisableBack)
            setBackBtnDismissDisenble();
        view.findViewById(R.id.tvUser).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent it = new Intent(context, YSXYActivity.class);
                it.putExtra("type", 1);
            }
        });

        view.findViewById(R.id.tvPrivate).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent it = new Intent(context, YSXYActivity.class);
                it.putExtra("type", 2);
            }
        });

        view.findViewById(R.id.deny).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // 隐私合规：用户拒绝隐私政策时正常退出，不能使用System.exit强制杀进程
                dismissDialog();
                if (context instanceof Activity) {
                    ((Activity) context).finishAffinity();
                }
            }
        });
        view.findViewById(R.id.ok).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                SharedPreferenceUtil.Companion.getInstance(context).put("userAgree", true);
//                Activity activity= StepApplication.getInstance().clearActivity();
                Intent it = new Intent(context, MainActivity.class);
                context.startActivity(it);
//                context.finish();
                dismissDialog();
            }
        });
    }

    @Override
    protected void onDismissDialog() {

    }

    @Override
    protected View createDialogView(Context context, LayoutInflater inflater) {
        view = inflater.inflate(R.layout.dialog_first_hint_for_user, null);
        return view;
    }


}
