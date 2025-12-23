package com.dn.sports.map;

import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.core.content.FileProvider;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dn.sports.R;
import com.dn.sports.StepApplication;
import com.dn.sports.adapter.BodyRecordAdapter;
import com.dn.sports.adapter.TraceDatasAdapter;
import com.dn.sports.common.BaseActivity;
import com.dn.sports.common.EyeLog;
import com.dn.sports.dialog.HintDialog;
import com.dn.sports.utils.Utils;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class TraceHistoryListActivity extends BaseActivity {

    private RecyclerView traceRecordList;
    private ImageView onData;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_trace_history_list);

        findViewById(R.id.root).setPadding(0, Utils.getStatusBarHeight(this),0,0);
        findViewById(R.id.back_btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        TextView title = findViewById(R.id.title);
        title.setText("历史轨迹");

//        String path = BDMapTraceActivity.STORE_PIC_PATH;
        String path = "";

        traceRecordList = findViewById(R.id.trace_record_list);
        onData = findViewById(R.id.no_data);

        File file = new File(path);
        if(!file.exists()){
            traceRecordList.setVisibility(View.GONE);
            onData.setVisibility(View.VISIBLE);
        }else{
            File[] files = file.listFiles();
            if(files == null || files.length == 0){
                traceRecordList.setVisibility(View.GONE);
                onData.setVisibility(View.VISIBLE);
            }else {
                List<TraceItemModel> datas = new ArrayList<>();
                for (File item:files){
                    try {
                        String name = getFileNameNoEx(item.getName());
//                        if(name.startsWith(BDMapTraceActivity.FILE_START)){
//                            name = name.replace(BDMapTraceActivity.FILE_START,"");
//                            String[] info = name.split("_");
//                            String time = info[0];
//                            String distance = info[1];
//                            TraceItemModel traceItemModel = new TraceItemModel();
//                            traceItemModel.setTime(Long.valueOf(time));
//                            traceItemModel.setDistance(Float.valueOf(distance));
//                            traceItemModel.setPath(item.getAbsolutePath());
//                            datas.add(traceItemModel);
//                        }
                    }catch (Exception e){
                        EyeLog.logi("TraceHistoryListActivity name3:"+e.getMessage());
                        e.printStackTrace();
                    }
                }

                if(datas.size() == 0){
                    traceRecordList.setVisibility(View.GONE);
                    onData.setVisibility(View.VISIBLE);
                }else{
                    traceRecordList.setVisibility(View.VISIBLE);
                    onData.setVisibility(View.GONE);
                }
                LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this, RecyclerView.VERTICAL,false);
                traceRecordList.setLayoutManager(linearLayoutManager);
                TraceDatasAdapter adapter = new TraceDatasAdapter(this,datas);
                traceRecordList.setAdapter(adapter);
                adapter.setClickListener(new TraceDatasAdapter.ClickListener() {
                    @Override
                    public void onClick(TraceItemModel itemModel, int pos) {

                        Uri uriForFile;
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                            uriForFile = FileProvider.getUriForFile(TraceHistoryListActivity.this,
                                    "com.dn.sports.fileprovider", new File(itemModel.getPath()));
                        } else {
                            uriForFile = Uri.fromFile(new File(path));
                        }

                        Intent intent = new Intent();
                        intent.setAction(android.content.Intent.ACTION_VIEW);
                        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                        intent.setDataAndType(uriForFile, "image/*");
                        startActivity(intent);

//                        Intent it = new Intent(TraceHistoryListActivity.this,TraceHistoryItemActivity.class);
//                        it.putExtra("path",itemModel.getPath());
//                        startActivity(it);
                    }

                    @Override
                    public void onDeleteClick(TraceItemModel itemModel, int pos) {
                        HintDialog hintDialog = new HintDialog(TraceHistoryListActivity.this,false);
                        hintDialog.setCommonHint("删除提示", "确认删除本条记录吗？", new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {
                                adapter.notifyItemRemoved(pos);
                                hintDialog.dismissDialog();

                                File file = new File(itemModel.getPath());
                                file.delete();
                            }
                        });
                        hintDialog.showDialogAtCenter();
                    }
                });
            }
        }
    }


    /*
     * Java文件操作 获取不带扩展名的文件名
     * */
    public static String getFileNameNoEx(String filename) {
        if ((filename != null) && (filename.length() > 0)) {
            int dot = filename.lastIndexOf('.');
            if ((dot >-1) && (dot < (filename.length()))) {
                return filename.substring(0, dot);
            }
        }
        return filename;
    }
}
