package com.dn.sports;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.dn.sports.adcoinLogin.Ad;
import com.dn.sports.adcoinLogin.LoginListener;
import com.dn.sports.adcoinLogin.StepUserManager;
import com.dn.sports.adcoinLogin.model.User;
import com.dn.sports.common.BaseActivity;
import com.dn.sports.common.UmengLog;
import com.dn.sports.dialog.GetMoneyDialog;
import com.dn.sports.dialog.ProgressDialog;
import com.dn.sports.utils.Utils;

public class MyMoneyActivity extends BaseActivity {
    private EditText editText;
    private LinearLayout listRecord;
    private Handler mainHandler = new Handler(Looper.getMainLooper());
    private ProgressDialog progressDialog;
    private LoginListener listener = new LoginListener() {

        @Override
        public void onGetCash() {
            super.onGetCash();
            if(progressDialog != null && progressDialog.isShowing()){
                progressDialog.dismiss();
            }
            UmengLog.logEvent(MyMoneyActivity.this,UmengLog.ID.GET_MONEY);

            Intent it = new Intent(MyMoneyActivity.this,AdActivity.class);
            it.putExtra(AdActivity.AD_TYPE,AdActivity.GET_MONEY);
            startActivity(it);
        }

        @Override
        public void onError(int msg, String info) {
            super.onError(msg, info);
            if(msg == Ad.Login.MSG_GET_MONEY){
                if(progressDialog != null && progressDialog.isShowing()){
                    progressDialog.dismiss();
                }
                Toast.makeText(getApplicationContext(),"提现失败", Toast.LENGTH_SHORT).show();
            }
        }

        @Override
        public void onUserInfoUpdate(int msg, User info) {
            super.onUserInfoUpdate(msg, info);

            ((TextView) findViewById(R.id.current_coin)).setText((int)info.getBalance()+"金币");
            ((TextView) findViewById(R.id.current_money)).setText(StepUserManager.coinToMoney(info.getBalance())+"元");
        }
    };

    private void updateData(){
        User signUserInfo = StepUserManager.getInstance().getUserInfo();
        ((TextView) findViewById(R.id.current_coin)).setText((int)signUserInfo.getBalance()+"金币");
        ((TextView) findViewById(R.id.current_money)).setText(StepUserManager.coinToMoney(signUserInfo.getBalance())+"元");

//        if(listRecord == null)
//            return;
//        listRecord.removeAllViews();
//
//        for (GetCashRecord getCashRecord:signUserInfo.getCashRecords()){
//            View view = LayoutInflater.from(this).inflate(R.layout.money_item,null);
//            ((TextView)view.findViewById(R.id.date)).setText(getCashRecord.getTime());
//            ((TextView)view.findViewById(R.id.money)).setText(getCashRecord.getText());
//            listRecord.addView(view);
//        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_my_money);
        findViewById(R.id.root).setPadding(0, Utils.getStatusBarHeight(this),0,0);
        ((TextView) findViewById(R.id.title)).setText(getResources().getString(R.string.my_money));
        findViewById(R.id.back_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        editText = findViewById(R.id.get_money_number);
        listRecord = findViewById(R.id.list_record);

        StepUserManager.getInstance().setLoginListener(listener);
        updateData();

        findViewById(R.id.get_money).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                User signUserInfo = StepUserManager.getInstance().getUserInfo();
                if(signUserInfo.getBalance()<10000){
                    Toast.makeText(getApplicationContext(),"未到提现额度", Toast.LENGTH_SHORT).show();
                    return;
                }
                String number = editText.getText().toString();
                try {
                    int moneyBum = Integer.valueOf(number);
                    if(moneyBum == 0){
                        Toast.makeText(getApplicationContext(),"提现失败", Toast.LENGTH_SHORT).show();
                        return;
                    }
                    if(moneyBum > signUserInfo.getBalance()){
                        Toast.makeText(getApplicationContext(),"余额不足", Toast.LENGTH_SHORT).show();
                        //return;
                    }

                    showGetMoneyDialog(number);
                }catch (Exception e){
                    e.printStackTrace();
                    Toast.makeText(getApplicationContext(),"提现失败", Toast.LENGTH_SHORT).show();
                }
            }
        });

        findViewById(R.id.get_all_money).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                User signUserInfo = StepUserManager.getInstance().getUserInfo();
                if(signUserInfo.getBalance()<10000){
                    Toast.makeText(getApplicationContext(),"少于1元，无法体现", Toast.LENGTH_SHORT).show();
                    return;
                }

                showGetMoneyDialog(signUserInfo.getBalance()+"");
            }
        });
    }

    public void showGetMoneyDialog(String money){
//        GetMoneyDialog getMoneyDialog = new GetMoneyDialog(this);
//        getMoneyDialog.setGetMoney(money);
//        getMoneyDialog.showDialogAtCenter();
//        getMoneyDialog.setGetMoneyCallback(new GetMoneyDialog.GetMoneyCallback() {
//            @Override
//            public void onGetMoney() {
//                if(progressDialog == null) {
//                    progressDialog = new ProgressDialog(MyMoneyActivity.this);
//                }
//                progressDialog.show();
//            }
//        });
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        StepUserManager.getInstance().removeLoginListener(listener);
    }
}
