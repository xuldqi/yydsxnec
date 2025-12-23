package com.dn.sports.common;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.pm.PackageManager;

public class CheckPermission {
    private static final String PERMISSION_READ_PHONE_STATE = Manifest.permission.READ_PHONE_STATE;
    private static final String PERMISSION_WRITE_EXTERNAL = Manifest.permission.WRITE_EXTERNAL_STORAGE;
    private static final String ACCESS_FINE_LOCATION = Manifest.permission.ACCESS_FINE_LOCATION;
    private static final String ACCESS_COARSE_LOCATION = Manifest.permission.ACCESS_COARSE_LOCATION;

    @TargetApi(23)
    public static boolean checkMustPermission(Activity act){
        String[] permissions = new String[]{
//                PERMISSION_READ_PHONE_STATE,
//                PERMISSION_WRITE_EXTERNAL,
                ACCESS_FINE_LOCATION,
                ACCESS_COARSE_LOCATION};

        for (int i = 0; i < permissions.length; i++) {
            if (act.checkSelfPermission(permissions[i]) != PackageManager.PERMISSION_GRANTED) {
                return false;
            }
        }
        return true;
    }

    @TargetApi(23)
    public static void requestMustPermission(Activity act, int mRequestCode){
        String[] permissions = new String[]{PERMISSION_READ_PHONE_STATE,
                PERMISSION_WRITE_EXTERNAL,ACCESS_FINE_LOCATION,ACCESS_COARSE_LOCATION};

        act.requestPermissions(permissions,mRequestCode);
    }

    @TargetApi(23)
    public static boolean checkWritePermission(Activity act){
        String[] permissions = new String[]{PERMISSION_WRITE_EXTERNAL};

        for (int i = 0; i < permissions.length; i++) {
            if (act.checkSelfPermission(permissions[i]) != PackageManager.PERMISSION_GRANTED) {
                return false;
            }
        }
        return true;
    }
    @TargetApi(23)
    public static void requestWritePermission(Activity act, int mRequestCode){
        String[] permissions = new String[]{PERMISSION_WRITE_EXTERNAL};
        act.requestPermissions(permissions, mRequestCode);
    }
}
