package com.dn.sports.utils

import android.annotation.SuppressLint
import android.content.Context
import android.util.Log
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.widget.TextView
import android.widget.Toast
import androidx.annotation.LayoutRes
import com.dn.sports.R

@SuppressLint("StaticFieldLeak")
object ToastUtils {


    private var sContext //Application 的context
            : Context? = null
    private var sToast: Toast? = null
    private var mToastView: View? = null

    /**
     * 初始化
     *
     * @param context context
     */
    fun init(context: Context?) {
        sContext = context
    }

    fun showToast(message: String?, duration: Int = Toast.LENGTH_SHORT) {
        showToast(message, duration, Gravity.CENTER, 0, DisplayUtils.dp2px(25))
    }

    fun cancelToast() {
        if (sToast != null) {
            sToast!!.cancel()
        }
    }

    fun showToast(message: String?, duration: Int, Gravity: Int, xoffset: Int, yoffset: Int) {
        try {
            if (sToast == null) {
                sToast = HookToastUtils.newToast(sContext)
            }
            sToast!!.setGravity(Gravity, xoffset, yoffset)
            mToastView = LayoutInflater.from(sContext).inflate(R.layout.toast_layout, null)
            sToast!!.setView(mToastView)
            if (mToastView != null) {
                val textView = mToastView!!.findViewById<View>(R.id.textView_message) as TextView
                textView.text = message
            }
            sToast!!.duration = duration
            sToast!!.show()
        } catch (e: Exception) {
            Log.e("Toast", Log.getStackTraceString(e))
        }
    }






    fun showToast(message: String?) {
        showToast(message, Toast.LENGTH_SHORT)
    }

    var SHOW_TOAST_TIME: Long = 0
    fun showToastDelayCheck(message: String?, delayTime: Long) {
        if (System.currentTimeMillis() - SHOW_TOAST_TIME >= delayTime) {
            showToast(message)
            SHOW_TOAST_TIME = System.currentTimeMillis()
        }
    }


    fun showToast(message: String?, duration: Int, Gravity: Int) {
        showToast(message, duration, Gravity, 0, 0)
    }


    fun showToast(resId: Int) {
        showToast(sContext!!.getString(resId))
    }


    fun showLongToast(message: String?) {
        showToast(message, Toast.LENGTH_LONG)
    }


    fun showLongToast(resId: Int) {
        showLongToast(sContext!!.getString(resId))
    }


}