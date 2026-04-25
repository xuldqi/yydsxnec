package com.dn.sports;

import android.os.Bundle;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.Nullable;

import com.dn.sports.common.BaseActivity;
import com.dn.sports.utils.Utils;

public class TaskAdActivity extends BaseActivity {

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_ad);
        View root = findViewById(R.id.root_layout);
        if (root != null) {
            root.setPadding(0, Utils.getStatusBarHeight(this), 0, 0);
        }

        View backBtn = findViewById(R.id.back_btn);
        if (backBtn != null) {
            backBtn.setOnClickListener(v -> finish());
        }

        TextView title = findViewById(R.id.title);
        if (title != null) {
            title.setText(R.string.task_feature_closed_title);
        }

        LinearLayout container = findViewById(R.id.coin_ad_lv);
        if (container != null) {
            container.removeAllViews();
            container.setGravity(Gravity.CENTER_HORIZONTAL);
            container.setPadding(dp(24), dp(80), dp(24), dp(24));

            TextView headline = new TextView(this);
            headline.setText(R.string.task_feature_closed_title);
            headline.setTextColor(0xFF333333);
            headline.setTextSize(TypedValue.COMPLEX_UNIT_SP, 18);
            headline.setGravity(Gravity.CENTER_HORIZONTAL);

            TextView body = new TextView(this);
            body.setText(R.string.task_feature_closed_desc);
            body.setTextColor(0xFF666666);
            body.setTextSize(TypedValue.COMPLEX_UNIT_SP, 14);
            body.setGravity(Gravity.CENTER_HORIZONTAL);
            LinearLayout.LayoutParams bodyLp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            );
            bodyLp.topMargin = dp(12);

            TextView tip = new TextView(this);
            tip.setText(R.string.task_feature_closed_tip);
            tip.setTextColor(0xFF999999);
            tip.setTextSize(TypedValue.COMPLEX_UNIT_SP, 12);
            tip.setGravity(Gravity.CENTER_HORIZONTAL);
            LinearLayout.LayoutParams tipLp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            );
            tipLp.topMargin = dp(8);

            container.addView(headline);
            container.addView(body, bodyLp);
            container.addView(tip, tipLp);
        }
    }

    private int dp(int value) {
        return (int) TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_DIP,
            value,
            getResources().getDisplayMetrics()
        );
    }
}
