package com.dn.sports.fragment;

import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.dn.sports.R;
import com.dn.sports.view.CustomWheelView;
import com.zyyoona7.wheel.WheelView;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class SubCountTimeFragment extends BaseFragment {

    private CustomWheelView wheelPickerH;
    private CustomWheelView wheelPickerM;
    private CustomWheelView wheelPickerS;
    private TextView countTime;
    private TextView countTimeTotal;
    private View wheelContent;
    private ImageView pauseOrStart;
    private ImageView stop;
    private boolean isStart = false;
    private boolean isPause = false;
    private long timeMILLISECONDS = 0;
    private ScheduledExecutorService scheduledExecutorService;
    private Handler handler = new Handler(Looper.getMainLooper()) {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            if (msg.what == 1) {
                long timeNum = (long) msg.obj;
                String text = "";
                int hour = (int) (timeNum / (60 * 60 * 1000));
                if (hour > 1) {
                    text = hour + ":";
                }
                timeNum = timeNum - 60 * 60 * 1000 * hour;
                int min = (int) (timeNum / (60 * 1000));
                if (min > 9) {
                    text = text + min + ":";
                } else {
                    text = text + "0" + min + ":";
                }
                timeNum = timeNum - 60 * 1000 * min;
                int second = (int) (timeNum / 1000);
                if (second > 9) {
                    text = text + second;
                } else {
                    text = text + "0" + second;
                }
                countTime.setText(text);
            } else if (msg.what == 2) {
                isStart = false;
                isPause = false;
                countTime.setText("00:00");
                wheelContent.setVisibility(View.VISIBLE);
                countTime.setVisibility(View.GONE);
                countTimeTotal.setVisibility(View.GONE);
                pauseOrStart.setKeepScreenOn(false);
                pauseOrStart.setImageResource(R.mipmap.start);
                timeMILLISECONDS = 0;
                if (scheduledExecutorService != null) {
                    scheduledExecutorService.shutdownNow();
                }
                stop.setVisibility(View.GONE);
            }
        }
    };

    public boolean isStart() {
        return isStart;
    }

    public void stop() {
        if (scheduledExecutorService != null) {
            scheduledExecutorService.shutdownNow();
        }
    }

    @Override
    public View getViewByLayout(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_sub_count_time, container, false);
    }

    @Override
    public void initViewAction(View view) {
        wheelPickerH = view.findViewById(R.id.wheelPickerH);
        wheelPickerM = view.findViewById(R.id.wheelPickerM);
        wheelPickerS = view.findViewById(R.id.wheelPickerS);
        countTime = view.findViewById(R.id.count_time);
        countTimeTotal = view.findViewById(R.id.count_time_total);
        stop = view.findViewById(R.id.stop);
        wheelContent = view.findViewById(R.id.wheel_content);
        pauseOrStart = view.findViewById(R.id.start_or_pause);

        List<String> hours = new ArrayList<>();
        for (int i = 0; i < 25; i++) {
            hours.add(String.valueOf(i));
        }
        initWheel(wheelPickerH, hours,0);

        List<String> mins = new ArrayList<>();
        for (int i = 0; i < 61; i++) {
            mins.add(String.valueOf(i));
        }
        initWheel(wheelPickerM, mins,1);
        wheelPickerM.getWheel().setSelectedPosition(5);
        initWheel(wheelPickerS, mins,2);

        pauseOrStart.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (isStart) {
                    if (isPause) {
                        isPause = false;
                        stop.setVisibility(View.VISIBLE);
                        pauseOrStart.setImageResource(R.mipmap.pause);
                        scheduledExecutorService = Executors.newScheduledThreadPool(1);
                        scheduledExecutorService.scheduleAtFixedRate(new SubCountTimeFragment.MiaoBiaoRunnable(), 0, 1000, TimeUnit.MILLISECONDS);
                    } else {
                        isPause = true;
                        handler.removeCallbacksAndMessages(null);
                        pauseOrStart.setImageResource(R.mipmap.start);
                        if (scheduledExecutorService != null) {
                            scheduledExecutorService.shutdownNow();
                        }
                    }
                } else {
                    checkTimeMILLISECONDS();
                    if (timeMILLISECONDS < 2000) {
                        Toast.makeText(getContext(), "时间不可以小于两秒", Toast.LENGTH_SHORT).show();
                        return;
                    }
                    isStart = true;
                    stop.setVisibility(View.VISIBLE);
                    wheelContent.setVisibility(View.GONE);
                    countTime.setVisibility(View.VISIBLE);
                    countTimeTotal.setVisibility(View.VISIBLE);
                    pauseOrStart.setKeepScreenOn(true);
                    pauseOrStart.setImageResource(R.mipmap.pause);
                    scheduledExecutorService = Executors.newScheduledThreadPool(1);
                    scheduledExecutorService.scheduleAtFixedRate(new SubCountTimeFragment.MiaoBiaoRunnable(), 0, 1000, TimeUnit.MILLISECONDS);
                }
            }
        });
        stop.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                isStart = false;
                isPause = false;
                wheelContent.setVisibility(View.VISIBLE);
                countTime.setVisibility(View.GONE);
                countTimeTotal.setVisibility(View.GONE);
                pauseOrStart.setKeepScreenOn(false);
                pauseOrStart.setImageResource(R.mipmap.start);
                timeMILLISECONDS = 0;
                if (scheduledExecutorService != null) {
                    scheduledExecutorService.shutdownNow();
                }
                stop.setVisibility(View.GONE);
            }
        });
    }

    private void checkTimeMILLISECONDS() {
        String h = wheelPickerH.getWheel().getSelectedItem();
        String m = wheelPickerM.getWheel().getSelectedItem();
        String s = wheelPickerS.getWheel().getSelectedItem();

        timeMILLISECONDS = Long.valueOf(h) * 60 * 60 * 1000;
        timeMILLISECONDS = timeMILLISECONDS + Integer.valueOf(m) * 60 * 1000;
        timeMILLISECONDS = timeMILLISECONDS + Integer.valueOf(s) * 1000;

        String text = "";
        long timeNum = timeMILLISECONDS;
        int hour = (int) (timeNum / (60 * 60 * 1000));
        if (hour > 1) {
            text = hour + "时";
        }
        timeNum = timeNum - 60 * 60 * 1000 * hour;
        int min = (int) (timeNum / (60 * 1000));
        if (min > 9) {
            text = text + min + "分";
        } else {
            text = text + "0" + min + "分";
        }
        timeNum = timeNum - 60 * 1000 * min;
        int second = (int) (timeNum / 1000);
        if (second > 9) {
            text = text + second + "秒";
        } else {
            text = text + "0" + second + "秒";
        }
        countTimeTotal.setText("共" + text);
    }

    private class MiaoBiaoRunnable implements Runnable {
        @Override
        public void run() {
            if (timeMILLISECONDS <= 0) {
                Message msg = handler.obtainMessage();
                msg.what = 2;
                msg.sendToTarget();
                return;
            }
            timeMILLISECONDS = timeMILLISECONDS - 1000;
            Message msg = handler.obtainMessage();
            msg.what = 1;
            msg.obj = timeMILLISECONDS;
            msg.sendToTarget();
        }
    }

    private void initWheel(CustomWheelView wheelPicker, List<String> mins, int type) {
        WheelView wheelView = wheelPicker.getWheel();
        wheelView.setData(mins);
        wheelView.setTextSize(45f);
        wheelPicker.setTextSpce(40);
        if (type == 0) {
            wheelPicker.setTextWidth(80, "小时");
        } else if (type == 1) {
            wheelPicker.setTextWidth(80, "分钟");
            wheelView.setSelectedPosition(5);
        } else {
            wheelPicker.setTextWidth(80, "秒");
        }
        wheelView.setCyclic(true);
    }

    @Override
    public void updateUserInfo() {
    }

    @Override
    public void clearUserInfo() {
    }
}
