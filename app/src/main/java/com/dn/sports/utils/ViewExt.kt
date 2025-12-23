package com.dn.sports.utils

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.graphics.Outline
import android.graphics.Rect
import android.os.Build
import android.view.TouchDelegate
import android.view.View
import android.view.ViewGroup
import android.view.ViewOutlineProvider
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import com.dn.sports.utils.ViewExt.ViewClickDelay.SPACE_TIME


class ViewExt {

    object ViewClickDelay {
        var hash: Int = 0
        var lastClickTime: Long = 0
        var SPACE_TIME: Long = 1000
    }


}

fun View.round(cornerRadius: Int) {
    val viewOutlineProvider: ViewOutlineProvider = @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    object : ViewOutlineProvider() {
        override fun getOutline(view: View, outline: Outline) {
            val cornerRadius = cornerRadius.dp // 圆角半径
            outline.setRoundRect(0, 0, view.width, view.height, cornerRadius.toFloat())
        }
    }
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
        this.outlineProvider = viewOutlineProvider
        this.clipToOutline = true
    }
}


fun View.clickDelay(spaceTime: Long = SPACE_TIME, clickAction: () -> Unit) {
    this.setOnClickListener {
        if (this.hashCode() != ViewExt.ViewClickDelay.hash) {
            ViewExt.ViewClickDelay.hash = this.hashCode()
            ViewExt.ViewClickDelay.lastClickTime = System.currentTimeMillis()
            clickAction()
        } else {
            val currentTime = System.currentTimeMillis()
            if (currentTime - ViewExt.ViewClickDelay.lastClickTime > spaceTime) {
                ViewExt.ViewClickDelay.lastClickTime = System.currentTimeMillis()
                clickAction()
            }
        }
    }
}

fun Context.jumpActivity(cls: Class<out Activity>, addExtra: (intent: Intent) -> Unit = {}) {
    val intent = Intent(this, cls)
    addExtra.invoke(intent)
    startActivity(intent)
}

fun View.gone() {
    visibility = View.GONE
}

fun View.setVisible(visible: Boolean = true) {
    visibility = if (visible) View.VISIBLE else View.INVISIBLE
}

fun View.setGone(visible: Boolean = false) {
    visibility = if (visible) View.VISIBLE else View.GONE
}

fun Context.getColorCompat(colorRes: Int): Int {
    return ContextCompat.getColor(this, colorRes)
}


fun <T> ViewGroup.foreachChild(call: (view: T?) -> Unit) {
    for (index in 0 until childCount) {
        call.invoke(getChildAt(index) as? T)
    }
}



fun View.bigClick(bigSize: Int = 5.dp) {
    val touchableArea = Rect()
    this.getHitRect(touchableArea)
    touchableArea.top -= bigSize
    touchableArea.bottom += bigSize
    touchableArea.left -= bigSize
    touchableArea.right += bigSize
    this.touchDelegate = TouchDelegate(touchableArea, this)
}



