package com.dn.sports.fragment;

import android.os.Bundle;
import android.os.Message;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.dn.sports.common.UIHandler;

import org.greenrobot.eventbus.EventBus;

public abstract class BaseFragment extends Fragment {

    protected View view;
    private UIHandler mActivityHandler;

    public boolean openEventBus(){
        return false;
    }

    public abstract View getViewByLayout(LayoutInflater inflater, ViewGroup container,Bundle savedInstanceState);

    public abstract void initViewAction(View view);


    public void setActivityHandler(UIHandler activityHandler){
        mActivityHandler = activityHandler;
    }

    protected void setMessageToActivity(Message msg){
        if(mActivityHandler == null) {
            Log.i("BaseFragment","setMessageToActivity error");
            return;
        }
        mActivityHandler.sendMessage(msg);
    }

    protected Message obtainMessage(){
        Message msg;
        if(mActivityHandler != null) {
            msg = mActivityHandler.obtainMessage();
        }else {
            msg = new Message();
        }
        return msg;
    }

    @Override
    final public View onCreateView(LayoutInflater inflater,ViewGroup container,Bundle savedInstanceState) {
        view = getViewByLayout(inflater,container,savedInstanceState);
        initViewAction(view);
        return view;
    }


    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if(openEventBus()){
            EventBus.getDefault().register(this);
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if(openEventBus()){
            EventBus.getDefault().unregister(this);
        }
    }

    public abstract void updateUserInfo();

    public abstract void clearUserInfo();
}
