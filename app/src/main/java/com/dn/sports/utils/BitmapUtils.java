package com.dn.sports.utils;

import android.graphics.Bitmap;

import com.baidubce.util.StringUtils;

import java.io.File;
import java.io.FileOutputStream;

public class BitmapUtils {

    private static int DEAFULT_QUALITY = 100;

    public static interface SharePictureCallBack {
        void onsuccess();

        void onFailed(Exception e);
    }


    public static boolean delete(String path) {
        return !StringUtils.isEmpty(path) && delete(new File(path));
    }

    public static boolean delete(File path) {
        if (path.isDirectory()) {
            File[] files = path.listFiles();
            if(files == null || files.length == 0){
                return false;
            }
            for (File file : files) {
                if (!delete(file)) {
                    return false;
                }
            }
        }
        return !path.exists() || path.delete();
    }

    public static void saveBitmap(final Bitmap bitmap, final String savePath, SharePictureCallBack callBack) {
        delete(savePath);
        FileOutputStream fileOutputStream = null;
        try {
            fileOutputStream = new FileOutputStream(savePath);
            bitmap.compress(Bitmap.CompressFormat.JPEG, DEAFULT_QUALITY, fileOutputStream);
            fileOutputStream.flush();
            if (callBack != null) {
                callBack.onsuccess();
            }
        } catch (Exception e) {
            if (callBack != null) {
                callBack.onFailed(e);
            }
            e.printStackTrace();
        } finally {
            try {
                fileOutputStream.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
