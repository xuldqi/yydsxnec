package com.dn.sports.dialog;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.dn.sports.R;
import com.dn.sports.YSXYActivity;

public class UserFirstHintDialog extends BasePopup {

    public UserFirstHintDialog(Context context){
        super(context, ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        setBackBtnDismiss();
        setOutsideTouchable(false);
    }

    @Override
    protected View createDialogView(final Context context, LayoutInflater inflater) {
        View view = inflater.inflate(R.layout.dialog_first_hint_for_user,null);
//        SpannableString spannableString = new SpannableString(context.getResources().getString(R.string.first_for_user_hint5));
//        ForegroundColorSpan colorSpan = new ForegroundColorSpan(Color.parseColor("#0099EE"));
//        spannableString.setSpan(colorSpan, 3, 7, Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
//        ((TextView)view.findViewById(R.id.goto_user)).setText(spannableString);
//
//        view.findViewById(R.id.goto_ys).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                Intent it = new Intent(context, YSXYActivity.class);
//                it.putExtra("type",2);
//                context.startActivity(it);
//            }
//        });

        SpannableString spannableString1 = new SpannableString(context.getResources().getString(R.string.first_for_user_hint6));
//        spannableString1.setSpan(colorSpan, 1, 5, Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
//        ((TextView)view.findViewById(R.id.goto_ys)).setText(spannableString1);
//        view.findViewById(R.id.goto_user).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                Intent it = new Intent(context, YSXYActivity.class);
//                it.putExtra("type",1);
//                context.startActivity(it);
//            }
//        });
//        view.findViewById(R.id.ok).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                dismissDialog();
//            }
//        });
        return view;
    }

    @Override
    protected void onDismissDialog() {

    }
}
