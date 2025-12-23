package com.dn.sports.target;

import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dn.sports.CountStepsActivity;
import com.dn.sports.R;
import com.dn.sports.StepApplication;
import com.dn.sports.adapter.BodyRecordAdapter;
import com.dn.sports.adapter.StepRecordAdapter;
import com.dn.sports.common.BaseActivity;
import com.dn.sports.database.BodyRecordModel;
import com.dn.sports.database.StepsCountModel;
import com.dn.sports.fragment.StepSubFragment;
import com.dn.sports.utils.Utils;

import java.util.List;

public class StepCountTargetActivity extends BaseActivity {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_step_count_target_list);
        if(getIntent() == null) {
            finish();
            return;
        }
        findViewById(R.id.root).setPadding(0, Utils.getStatusBarHeight(this),0,0);
        int type = getIntent().getIntExtra(CountStepsActivity.STEP_TYPE, StepSubFragment.TYPE_RUN_INDOOR);
        String title = getIntent().getStringExtra("title");
        ((TextView) findViewById(R.id.title)).setText(title);
        findViewById(R.id.back_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });
        List<StepsCountModel> models = StepApplication.getInstance().getService().findAllByType(type);


        RecyclerView list = findViewById(R.id.list);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this, RecyclerView.VERTICAL,false);
        list.setLayoutManager(linearLayoutManager);
        StepRecordAdapter adapter = new StepRecordAdapter(this,models);
        list.setAdapter(adapter);
    }
}
