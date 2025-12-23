package com.dn.sports;

import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;

import com.dn.sports.adcoinLogin.Ad;
import com.dn.sports.adcoinLogin.GetImageSync;
import com.dn.sports.adcoinLogin.LoginListener;
import com.dn.sports.adcoinLogin.StepUserManager;
import com.dn.sports.adcoinLogin.model.User;
import com.dn.sports.common.BaseActivity;
import com.dn.sports.common.UmengLog;
import com.dn.sports.dialog.EditTextDialog;
import com.dn.sports.dialog.ProgressDialog;
import com.dn.sports.dialog.WheelPickDialog;
import com.dn.sports.utils.Utils;

public class UserInfoActivity extends BaseActivity {

    private ImageView userImage;
    private TextView nick_name_content;
    private TextView account_content;
    private TextView invite_code_content;
    private TextView sex_content;
    private TextView location_content;
    private TextView mobile_content;
    private WheelPickDialog sexDialog;
    private WheelPickDialog locDialog;
    private EditTextDialog mobileDialog;
    private EditTextDialog nickNameDialog;
    private ProgressDialog progressDialog;

    private LoginListener loginListener = new LoginListener(){

        @Override
        public void onUserInfoUpdate(int msg, User info) {
            super.onUserInfoUpdate(msg,info);
            if(msg == Ad.Login.MSG_MODIFY_USER_INFO
                && progressDialog != null && progressDialog.isShowing()){
                progressDialog.dismiss();
                Toast.makeText(getApplicationContext(),getResources().getString(R.string.modify_success),Toast.LENGTH_SHORT).show();
                finish();
            }
        }

        @Override
        public void onError(int msg, String info) {
            super.onError(msg, info);
            if(msg == Ad.Login.MSG_MODIFY_USER_INFO
                    && progressDialog != null && progressDialog.isShowing()){
                progressDialog.dismiss();
                Toast.makeText(getApplicationContext(),getResources().getString(R.string.modify_error),Toast.LENGTH_SHORT).show();
            }
        }
    };

    @Override
    protected void onDestroy() {
        super.onDestroy();
        StepUserManager.getInstance().removeLoginListener(loginListener);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_user_info);
        StepUserManager.getInstance().setLoginListener(loginListener);
        findViewById(R.id.root_layout).setPadding(0, Utils.getStatusBarHeight(this),0,0);
        findViewById(R.id.back_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        TextView title = findViewById(R.id.title);
        title.setText(getResources().getString(R.string.my_info));
        TextView rightBtn = findViewById(R.id.right_btn_text);
        rightBtn.setText(getResources().getString(R.string.save));
        rightBtn.setVisibility(View.VISIBLE);
        rightBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(progressDialog == null){
                    progressDialog = ProgressDialog.createDialog(UserInfoActivity.this);
                }
                progressDialog.show();
                int sex = sex_content.getText().toString().equals("男")?0:1;
                User user = StepUserManager.getInstance().getUserInfo();
                StepUserManager.getInstance().modifyUserInfo(UserInfoActivity.this,
                        nick_name_content.getText().toString(),
                        "","",sex,
                        mobile_content.getText().toString(),
                        location_content.getText().toString(),user.getStepTarget());
            }
        });

        UmengLog.logEvent(getApplicationContext(),UmengLog.ID.USER_INFO);
        location_content = findViewById(R.id.location_content);
        sex_content = findViewById(R.id.sex_content);
        mobile_content = findViewById(R.id.mobile_content);
        nick_name_content = findViewById(R.id.nick_name_content);
        account_content = findViewById(R.id.account_content);
        invite_code_content = findViewById(R.id.invite_code_content);
        userImage = findViewById(R.id.user_image);

        User user = StepUserManager.getInstance().getUserInfo();
        if(user == null) {
            finish();
            return;
        }
        location_content.setText(user.getAddress());
        sex_content.setText(user.getSex() == 0?"男":"女");
        mobile_content.setText(user.getMobile());
        nick_name_content.setText(user.getNickname());
        account_content.setText("id:"+user.getUserId());
        invite_code_content.setText(user.getInviteCode());

        new GetImageSync(userImage,this).execute(user.getHeadImg());

        findViewById(R.id.layout_nick_name).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(nickNameDialog == null){
                    nickNameDialog = new EditTextDialog(UserInfoActivity.this);
                    nickNameDialog.setEditTextContent(nick_name_content.getText().toString());
                    nickNameDialog.setOkClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            nickNameDialog.dismissDialog();
                            nick_name_content.setText(nickNameDialog.getEditTextContent());
                        }
                    });
                }
                nickNameDialog.showDialogAtCenter();
            }
        });
        findViewById(R.id.layout_location).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(locDialog == null){
                    locDialog = new WheelPickDialog(UserInfoActivity.this);
                    locDialog.initWheelType(WheelPickDialog.TYPE_LOC);
                    locDialog.setOkClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            locDialog.dismissDialog();
                            location_content.setText(locDialog.getCurrentString());
                        }
                    });
                }
                locDialog.showDialogAtCenter();
            }
        });
        findViewById(R.id.layout_sex).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(sexDialog == null){
                    sexDialog = new WheelPickDialog(UserInfoActivity.this);
                    sexDialog.initWheelType(WheelPickDialog.TYPE_SEX);
                    sexDialog.setOkClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            sexDialog.dismissDialog();
                            sex_content.setText(sexDialog.getCurrentString());
                        }
                    });
                }
                sexDialog.showDialogAtCenter();
            }
        });
        findViewById(R.id.layout_mobile).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(mobileDialog == null){
                    mobileDialog = new EditTextDialog(UserInfoActivity.this);
                    mobileDialog.setEditTextContent(mobile_content.getText().toString());
                    mobileDialog.setTitle("设置手机号");
                    mobileDialog.setOkClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            mobileDialog.dismissDialog();
                            mobile_content.setText(mobileDialog.getEditTextContent());
                        }
                    });
                }
                mobileDialog.showDialogAtCenter();
            }
        });

        findViewById(R.id.exit).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                StepUserManager.getInstance().exitLogin(UserInfoActivity.this);
                finish();
                StepUserManager.getInstance().setIsMustNeedLogin(true);
            }
        });
    }
}
