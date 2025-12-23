package com.dn.sports.utils

import android.content.Context
import android.os.Build
import android.os.Handler
import android.os.Message
import android.util.Log
import android.widget.Toast
import java.lang.reflect.Field

object HookToastUtils {
    private val TAG = HookToastUtils::class.java.simpleName
    private var sField_TN: Field? = null
    private var sField_TN_Handler: Field? = null

    private fun hookField(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.P) {
            try {
                sField_TN = Toast::class.java.getDeclaredField("mTN")
                sField_TN?.setAccessible(true)
                sField_TN_Handler = sField_TN?.getType()?.getDeclaredField("mHandler")
                sField_TN_Handler?.setAccessible(true)
                Log.i(TAG, "hook success")
                return true
            } catch (e: Exception) {
                Log.e(TAG, Log.getStackTraceString(e))
            }
        }
        return false
    }

    private fun hook(toast: Toast) {
        if (!hookField()) {
            return
        }
        try {
            val tn = sField_TN!![toast]
            val preHandler = sField_TN_Handler!![tn] as Handler
            sField_TN_Handler!![tn] = HookHandler(preHandler)
        } catch (e: Exception) {
            Log.e(TAG, Log.getStackTraceString(e))
        }
    }

    fun newToast(context: Context?): Toast {
        val toast = Toast(context)
        hook(toast)
        return toast
    }

    private class HookHandler(private val impl: Handler) : Handler() {
        override fun dispatchMessage(msg: Message) {
            try {
                super.dispatchMessage(msg)
            } catch (e: Exception) {
                Log.e(TAG, Log.getStackTraceString(e))
            }
        }

        override fun handleMessage(msg: Message) {
            impl.handleMessage(msg)
        }
    }
}