package com.dn.sports.common;

import android.content.Context;

public class Constant {
    public interface SHARE_APP_PKG{
        String PENGYOUQUAN = "com.tencent.mm.ui.tools.ShareToTimeLineUI";
        String WEIXIN = "com.tencent.mm.ui.tools.ShareImgUI";
        String WEIBO = "com.sina.weibo.composerinde.ComposerDispatchActivity";
        String QQ = "com.tencent.mobileqq.activity.JumpActivity";

    }

    public static class WX_LOGIN{
        static final String WX_APP_ID = "wx487bd982149bc6e7";
        static final String WX_SECRET = "695b13faa3ba11ddbbba0075e0ee6765";

        public static String getWxAppId(Context context){
            return WX_APP_ID;
        }

        public static String getWxSecret(Context context){
            return WX_SECRET;
        }
    }
}
