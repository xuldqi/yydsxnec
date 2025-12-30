package com.dn.sports;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;

import androidx.fragment.app.FragmentActivity;

import com.dn.sports.adcoinLogin.AdConfigure;
import com.dn.sports.adcoinLogin.StepUserManager;
import com.dn.sports.adcoinLogin.chuanshanjia.LogoAd;
import com.dn.sports.adcoinLogin.common.AdListener;
import com.dn.sports.common.CheckPermission;
import com.dn.sports.common.EyeLog;
import com.dn.sports.dialog.BasePopup;
import com.dn.sports.dialog.UserFirstDialog;
import com.dn.sports.dialog.UserFirstHintDialog;
import com.dn.sports.dialog.UserPrivateDialog;
import com.dn.sports.utils.SharedPreferenceUtil;
import com.dn.sports.utils.Utils;

import java.lang.ref.WeakReference;

public class StartLogoActivity extends FragmentActivity {

    private boolean isClicked = false;
    private boolean hasShownAd = false; // 防止广告重复展示
    private RelativeLayout adLayout;
    private LinearLayout skipContainer;
    private TextView skip;
    private UserFirstHintDialog userFirstHintDialog;
    private final StartLogoActivity.MainHandler adHandler = new StartLogoActivity.MainHandler(this);

    private static class MainHandler extends Handler {
        private final WeakReference<StartLogoActivity> mActivty;

        private MainHandler(StartLogoActivity activity) {
            mActivty = new WeakReference<>(activity);
        }

        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            final StartLogoActivity activity = mActivty.get();
            super.handleMessage(msg);
            if (activity != null) {
                if (msg.what == 1) {
                    int m = Integer.parseInt(activity.skip.getText().toString());
                    if (m > 0) {
                        activity.skip.setText(String.valueOf(m - 1));
                    } else {
                        activity.hidePost();
                    }
                    activity.adHandler.sendEmptyMessageDelayed(1, 1000);
                } else if (msg.what == AdConfigure.SHOW_AD) {
                    activity.showLogoAd();
                } else if (msg.what == AdConfigure.ERROR_AD || msg.what == AdConfigure.HIDE_AD) {
                    activity.skip.setVisibility(View.INVISIBLE);
                    activity.hideDelay();
                }
            }
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Window window = getWindow();
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
            window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
            window.setStatusBarColor(Color.TRANSPARENT);
            window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_LAYOUT_STABLE);
            window.setNavigationBarColor(getResources().getColor(R.color.white));
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN |
                    View.SYSTEM_UI_FLAG_LAYOUT_STABLE | View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);
        }

        super.onCreate(savedInstanceState);
        StepApplication.getInstance().addActivity(this);

        setContentView(R.layout.activity_start_logo);

        adLayout = (RelativeLayout) findViewById(R.id.logo_ad);
        skipContainer = (LinearLayout) findViewById(R.id.skip_layout);
        skip = (TextView) findViewById(R.id.skip);
        int h = Utils.getHeight(this);
        FrameLayout.LayoutParams params = (FrameLayout.LayoutParams) adLayout.getLayoutParams();
        params.height = (h * 8) / 9;
        adLayout.setLayoutParams(params);

        if (Utils.isFirstOpenAppForUserHint(this)) {
            adHandler.postDelayed(new Runnable() {
                @Override
                public void run() {
//                    userFirstHintDialog = new UserFirstHintDialog(StartLogoActivity.this);
//                    userFirstHintDialog.showDialogAtCenter();
//                    userFirstHintDialog.setShowCallback(new BasePopup.ShowCallback() {
//                        @Override
//                        public void onShow() {
//
//                        }
//
//                        @Override
//                        public void onDismiss() {
//                            initAdPermission();
//                        }
//                    });
                }
            }, 1000);
        } else {
            if (Utils.isNetworkAvailable(this) && StepApplication.getInstance().isShowAd()) {
                AdConfigure.getAdConfigure(this, adHandler);
            } else {
                hideDelay();
            }
        }
    }

    private void initAdPermission() {
        if (!CheckPermission.checkMustPermission(this)) {
            CheckPermission.requestMustPermission(this, 10001);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == 10001) {
            for (int result : grantResults) {
                if (result != PackageManager.PERMISSION_GRANTED) {
                    Toast.makeText(this, getResources().getString(R.string.deny_permission), Toast.LENGTH_SHORT).show();
                    return;
                }
            }
        }

        hidePost();
    }

    @Override
    public void onBackPressed() {
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        StepApplication.getInstance().removeActivity(this);

    }

    @Override
    protected void onResume() {
        super.onResume();
        if (isClicked) {
            hidePost();
        }
        hidePost();


    }

    private void hideDelay() {
        adHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                hide();
            }
        }, 1600);
    }

    private void hidePost() {
        adHandler.post(new Runnable() {
            @Override
            public void run() {
                hide();
            }
        });
    }

    private void hide() {
        boolean open = (boolean) SharedPreferenceUtil.Companion.getInstance(this).get("userAgree", false);
        if (open) {
            Intent it = new Intent(StartLogoActivity.this, MainActivity.class);
            startActivity(it);
            overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
//            finish();
        } else {
            UserFirstDialog dialog = new UserFirstDialog();

            dialog.show(this.getSupportFragmentManager(),"" );
        }

    }

    private void showLogoAd() {
        // 防止广告重复展示
        if (hasShownAd) {
            hideDelay();
            return;
        }
        hasShownAd = true;
        showByteJumpLogoAd();
    }

    private LogoAd byteLogoAd;

    private void showByteJumpLogoAd() {
        byteLogoAd = new LogoAd();
        byteLogoAd.initAd(this, new AdListener() {
            @Override
            public void adError(String error) {
                super.adError(error);
                EyeLog.loge("LogoActivityAd-->adError: " + error);
                hideDelay();
            }

            @Override
            public void adLoad() {
                super.adLoad();
                if (byteLogoAd != null && byteLogoAd.isAdLoaded()) {
                    // 使用全屏视频广告（插屏）展示方式
                    byteLogoAd.showAd(StartLogoActivity.this, 0);
                    
                    // 设置广告展示后延迟跳转
                    adHandler.postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            hidePost();
                        }
                    }, 3000);
                }
            }
        });
    }
}

