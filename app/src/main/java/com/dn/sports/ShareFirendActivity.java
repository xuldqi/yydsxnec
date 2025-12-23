package com.dn.sports;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Rect;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;

import com.dn.sports.adcoinLogin.StepUserManager;
import com.dn.sports.adcoinLogin.model.User;
import com.dn.sports.common.BaseActivity;
import com.dn.sports.common.Constant;
import com.dn.sports.common.UmengLog;
import com.dn.sports.utils.Utils;
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX;
import com.tencent.mm.opensdk.modelmsg.WXImageObject;
import com.tencent.mm.opensdk.modelmsg.WXMediaMessage;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

public class ShareFirendActivity extends BaseActivity {

    private TextView myInviteCode;
    private boolean shareApp = false;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_share_firend);
        findViewById(R.id.root).setPadding(0, Utils.getStatusBarHeight(this),0,0);
        ((TextView) findViewById(R.id.title)).setText(getResources().getString(R.string.invite_friend));
        ((TextView) findViewById(R.id.title)).setTextColor(Color.BLACK);
        findViewById(R.id.back_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        User user = StepUserManager.getInstance().getUserInfo();
        if(user == null) {
            finish();
            return;
        }
        if(getIntent() != null){
            shareApp = getIntent().getBooleanExtra("share_app",false);
        }

//        myInviteCode = findViewById(R.id.invite_code);
//        ((TextView)findViewById(R.id.my_invite_code)).setText(getResources().getString(R.string.my_invite_code)+":");
//        myInviteCode.setText(user.getInviteCode());
//        findViewById(R.id.copy).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                User user = StepUserManager.getInstance().getUserInfo();
//                if(user == null)
//                    return;
//                try {
//                    //获取剪贴板管理器
//                    ClipboardManager cm = (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);
//                    // 创建普通字符型ClipData
//                    ClipData mClipData = ClipData.newPlainText("Label", user.getInviteCode());
//                    // 将ClipData内容放到系统剪贴板里。
//                    cm.setPrimaryClip(mClipData);
//                    Toast.makeText(ShareFirendActivity.this,getResources().getString(R.string.already_copy),Toast.LENGTH_SHORT).show();
//                } catch (Exception e) {
//                    e.printStackTrace();
//                }
//
//                if(shareApp) {
//                    StepUserManager.getInstance().uploadShareAction(ShareFirendActivity.this);
//                }
//            }
//        });
//
//        findViewById(R.id.invite_my_friend).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                UmengLog.logEvent(getApplicationContext(),UmengLog.ID.INVITE_FRIEND);
//                //由文件得到uri
//                Bitmap bp = BitmapFactory.decodeResource(getResources(),R.mipmap.invite_friend_page);
//                bp = addTextWatermark(ShareFirendActivity.this,bp,user.getInviteCode(),60,Color.RED,
//                        bp.getHeight()/2-20 ,true);
//                Uri imageUri = Uri.parse(MediaStore.Images.Media.insertImage(getContentResolver(), bp, null, null));
//                Intent shareIntent = new Intent();
//                shareIntent.setAction(Intent.ACTION_SEND);
//                shareIntent.putExtra(Intent.EXTRA_STREAM, imageUri);
//                shareIntent.setType("image/*");
//                startActivity(Intent.createChooser(shareIntent, "分享到"));
//
//                if(shareApp) {
//                    StepUserManager.getInstance().uploadShareAction(ShareFirendActivity.this);
//                }
//            }
//        });
//
//        findViewById(R.id.share_to_wx).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                UmengLog.logEvent(getApplicationContext(),UmengLog.ID.INVITE_FRIEND);
//                User user = StepUserManager.getInstance().getUserInfo();
//                if(user == null)
//                    return;
//                IWXAPI mWxApi = WXAPIFactory.createWXAPI(ShareFirendActivity.this, Constant.WX_LOGIN.getWxAppId(ShareFirendActivity.this), true);
//                mWxApi.registerApp(Constant.WX_LOGIN.getWxAppId(ShareFirendActivity.this));
//
//                Bitmap bp = BitmapFactory.decodeResource(getResources(),R.mipmap.invite_friend_page);
//                bp = addTextWatermark(ShareFirendActivity.this,bp,user.getInviteCode(),60,Color.RED,
//                        bp.getHeight()/2-20 ,true);
//                WXImageObject imageObject = new WXImageObject(bp);
//                WXMediaMessage msg = new WXMediaMessage();
//                msg.mediaObject = imageObject;
//                bp.recycle();
//                //构造一个Req
//                SendMessageToWX.Req req = new SendMessageToWX.Req();
//                req.transaction = Long.toString(System.currentTimeMillis());
//                req.message = msg;
//                //表示发送给朋友圈  WXSceneTimeline  表示发送给朋友  WXSceneSession
//                req.scene = SendMessageToWX.Req.WXSceneSession;
//                //调用api接口发送数据到微信
//                mWxApi.sendReq(req);
//
//                if(shareApp) {
//                    StepUserManager.getInstance().uploadShareAction(ShareFirendActivity.this);
//                }
//            }
//        });
//        findViewById(R.id.share_to_qq).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                UmengLog.logEvent(getApplicationContext(),UmengLog.ID.INVITE_FRIEND);
//                //由文件得到uri
//                Bitmap bp = BitmapFactory.decodeResource(getResources(),R.mipmap.invite_friend_page);
//                bp = addTextWatermark(ShareFirendActivity.this,bp,user.getInviteCode(),60,Color.RED,
//                        bp.getHeight()/2-20 ,true);
//                Uri imageUri = Uri.parse(MediaStore.Images.Media.insertImage(getContentResolver(), bp, null, null));
//                Intent shareIntent = new Intent();
//                shareIntent.setAction(Intent.ACTION_SEND);
//                shareIntent.putExtra(Intent.EXTRA_STREAM, imageUri);
//                shareIntent.setType("image/*");
//                startActivity(Intent.createChooser(shareIntent, "分享到"));
//
//                if(shareApp) {
//                    StepUserManager.getInstance().uploadShareAction(ShareFirendActivity.this);
//                }
//            }
//        });
//        findViewById(R.id.share_to_friend).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                UmengLog.logEvent(getApplicationContext(),UmengLog.ID.INVITE_FRIEND);
//                User user = StepUserManager.getInstance().getUserInfo();
//                if(user == null)
//                    return;
//                IWXAPI mWxApi = WXAPIFactory.createWXAPI(ShareFirendActivity.this, Constant.WX_LOGIN.getWxAppId(ShareFirendActivity.this), true);
//                mWxApi.registerApp(Constant.WX_LOGIN.getWxAppId(ShareFirendActivity.this));
//
//                Bitmap bp = BitmapFactory.decodeResource(getResources(),R.mipmap.invite_friend_page);
//                bp = addTextWatermark(ShareFirendActivity.this,bp,user.getInviteCode(),60,Color.RED,
//                        bp.getHeight()/2-20 ,true);
//                WXImageObject imageObject = new WXImageObject(bp);
//                WXMediaMessage msg = new WXMediaMessage();
//                msg.mediaObject = imageObject;
//                bp.recycle();
//                //构造一个Req
//                SendMessageToWX.Req req = new SendMessageToWX.Req();
//                req.transaction = Long.toString(System.currentTimeMillis());
//                req.message = msg;
//                //表示发送给朋友圈  WXSceneTimeline  表示发送给朋友  WXSceneSession
//                req.scene = SendMessageToWX.Req.WXSceneTimeline;
//                //调用api接口发送数据到微信
//                mWxApi.sendReq(req);
//
//                if(shareApp) {
//                    StepUserManager.getInstance().uploadShareAction(ShareFirendActivity.this);
//                }
//            }
//        });
    }

    public static Bitmap addTextWatermark(Context context,Bitmap bitmap, String content, int textSize, int color,float y, boolean recycle) {
        if (isEmptyBitmap(bitmap) || content == null)
            return null;
        Bitmap ret = bitmap.copy(bitmap.getConfig(), true);
        Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        paint.setTextAlign(Paint.Align.CENTER);
        paint.setColor(color);
        paint.setTextSize(textSize);
        Rect bounds = new Rect();
        paint.getTextBounds(content, 0, content.length(), bounds);

        if (recycle && !bitmap.isRecycled())
            bitmap.recycle();

        int r = 200;
        Bitmap icon = BitmapFactory.decodeResource(context.getResources(),R.mipmap.ic_app);
        icon = zoomBitmap(icon,r,r);
        int w = ret.getWidth();
        int h = ret.getHeight();

        Rect mSrcRect = new Rect(0, 0, r, r);
        Rect mDesRect = new Rect(w/2-r/2, h-r-40, w/2+r/2, h-40);
        Canvas mCanvas = new Canvas(ret);
        mCanvas.drawBitmap(icon,mSrcRect,mDesRect,null);
        mCanvas.drawText(content,w/2,h/2,paint);
        return ret;
    }

    /**
     * 放大缩小图片
     *
     * @param bitmap
     * @param w
     * @param h
     * @return
     */
    public static Bitmap zoomBitmap(Bitmap bitmap, int w, int h) {
        if (w == 0 || h == 0)
        {
            return bitmap;
        }
        int width = bitmap.getWidth();
        int height = bitmap.getHeight();
        Matrix matrix = new Matrix();
        float scaleWidht = ((float) w / width);
        float scaleHeight = ((float) h / height);
        matrix.postScale(scaleWidht, scaleHeight);
        bitmap = Bitmap.createBitmap(bitmap, 0, 0, width, height,
                matrix, true);
        return bitmap;
    }

    /**
     * Bitmap对象是否为空。
     */
    public static boolean isEmptyBitmap(Bitmap src) {
        return src == null || src.getWidth() == 0 || src.getHeight() == 0;
    }


    public void saveMyBitmap(String bitName,Bitmap mBitmap){
        File f = new File("/sdcard/" + bitName + ".png");
        if(f.exists()){
            f.delete();
        }
        try {
            f.createNewFile();
        } catch (IOException e) {
            e.printStackTrace();
        }
        FileOutputStream fOut = null;
        try {
            fOut = new FileOutputStream(f);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        mBitmap.compress(Bitmap.CompressFormat.PNG, 100, fOut);
        try {
            fOut.flush();
        } catch (IOException e) {
            e.printStackTrace();
        }
        try {
            fOut.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
