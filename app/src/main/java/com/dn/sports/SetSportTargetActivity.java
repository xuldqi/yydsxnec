//package com.dn.sports;
//
//import android.content.Intent;
//import android.os.Bundle;
//import android.view.View;
//import android.widget.TextView;
//
//import androidx.annotation.Nullable;
//import androidx.recyclerview.widget.LinearLayoutManager;
//import androidx.recyclerview.widget.RecyclerView;
//
//import com.dn.sports.adapter.SetTargetTypeAdapter;
//import com.dn.sports.common.BaseActivity;
//import com.dn.sports.utils.Utils;
//
//import java.util.ArrayList;
//import java.util.List;
//
//public class SetSportTargetActivity extends BaseActivity {
//    private RecyclerView setTargetTypeList;
//    private int type;
//
//    @Override
//    protected void onCreate(@Nullable Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_set_sport_target);
//        findViewById(R.id.back_btn).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                finish();
//            }
//        });
//        ((TextView) findViewById(R.id.title)).setText("运动目标设置");
//        findViewById(R.id.root).setPadding(0, Utils.getStatusBarHeight(this),0,0);
//
//        setTargetTypeList = findViewById(R.id.set_target_type_list);
//        List<Integer> dataList = new ArrayList<>();
//        dataList.add(0);
//        dataList.add(400);
//        dataList.add(800);
//        dataList.add(1000);
//        dataList.add(2000);
//        dataList.add(3000);
//        dataList.add(4000);
//        dataList.add(5000);
//        dataList.add(6000);
//        dataList.add(7000);
//        dataList.add(8000);
//        dataList.add(9000);
//        dataList.add(10000);
//        dataList.add(15000);
//        dataList.add(21500);
//        dataList.add(42500);
//
//        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this, RecyclerView.VERTICAL,false);
//        setTargetTypeList.setLayoutManager(linearLayoutManager);
//        SetTargetTypeAdapter adapter = new SetTargetTypeAdapter(this,dataList,"");
//        setTargetTypeList.setAdapter(adapter);
//        type = getIntent().getIntExtra("set_sport_target_type",0);
//        int pos = 0;
//        for(int i = 0;i<dataList.size();i++){
//            if(type == dataList.get(i)){
//                pos = i;
//            }
//        }
//        adapter.setSelectItem(pos);
//        adapter.setClickListener(new SetTargetTypeAdapter.ClickListener() {
//            @Override
//            public void onClick(Integer integer, int pos) {
//                type = integer;
//                adapter.setSelectItem(pos);
//            }
//        });
//
//        findViewById(R.id.ok).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                Intent it = new Intent();
//                it.putExtra("set_sport_target_type",type);
//                setResult(10001,it);
//                finish();
//            }
//        });
//    }
//}
