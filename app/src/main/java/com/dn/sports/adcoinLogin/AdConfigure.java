package com.dn.sports.adcoinLogin;

import android.content.Context;
import android.os.Handler;

import com.dn.sports.StepApplication;
import com.dn.sports.common.EyeLog;
import com.dn.sports.utils.Utils;

import org.json.JSONException;
import org.json.JSONObject;

import retrofit2.Call;
import retrofit2.Response;
import retrofit2.Retrofit;

public class AdConfigure {

    public static final int SHOW_AD = 5;
    public static final int HIDE_AD = 6;
    public static final int ERROR_AD = 7;

    public static void getAdConfigure(Context context, final Handler handler){
        if (Utils.isNetworkAvailable(context)) {
            Retrofit retrofit = new Retrofit.Builder()
                    .baseUrl(Utils.AD_CHECK_URL)
                    .addConverterFactory(new ToStringConverterFactory())
                    .build();

            final Ad.AdData uiData = retrofit.create(Ad.AdData.class);
            String id ="14";
            int verCode =Utils.getVersionCode(context);
            String channel =Utils.getMarket(context);
            Call<String> call = uiData.getAdShow(id,verCode,channel);
            EyeLog.logi("AdConfigure->id:"+id+",verCode:"+verCode+",channel:"+channel);
            call.enqueue(new retrofit2.Callback<String>() {
                @Override
                public void onResponse(Call<String> call, Response<String> response) {
                    String data = response.body();
                    try {
                        JSONObject jsonObject = new JSONObject(data);
                        EyeLog.logi("getAdConfigure:"+data);
                        int showAd = jsonObject.optInt("showad");
                        int showProduct = jsonObject.optInt("showProduct");

                        if(showProduct != 0) {
                            StepApplication.getInstance().setShowProduct(true);
                        }else{
                            StepApplication.getInstance().setShowProduct(false);
                        }

                        if(showAd != 0){
                            StepApplication.getInstance().setShowAd(true);
                            handler.sendEmptyMessage(SHOW_AD);
                        }else{
                            StepApplication.getInstance().setShowAd(false);
                            handler.sendEmptyMessage(HIDE_AD);
                        }
                    }catch (JSONException e){
                        e.printStackTrace();
                        handler.sendEmptyMessage(ERROR_AD);
                    }catch (NullPointerException e){
                        e.printStackTrace();
                        handler.sendEmptyMessage(ERROR_AD);
                    }
                }

                @Override
                public void onFailure(Call<String> call, Throwable t) {
                    handler.sendEmptyMessage(ERROR_AD);
                }
            });
        }
    }
}
