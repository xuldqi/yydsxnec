package com.dn.sports.dialog;

import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import android.view.animation.AnimationUtils;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.dn.sports.R;
import com.dn.sports.utils.Utils;


/**
 * Created by Administrator on 2018/8/13 0013.
 */

public class ProgressDialog extends Dialog {
    private Context context = null;
   // private static ProgressDialog ProgressDialog = null;

    public ProgressDialog(Context context){
        super(context);
        this.context = context;
    }

    public ProgressDialog(Context context, int theme) {
        super(context, theme);
    }

    public void setText(String text) {
        TextView tv = findViewById(R.id.id_tv_loadingmsg);
        tv.setVisibility(View.VISIBLE);
        tv.setText(text);
    }
    //创建dialog
    public static ProgressDialog createDialog(Context context){
        ProgressDialog dialog = new ProgressDialog(context, R.style.progressDialog);//应用自定义style
        dialog.setContentView(R.layout.progress_dialog);//加载自定义布局
        dialog.setCanceledOnTouchOutside(false);
        ProgressBar pb = (ProgressBar) dialog.findViewById(R.id.progress_bar);
        pb.startAnimation(AnimationUtils.loadAnimation(context,
                R.anim.progress_anim));

        dialog.setOnKeyListener(new OnKeyListener() {
            @Override
            public boolean onKey(DialogInterface dialog, int keyCode, KeyEvent event) {
                return true;
            }
        });

        WindowManager.LayoutParams params = dialog.getWindow().getAttributes();
        params.gravity = Gravity.CENTER;//居中
        params.width = (int)(Utils.getWidth(context) * 0.4);
        params.height = (int)(params.width * 0.8);
        dialog.getWindow().setAttributes(params);

        return dialog;
    }

    //创建dialog
    public static ProgressDialog createDialog(Context context, String text){
        ProgressDialog dialog = new ProgressDialog(context, R.style.progressDialog);//应用自定义style
        dialog.setContentView(R.layout.progress_dialog);//加载自定义布局
        dialog.setCanceledOnTouchOutside(false);
        ProgressBar pb = (ProgressBar) dialog.findViewById(R.id.progress_bar);
        pb.startAnimation(AnimationUtils.loadAnimation(context,
                R.anim.progress_anim));
        TextView textView = dialog.findViewById(R.id.id_tv_loadingmsg);
        textView.setText(text);
        textView.setVisibility(View.VISIBLE);
        dialog.setOnKeyListener(new OnKeyListener() {
            @Override
            public boolean onKey(DialogInterface dialog, int keyCode, KeyEvent event) {
                return true;
            }
        });

        WindowManager.LayoutParams params = dialog.getWindow().getAttributes();
        params.gravity = Gravity.CENTER;//居中
        params.width = (int)(Utils.getWidth(context) * 0.4);
        params.height = (int)(params.width * 0.9);
        dialog.getWindow().setAttributes(params);

        return dialog;
    }
}
