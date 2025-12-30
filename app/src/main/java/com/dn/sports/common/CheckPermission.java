package com.dn.sports.common;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.pm.PackageManager;

/**
 * 权限检查和请求工具类
 * 隐私合规：所有权限请求前都会弹窗说明用途，用户同意后才调用系统权限请求
 */
public class CheckPermission {
    private static final String PERMISSION_READ_PHONE_STATE = Manifest.permission.READ_PHONE_STATE;
    private static final String PERMISSION_WRITE_EXTERNAL = Manifest.permission.WRITE_EXTERNAL_STORAGE;
    private static final String ACCESS_FINE_LOCATION = Manifest.permission.ACCESS_FINE_LOCATION;
    private static final String ACCESS_COARSE_LOCATION = Manifest.permission.ACCESS_COARSE_LOCATION;

    @TargetApi(23)
    public static boolean checkMustPermission(Activity act){
        String[] permissions = new String[]{
                ACCESS_FINE_LOCATION,
                ACCESS_COARSE_LOCATION};

        for (int i = 0; i < permissions.length; i++) {
            if (act.checkSelfPermission(permissions[i]) != PackageManager.PERMISSION_GRANTED) {
                return false;
            }
        }
        return true;
    }

    /**
     * 请求必要权限（位置+存储）
     * 隐私合规：先弹窗说明权限用途，用户点击同意后才请求权限
     */
    @TargetApi(23)
    public static void requestMustPermission(Activity act, int mRequestCode){
        // 隐私合规：先弹窗说明为什么需要这些权限
        showPermissionExplainDialog(act, mRequestCode);
    }

    /**
     * 显示权限说明弹窗
     */
    private static void showPermissionExplainDialog(final Activity act, final int requestCode) {
        new AlertDialog.Builder(act)
                .setTitle("权限申请说明")
                .setMessage("为了给您提供更好的服务，我们需要以下权限：\n\n" +
                        "• 位置权限：用于记录您的户外运动轨迹和计算运动距离\n\n" +
                        "• 存储权限：用于保存运动数据和缓存应用资源\n\n" +
                        "您可以在系统设置中随时关闭这些权限。")
                .setPositiveButton("同意", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        // 用户同意后，调用系统权限请求
                        String[] permissions = new String[]{
                                PERMISSION_WRITE_EXTERNAL,
                                ACCESS_FINE_LOCATION,
                                ACCESS_COARSE_LOCATION};
                        act.requestPermissions(permissions, requestCode);
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

    /**
     * 请求存储权限
     * 隐私合规：先弹窗说明权限用途
     */
    @TargetApi(23)
    public static void requestWritePermission(Activity act, int mRequestCode){
        showStoragePermissionDialog(act, mRequestCode);
    }

    /**
     * 显示存储权限说明弹窗
     */
    private static void showStoragePermissionDialog(final Activity act, final int requestCode) {
        new AlertDialog.Builder(act)
                .setTitle("存储权限申请")
                .setMessage("我们需要存储权限来保存您的运动数据和应用缓存。\n\n您可以在系统设置中随时关闭此权限。")
                .setPositiveButton("同意", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        String[] permissions = new String[]{PERMISSION_WRITE_EXTERNAL};
                        act.requestPermissions(permissions, requestCode);
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

    /**
     * 仅请求位置权限（带弹窗说明）
     */
    @TargetApi(23)
    public static void requestLocationPermission(Activity act, int mRequestCode) {
        showLocationPermissionDialog(act, mRequestCode);
    }

    /**
     * 显示位置权限说明弹窗
     */
    private static void showLocationPermissionDialog(final Activity act, final int requestCode) {
        new AlertDialog.Builder(act)
                .setTitle("位置权限申请")
                .setMessage("我们需要位置权限来记录您的户外运动轨迹和计算运动距离。\n\n" +
                        "• 仅在您使用户外运动功能时采集位置\n" +
                        "• 不会在后台自动采集位置信息\n\n" +
                        "您可以在系统设置中随时关闭此权限。")
                .setPositiveButton("同意", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        String[] permissions = new String[]{
                                ACCESS_FINE_LOCATION,
                                ACCESS_COARSE_LOCATION};
                        act.requestPermissions(permissions, requestCode);
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
