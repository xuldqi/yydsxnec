package com.dn.sports.fragment;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.dn.sports.R;
import com.dn.sports.common.EyeLog;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class SubMiaoBiaoFragment extends BaseFragment {

    private ImageView daBiao;
    private ImageView pauseOrStart;
    private ImageView stop;
    private TextView time;
    private TextView timeMills;
    private LinearLayout daBiaoList;
    private boolean isStart = false;
    private boolean isPause = false;
    private long timeMILLISECONDS = 0;
    private long lastDaBiaoMILLISECONDS = 0;
    private ScheduledExecutorService scheduledExecutorService;
    private Handler handler = new Handler(Looper.getMainLooper()){
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            long timeNum = (long)msg.obj;
            String text = "";
            int hour = (int)(timeNum/(60*60*1000));
            if(hour > 1) {
                text = hour + ":";
            }
            timeNum = timeNum - 60*60*1000*hour;
            int min = (int)(timeNum/(60*1000));
            if(min > 9) {
                text = text + min + ":";
            }else{
                text = text + "0" + min + ":";
            }
            timeNum = timeNum - 60*1000*min;
            int second = (int)(timeNum/1000);
            if(second > 9) {
                text = text + second;
            }else{
                text = text + "0" + second;
            }
            timeNum = timeNum - 1000*second;
            int millSecond = (int)(timeNum/10);
            if(millSecond > 9) {
                timeMills.setText("."+millSecond+"");
            }else{
                timeMills.setText(".0"+millSecond);
            }
            time.setText(text);
        }
    };

    public boolean isStart() {
        return isStart;
    }

    public void stop(){
        if(scheduledExecutorService != null) {
            scheduledExecutorService.shutdownNow();
        }
    }

    @Override
    public View getViewByLayout(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_sub_miaobiao,container,false);
    }

    @Override
    public void initViewAction(View view) {
        daBiao = view.findViewById(R.id.da_biao);
        stop = view.findViewById(R.id.stop);
        pauseOrStart = view.findViewById(R.id.start_or_pause);
        time = view.findViewById(R.id.miao_biao_time);
        timeMills = view.findViewById(R.id.miao_biao_time_mills);
        daBiaoList = view.findViewById(R.id.record_list);

        pauseOrStart.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(isStart){
                    if(isPause){
                        isPause = false;
                        stop.setVisibility(View.GONE);
                        daBiao.setVisibility(View.VISIBLE);
                        pauseOrStart.setImageResource(R.mipmap.pause);
                        scheduledExecutorService =  Executors.newScheduledThreadPool(1);
                        scheduledExecutorService.scheduleAtFixedRate(new MiaoBiaoRunnable(),0,10, TimeUnit.MILLISECONDS);
                    }else{
                        isPause = true;
                        daBiao.setVisibility(View.GONE);
                        stop.setVisibility(View.VISIBLE);
                        pauseOrStart.setImageResource(R.mipmap.start);
                        if(scheduledExecutorService != null) {
                            scheduledExecutorService.shutdownNow();
                        }
                    }
                }else{
                    isStart = true;
                    lastDaBiaoMILLISECONDS = 0;
                    daBiaoList.removeAllViews();
                    pauseOrStart.setKeepScreenOn(true);
                    daBiao.setVisibility(View.VISIBLE);
                    pauseOrStart.setImageResource(R.mipmap.pause);
                    scheduledExecutorService =  Executors.newScheduledThreadPool(1);
                    scheduledExecutorService.scheduleAtFixedRate(new MiaoBiaoRunnable(),0,10, TimeUnit.MILLISECONDS);
                }
            }
        });
        stop.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                isStart = false;
                isPause = false;
                pauseOrStart.setKeepScreenOn(false);
                pauseOrStart.setImageResource(R.mipmap.start);
                daBiao.setVisibility(View.GONE);
                timeMILLISECONDS = 0;
                if(scheduledExecutorService != null) {
                    scheduledExecutorService.shutdownNow();
                }
                stop.setVisibility(View.GONE);
            }
        });
        daBiao.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                long addTime = timeMILLISECONDS;
                long mm = addTime - lastDaBiaoMILLISECONDS;
                lastDaBiaoMILLISECONDS = addTime;

                View item = View.inflate(getActivity(),R.layout.da_biao_record_item,null);
                int index = daBiaoList.getChildCount()+1;
                ((TextView)item.findViewById(R.id.index)).setText(index+"");
                ((TextView)item.findViewById(R.id.middle)).setText("+"+convertTime(mm));
                ((TextView)item.findViewById(R.id.add_time)).setText(convertTime(addTime));
                daBiaoList.addView(item,0);
            }
        });
    }

    private class MiaoBiaoRunnable implements Runnable {
        @Override
        public void run() {
            timeMILLISECONDS = timeMILLISECONDS + 10;
            Message msg = handler.obtainMessage();
            msg.obj = timeMILLISECONDS;
            msg.sendToTarget();
        }
    }

    private String convertTime(long timeNum){
        String text = "";
        int hour = (int)(timeNum/(60*60*1000));
        if(hour > 1) {
            text = hour + ":";
        }
        timeNum = timeNum - 60*60*1000*hour;
        int min = (int)(timeNum/(60*1000));
        if(min > 9) {
            text = text + min + ":";
        }else{
            text = text + "0" + min + ":";
        }
        timeNum = timeNum - 60*1000*min;
        int second = (int)(timeNum/1000);
        if(second > 9) {
            text = text + second + ":";
        }else{
            text = text + "0" + second + ":";
        }
        timeNum = timeNum - 1000*second;
        int millSecond = (int)(timeNum/10);
        if(millSecond > 9) {
            text = text + millSecond;
        }else{
            text = text + "0" + millSecond;
        }
        return text;
    }

    @Override
    public void updateUserInfo() {

    }

    @Override
    public void clearUserInfo() {

    }
}
