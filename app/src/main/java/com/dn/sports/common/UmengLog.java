package com.dn.sports.common;

import android.content.Context;

import com.umeng.analytics.MobclickAgent;

/**
 * Created by S on 2018/12/7.
 */
public class UmengLog {

    public interface ID{
        String SIGN = "sign";
        String SIGN_REQUEST = "sign_request";
        String SYNC_STEP = "sync_step";
        String LUCK_REWARD = "luck_reward";
        String INVITE_FRIEND = "invite_friend";
        String GET_RANDOM_COIN = "get_random_coin";
        String SET_STEP_TARGET = "set_step_target";
        String WRITE_INVITE_CODE = "write_invite_code";
        String GET_MONEY = "get_money";
        String USER_INFO = "user_info";
        String LOGIN = "login";
        String TASK_FIRST_LOGIN = "TASK_FIRST_LOGIN";
        String TASK_SYNC_STEP = "TASK_SYNC_STEP";
        String TASK_STEP_1 = "TASK_STEP_1";
        String TASK_STEP_2 = "TASK_STEP_2";
        String TASK_STEP_3 = "TASK_STEP_3";
        String TASK_STEP_4 = "TASK_STEP_4";
        String TASK_FRIEND_1 = "TASK_FRIEND_1";
        String TASK_FRIEND_2 = "TASK_FRIEND_2";
        String TASK_FRIEND_3 = "TASK_FRIEND_3";
        String TASK_FRIEND_4 = "TASK_FRIEND_4";
        String TASK_COIN_1 = "TASK_COIN_1";
        String TASK_COIN_2 = "TASK_COIN_2";
        String TASK_COIN_3 = "TASK_COIN_3";
        String TASK_COIN_4 = "TASK_COIN_4";
        String TASK_VIDEO_AD = "TASK_VIDEO_AD";
        String TASK_FIRST_GET_MONEY = "TASK_FIRST_GET_MONEY";
        String TASK_WRITE_INVITE_CODE = "TASK_WRITE_INVITE_CODE";
        String TASK_SHARE_INVITE = "TASK_SHARE_INVITE";
    }

    public static void logEvent(Context context, String event){
        MobclickAgent.onEvent(context, event);
    }
}
