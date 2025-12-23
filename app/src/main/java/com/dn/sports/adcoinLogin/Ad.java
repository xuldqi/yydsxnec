package com.dn.sports.adcoinLogin;

import com.dn.sports.utils.Utils;

import retrofit2.Call;
import retrofit2.http.POST;
import retrofit2.http.Query;

/**
 * Created by Sdy on 2018/12/18.
 */
public class Ad {
    public interface AdData {
        @POST(Utils.AD_CHECK_URL)
        Call<String> getAdShow(@Query("id") String id, @Query("version") int version, @Query("channel") String channel);
    }

    public static class Login{
        public static  final int AD_W = 320;
        public static  final int AD_H = 250;

        public static final int MSG_REGISTER = 1001;
        public static final int MSG_MODIFY_USER_INFO = 1002;
        public static final int MSG_GET_USER_INFO = 1003;
        public static final int MSG_SIGN = 1004;
        public static final int MSG_SIGN_LIST = 1005;
        public static final int MSG_INVITE_FRIEND = 1006;
        public static final int MSG_INVITE_FRIEND_LIST = 1007;
        public static final int MSG_GET_RANDOM_COIN_LIST = 1008;
        public static final int MSG_GET_RANDOM_COIN = 1009;
        public static final int MSG_UPLOAD_SHARE_ACTION = 1010;
        public static final int MSG_GET_SHARE_RECORD = 1011;
        public static final int MSG_SYNC_STEPS = 1012;
        public static final int MSG_GET_STEPS_RECORD = 1013;
        public static final int MSG_GET_TASK_LIST = 1014;
        public static final int MSG_GET_MONEY = 1015;
        public static final int MSG_GET_REWARD = 1016;
        public static final int MSG_UPDATE_TASK = 1017;
        public static final int MSG_SYNC_TASK_RESULT = 1018;
        public static final int MSG_COIN_RECORD_LIST = 1019;
        public static final int UNKNOWN_ERROR = 2000;


        static final String TEST_BASE_URL1 = "http://e284h44000.qicp.vip:54166";
        static final String TEST_BASE_URL = "http://e284h44000.qicp.vip:80";
        static final String REAL_BASE_URL = "http://IP:PORT";
        static final String REAL_URL = "https://www.moningcall.cn";
        static final String BASE_URL = REAL_URL;
        static final String RIGISTER = BASE_URL+"/zlzq/account/login.do";
        static final String MODIFY_USER_INFO = BASE_URL+"/zlzq/account/modifyUser.do";
        static final String GET_USER_INFO = BASE_URL+"/zlzq/account/getUserInfo.do";
        static final String SIGN = BASE_URL+"/zlzq/sign/sign.do";
        static final String SIGN_LIST = BASE_URL+"/zlzq/sign/fetchSignRecord.do";
        static final String INVITE_FRIEND = BASE_URL+"/zlzq/invite/invite.do";
        static final String INVITE_FRIEND_LIST = BASE_URL+"/zlzq/invite/getInviteList.do";
        static final String GET_RANDOM_COIN_LIST = BASE_URL+"/zlzq/randgold/getAllGold.do";
        static final String GET_RANDOM_COIN = BASE_URL+"/zlzq/randgold/recGold.do";
        static final String UPLOAD_SHARE_ACTION = BASE_URL+"/zlzq/share/share.do";
        static final String GET_SHARE_RECORD = BASE_URL+"/zlzq/share/fetchShareRecord.do";
        static final String SYNC_STEPS = BASE_URL+"/zlzq/step/syncStep.do";
        static final String GET_STEPS_RECORD = BASE_URL+"/zlzq/step/fetchStepRecord.do";
        static final String GET_MONEY = BASE_URL+"/zlzq/cash/cashout.do";
        static final String GET_TASK_LIST = BASE_URL+"/zlzq/task/getTaskList.do";
        static final String GET_REWARD = BASE_URL+"/zlzq/task/getReward.do";
        static final String UPDATE_SINGLE_TASK = BASE_URL+"/zlzq/task/getTask.do";
        static final String SYNC_TASK_RESULT = BASE_URL+"/zlzq/task/syncTaskResult.do";
        static final String COIN_RECORD_LIST = BASE_URL+"/zlzq/task/getTaskRecordList.do";

        public static String msgToUrl(int msg){
            switch (msg) {
                case MSG_REGISTER:
                    return RIGISTER;
                case MSG_MODIFY_USER_INFO:
                    return MODIFY_USER_INFO;
                case MSG_GET_USER_INFO:
                    return GET_USER_INFO;
                case MSG_SIGN:
                    return SIGN;
                case MSG_SIGN_LIST:
                    return SIGN_LIST;
                case MSG_INVITE_FRIEND:
                    return INVITE_FRIEND;
                case MSG_INVITE_FRIEND_LIST:
                    return INVITE_FRIEND_LIST;
                case MSG_GET_RANDOM_COIN_LIST:
                    return GET_RANDOM_COIN_LIST;
                case MSG_GET_RANDOM_COIN:
                    return GET_RANDOM_COIN;
                case MSG_UPLOAD_SHARE_ACTION:
                    return UPLOAD_SHARE_ACTION;
                case MSG_GET_SHARE_RECORD:
                    return GET_SHARE_RECORD;
                case MSG_SYNC_STEPS:
                    return SYNC_STEPS;
                case MSG_GET_STEPS_RECORD:
                    return GET_STEPS_RECORD;
                case MSG_GET_TASK_LIST:
                    return GET_TASK_LIST;
                case MSG_GET_MONEY:
                    return GET_MONEY;
                case MSG_GET_REWARD:
                    return GET_REWARD;
                case MSG_UPDATE_TASK:
                    return UPDATE_SINGLE_TASK;
                case MSG_SYNC_TASK_RESULT:
                    return SYNC_TASK_RESULT;
                case MSG_COIN_RECORD_LIST:
                    return COIN_RECORD_LIST;
            }
            return "";
        }

        public static String msgToString(int msg){
            switch (msg) {
                case MSG_REGISTER:
                    return "注册";
                case MSG_MODIFY_USER_INFO:
                    return "修改用户信息";
                case MSG_GET_USER_INFO:
                    return "获取用户信息";
                case MSG_SIGN:
                    return "签到";
                case MSG_SIGN_LIST:
                    return "签到列表";
                case MSG_INVITE_FRIEND:
                    return "邀请好友";
                case MSG_INVITE_FRIEND_LIST:
                    return "邀请好友列表";
                case MSG_GET_RANDOM_COIN_LIST:
                    return "随机金币列表";
                case MSG_GET_RANDOM_COIN:
                    return "获取随机金币";
                case MSG_UPLOAD_SHARE_ACTION:
                    return "分享上传";
                case MSG_GET_SHARE_RECORD:
                    return "分享列表";
                case MSG_SYNC_STEPS:
                    return "同步步数";
                case MSG_GET_STEPS_RECORD:
                    return "步数列表";
                case MSG_GET_TASK_LIST:
                    return "任务列表";
                case MSG_GET_MONEY:
                    return "提现";
                case MSG_GET_REWARD:
                    return "任务奖励";
                case MSG_SYNC_TASK_RESULT:
                    return "同步任务结果";
                case MSG_UPDATE_TASK:
                    return "更新单个任务";
                case MSG_COIN_RECORD_LIST:
                    return "金币记录";
            }
            return "Unknown";
        }
    }
}
