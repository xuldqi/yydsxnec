//package com.dn.sports.map;
//
//import android.os.Bundle;
//import android.os.Handler;
//import android.os.Looper;
//import android.text.TextUtils;
//import android.view.View;
//import android.widget.TextView;
//
//import androidx.annotation.Nullable;
//
//import com.baidu.mapapi.map.BaiduMap;
//import com.baidu.mapapi.map.MapStatusUpdateFactory;
//import com.baidu.mapapi.map.MapView;
//import com.baidu.mapapi.map.MyLocationData;
//import com.baidu.mapapi.model.LatLng;
//import com.baidu.trace.model.SortType;
//import com.google.gson.JsonArray;
//import com.dn.sports.R;
//import com.dn.sports.common.BaseActivity;
//import com.dn.sports.common.EyeLog;
//import com.dn.sports.dialog.ProgressDialog;
//import com.dn.sports.utils.Utils;
//
//import org.json.JSONArray;
//import org.json.JSONException;
//import org.json.JSONObject;
//
//import java.io.BufferedReader;
//import java.io.File;
//import java.io.FileInputStream;
//import java.io.IOException;
//import java.io.InputStream;
//import java.io.InputStreamReader;
//import java.util.ArrayList;
//import java.util.List;
//
//public class TraceHistoryItemActivity extends BaseActivity {
//    private List<LatLng> trackPoints = new ArrayList<>();
//    private MapView mMapView;
//    private BaiduMap mBaiduMap;
//    private MapUtil mapUtil = null;
//    private Handler gpsHandler = new Handler(Looper.getMainLooper());
//    private TextView distanceText;
//    private TextView timeText;
//    private ProgressDialog progressDialog;
//    private float level;
//
//    @Override
//    protected void onCreate(@Nullable Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_trace_history_item);
//
//        findViewById(R.id.root).setPadding(0, Utils.getStatusBarHeight(this),0,0);
//        findViewById(R.id.back_btn).setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                finish();
//            }
//        });
//        TextView title = findViewById(R.id.title);
//        title.setText("历史轨迹");
//
//        mMapView = findViewById(R.id.bmapView);
//        mBaiduMap = mMapView.getMap();
//        mBaiduMap.setMyLocationEnabled(true);
//        float maxZoomLevel=mBaiduMap.getMaxZoomLevel();
//        level = maxZoomLevel-2;
//        mBaiduMap.setMapStatus(MapStatusUpdateFactory.zoomTo(level));
//        BitmapUtil.init();
//        int lineColor = getResources().getColor(R.color.line_color);
//        mapUtil = MapUtil.getInstance();
//        mapUtil.init(mMapView,lineColor);
//        View infoLayout = findViewById(R.id.info_layout);
//        distanceText = findViewById(R.id.distance);
//        timeText = findViewById(R.id.speed);
//        infoLayout.setVisibility(View.VISIBLE);
//
//        final String path = getIntent().getStringExtra("path");
//
//       Thread thread = new Thread(){
//            @Override
//            public void run() {
//                super.run();
//
//
//
//                String data = ReadTxtFile(path);
//                if(!TextUtils.isEmpty(data)){
//                    try {
//                        JSONObject jsonObject = new JSONObject(data);
//                        String time = jsonObject.optString("time");
//                        String distance = jsonObject.optString("distance");
//                        String listData =  jsonObject.optString("data");
//                        JSONArray jsonArray = new JSONArray(listData);
//
//                        for (int i = 0; i < jsonArray.length(); i++) {
//                            // JSON数组里面的具体-JSON对象
//                            JSONObject item = jsonArray.getJSONObject(i);
//                            long la = item.optLong("la");
//                            long lo = item.optLong("lo");
//                            trackPoints.add(MapUtil.convertTraceLocation2Map(la,lo));
//                        }
//
//                        gpsHandler.post(new Runnable() {
//                            @Override
//                            public void run() {
//                                if(trackPoints.size()>0) {
//                                    MyLocationData locData = new MyLocationData.Builder()
//                                            .accuracy(50)
//                                            // 此处设置开发者获取到的方向信息，顺时针0-360
//                                            .direction(90).latitude(trackPoints.get(0).latitude)
//                                            .longitude(trackPoints.get(0).longitude).build();
//                                    mBaiduMap.setMyLocationData(locData);
//
//
//                                    mapUtil.drawHistoryTrack(trackPoints, SortType.asc, level);
//                                    distanceText.setText("" + time);
//                                    timeText.setText(distance);
//                                }
//                            }
//                        });
//                    }catch (JSONException e){
//                        EyeLog.logi( "JSONException:"+e.getMessage());
//                        e.printStackTrace();
//                        finish();
//                    }
//                }
//            }
//        };
//        thread.start();
//    }
//
//    //读取文本文件中的内容
//    public static String ReadTxtFile(String strFilePath)
//    {
//        String path = strFilePath;
//        String content = ""; //文件内容字符串
//        //打开文件
//        File file = new File(path);
//        //如果path是传递过来的参数，可以做一个非目录的判断
//        if (file.isDirectory())
//        {
//            EyeLog.logi( "The File doesn't not exist.");
//        }
//        else
//        {
//            try {
//                InputStream instream = new FileInputStream(file);
//                if (instream != null)
//                {
//                    InputStreamReader inputreader = new InputStreamReader(instream);
//                    BufferedReader buffreader = new BufferedReader(inputreader);
//                    String line;
//                    //分行读取
//                    while (( line = buffreader.readLine()) != null) {
//                        content += line + "\n";
//                    }
//                    instream.close();
//                }
//            }
//            catch (java.io.FileNotFoundException e)
//            {
//                EyeLog.logi(  "The File doesn't not exist.");
//            }
//            catch (IOException e)
//            {
//                EyeLog.logi(  e.getMessage());
//            }
//        }
//        return content;
//    }
//}
