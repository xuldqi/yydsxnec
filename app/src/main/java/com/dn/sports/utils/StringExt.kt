package com.dn.sports.utils

import android.widget.Toast

fun String.toast() {
    ToastUtils.showToast(this, Toast.LENGTH_SHORT)
}


fun String.copy() {
    ClipboardHelper.copyText(this)
}