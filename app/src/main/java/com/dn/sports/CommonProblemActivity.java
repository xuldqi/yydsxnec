package com.dn.sports;

import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.Nullable;

import com.dn.sports.common.BaseActivity;
import com.dn.sports.utils.Utils;

public class CommonProblemActivity extends BaseActivity {

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_common_problem);
        findViewById(R.id.back_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        ((TextView) findViewById(R.id.title)).setText(getResources().getString(R.string.common_problem));
        findViewById(R.id.root_layout).setPadding(0, Utils.getStatusBarHeight(this), 0, 0);
        String problem = "";
        String[] problemList = getResources().getStringArray(R.array.common_problem);
        for (String item:problemList){
            problem = problem + item +"\n"+"\n";
        }
        ((TextView) findViewById(R.id.content_text)).setText(problem);
    }
}
