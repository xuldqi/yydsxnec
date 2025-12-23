package com.dn.sports.fragment;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dn.sports.R;
import com.dn.sports.adapter.BodyRecordAdapter;
import com.dn.sports.dialog.HintDialog;
import com.dn.sports.dialog.RulerViewPickDialog;
import com.dn.sports.greendao.DbHelper;
import com.dn.sports.ormbean.BodyRecord;

import java.util.List;

public class RecordSubFragment extends BaseFragment {

    public static final int TYPE_HEIGHT = 1;
    public static final int TYPE_WEIGHT = 2;
    public static final int TYPE_XW = 3;
    public static final int TYPE_YW = 4;
    public static final int TYPE_TW = 5;
    public static final int TYPE_SBW = 6;
    public static final int TYPE_DTW = 7;
    public static final int TYPE_XTW = 8;
    private int type;
    private String title;
    private RecyclerView bodyRecordList;
    private ImageView onData;

    public RecordSubFragment(int type,String title){
        this.type = type;
        this.title = title;
    }

    public int getType() {
        return type;
    }

    @Override
    public View getViewByLayout(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_sub_body_record,null);
    }

    @Override
    public void initViewAction(View view) {
        bodyRecordList = view.findViewById(R.id.body_record_list);
        onData = view.findViewById(R.id.no_data);
        updateList();
    }

    public void updateList(){
        List<BodyRecord> datas = DbHelper.INSTANCE.getDaoSession().getBodyRecordDao().queryRaw("where type = ? order by time desc",String.valueOf(type));

        if(datas == null || datas.size() == 0){
            bodyRecordList.setVisibility(View.GONE);
            onData.setVisibility(View.VISIBLE);
            return;
        }
        bodyRecordList.setVisibility(View.VISIBLE);
        onData.setVisibility(View.GONE);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getActivity(), RecyclerView.VERTICAL,false);
        bodyRecordList.setLayoutManager(linearLayoutManager);
        BodyRecordAdapter adapter = new BodyRecordAdapter(getActivity(),datas,title);
        bodyRecordList.setAdapter(adapter);

        adapter.setClickListener(new BodyRecordAdapter.ClickListener(){
            @Override
            public void onDeleteClick(BodyRecord itemModel, int pos) {
                HintDialog hintDialog = new HintDialog(getActivity(),false);
                hintDialog.setCommonHint("删除提示", "确认删除本条记录吗？", new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        adapter.notifyItemRemoved(pos);
                        DbHelper.INSTANCE.getDaoSession().getBodyRecordDao().delete(itemModel);
                        hintDialog.dismissDialog();
                    }
                });
                hintDialog.showDialogAtCenter();
            }

            @Override
            public void onModifyClick(BodyRecord itemModel, int pos) {
                RulerViewPickDialog rulerViewPickDialog = new RulerViewPickDialog(getActivity());
                rulerViewPickDialog.showDialogAtBottom();
                rulerViewPickDialog.initWithType("修改" + title + "记录"
                        , type, new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {
                                itemModel.setData( rulerViewPickDialog.getRulerData() + "");
//                                StepApplication.getInstance().getService().updateBodyRecordById(itemModel.getDbData(),itemModel.id);
                                DbHelper.INSTANCE.getDaoSession().getBodyRecordDao().update(itemModel);

                                adapter.notifyItemChanged(pos,itemModel);
                                rulerViewPickDialog.dismissDialog();
                            }
                        },Float.parseFloat(itemModel.getData()));
            }
        });
    }

    @Override
    public void updateUserInfo() {

    }

    @Override
    public void clearUserInfo() {

    }
}
