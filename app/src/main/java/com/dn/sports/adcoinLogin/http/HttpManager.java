package com.dn.sports.adcoinLogin.http;

import android.content.Context;

import com.dn.sports.common.EyeLog;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import okhttp3.Call;
import okhttp3.MultipartBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

/**
 * Created by Administrator on 2019/5/19.
 */

public class HttpManager {

    public static final int RESULT_SUCCESS = 0;
    public static final int RESULT_FAILED = 1;
    public static final int RESULT_UNLOGIN= 2;

    public static HashMap<String, String> buildPublicParams(Context context) {
        HashMap<String, String> params = new HashMap<>();
//        params.put("clientType", "1");
//        params.put("brand", SystemUtils.getFatory());
//        params.put("model", SystemUtils.getPhoneType());
//        params.put("sysVersion",String.valueOf(SystemUtils.getAndroidVerStr()));
//        params.put("system","Android");
//        params.put("versionCode",String.valueOf(SystemUtils.getVersionCode(context)));
//        params.put("versionName",SystemUtils.getVersionName(context));
//        params.put("screenWidth",String.valueOf(SystemUtils.getScreenWidth(context)));
//        params.put("screenHeight",String.valueOf(SystemUtils.getScreenWidth(context)));
        return params;
    }

    //表单格式
    public static void requestForm(final String method, final HashMap<String, Object> params, final HttpRequester.Callback callback) {
        requestForm(method,params,callback,false);
    }

    public static void requestJson(final String method, final HashMap<String, Object> params, final HttpRequester.Callback callback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                HttpRequester hr = new HttpRequester();
                try {
                    String url = method;
                    hr.httpPostJson(url, params, new HttpRequester.Callback() {
                        @Override
                        public void onFailure(final Call call, final IOException e) {
                            callback.onFailure(call,e);

                        }
                        @Override
                        public void onResponse(final Call call, final Response response) throws IOException {
                            callback.onResponse(call,response);
                        }
                    });
                } catch (Exception e) {
                    EyeLog.logi("request exception:");
                    e.printStackTrace();
                } finally {

                }
            }
        }).start();
    }

    public static void requestSendPost(final Context context, final String method, final HashMap<String, String> params, final HttpRequester.Callback callback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                HttpRequester hr = new HttpRequester();
                try {
                    String url = method;
                    hr.sendPost(url, params, new HttpRequester.Callback() {
                        @Override
                        public void onFailure(final Call call, final IOException e) {
                            callback.onFailure(call,e);
                        }

                        @Override
                        public void onResponse(final Call call, final Response response) throws IOException {
                            try {
                                callback.onResponse(call,response);
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        }
                    });
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }).start();
    }



    public static void requestForm(final String method, final HashMap<String, Object> params, final HttpRequester.Callback callback, final boolean bShowDialg) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                HttpRequester hr = new HttpRequester();
                try {
                    String url = method;
                    hr.httpPostForm(url, params, new HttpRequester.Callback() {
                        @Override
                        public void onFailure(final Call call, final IOException e) {
                            callback.onFailure(call,e);
                        }

                        @Override
                        public void onResponse(final Call call, final Response response) throws IOException {
                            try {
                                callback.onResponse(call,response);
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        }
                    });
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {

                }
            }
        }).start();
    }

    //上传多文件多参数
    public static void requestWithFiles(final Context context, final String method, final HashMap<String, Object> params, final List<File> files, final HttpRequester.Callback callback, final boolean bShowDialg) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                HttpRequester hr = new HttpRequester();
                try {
                    String url = method;

                    hr.requestWithFiles(url, params,files, new HttpRequester.Callback() {
                        @Override
                        public void onFailure(Call call, IOException e) {
                            callback.onFailure(call,e);
                        }

                        @Override
                        public void onResponse(Call call, Response response) throws IOException {
                            callback.onResponse(call,response);
                        }
                    });
                } catch (Exception e) {
                    EyeLog.logi("httpManager exception:");
                    e.printStackTrace();
                } finally {
                }
            }
        }).start();
    }

    public static void upload(Context context, String url, String filePath, String fileName, final HttpRequester.Callback callback)  {
        try {
            //multipart/form-data
            OkHttpClient client = new OkHttpClient();

            RequestBody fileBody = RequestBody.create(MultipartBody.FORM, new File(filePath));
            MultipartBody.Builder builder=  new MultipartBody.Builder().setType(MultipartBody.FORM);

            builder.addFormDataPart("file",fileName,fileBody);

            Request request = new Request.Builder()
                   //
                    // .header("Authorization", "Client-ID " + UUID.randomUUID())
                    .url(url)
                    .post(builder.build())
                    .build();

            client.newCall(request).enqueue(new HttpRequester.Callback() {
                @Override
                public void onFailure(Call call, IOException e) {
                    callback.onFailure(call,e);
                }

                @Override
                public void onResponse(Call call, Response response) throws IOException {
                    callback.onResponse(call,response);
                }
            });
        } catch (Exception e) {
            EyeLog.logi("uploadfile exception:");
            e.printStackTrace();
        }
    }
}
