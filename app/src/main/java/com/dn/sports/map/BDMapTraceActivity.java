//package com.dn.sports.map;
//
//import android.Manifest;
//import android.content.Intent;
//import android.content.pm.PackageManager;
//import android.graphics.Bitmap;
//import android.location.Location;
//import android.location.LocationListener;
//import android.location.LocationManager;
//import android.net.Uri;
//import android.os.Build;
//import android.os.Bundle;
//import android.os.Environment;
//import android.os.Handler;
//import android.os.Looper;
//import android.os.Message;
//import android.view.View;
//import android.widget.TextView;
//import android.widget.Toast;
//
//import androidx.annotation.Nullable;
//import androidx.core.content.FileProvider;
//
//import com.baidu.location.BDAbstractLocationListener;
//import com.baidu.location.BDLocation;
//import com.baidu.location.LocationClient;
//import com.baidu.location.LocationClientOption;
//import com.baidu.mapapi.map.BaiduMap;
//import com.baidu.mapapi.map.BitmapDescriptorFactory;
//import com.baidu.mapapi.map.MapStatusUpdateFactory;
//import com.baidu.mapapi.map.MapView;
//import com.baidu.mapapi.map.MyLocationConfiguration;
//import com.baidu.mapapi.map.MyLocationData;
//import com.baidu.mapapi.model.LatLng;
//import com.baidu.trace.model.SortType;
//import com.dn.sports.R;
//import com.dn.sports.common.BaseActivity;
//import com.dn.sports.common.EyeLog;
//import com.dn.sports.dialog.HintDialog;
//import com.dn.sports.dialog.ProgressDialog;
//import com.dn.sports.utils.Utils;
//
//import org.json.JSONArray;
//import org.json.JSONException;
//import org.json.JSONObject;
//
//import java.io.File;
//import java.io.FileNotFoundException;
//import java.io.FileOutputStream;
//import java.io.FileWriter;
//import java.io.IOException;
//import java.text.NumberFormat;
//import java.util.ArrayList;
//import java.util.List;
//import java.util.concurrent.Executors;
//import java.util.concurrent.ScheduledExecutorService;
//import java.util.concurrent.TimeUnit;
//
//public class BDMapTraceActivity extends BaseActivity {
//
//    private MapView mMapView;
//    private BaiduMap mBaiduMap;
//    private LocationClient mLocationClient;
//    private MapUtil mapUtil = null;
//    private boolean isGathering  = false;
//    private boolean isStop = false;
//    private List<LatLng> trackPoints = new ArrayList<>();
//    private LocationManager  mLocationManager;
//    private View trace;
//    private View infoLayout;
//    private TextView distance;
//    private TextView timeText;
//    private ProgressDialog progressDialog;
//    private Handler gpsHandler = new Handler(Looper.getMainLooper());
//    private float dectirtion = 90;
//    private NumberFormat nf = NumberFormat.getNumberInstance();
//    private float level;
//    private float speed;
//    private String address;
//    private double distanceData;
//    private ScheduledExecutorService scheduledExecutorService;
//
//    private Handler handler = new Handler(Looper.getMainLooper()){
//        @Override
//        public void handleMessage(Message msg) {
//            super.handleMessage(msg);
//            if(msg.what == 1){
//                long timeNum = (long)msg.obj;
//                String text = "";
//                int hour = (int)(timeNum/(60*60*1000));
//                if(hour > 1) {
//                    text = hour + ":";
//                }
//                timeNum = timeNum - 60*60*1000*hour;
//                int min = (int)(timeNum/(60*1000));
//                if(min > 9) {
//                    text = text + min + ":";
//                }else{
//                    text = text + "0" + min + ":";
//                }
//                timeNum = timeNum - 60*1000*min;
//                int second = (int)(timeNum/1000);
//                if(second > 9) {
//                    text = text + second;
//                }else{
//                    text = text + "0" + second;
//                }
//                timeText.setText("时间："+text);
//            }
//        }
//    };
//
//    @Override
//    protected void onCreate(@Nullable Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_bd_map_trace);
//        findViewById(R.id.root).setPadding(0, Utils.getStatusBarHeight(this),0,0);
//        findViewById(R.id.back_btn).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                finish();
//            }
//        });
//        nf.setMaximumFractionDigits(2);
//        mLocationManager = (LocationManager) getSystemService(LOCATION_SERVICE);
//        TextView title = findViewById(R.id.title);
//        title.setText("轨迹追踪");
//        progressDialog = ProgressDialog.createDialog(this,"GPS获取位置中，第一次获取时间较长请耐心等待");
//        mMapView = findViewById(R.id.bmapView);
//        mBaiduMap = mMapView.getMap();
//        mBaiduMap.setMyLocationEnabled(true);
//
//        infoLayout = findViewById(R.id.info_layout);
//        distance = findViewById(R.id.distance);
//        timeText = findViewById(R.id.speed);
//
//
//        MyLocationConfiguration mLocationConfiguration = new MyLocationConfiguration(
//                MyLocationConfiguration.LocationMode.FOLLOWING,true, BitmapDescriptorFactory.fromResource(R.mipmap.tr),0,0);
//        mBaiduMap.setMyLocationConfiguration(mLocationConfiguration);
//
//        float maxZoomLevel=mBaiduMap.getMaxZoomLevel();
//        level = maxZoomLevel-2;
//        mBaiduMap.setMapStatus(MapStatusUpdateFactory.zoomTo(level));
//        initLoc();
//
//        initGps();
//        gpsHandler.postDelayed(new Runnable() {
//            @Override
//            public void run() {
//                try {
//                    if (progressDialog != null)
//                        progressDialog.show();
//                }catch (Exception e){
//                    e.printStackTrace();
//                }
//            }
//        },200);
//
//        new Handler().postDelayed(new Runnable() {
//            @Override
//            public void run() {
//                if(progressDialog != null){
//                    gpsHandler.removeCallbacksAndMessages(null);
//                    progressDialog.dismiss();
//                    progressDialog = null;
//                }
//            }
//        },13000);
//
//    }
//
//    public void stop(){
//        if(scheduledExecutorService != null) {
//            scheduledExecutorService.shutdownNow();
//        }
//    }
//
//    @Override
//    protected void onResume() {
//        super.onResume();
//        mMapView.onResume();
//    }
//    @Override
//    protected void onPause() {
//        super.onPause();
//        mMapView.onPause();
//    }
//    @Override
//    protected void onDestroy() {
//        super.onDestroy();
//        mLocationManager.removeUpdates(gpsLocationListener);
//        mBaiduMap.setMyLocationEnabled(false);
//        mMapView.onDestroy();
//    }
//
//    @Override
//    public void onBackPressed() {
//        if(isGathering){
//            HintDialog hintDialog = new HintDialog(this,false);
//            hintDialog.setCommonHint("退出提示","录制轨迹中，确认退出？",new View.OnClickListener(){
//                @Override
//                public void onClick(View view) {
//                    finish();
//                }
//            });
//            hintDialog.showDialogAtCenter();
//            return;
//        }
//        super.onBackPressed();
//    }
//
//    //初始化位置
//    private void initLoc(){
//        //定位初始化
//        mLocationClient = new LocationClient(this);
//
//        LocationClientOption option = new LocationClientOption();
//        option.setOpenGps(true); // 打开gps
//        option.setCoorType("bd09ll"); // 设置坐标类型
//        option.setScanSpan(500);
//        mLocationClient.setLocOption(option);
//        MyLocationListener myLocationListener = new MyLocationListener();
//        mLocationClient.registerLocationListener(myLocationListener);
//        mLocationClient.start();
//    }
//
//    //定位到一次就结束
//    public class MyLocationListener extends BDAbstractLocationListener {
//        @Override
//        public void onReceiveLocation(BDLocation location) {
//            //mapView 销毁后不在处理新接收的位置
//            if (location == null || mMapView == null){
//                return;
//            }
//            dectirtion = location.getDirection();
//            speed = location.getSpeed();
//            address = location.getAddrStr();
//            MyLocationData locData = new MyLocationData.Builder()
//                    .accuracy(location.getRadius())
//                    // 此处设置开发者获取到的方向信息，顺时针0-360
//                    .direction(dectirtion).latitude(location.getLatitude())
//                    .longitude(location.getLongitude()).build();
//            mBaiduMap.setMyLocationData(locData);
//
//            //speedText.setText("速度："+nf.format(speed)+"km/h");
//        }
//    }
//
//    private void initGps(){
//        if (Build.VERSION.SDK_INT>=23 && checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
//            requestPermissions(new String[]{Manifest.permission.ACCESS_FINE_LOCATION},10001);
//            return;
//        }
//
//        trace = findViewById(R.id.trace);
//        trace.setVisibility(View.GONE);
//        findViewById(R.id.trace).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                if (Build.VERSION.SDK_INT>=23 && checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
//                    requestPermissions(new String[]{Manifest.permission.ACCESS_FINE_LOCATION},10001);
//                    return;
//                }
//                if(isGathering){
//                    isGathering = false;
//                    isStop = true;
//                    findViewById(R.id.trace).setVisibility(View.GONE);
//
//                    handler.removeCallbacksAndMessages(null);
//                    if(scheduledExecutorService != null) {
//                        scheduledExecutorService.shutdownNow();
//                    }
//
//                    //startStoreTracePathData();
//                    findViewById(R.id.share_bp).setVisibility(View.VISIBLE);
//                    findViewById(R.id.share_bp).setOnClickListener(new View.OnClickListener() {
//                        @Override
//                        public void onClick(View view) {
//                            mBaiduMap.snapshot(new BaiduMap.SnapshotReadyCallback() {
//                                @Override
//                                public void onSnapshotReady(Bitmap bitmap) {
//                                    String path = saveBitmap(bitmap,distanceData);
//
//                                    Uri uri;
//                                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
//                                        uri = FileProvider.getUriForFile(BDMapTraceActivity.this,
//                                                "com.dn.sports.fileprovider", new File(path));
//                                    } else {
//                                        uri = Uri.fromFile(new File(path));
//                                    }
//
//                                    Intent shareIntent = new Intent();
//                                    shareIntent.setAction(Intent.ACTION_SEND);
//                                    shareIntent.putExtra(Intent.EXTRA_STREAM, uri);
//                                    shareIntent.setType("image/*");
//                                    startActivity(Intent.createChooser(shareIntent, "分享到："));
//                                }
//                            });
//                        }
//                    });
//                }else{
//                    isGathering = true;
//                    ((TextView)findViewById(R.id.trace)).setText("Tracing");
//
//                    scheduledExecutorService =  Executors.newScheduledThreadPool(1);
//                    scheduledExecutorService.scheduleAtFixedRate(new MiaoBiaoRunnable(),0,1000, TimeUnit.MILLISECONDS);
//                }
//            }
//        });
//        BitmapUtil.init();
//        int lineColor = getResources().getColor(R.color.line_color);
//        mapUtil = MapUtil.getInstance();
//        mapUtil.init(mMapView,lineColor);
//
//        mLocationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 2000,2f, gpsLocationListener, Looper.getMainLooper());
//    }
//
//    private long timeMILLISECONDS = 0;
//    private class MiaoBiaoRunnable implements Runnable {
//        @Override
//        public void run() {
//            timeMILLISECONDS = timeMILLISECONDS + 1000;
//            Message msg = handler.obtainMessage();
//            msg.what = 1;
//            msg.obj = timeMILLISECONDS;
//            msg.sendToTarget();
//        }
//    }
//
//    private Location lastLocation;
//    private double sportDistance;
//
//    private LocationListener gpsLocationListener = new LocationListener() {
//
//        @Override
//        public void onLocationChanged(Location location) {
//            if(progressDialog != null){
//                gpsHandler.removeCallbacksAndMessages(null);
//                progressDialog.dismiss();
//                progressDialog = null;
//            }
//
//            if(isStop) return;
//            if(trace.getVisibility() != View.VISIBLE){
//                trace.setVisibility(View.VISIBLE);
//                infoLayout.setVisibility(View.VISIBLE);
//                LatLng currentLatLng = mapUtil.convertTraceLocation2Map(location);
//                trackPoints.add(currentLatLng);
//                if (null != mapUtil) {
//                    mapUtil.drawHistoryTrack(trackPoints, SortType.asc,level);
//                }
//            }
//            if(isGathering) {
//                if(lastLocation == null){
//                    lastLocation = location;
//                }else{
//                    sportDistance = sportDistance + getDistance(lastLocation,location);
//                    distanceData  = sportDistance;
//                    if(sportDistance <1000){
//                        distance.setText("里程："+nf.format(sportDistance)+"米");
//                    }else{
//                        distance.setText("里程："+nf.format(sportDistance/1000)+"km");
//                    }
//                    lastLocation = location;
//                }
//                EyeLog.logi("sportDistance:"+sportDistance+",speed:"+lastLocation.getSpeed());
//                LatLng currentLatLng = mapUtil.convertTraceLocation2Map(location);
//
//                trackPoints.add(currentLatLng);
//                if (null != mapUtil) {
//                    mapUtil.drawHistoryTrack(trackPoints, SortType.asc,level);
//                }
//            }
//        }
//
//        @Override
//        public void onProviderDisabled(String provider) {
//        }
//
//        @Override
//        public void onProviderEnabled(String provider) {
//        }
//
//        @Override
//        public void onStatusChanged(String provider, int status, Bundle extras) {
//
//        }
//    };
//
//    public double getDistance(Location loc1, Location loc2) {
//        float[] results = new float[1];
//        Location.distanceBetween(loc1.getLatitude(), loc1.getLongitude(), loc2.getLatitude(), loc2.getLongitude(), results);
//        return results[0];
//    }
//
//
//    private void startStoreTracePathData(){
//        final ProgressDialog progressDialog = ProgressDialog.createDialog(this);
//        progressDialog.show();
//        Thread storeTrace = new Thread(){
//            @Override
//            public void run() {
//                super.run();
//                try {
//                    JSONArray jsonArray = new JSONArray();
//                    for(LatLng item:trackPoints){
//                        JSONObject jsonObject = new JSONObject();
//                        jsonObject.put("la",item.latitude);
//                        jsonObject.put("lo",item.longitude);
//                        jsonArray.put(jsonObject);
//                    }
//
//                    trackPoints.clear();
//                    JSONObject result = new JSONObject();
//                    result.put("addr",address);
//                    result.put("time",System.currentTimeMillis());
//                    result.put("distance",distance.getText());
//                    result.put("data",jsonArray);
//                    String storeData = result.toString();
//                    EyeLog.logi("startStoreTracePathData:"+storeData);
//                    saveTraceData(storeData,distanceData);
//
//                    new Handler(Looper.getMainLooper()).post(new Runnable() {
//                        @Override
//                        public void run() {
//                            progressDialog.dismiss();
//                            Toast.makeText(getApplicationContext(),"已保存",Toast.LENGTH_SHORT).show();
//                        }
//                    });
//                }catch (JSONException e){
//                    e.printStackTrace();
//                }
//            }
//        };
//        storeTrace.start();
//    }
//
//    public static final String FILE_DIR = "WeiStep";
//    public static final String FILE_DIR_SUB = "TraceData";
//    public static final String FILE_DIR_PIC = "Pic";
//    public static final String FILE_START = "trace_num_";
//    public static final String STORE_PATH = Environment.getExternalStorageDirectory()+"/"+FILE_DIR+"/"+FILE_DIR_SUB;
//    public static final String STORE_PIC_PATH = Environment.getExternalStorageDirectory()+"/"+FILE_DIR+"/"+FILE_DIR_PIC;
//
//    public static void saveTraceData(String message,double distance) {
//        String path =STORE_PATH;
//        File files = new File(path);
//        if (!files.exists()) {
//            files.mkdirs();
//        }
//        if (files.exists()) {
//            try {
//                FileWriter fw = new FileWriter(path + File.separator
//                        + FILE_START+System.currentTimeMillis() + "_"+distance+ ".txt");
//                fw.write(message);
//                fw.close();
//            } catch (Exception e) {
//                e.printStackTrace();
//            }
//        }
//    }
//
//    public static String saveBitmap(Bitmap bm,double distance) {
//        File files = new File(STORE_PIC_PATH);
//        if (!files.exists()) {
//            files.mkdirs();
//        }
//        File f = new File(STORE_PIC_PATH, FILE_START+System.currentTimeMillis() + "_"+distance+ ".png");
//        if (f.exists()) {
//            f.delete();
//        }
//        try {
//            FileOutputStream out = new FileOutputStream(f);
//            bm.compress(Bitmap.CompressFormat.PNG, 90, out);
//            out.flush();
//            out.close();
//        } catch (FileNotFoundException e) {
//            e.printStackTrace();
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//
//        return f.getAbsolutePath();
//    }
//}
