package com.dn.sports.common;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.pm.PackageManager;

/**
 * 权限检查和请求工具类
 * 隐私合规：所有权限请求前都会弹窗说明用途，用户同意后才调用系统权限请求
 * 注意：各权限应按需单独请求，不应捆绑申请
 */
public class CheckPermission {
    /**
     * 请求健身运动(步数)权限 (Android 10+)
     */
    @TargetApi(29)
    public static void requestStepPermission(Activity act, int mRequestCode) {
        if (android.os.Build.VERSION.SDK_INT >= 29) {
            showStepPermissionDialog(act, mRequestCode);
        }
    }

    /**
     * 检查是否有步数权限
     */
    @TargetApi(23)
    public static boolean checkStepPermission(Activity act) {
        if (android.os.Build.VERSION.SDK_INT >= 29) {
            return act.checkSelfPermission("android.permission.ACTIVITY_RECOGNITION") == PackageManager.PERMISSION_GRANTED;
        }
        return true;
    }

    /**
     * 显示健身运动权限说明弹窗
     */
    private static void showStepPermissionDialog(final Activity act, final int requestCode) {
        new AlertDialog.Builder(act)
                .setTitle("健身运动权限申请")
                .setMessage("我们需要获取您的健身运动权限来同步手机系统的真实步数结果。如果不开启此权限，应用将无法记录您的真实运动量。\n\n您可以在系统设置中随时关闭此权限。")
                .setPositiveButton("去授权", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        if (android.os.Build.VERSION.SDK_INT >= 29) {
                            act.requestPermissions(new String[]{"android.permission.ACTIVITY_RECOGNITION"}, requestCode);
                        }
                    }
                })
                .setNegativeButton("拒绝", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.dismiss();
                    }
                })
                .setCancelable(false)
                .show();
    }
}
