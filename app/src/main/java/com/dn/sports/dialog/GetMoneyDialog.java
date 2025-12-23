package com.dn.sports.dialog;

import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.Toast;

import com.dn.sports.R;
import com.dn.sports.adcoinLogin.StepUserManager;

public class GetMoneyDialog extends BasePopup {

    GetMoneyDialog(Context context) {
        super(context);
    }

    GetMoneyDialog(Context context, int w, int h) {
        super(context, w, h);
    }

    //    private String getMoney;
//    private EditText name;
//    private EditText account;
//    private GetMoneyCallback getMoneyCallback;
//
//    public void setGetMoneyCallback(GetMoneyCallback getMoneyCallback) {
//        this.getMoneyCallback = getMoneyCallback;
//    }
//
//    public interface GetMoneyCallback{
//        void onGetMoney();
//    }
//
//    public void setGetMoney(String getMoney) {
//        this.getMoney = getMoney;
//    }
//
//    public GetMoneyDialog(Context context){
//        super(context, ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
//    }
//
    @Override
    protected void onDismissDialog() {

    }
//
    @Override
    protected View createDialogView(final Context context, LayoutInflater inflater) {
//        View view = inflater.inflate(R.layout.dialog_get_money,null);
//        name = view.findViewById(R.id.name);
//        account = view.findViewById(R.id.accunt);
//        view.findViewById(R.id.get_carsh).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                String myName = name.getText().toString();
//                String myAccount = account.getText().toString();
//                if(TextUtils.isEmpty(myName)|| TextUtils.isEmpty(myAccount)){
//                    Toast.makeText(context,"账户或姓名错误", Toast.LENGTH_SHORT).show();
//                    dismissDialog();
//                    return;
//                }
//                StepUserManager.getInstance().getCash(context,Integer.valueOf(getMoney),myAccount,myName);
//                dismissDialog();
//
//                if(getMoneyCallback != null){
//                    getMoneyCallback.onGetMoney();
//                }
//            }
//        });
//        view.findViewById(R.id.cancel).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                dismissDialog();
//            }
//        });
//        return view;
        return null;
    }
}
