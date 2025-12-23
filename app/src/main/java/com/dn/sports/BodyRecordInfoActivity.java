package com.dn.sports;

import android.os.Bundle;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;
import androidx.viewpager.widget.ViewPager;

import com.google.android.material.tabs.TabLayout;
import com.dn.sports.common.BaseActivity;
import com.dn.sports.database.BodyRecordModel;
import com.dn.sports.database.DbService;
import com.dn.sports.dialog.RulerViewPickDialog;
import com.dn.sports.fragment.RecordSubFragment;
import com.dn.sports.utils.Utils;

import java.util.ArrayList;
import java.util.List;

public class BodyRecordInfoActivity extends BaseActivity {

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_body_record_info);
        findViewById(R.id.back_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        ((TextView) findViewById(R.id.title)).setText("身体数据概览");
        findViewById(R.id.root).setPadding(0, Utils.getStatusBarHeight(this),0,0);

        TextView weightText = findViewById(R.id.weight_kg);
        TextView heightText = findViewById(R.id.height_cm);
        TextView breastText = findViewById(R.id.breast_cm);
        TextView yaoweiText = findViewById(R.id.yaowei_cm);
        TextView tunweiText = findViewById(R.id.tunwei_cm);
        TextView shangbiweiText = findViewById(R.id.shangbiwei_cm);
        TextView datuiweiText = findViewById(R.id.datuiwei_cm);
        TextView xiaotuiweiText = findViewById(R.id.xiaotuiwei_cm);

        DbService service = StepApplication.getInstance().getService();
        BodyRecordModel bodyRecordModel = service.findLastBodyModel(RecordSubFragment.TYPE_WEIGHT);
        if(bodyRecordModel != null) {
            weightText.setText(String.valueOf(bodyRecordModel.getData()));
        }else{
            weightText.setText("你还没有记录过体重");
        }

        bodyRecordModel = service.findLastBodyModel(RecordSubFragment.TYPE_HEIGHT);
        if(bodyRecordModel != null) {
            heightText.setText(String.valueOf(bodyRecordModel.getData()));
        }else{
            heightText.setText("你还没有记录过身高");
        }

        bodyRecordModel = service.findLastBodyModel(RecordSubFragment.TYPE_XW);
        if(bodyRecordModel != null) {
            breastText.setText(String.valueOf(bodyRecordModel.getData()));
        }else{
            breastText.setText("你还没有记录过胸围");
        }

        bodyRecordModel = service.findLastBodyModel(RecordSubFragment.TYPE_YW);
        if(bodyRecordModel != null) {
            yaoweiText.setText(String.valueOf(bodyRecordModel.getData()));
        }else{
            yaoweiText.setText("你还没有记录过腰围");
        }

        bodyRecordModel = service.findLastBodyModel(RecordSubFragment.TYPE_TW);
        if(bodyRecordModel != null) {
            tunweiText.setText(String.valueOf(bodyRecordModel.getData()));
        }else{
            tunweiText.setText("你还没有记录过臀围");
        }

        bodyRecordModel = service.findLastBodyModel(RecordSubFragment.TYPE_SBW);
        if(bodyRecordModel != null) {
            shangbiweiText.setText(String.valueOf(bodyRecordModel.getData()));
        }else{
            shangbiweiText.setText("你还没有记录过上臂围");
        }

        bodyRecordModel = service.findLastBodyModel(RecordSubFragment.TYPE_DTW);
        if(bodyRecordModel != null) {
            datuiweiText.setText(String.valueOf(bodyRecordModel.getData()));
        }else{
            datuiweiText.setText("你还没有记录过大腿围");
        }

        bodyRecordModel = service.findLastBodyModel(RecordSubFragment.TYPE_XTW);
        if(bodyRecordModel != null) {
            xiaotuiweiText.setText(String.valueOf(bodyRecordModel.getData()));
        }else{
            xiaotuiweiText.setText("你还没有记录过小腿围");
        }
    }
}
