package com.dn.sports.adcoinLogin;

import com.dn.sports.adcoinLogin.model.CoinRecord;
import com.dn.sports.adcoinLogin.model.RandomCoin;
import com.dn.sports.adcoinLogin.model.ShareRecord;
import com.dn.sports.adcoinLogin.model.SignRecord;
import com.dn.sports.adcoinLogin.model.StepsRecord;
import com.dn.sports.adcoinLogin.model.TaskModel;
import com.dn.sports.adcoinLogin.model.User;

import java.util.List;

public class LoginListener{
    public void onLogin(User info,boolean needUpdate){}

    public void onHintUserNew(User user){}

    public void onUserInfoUpdate(int msg,User info){}

    public void onRandomList(List<RandomCoin> datas){}

    public void onSign(){}

    public void onSignList(List<SignRecord> datas){}

    public void onCoinRecordList(List<CoinRecord> datas){}

    public void onShare(){}

    public void onShareList(List<ShareRecord> datas){}

    public void onSyncSteps(){}

    public void onStepChange(){}

    public void onSyncStepsList(List<StepsRecord> datas){}

    public void onAlreadySign(){}

    public void onRegisterError(String state,String message){}

    public void onTaskList(List<TaskModel> datas){}

    public void onGetCash(){}

    public void onGetTaskReward(TaskModel taskModel){}

    public void onUpdateTask(TaskModel taskModel){}

    //邀请码
    public void onInviteFirend(){}

    public void onSyncTaskAdResult(int reward){}

    public void onError(int msg,String info){}

    public void onExitLogin(){}

    public void onClearLogin(){}
}
