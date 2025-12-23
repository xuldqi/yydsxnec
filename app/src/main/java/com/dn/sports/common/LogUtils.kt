package com.dn.sports.common



 object LogUtils {


     @JvmStatic
  fun d(tag: String, msg: String) {
    android.util.Log.d(tag, msg)
  }

     @JvmStatic

     fun e(tag: String, msg: String) {
    android.util.Log.e(tag, msg)
  }

     @JvmStatic

     fun i(tag: String, msg: String) {
    android.util.Log.i(tag, msg)
  }


}