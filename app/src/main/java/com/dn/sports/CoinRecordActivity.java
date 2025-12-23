package com.dn.sports;

import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dn.sports.adapter.CoinRecordAdapter;
import com.dn.sports.adcoinLogin.LoginListener;
import com.dn.sports.adcoinLogin.StepUserManager;
import com.dn.sports.adcoinLogin.model.CoinRecord;
import com.dn.sports.common.BaseActivity;
import com.dn.sports.utils.Utils;

import java.util.List;

public class CoinRecordActivity extends BaseActivity {

    private RecyclerView coinRecordList;

    private LoginListener loginListener = new LoginListener(){
        @Override
        public void onCoinRecordList(List<CoinRecord> datas) {
            super.onCoinRecordList(datas);
            CoinRecordAdapter adapter = new CoinRecordAdapter(CoinRecordActivity.this,datas);
            coinRecordList.setAdapter(adapter);
        }
    };

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_coin_record);
        StepUserManager.getInstance().setLoginListener(loginListener);
        findViewById(R.id.root_layout).setPadding(0, Utils.getStatusBarHeight(this),0,0);
        findViewById(R.id.back_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        TextView title = findViewById(R.id.title);
        title.setText(getResources().getString(R.string.coin_record_list));
        coinRecordList = findViewById(R.id.coin_record);
        StepUserManager.getInstance().getCoinRecordList(this);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this, RecyclerView.VERTICAL,false);
        linearLayoutManager.setReverseLayout(true);//布局反向
        coinRecordList.setLayoutManager(linearLayoutManager);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        StepUserManager.getInstance().removeLoginListener(loginListener);
    }
}
