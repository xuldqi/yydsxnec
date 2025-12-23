package com.dn.sports.adcoinLogin.chuanshanjia;

import android.util.Log;

import com.bytedance.sdk.openadsdk.TTAppDownloadListener;

public class DownloadStatusListener implements TTAppDownloadListener {

    @Override
    public void onIdle() {
    }

    @Override
    public void onDownloadActive(long totalBytes, long currBytes, String fileName, String appName) {
        Log.d("DML", "onDownloadActive==totalBytes=" + totalBytes + ",currBytes=" + currBytes + ",fileName=" + fileName + ",appName=" + appName);
    }

    @Override
    public void onDownloadPaused(long totalBytes, long currBytes, String fileName, String appName) {
        Log.d("DML", "onDownloadPaused===totalBytes=" + totalBytes + ",currBytes=" + currBytes + ",fileName=" + fileName + ",appName=" + appName);
    }

    @Override
    public void onDownloadFailed(long totalBytes, long currBytes, String fileName, String appName) {
        Log.d("DML", "onDownloadFailed==totalBytes=" + totalBytes + ",currBytes=" + currBytes + ",fileName=" + fileName + ",appName=" + appName);
    }

    @Override
    public void onDownloadFinished(long totalBytes, String fileName, String appName) {
        Log.d("DML", "onDownloadFinished==totalBytes=" + totalBytes + ",fileName=" + fileName + ",appName=" + appName);
    }

    @Override
    public void onInstalled(String fileName, String appName) {
        Log.d("DML", "onInstalled==" + ",fileName=" + fileName + ",appName=" + appName);
    }
}