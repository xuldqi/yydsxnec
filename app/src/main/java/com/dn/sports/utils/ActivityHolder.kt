package com.dn.sports.utils

import android.annotation.SuppressLint
import android.app.Activity
import android.app.ActivityManager
import android.app.Application
import android.content.ComponentName
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.os.Bundle
import android.os.Process
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.LifecycleOwner
import com.dn.sports.common.LogUtils

@SuppressLint("StaticFieldLeak")
object ActivityHolder : BaseActivityLifecycleCallbacks() {

    var TAG = "ActivityHolder"
    /**
     * 保存在栈里的所有Activity
     */
    val mActivities = mutableListOf<Activity>()

    lateinit var mApp: Application
    fun init(app: Application) {
        mApp = app
        mApp.registerActivityLifecycleCallbacks(this)
    }

    /**
     * 当前显示的Activity，必须是onResume状态
     */
    @JvmStatic
    var mCurrentActivity: Activity? = null
        get() {
            if (field == null && mActivities.size > 0) {
                return mActivities[0]
            }
            return field
        }


    override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
        mActivities.add(activity)
        LogUtils.d(TAG, "onActivityCreated ${activity.javaClass}")
    }

    override fun onActivityDestroyed(activity: Activity) {
        mActivities.remove(activity)
        LogUtils.d(TAG, "onActivityDestroyed ${activity.javaClass}")
    }

    override fun onActivityStopped(activity: Activity) {
        super.onActivityStopped(activity)
        if (activity.isFinishing) {
            mActivities.remove(activity)
            LogUtils.d(TAG, "onActivityStopped ${activity.javaClass}")
        }
    }

    /**
     * 当Activity执行onResume时调用 - 保存当前显示的activity，更新栈顶Activity
     *
     * @param activity 执行onResume的Activity
     */
    override fun onActivityResumed(activity: Activity) {
        mCurrentActivity = activity
    }


    /**
     * 当Activity执行onPause时调用 - 清除当前显示的Activity
     *
     * @param activity 执行onPause的Activity
     */
    override fun onActivityPaused(activity: Activity) {
        mCurrentActivity = null
    }

    /**
     * 退出APP
     */
    fun exitApp() {
        finishActivities()
        (mApp.getSystemService(Context.ACTIVITY_SERVICE) as? ActivityManager)?.runningAppProcesses?.forEach {
            if (it.pid !== Process.myPid()) {
                Process.killProcess(it.pid)
            }
        }
        Process.killProcess(Process.myPid())
    }

    @JvmStatic
    fun checkActivityByContext(context: Context?): Boolean {
        val activity = scanForActivity(context)
        return activity != null && !activity.isFinishing
    }


    @JvmStatic
    fun scanForActivity(context: Context?): Activity? {
        return if (context == null) null else if (context is Activity) context else if (context is ContextWrapper) scanForActivity(
            context.baseContext
        ) else null
    }

    @JvmStatic
    fun scanForFragmentActivity(context: Context?): FragmentActivity? {
        return scanForActivity(context) as? FragmentActivity
    }


    fun isActivityActive(context: Context?): Boolean {
        val activity = scanForActivity(context) ?: return false
        return !(activity.isFinishing || activity.isDestroyed)
    }

    /**
     * 根据context，监听宿主activity ON_DESTROY 事件
     */
    @JvmStatic
    fun observeLifeCycle(context: Context?, onDestory: () -> Unit, onStop: () -> Unit = {}) {
        val currentActivity = scanForActivity(context)
        (currentActivity as? FragmentActivity)?.lifecycle?.addObserver(object :
            LifecycleEventObserver {
            override fun onStateChanged(source: LifecycleOwner, event: Lifecycle.Event) {
                if (event == Lifecycle.Event.ON_STOP) {
                    onStop.invoke()
                    if (currentActivity.isFinishing) {
                        onDestory.invoke()
                    }
                } else if (event == Lifecycle.Event.ON_DESTROY) {
                    currentActivity.lifecycle.removeObserver(this)
                }
            }
        })
    }

    fun finishActivities(handler: (activity: Activity) -> Boolean = { true}) {
        for (activity in mActivities) {
            if (!handler.invoke(activity)) {
                activity.finish()
            }
        }
        mActivities.clear()
    }

    @JvmStatic
    fun toStartupActivity() {
        val intent = Intent()
        intent.component = ComponentName("com.gaopeng.party", "com.gaopeng.party.StartupActivity")
        mCurrentActivity?.startActivity(intent)
        finishActivities{it::class.java.simpleName == "StartupActivity"}
    }

    fun isActivityInHistory(thisClass: Class<out Activity?>): Activity? {
        return if (mActivities != null && !mActivities.isEmpty()) {
            for (activity in mActivities) {
                if (activity.javaClass == thisClass) {
                    return activity
                }
            }
            null
        } else {
            null
        }
    }


}