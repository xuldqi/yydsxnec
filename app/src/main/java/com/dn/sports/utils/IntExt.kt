package com.dn.sports.utils

import androidx.core.content.ContextCompat
import com.dn.sports.StepApplication

fun Int.km(value: Int): Float {
    val km = this.toFloat() * 0.6f / 1000
    return km
}




val Int.dp
    get()= DisplayUtils.dp2px(this)


/**
 * 给定的数字，向上取整，保证除去第一位，其余都是0
 */
fun Int.ceil(): Int {
    val str = this.toString()
    val first = str.substring(0, 1)
    val other = str.substring(1, str.length)
    val result = (first.toInt() + 1).toString() + other.replace("[0-9]".toRegex(), "0")
    return result.toInt()
}

/**
 * 给定的数字，向下取整，保证除去第一位，其余都是0
 */
fun Int.floor(): Int {
    val str = this.toString()
    val first = str.substring(0, 1).toInt()
    val other = str.substring(1, str.length)
    if (first != 1) {
        return ((first - 1).toString() + other.replace("[0-9]".toRegex(), "0")).toInt()
    } else {
        return (first.toString() + other.replace("[0-9]".toRegex(), "0")).toInt()
    }
}

fun Int.color(): Int {
    return ContextCompat.getColor(StepApplication.getInstance().baseContext, this)
}

/**
 * 步数-> 千卡
 */
fun Int.toKal(): Int {
    return Utils.getKalByStep(this)
}


/**
 * 步数-> km
 */
fun Int.toDistance(): String {
    return Utils.getDistanceByStep(this)
}
