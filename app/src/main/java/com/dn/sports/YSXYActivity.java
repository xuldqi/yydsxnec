package com.dn.sports;

import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.widget.TextView;

import com.dn.sports.common.BaseActivity;
import com.dn.sports.utils.Utils;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

public class YSXYActivity extends BaseActivity {

    WebView webview;
    ViewGroup user;
    TextView content;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_yinsi_xieyi);
        findViewById(R.id.root_layout).setPadding(0, Utils.getStatusBarHeight(this), 0, 0);
        webview = findViewById(R.id.webView);
        user = findViewById(R.id.user);

        findViewById(R.id.back_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        if (getIntent() != null) {
            int type = getIntent().getIntExtra("type", 0);
            if (type == 1) {
                user.setVisibility(View.VISIBLE);
                content = findViewById(R.id.content);
                content.setText(readContent("user_eye_xy_1.txt"));
                ((TextView)findViewById(R.id.title) ).setText("用户协议");
            } else if (type == 2) {
                webview.loadUrl("https://www.dailynet.cn/smessage/wkydxec.html");
                webview.setVisibility(View.VISIBLE);
                ((TextView)findViewById(R.id.title) ).setText("隐私协议");
            }
        }
    }

    private String readContent(String fileName) {
        try {
            InputStream is = getAssets().open(fileName);
            int size = is.available();
            byte[] buffer = new byte[size];
            is.read(buffer);
            is.close();
            String text = new String(buffer, StandardCharsets.UTF_8);
            return text;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return "";
    }
}
