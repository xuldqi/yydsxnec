package com.dn.sports.adcoinLogin.http;


import android.util.Log;

import com.alibaba.fastjson.JSONObject;
import com.dn.sports.common.EyeLog;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import java.util.concurrent.TimeUnit;

import okhttp3.FormBody;
import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;

import static java.lang.String.valueOf;

public class HttpRequester {
    public static interface Callback extends okhttp3.Callback {
        
    }


    private String defaultContentEncoding;
      
    public HttpRequester() {     
      this.defaultContentEncoding = Charset.defaultCharset().name();
    }     
      

    public HttpRespons sendGet(String urlString) throws IOException {

        return this.send(urlString, "GET", null, null);     
    }     
      

    public HttpRespons sendGet(String urlString, Map<String, String> params)
            throws IOException {
        return this.send(urlString, "GET", params, null);     
    }     
      

    public HttpRespons sendGet(String urlString, Map<String, String> params,
                               Map<String, String> propertys) throws IOException {
        return this.send(urlString, "GET", params, propertys);     
    }     
      

    public HttpRespons sendPost(String urlString) throws IOException {
        return this.send(urlString, "POST", null, null);     
    }     
      

    public HttpRespons sendPost(String urlString, Map<String, String> params, Callback callback)
            throws IOException {
        return this.send(urlString, "POST", params, null,callback);
    }     
      



    private HttpRespons send(String urlString, String method,
                             Map<String, String> parameters, Map<String, String> propertys, Callback callback) throws IOException {
        HttpURLConnection urlConnection = null;

        if (method.equalsIgnoreCase("GET") && parameters != null) {
            StringBuffer param = new StringBuffer();
            int i = 0;
            for (String key : parameters.keySet()) {
                if (i == 0)
                    param.append("?");
                else
                    param.append("&");
                param.append(key).append("=").append(parameters.get(key));
                i++;
            }
            urlString += param;
        }
        URL url = new URL(urlString);
        urlConnection = (HttpURLConnection) url.openConnection();

        urlConnection.setRequestMethod(method);
        urlConnection.setDoOutput(true);
        urlConnection.setDoInput(true);
        urlConnection.setUseCaches(false);

        if (propertys != null)
            for (String key : propertys.keySet()) {
                urlConnection.addRequestProperty(key, propertys.get(key));
            }


        if (method.equalsIgnoreCase("POST") && parameters != null) {
            StringBuffer param = new StringBuffer();
            for (String key : parameters.keySet()) {
                param.append("&");
                param.append(key).append("=").append(parameters.get(key));
            }
            urlConnection.getOutputStream().write(param.toString().getBytes());
            urlConnection.getOutputStream().flush();
            urlConnection.getOutputStream().close();
        }
        HttpRespons resp = makeContent(urlString, urlConnection);
        return resp;
    }

    private HttpRespons send(String urlString, String method,
                             Map<String, String> parameters, Map<String, String> propertys)
            throws IOException {
      return send(urlString,method,parameters,propertys,null);
    }

    /**
     * json格式请求
     * @param url
     * @param params
     * @param callabck
     * @return
     * @throws Exception
     */
    public static String httpPostJson(String url, HashMap<String, Object> params, Callback callabck) throws Exception {
        OkHttpClient okHttpClient = new OkHttpClient.Builder().connectTimeout(6, TimeUnit.SECONDS).build();

        MediaType JSON= MediaType.parse("application/json; charset=utf-8");
        String jsonStr = JSONObject.toJSONString(params);
        EyeLog.logi("(json) upload params:" + jsonStr + ",url = " + url);
        RequestBody body = RequestBody.create(JSON, jsonStr);
        Request request = new Request.Builder().url(url).post(body).addHeader("content-type", "application/json").build();
        okHttpClient.newCall(request).enqueue(callabck);
        return "";
    }

    /**
     * 表单格式请求
     * @param url
     * @param params
     * @param callabck
     * @return
     * @throws Exception
     */
    public static String httpPostForm(String url, HashMap<String, Object> params, Callback callabck) throws Exception {
        OkHttpClient okHttpClient = new OkHttpClient.Builder().connectTimeout(6, TimeUnit.SECONDS).build();

        String jsonStr = JSONObject.toJSONString(params);
        EyeLog.logd("(form) upload params:" + jsonStr + ",url = " + url);

        FormBody.Builder builder = new FormBody.Builder();
        for (String key : params.keySet()) {
            builder.add(key,  String.valueOf(params.get(key)));
        }

        FormBody formBody = builder.build();

        Request request = new Request.Builder().url(url).post(formBody).build();
        okHttpClient.newCall(request).enqueue(callabck);
        return "";
    }


    /**
     * 将响应的数据流转换成字符串
     *
     * @param is
     * @return
     */
    public static String convertStreamToString(InputStream is) {
        StringBuilder sb = new StringBuilder();
        String line = null;
        try {
            BufferedReader reader = new BufferedReader(new InputStreamReader(is,"UTF-8"));
            while ((line = reader.readLine()) != null) {
                sb.append(line + "\n");
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                is.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return sb.toString();
    }
      

    private HttpRespons makeContent(String urlString,
                                    HttpURLConnection urlConnection) throws IOException {
        HttpRespons httpResponser = new HttpRespons();     
        try {     
            InputStream in = urlConnection.getInputStream();
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(in,"utf-8"));
            httpResponser.contentCollection = new Vector<String>();
            StringBuffer temp = new StringBuffer();
            String line = bufferedReader.readLine();
            while (line != null) {     
                httpResponser.contentCollection.add(line);     
                temp.append(line).append("\r\n");     
                line = bufferedReader.readLine();     
            }     
            bufferedReader.close();     
      
            String ecod = urlConnection.getContentEncoding();
            if (ecod == null)     
                ecod = this.defaultContentEncoding;     
      
            httpResponser.urlString = urlString;     
      
            httpResponser.defaultPort = urlConnection.getURL().getDefaultPort();     
            httpResponser.file = urlConnection.getURL().getFile();     
            httpResponser.host = urlConnection.getURL().getHost();     
            httpResponser.path = urlConnection.getURL().getPath();     
            httpResponser.port = urlConnection.getURL().getPort();     
            httpResponser.protocol = urlConnection.getURL().getProtocol();     
            httpResponser.query = urlConnection.getURL().getQuery();     
            httpResponser.ref = urlConnection.getURL().getRef();     
            httpResponser.userInfo = urlConnection.getURL().getUserInfo();     
      
            httpResponser.content = new String(temp.toString().getBytes(), ecod);
            httpResponser.contentEncoding = ecod;     
            httpResponser.code = urlConnection.getResponseCode();     
            httpResponser.message = urlConnection.getResponseMessage();     
            httpResponser.contentType = urlConnection.getContentType();     
            httpResponser.method = urlConnection.getRequestMethod();     
            httpResponser.connectTimeout = urlConnection.getConnectTimeout();     
            httpResponser.readTimeout = urlConnection.getReadTimeout();     
      
            return httpResponser;     
        } catch (IOException e) {
            throw e;     
        } finally {     
            if (urlConnection != null)     
                urlConnection.disconnect();     
        }     
    }






    protected void requestWithFiles(final String url, final Map<String, Object> map, List<File> files, Callback callabck) {

        OkHttpClient client = new OkHttpClient();
        // form 表单形式上传
        MultipartBody.Builder requestBody = new MultipartBody.Builder().setType(MultipartBody.FORM);
        // MultipartBody.Builder requestBody = new MultipartBody.Builder().setType(MediaType.parse("text/plain"));

        if (files != null) {
            for (File file : files) {
                RequestBody body = RequestBody.create(MediaType.parse("application/octet-stream"), file);
                String filename = file.getName();
                requestBody.addFormDataPart("files", file.getName(), body);
            }
        }


        if (map != null) {
            //String jsonStr = JSONObject.toJSONString(map);
            //requestBody.addPart(Headers.of("Content-Disposition", "form-data;name=\"" + "data" + "\""), RequestBody.create(MediaType.parse("text/plain"), jsonStr));
            //requestBody.addFormDataPart(valueOf(entry.getKey()), valueOf(entry.getValue()));

            // map 里面是请求中所需要的 key 和 value
            for (Map.Entry entry : map.entrySet()) {
                //String value = (String) entry.getValue();
                //requestBody.addPart(Headers.of("Content-Disposition", "form-data;name=\"" + entry.getKey() + "\""), RequestBody.create(MediaType.parse("text/plain"), value));
                EyeLog.logi("requestWithFiles keyvalues : " + valueOf(entry.getKey()) + "  , " + valueOf(entry.getValue()));
                requestBody.addFormDataPart(valueOf(entry.getKey()), valueOf(entry.getValue()));
            }
        }



       // Log.i("aleck","uploadfiles params:" + requestBody.build() + ",url = " + url);
        Request request = new Request.Builder().url(url).post(requestBody.build()).build();


        // readTimeout("请求超时时间" , 时间单位);
        client.newBuilder().readTimeout(10000, TimeUnit.MILLISECONDS).build().newCall(request).enqueue(callabck);

    }

}  