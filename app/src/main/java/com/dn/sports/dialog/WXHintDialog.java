package com.dn.sports.dialog;

import android.content.Context;
import android.graphics.Paint;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.dn.sports.R;
import com.dn.sports.adcoinLogin.StepUserManager;


public class WXHintDialog extends BasePopup {

    public WXHintDialog(Context context){
        super(context, ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        setBackBtnDismiss();
        setOutsideTouchable(false);
    }

    @Override
    protected View createDialogView(final Context context, LayoutInflater inflater) {
        View view = inflater.inflate(R.layout.dialog_win_hint,null);
        view.findViewById(R.id.deny).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismissDialog();
            }
        });
        view.findViewById(R.id.auth).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                StepUserManager.getInstance().launchMiniPro(context);
                dismissDialog();
            }
        });
        return view;
    }

    @Override
    protected void onDismissDialog() {

    }
}
