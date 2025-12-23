package com.dn.sports.dialog;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.TextView;

import com.dn.sports.R;
import com.dn.sports.view.WheelPicker;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class WheelPickDialog extends BasePopup {

    private WheelPicker<String> wheelPicker;
    public static final int TYPE_SEX = 1;
    public static final int TYPE_LOC = 2;
    private View view;

    public WheelPickDialog(Context context){
        super(context, ViewGroup.LayoutParams.MATCH_PARENT,ViewGroup.LayoutParams.WRAP_CONTENT);
    }

    @Override
    protected void onDismissDialog() {
    }

    public void initWheelType(int type){
        List<String> mins = new ArrayList<>();
        if(TYPE_SEX == type) {
            mins.add("男");
            mins.add("女");
            ((TextView)view.findViewById(R.id.title)).setText("性别");
        }else{
            mins = Arrays.asList(context.getResources().getStringArray(R.array.loc_list));
            ((TextView)view.findViewById(R.id.title)).setText("选择归属地");
        }
        wheelPicker.setDataList(mins);
    }

    @Override
    protected View createDialogView(Context context, LayoutInflater inflater) {
        view = inflater.inflate(R.layout.dialog_wheel_pick,null);
        wheelPicker = view.findViewById(R.id.wheel_pick);
        wheelPicker.setCyclic(false);
        List<String> mins = new ArrayList<>();
        wheelPicker.setDataList(mins);
        wheelPicker.setCurtainBorderColor(Color.TRANSPARENT);
        wheelPicker.setSelectedItemTextColor(Color.BLACK);
        wheelPicker.setSelectedItemTextSize(90);
        wheelPicker.setItemHeightSpace(60);
        wheelPicker.setHalfVisibleItemCount(1);
        wheelPicker.setCurtainColor(Color.TRANSPARENT);

        view.findViewById(R.id.deny).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismissDialog();
            }
        });
        return view;
    }

    public void setOkClickListener(View.OnClickListener listener){
        view.findViewById(R.id.auth).setOnClickListener(listener);
    }

    public String getCurrentString(){
        return wheelPicker.getDataList().get(wheelPicker.getCurrentPosition());
    }
}
