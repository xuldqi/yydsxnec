package com.dn.sports.utils;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.AppOpsManager;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.TaskStackBuilder;
import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.BitmapShader;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.PixelFormat;
import android.graphics.Rect;
import android.graphics.Shader;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.Binder;
import android.os.Build;
import android.os.Environment;
import android.provider.DocumentsContract;
import android.provider.MediaStore;
import android.provider.Settings;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.style.ForegroundColorSpan;
import android.text.style.UnderlineSpan;
import android.util.DisplayMetrics;
import android.util.Log;
import android.util.TypedValue;
import android.view.Display;
import android.view.View;
import android.view.WindowManager;
import android.widget.TextView;

import com.dn.sports.MainActivity;
import com.dn.sports.R;

import java.io.InputStream;
import java.lang.reflect.Method;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.NumberFormat;

public class Utils {
    public static final String AD_CHECK_URL = "https://www.moningcall.cn/appsystem/main/checkConfigV2/";

    public interface OFF_ON{
        String OFF = "off";
        String ON = "on";
    }

    public static boolean isEmpty(String src) {
        return src == null || src.trim().length() == 0;
    }

    public static int dp2px(Context context, int dip) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dip * scale + 0.5f);
    }

    public static int sp2px(Context context, float spValue) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, spValue, context.getResources().getDisplayMetrics());
    }

    public static int px2dip(Context context, float pxValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (pxValue / scale + 0.5f);
    }

    public static String getVerName(Context context) {
        String verName = "";
        try {
            verName = context.getPackageManager().
                    getPackageInfo(context.getPackageName(), 0).versionName;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return verName;
    }

    public static void collapseStatusBar(Context context) {
        try {
            Object statusBarManager = context.getSystemService("statusbar");
            Method collapse;
            if (Build.VERSION.SDK_INT <= 16) {
                collapse = statusBarManager.getClass().getMethod("collapse");
            } else {
                collapse = statusBarManager.getClass().getMethod("collapsePanels");
            }
            collapse.invoke(statusBarManager);
        } catch (Exception localException) {
            localException.printStackTrace();
        }
    }

    public static int getVersionCode(Context context) {
        // 包管理器 可以获取清单文件信息
        PackageManager packageManager = context.getPackageManager();
        try {
            // 获取包信息
            // 参1 包名 参2 获取额外信息的flag 不需要的话 写0
            PackageInfo packageInfo = packageManager.getPackageInfo(
                    context.getPackageName(), 0);
            return packageInfo.versionCode;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return 0;
    }

     public static boolean canDrawOverlays(Context context) {
        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.M && Settings.canDrawOverlays(context)) return true;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {//USING APP OPS MANAGER
            AppOpsManager manager = (AppOpsManager) context.getSystemService(Context.APP_OPS_SERVICE);
            if (manager != null) {
                try {
                    int result = manager.checkOp(AppOpsManager.OPSTR_SYSTEM_ALERT_WINDOW, Binder.getCallingUid(), context.getPackageName());
                    return result == AppOpsManager.MODE_ALLOWED;
                } catch (Exception ignore) {
                }
            }
        }

        try {//IF This Fails, we definitely can't do it
            WindowManager mgr = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
            if (mgr == null) return false; //getSystemService might return null
            View viewToAdd = new View(context);
            WindowManager.LayoutParams params = new WindowManager.LayoutParams(0, 0, Build.VERSION.SDK_INT >= Build.VERSION_CODES.O ?
                    WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY : WindowManager.LayoutParams.TYPE_SYSTEM_ALERT,
                    WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE | WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE, PixelFormat.TRANSPARENT);
            viewToAdd.setLayoutParams(params);
            mgr.addView(viewToAdd, params);
            mgr.removeView(viewToAdd);
            return true;
        } catch (Exception ignore) {
        }
        return false;

    }



    private static final String FILE_NAME = "Eye_data";
    private static final String SHOW_AD_TAG = "ad_tag";

    public static boolean isShowAd(Context context) {
        boolean showAd = (boolean)get(context,SHOW_AD_TAG,true);
        if(!showAd){
            put(context,SHOW_AD_TAG,true);
        }
        return showAd;
    }

    public static boolean isShowAdToday(Context context){
        String todayTag = DateUtils.getYMD(0);
        Log.i("Utils","isShowAdToday:"+todayTag);
        return (boolean)get(context,todayTag,true);
    }

    public static void setTodayNoAd(Context context){
        String todayTag = DateUtils.getYMD(0);
        Log.i("Utils","setTodayNoAd:");
        put(context,todayTag,false);
    }

    private static final String IS_FIRST_OPEN = "is_first_open";
    private static final String IS_FIRST_OPEN_FOR_USER_HINT = "is_first_open_for_user_hint";

    public static boolean isFirstOpen(Context context) {
        boolean firstOpen = (boolean)get(context,IS_FIRST_OPEN,true);
        if(firstOpen){
            put(context,IS_FIRST_OPEN,false);
        }
        return firstOpen;
    }

    public static boolean isShowPer(Context context) {
        boolean firstOpen = (boolean)get(context,"show_per",true);
        if(firstOpen){
            put(context,"show_per",false);
        }
        return firstOpen;
    }

    public static boolean isFirstOpenAppForUserHint(Context context) {
        boolean firstOpen = (boolean)get(context,IS_FIRST_OPEN_FOR_USER_HINT,true);
        if(firstOpen){
            put(context,IS_FIRST_OPEN_FOR_USER_HINT,false);
        }
        return firstOpen;
    }

    private static final String IS_FIRST_OPEN_WX_HINT = "IS_FIRST_OPEN_WX_HINT";

    public static boolean isOpenWXHint(Context context) {
        boolean firstOpen = (boolean)get(context,IS_FIRST_OPEN_WX_HINT,true);
        if(firstOpen){
            put(context,IS_FIRST_OPEN_WX_HINT,false);
        }
        return firstOpen;
    }

    public static boolean isNetworkAvailable(Context context) {
        ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        if (cm == null) {
        } else {
            //如果仅仅是用来判断网络连接 　　　　　　
            //则可以使用 cm.getActiveNetworkInfo().isAvailable();
            NetworkInfo[] info = cm.getAllNetworkInfo();
            if (info != null) {
                for (int i = 0; i < info.length; i++) {
                    if (info[i].getState() == NetworkInfo.State.CONNECTED) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    public static short getWidth(Context context) {
        try {
            WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
            return (short) wm.getDefaultDisplay().getWidth();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 480;
    }

    public static short getHeight(Context context) {
        try {
            WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
            return (short) wm.getDefaultDisplay().getHeight();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 800;
    }

    public static float getScale(Context context) {
        return getWidth(context) / 720.0f;
    }

    public static int getStatusBarHeight(Context context) {
        int result = 0;
        int resourceId = context.getResources().getIdentifier("status_bar_height", "dimen", "android");
        if (resourceId > 0) {
            result = context.getResources().getDimensionPixelSize(resourceId);
        }
        return result;
    }

    public static void setSetting(Activity activity){
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            //如果当前平台版本大于23平台
            if (!Settings.System.canWrite(activity)) {
                //如果没有修改系统的权限这请求修改系统的权限
                Intent intent = new Intent(Settings.ACTION_MANAGE_WRITE_SETTINGS);
                intent.setData(Uri.parse("package:" + activity.getPackageName()));
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                activity.startActivityForResult(intent, 0);
            }
        }
    }

    public static int getSystemBrightness(Context context) {
        int systemBrightness = 0;
        try {
            systemBrightness = Settings.System.getInt(context.getContentResolver(), Settings.System.SCREEN_BRIGHTNESS);
        } catch (Settings.SettingNotFoundException e) {
            e.printStackTrace();
        }
        return systemBrightness;
    }

    public static int getScreenMode(Activity activity){
        int screenMode=0;
        try{
            screenMode = Settings.System.getInt(activity.getContentResolver(), Settings.System.SCREEN_BRIGHTNESS_MODE);
        } catch (Exception localException){
            localException.printStackTrace();
        }
        return screenMode;
    }

    public static void setScreenBrightness(int process, Activity activity) {
        ContentResolver contentResolver = activity.getContentResolver();
        Settings.System.putInt(contentResolver, Settings.System.SCREEN_BRIGHTNESS_MODE,
                Settings.System.SCREEN_BRIGHTNESS_MODE_MANUAL);
        Settings.System.putInt(contentResolver,
                Settings.System.SCREEN_BRIGHTNESS, process);
    }

    public static void saveBrightness(ContentResolver resolver, int brightness) {
        Settings.System.putInt(resolver, Settings.System.SCREEN_BRIGHTNESS_MODE,
                Settings.System.SCREEN_BRIGHTNESS_MODE_MANUAL);
        //保存到系统中
        Uri uri = Settings.System.getUriFor(Settings.System.SCREEN_BRIGHTNESS);
        Settings.System.putInt(resolver, Settings.System.SCREEN_BRIGHTNESS, brightness);
        resolver.notifyChange(uri, null);
    }

    /**
     * 设置当前屏幕亮度的模式
     * SCREEN_BRIGHTNESS_MODE_AUTOMATIC=1 为自动调节屏幕亮度
     * SCREEN_BRIGHTNESS_MODE_MANUAL=0  为手动调节屏幕亮度
     */
    private void setScreenMode(int paramInt, Activity activity){
        try{
            Settings.System.putInt(activity.getContentResolver(), Settings.System.SCREEN_BRIGHTNESS_MODE, paramInt);
        }catch (Exception localException){
            localException.printStackTrace();
        }
    }

    /**
     * 获取导航栏高度
     * @param context
     * @return
     */
    public static int getDaoHangHeight(Context context) {
        int result = 0;
        int resourceId=0;
        int rid = context.getResources().getIdentifier("config_showNavigationBar", "bool", "android");
        if (rid!=0){
            resourceId = context.getResources().getIdentifier("navigation_bar_height", "dimen", "android");
            return context.getResources().getDimensionPixelSize(resourceId);
        }else
            return 0;
    }

    public static boolean navigationBarExist2(Activity activity) {
        WindowManager windowManager = activity.getWindowManager();
        Display d = windowManager.getDefaultDisplay();

        DisplayMetrics realDisplayMetrics = new DisplayMetrics();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
            d.getRealMetrics(realDisplayMetrics);
        }

        int realHeight = realDisplayMetrics.heightPixels;
        int realWidth = realDisplayMetrics.widthPixels;

        DisplayMetrics displayMetrics = new DisplayMetrics();
        d.getMetrics(displayMetrics);

        int displayHeight = displayMetrics.heightPixels;
        int displayWidth = displayMetrics.widthPixels;

        return (realWidth - displayWidth) > 0 || (realHeight - displayHeight) > 0;
    }

    /**
     * 保存数据的方法，我们需要拿到保存数据的具体类型，然后根据类型调用不同的保存方法
     *
     * @param key
     * @param object
     */
    public static void put(Context context, String key, Object object) {
        SharedPreferences sp = context.getSharedPreferences(FILE_NAME,
                Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sp.edit();

        if (object instanceof String) {
            editor.putString(key, (String) object);
        } else if (object instanceof Integer) {
            editor.putInt(key, (Integer) object);
        } else if (object instanceof Boolean) {
            editor.putBoolean(key, (Boolean) object);
        } else if (object instanceof Float) {
            editor.putFloat(key, (Float) object);
        } else if (object instanceof Long) {
            editor.putLong(key, (Long) object);
        } else {
            editor.putString(key, object.toString());
        }
        editor.commit();
    }

    /**
     * 得到保存数据的方法，我们根据默认值得到保存的数据的具体类型，然后调用相对于的方法获取值
     *
     * @param key
     * @param defaultObject
     * @return
     */
    public static Object get(Context context, String key, Object defaultObject) {
        SharedPreferences sp = context.getSharedPreferences(FILE_NAME,
                Context.MODE_PRIVATE);

        if (defaultObject instanceof String) {
            return sp.getString(key, (String) defaultObject);
        } else if (defaultObject instanceof Integer) {
            return sp.getInt(key, (Integer) defaultObject);
        } else if (defaultObject instanceof Boolean) {
            return sp.getBoolean(key, (Boolean) defaultObject);
        } else if (defaultObject instanceof Float) {
            return sp.getFloat(key, (Float) defaultObject);
        } else if (defaultObject instanceof Long) {
            return sp.getLong(key, (Long) defaultObject);
        }

        return null;
    }

    public static void setTextViewKeyWordLight(TextView textView, String keyWord, int color){
        if(keyWord == null||keyWord.trim().isEmpty()){
            return;
        }
        try {
            String content = textView.getText().toString();
            SpannableStringBuilder style = new SpannableStringBuilder(content);
            int pos = content.indexOf(keyWord);
            if(pos>=0){
                style.setSpan(new ForegroundColorSpan(color), pos, pos+keyWord.length(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
                style.setSpan(new UnderlineSpan(), pos, pos+keyWord.length(), 0);
            }else{
                return;
            }
            while (pos>=0){
                pos = content.indexOf(keyWord,pos+keyWord.length());
                if(pos>0) {
                    style.setSpan(new ForegroundColorSpan(color), pos, pos + keyWord.length(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
                    style.setSpan(new UnderlineSpan(), pos, pos+keyWord.length(), 0);
                }
            }
            textView.setText(style);
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    public static final String IS_OPEN_NOTIFY = "IS_OPEN_NOTIFY";
    public static boolean isNotifyOpenON(Context context){
        String offOnState = (String) Utils.get(context, IS_OPEN_NOTIFY, OFF_ON.ON);
        if(offOnState == null){
            Utils.put(context, IS_OPEN_NOTIFY, OFF_ON.ON);
            return true;
        }else {
            return offOnState.equals(OFF_ON.ON);
        }
    }

    public static final String IS_OPEN_EYE_PROTECT = "IS_OPEN_EYE_PROTECT";
    public static boolean isEyeOpenON(Context context){
        String offOnState = (String) Utils.get(context, IS_OPEN_EYE_PROTECT, OFF_ON.ON);
        if(offOnState == null){
            Utils.put(context, IS_OPEN_EYE_PROTECT, OFF_ON.ON);
            return true;
        }else {
            return offOnState.equals(OFF_ON.ON);
        }
    }

    public static String getMarket(Context context){
        try {
            ApplicationInfo appInfo = context.getPackageManager()
                    .getApplicationInfo(context.getPackageName(),
                            PackageManager.GET_META_DATA);
            String msg=appInfo.metaData.getString("UMENG_CHANNEL");
            return msg;
        }catch (PackageManager.NameNotFoundException e){
            e.printStackTrace();
        }
        return "UMeng";
    }

    public static String getTopTitleName(Context context){
        try {
            ApplicationInfo appInfo = context.getPackageManager()
                    .getApplicationInfo(context.getPackageName(),
                            PackageManager.GET_META_DATA);
            String msg=appInfo.metaData.getString("app_name");
            return msg;
        }catch (PackageManager.NameNotFoundException e){
            e.printStackTrace();
        }
        return context.getResources().getString(R.string.app_name);
    }

    //加载图片
    public static Bitmap getURLimage(String url) {
        Bitmap bmp = null;
        try {
            URL myurl = new URL(url);
            // 获得连接
            HttpURLConnection conn = (HttpURLConnection) myurl.openConnection();
            conn.setConnectTimeout(6000);//设置超时
            conn.setDoInput(true);
            conn.setUseCaches(false);//不缓存
            conn.connect();
            InputStream is = conn.getInputStream();//获得图片的数据流
            bmp = BitmapFactory.decodeStream(is);//读取图像数据
            is.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return getCirleBitmap(bmp);
    }

    public static Bitmap getCirleBitmap(Bitmap bmp) {
         //获取bmp的宽高 小的一个做为圆的直径r
         int w = bmp.getWidth();
         int h = bmp.getHeight();
         int r = Math.min(w, h);
         //创建一个paint
         Paint paint = new Paint();
         paint.setAntiAlias(true);
         //新创建一个Bitmap对象newBitmap 宽高都是r
         Bitmap newBitmap = Bitmap.createBitmap(r, r, Bitmap.Config.ARGB_8888);
         //创建一个使用newBitmap的Canvas对象
         Canvas canvas = new Canvas(newBitmap);
         //创建一个BitmapShader对象 使用传递过来的原Bitmap对象bmp
         BitmapShader bitmapShader = new BitmapShader(bmp, Shader.TileMode.CLAMP, Shader.TileMode.CLAMP);
         //paint设置shader
         paint.setShader(bitmapShader);
         //canvas画一个圆 使用设置了shader的paint
         canvas.drawCircle(r / 2, r / 2, r / 2, paint);
         return newBitmap;
    }




    public static String getFilePath_below19(Context context, Uri uri) {
        //这里开始的第二部分，获取图片的路径：低版本的是没问题的，但是sdk>19会获取不到
        String[] proj = {MediaStore.Images.Media.DATA};
        //好像是android多媒体数据库的封装接口，具体的看Android文档
        Cursor cursor = context.getContentResolver().query(uri, proj, null, null, null);
        //获得用户选择的图片的索引值
        if(cursor ==null){
            return "";
        }
        int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
        //将光标移至开头 ，这个很重要，不小心很容易引起越界
        cursor.moveToFirst();
        //最后根据索引值获取图片路径   结果类似：/mnt/sdcard/DCIM/Camera/IMG_20151124_013332.jpg
        String path = cursor.getString(column_index);
        cursor.close();
        return path;
    }

    @TargetApi(Build.VERSION_CODES.KITKAT)
    public static String getPath_above19(final Context context, final Uri uri) {
        // DocumentProvider
        if (DocumentsContract.isDocumentUri(context, uri)) {
            // ExternalStorageProvider
            if (isExternalStorageDocument(uri)) {
                final String docId = DocumentsContract.getDocumentId(uri);
                final String[] split = docId.split(":");
                final String type = split[0];
                if ("primary".equalsIgnoreCase(type)) {
                    return Environment.getExternalStorageDirectory() + "/" + split[1];
                }
            }
            // DownloadsProvider
            else if (isDownloadsDocument(uri)) {
                final String id = DocumentsContract.getDocumentId(uri);
                final Uri contentUri = ContentUris.withAppendedId(
                        Uri.parse("content://downloads/public_downloads"), Long.valueOf(id));
                return getDataColumn(context, contentUri, null, null);
            }
            // MediaProvider
            else if (isMediaDocument(uri)) {
                final String docId = DocumentsContract.getDocumentId(uri);
                final String[] split = docId.split(":");
                final String type = split[0];
                Uri contentUri = null;
                if ("image".equals(type)) {
                    contentUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
                } else if ("video".equals(type)) {
                    contentUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
                } else if ("audio".equals(type)) {
                    contentUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
                }
                final String selection = "_id=?";
                final String[] selectionArgs = new String[]{
                        split[1]
                };
                return getDataColumn(context, contentUri, selection, selectionArgs);
            }
        }
        // MediaStore (and general)
        else if ("content".equalsIgnoreCase(uri.getScheme())) {
            // Return the remote address
            if (isGooglePhotosUri(uri))
                return uri.getLastPathSegment();
            return getDataColumn(context, uri, null, null);
        }
        // File
        else if ("file".equalsIgnoreCase(uri.getScheme())) {
            return uri.getPath();
        }
        return null;
    }

    public static String getDataColumn(Context context, Uri uri, String selection,
                                       String[] selectionArgs) {
        Cursor cursor = null;
        final String column = "_data";
        final String[] projection = {column};
        try {
            cursor = context.getContentResolver().query(uri, projection, selection, selectionArgs,
                    null);
            if (cursor != null && cursor.moveToFirst()) {
                final int index = cursor.getColumnIndexOrThrow(column);
                return cursor.getString(index);
            }
        } finally {
            if (cursor != null)
                cursor.close();
        }
        return null;
    }

    public static boolean isExternalStorageDocument(Uri uri) {
        return "com.android.externalstorage.documents".equals(uri.getAuthority());
    }

    public static boolean isDownloadsDocument(Uri uri) {
        return "com.android.providers.downloads.documents".equals(uri.getAuthority());
    }

    public static boolean isMediaDocument(Uri uri) {
        return "com.android.providers.media.documents".equals(uri.getAuthority());
    }

    public static boolean isGooglePhotosUri(Uri uri) {
        return "com.google.android.apps.photos.content".equals(uri.getAuthority());
    }


    public static String getDistanceByStep(int step){
        NumberFormat nf = NumberFormat.getNumberInstance();
        nf.setMaximumFractionDigits(2);
        float kmiles = ((float)step)*0.6f/1000;
        return nf.format(kmiles);
    }

    public static float getFloatDistanceByStep(int step){
        float kmiles = ((float)step)*0.6f/1000;
        return kmiles;
    }

    public static int getKalByStep(int step){
        NumberFormat nf = NumberFormat.getNumberInstance();
        nf.setMaximumFractionDigits(2);
        float kmiles = ((float)step)*0.6f/1000;
        float times = kmiles*14;

        return (int)((times/60)*240);
    }

    @TargetApi(19)
    public static int reachSportTarget(Context context){
        boolean open = (boolean) SharedPreferenceUtil.Companion.getInstance(context).get("testFeedMessage", true);
        if(!open){
            return 0;
        }
        createNotificationChannel(context,"sport", "目标通知", NotificationManager.IMPORTANCE_DEFAULT,
                "你的运动目标已达成", "step");

        Notification.Builder builder = null;
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            NotificationManager mNotificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            builder = new Notification.Builder(context, "sport");
            builder.setSmallIcon(R.mipmap.ic_app)
                    .setContentTitle("运动目标达成")
                    .setContentText("你的运动目标已达成")
                    .setBadgeIconType(R.mipmap.ic_app)
                    .setNumber(1)
                    .setAutoCancel(true);
            mNotificationManager.notify((int) System.currentTimeMillis(), builder.build());
        }
        return 0;
    }

    public static void createNotificationChannel(Context context,String id, String name
            , int importance, String desc, String groupId) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationManager mNotificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            if (mNotificationManager.getNotificationChannel(id) != null) {
                return;
            }

            NotificationChannel notificationChannel = new NotificationChannel(id, name, importance);
            notificationChannel.enableLights(true);
            notificationChannel.enableVibration(true);
            notificationChannel.setImportance(NotificationManager.IMPORTANCE_LOW);
            notificationChannel.setLightColor(Color.RED);
            notificationChannel.setLockscreenVisibility(Notification.VISIBILITY_PUBLIC);
            notificationChannel.setShowBadge(true);
            notificationChannel.setBypassDnd(true);
//            notificationChannel.setVibrationPattern(new long[]{100, 200, 300, 400});
            notificationChannel.setDescription(desc);
            notificationChannel.setGroup(groupId);
        notificationChannel.setSound(null,null);

            mNotificationManager.createNotificationChannel(notificationChannel);
        }
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
}
