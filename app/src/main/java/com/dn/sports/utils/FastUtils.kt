package com.dn.sports.utils

import android.app.Activity
import android.content.Context
import android.content.ContextWrapper
import android.view.View

object FastUtils {


    fun scanForActivity(context:Context?): Activity? {
        return if (context == null) null else if (context is Activity) context else if (context is ContextWrapper) scanForActivity(
            context.baseContext
        ) else null
    }
}

fun Context.getAct(): Activity?{
    return FastUtils.scanForActivity(this)
}

fun View.getAct(): Activity?{
    return FastUtils.scanForActivity(this.context)
}