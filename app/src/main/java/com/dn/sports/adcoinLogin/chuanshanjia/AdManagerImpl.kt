package com.dn.sports.adcoinLogin.chuanshanjia

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.multidex.BuildConfig
import com.bytedance.sdk.openadsdk.AdSlot
import com.bytedance.sdk.openadsdk.TTAdConfig
import com.bytedance.sdk.openadsdk.TTAdConstant
import com.bytedance.sdk.openadsdk.TTAdLoadType
import com.bytedance.sdk.openadsdk.TTAdManager
import com.bytedance.sdk.openadsdk.TTAdNative
import com.bytedance.sdk.openadsdk.TTAdSdk
import com.bytedance.sdk.openadsdk.TTCustomController
import com.dn.sports.adcoinLogin.AdManager
import com.dn.sports.utils.ActivityHolder

object AdManagerImpl : AdManager {
    private  var sInit = false
    val TAG = "AdManagerImpl"

    fun initSdk(context:Context){
        if (!sInit) {
            //setp1.1：初始化SDK
            TTAdSdk.init(context, buildConfig())
            //setp1.2：启动SDK
            TTAdSdk.start(object : TTAdSdk.Callback {
                override fun success() {
                    Log.i(TAG, "success: " + TTAdSdk.isInitSuccess())
                }

                override fun fail(code: Int, msg: String) {
                    Log.i(TAG, "fail:  code = $code msg = $msg")
                }
            })
            sInit = true
        }
    }

    private fun buildConfig(): TTAdConfig? {
        return TTAdConfig.Builder()
            .appId("5430911")
            .useTextureView(true) //使用TextureView控件播放视频
            .allowShowNotify(true) //是否允许sdk展示通知栏提示
            .titleBarTheme(TTAdConstant.TITLE_BAR_THEME_DARK)
            .debug(BuildConfig.DEBUG) //测试阶段打开，可以通过日志排查问题，上线时去除该调用
            .directDownloadNetworkType(
                TTAdConstant.NETWORK_STATE_WIFI,
                TTAdConstant.NETWORK_STATE_3G
            ) //允许直接下载的网络状态集合
            .supportMultiProcess(false) //是否支持多进程
            // 隐私合规：添加自定义隐私控制器
            // 注意：完全禁止所有信息采集会导致广告无法展示
            .customController(object : TTCustomController() {
                // 禁止SDK获取手机状态信息(IMEI等) - 这是最敏感的信息
                override fun isCanUsePhoneState(): Boolean = false
                // 禁止SDK获取位置信息 - 广告不需要位置
                override fun isCanUseLocation(): Boolean = false
                // 允许SDK获取WiFi状态信息 - 广告需要网络信息
                override fun isCanUseWifiState(): Boolean = true
                // 允许SDK写入外部存储 - 缓存广告素材
                override fun isCanUseWriteExternal(): Boolean = true
                // 允许SDK获取AndroidId - 广告需要设备标识
                override fun isCanUseAndroidId(): Boolean = true
            })
            .build()
    }


    //step1:初始化sdk
    private var ttAdManager: TTAdManager? = null
    private var mTTAdNative: TTAdNative? = null
    private var mAdLoadListener: AdLoadListener? = null


    private fun getManger(activity: Activity,askPermiss:Boolean=false): TTAdManager {
        if (ttAdManager == null) {
            ttAdManager = TTAdSdk.getAdManager()
        }
        ttAdManager?.apply {
            if(askPermiss){
                requestPermissionIfNecessary(activity)
            }
            if (mTTAdNative == null) {
                mTTAdNative = ttAdManager!!.createAdNative(activity.applicationContext)
            }
        }
        return ttAdManager!!
    }


    override fun showAd(activity: Activity, adType: String,askPermiss:Boolean) {
        val disposeLoadAdd = {

        }
        ActivityHolder.observeLifeCycle(activity, disposeLoadAdd)
        getManger(activity)

        //step5:创建广告请求参数AdSlot
        val adSlot = AdSlot.Builder()
            .setCodeId(adType) // 广告代码位Id
            .setAdLoadType(TTAdLoadType.LOAD) // 本次广告用途：TTAdLoadType.LOAD实时；TTAdLoadType.PRELOAD预请求
            .build()
        //step6:注册广告加载生命周期监听，请求广告
        mAdLoadListener = AdLoadListener(activity)
        mTTAdNative!!.loadFullScreenVideoAd(adSlot, mAdLoadListener)

    }


}