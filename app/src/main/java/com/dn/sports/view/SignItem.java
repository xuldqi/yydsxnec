package com.dn.sports.view;

import android.content.Context;
import android.graphics.Color;
import android.text.format.DateFormat;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.dn.sports.R;
import com.dn.sports.adcoinLogin.model.SignRecord;
import com.dn.sports.utils.DateTest;

public class SignItem extends LinearLayout {
    private View root;
    private TextView name;
    private TextView coin;
    private TextView state;
    private DateTest.WeekDay weekDay;
    private boolean isSign = false;

    public SignItem(Context context){
        super(context);
        init(context);
    }

    public SignItem(Context context, AttributeSet attrs){
        super(context,attrs);
        init(context);
    }

    private void init(Context context){
        View view = LayoutInflater.from(context).inflate(R.layout.sign_item,this);
        root = view.findViewById(R.id.root);
        name = view.findViewById(R.id.name);
        coin = view.findViewById(R.id.coin);
        state = view.findViewById(R.id.state);
    }

    public void setWeekDay(DateTest.WeekDay weekDay,boolean isToToday) {
        this.weekDay = weekDay;

        name.setText(weekDay.week);
        if(isToToday) {
            state.setText(getResources().getString(R.string.no_sign_date));
        }else{
            state.setText(getResources().getString(R.string.no_sign));
        }
        name.setTextColor(Color.BLACK);
        root.setBackgroundResource(R.drawable.common_tab_gray);
    }

    public boolean isSameDate(String date){
        if(date.equals(weekDay.day)){
            state.setText(getResources().getString(R.string.go_sign));
            name.setTextColor(Color.BLACK);
            return true;
        }
        return false;
    }

    public void setTodayIsSign(boolean isSign) {
        if(isSign) {
            state.setText(getResources().getString(R.string.already_sign));
            name.setTextColor(Color.WHITE);
            setClickable(false);
            root.setBackgroundResource(R.drawable.common_tab_pink);
        }else{
            state.setText(getResources().getString(R.string.go_sign));
            name.setTextColor(Color.BLACK);
            root.setBackgroundResource(R.drawable.common_tab_gray);
        }
    }

    public void checkIsSign(SignRecord signRecord){
        String dateStr = DateFormat.format("MM-dd", signRecord.getDate()).toString();
        if(dateStr.equals(weekDay.day)){
            isSign = true;
            state.setText(getResources().getString(R.string.already_sign));
            setClickable(false);
            name.setTextColor(Color.WHITE);
            root.setBackgroundResource(R.drawable.common_tab_pink);
        }
    }
}
