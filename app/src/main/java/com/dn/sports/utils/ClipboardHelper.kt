package com.dn.sports.utils

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import com.dn.sports.StepApplication

object ClipboardHelper {
    fun copyText(text: String) {
        try {
            (StepApplication.getInstance().applicationContext?.getSystemService(Context.CLIPBOARD_SERVICE) as? ClipboardManager)?.let {
                it.setPrimaryClip(ClipData.newPlainText("", text))
                "复制成功".toast()
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}