//package com.dn.sports.adcoinLogin;
//
//import android.content.ComponentName;
//import android.content.Context;
//import android.content.Intent;
//import android.net.Uri;
//
//import com.dn.sports.BuildConfig;
//
//public class AppDetailUtils {
//
//    private static Intent getAppDetailSettingIntent(Context context) {
//        Intent localIntent = new Intent();
//        localIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//        localIntent.setAction("android.settings.APPLICATION_DETAILS_SETTINGS");
//        localIntent.setData(Uri.fromParts("package", context.getPackageName(), null));
//
//        return localIntent;
//    }
//
//    public static void getPermission(Context context){
//        try {
//            Intent intent = new Intent();
//            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//            ComponentName comp = new ComponentName("com.huawei.systemmanager", "com.huawei.permissionmanager.ui.MainActivity");//华为权限管理
//            intent.setComponent(comp);
//            context.startActivity(intent);
//            return;
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        try {
//            Intent intent = new Intent("com.meizu.safe.security.SHOW_APPSEC");
//            intent.addCategory(Intent.CATEGORY_DEFAULT);
//            intent.putExtra("packageName", BuildConfig.APPLICATION_ID);
//            context.startActivity(intent);
//            return;
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//
//        try { // MIUI 8
//            Intent localIntent = new Intent("miui.intent.action.APP_PERM_EDITOR");
//            localIntent.setClassName("com.miui.securitycenter", "com.miui.permcenter.permissions.PermissionsEditorActivity");
//            localIntent.putExtra("extra_pkgname", context.getPackageName());
//            context.startActivity(localIntent);
//            return;
//        } catch (Exception e) {
//            try { // MIUI 5/6/7
//                Intent localIntent = new Intent("miui.intent.action.APP_PERM_EDITOR");
//                localIntent.setClassName("com.miui.securitycenter", "com.miui.permcenter.permissions.AppPermissionsEditorActivity");
//                localIntent.putExtra("extra_pkgname", context.getPackageName());
//                context.startActivity(localIntent);
//                return;
//            } catch (Exception e1) { // 否则跳转到应用详情
//                e.printStackTrace();
//            }
//        }
//        context.startActivity(getAppDetailSettingIntent(context));
//    }
//}
