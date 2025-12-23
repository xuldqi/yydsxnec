package com.dn.sports.utils

import android.content.Context
import com.google.gson.Gson

class SharedPreferenceUtil private constructor() {
    /**
     * 存入键值对
     *
     * @param key
     * @param value
     */
    fun put(key: String?, value: Any) {
        //判断类型
        val type = value.javaClass.simpleName
        val sharedPreferences = context!!.getSharedPreferences(FILE_NAME, Context.MODE_PRIVATE)
        val editor = sharedPreferences.edit()
        if ("Integer" == type) {
            editor.putInt(key, (value as Int))
        } else if ("Boolean" == type) {
            editor.putBoolean(key, (value as Boolean))
        } else if ("Float" == type) {
            editor.putFloat(key, (value as Float))
        } else if ("Long" == type) {
            editor.putLong(key, (value as Long))
        } else if ("String" == type) {
            editor.putString(key, value as String)
        }
        editor.apply()
    }

    /**
     * 读取键的值，若无则返回默认值
     *
     * @param key
     * @param defValue 默认值
     * @return
     */
    operator fun get(key: String?, defValue: Any): Any? {
        val sharedPreferences = context!!.getSharedPreferences(FILE_NAME, Context.MODE_PRIVATE)
        val type = defValue.javaClass.simpleName
        if ("Integer" == type) {
            return sharedPreferences.getInt(key, (defValue as Int))
        } else if ("Boolean" == type) {
            return sharedPreferences.getBoolean(key, (defValue as Boolean))
        } else if ("Float" == type) {
            return sharedPreferences.getFloat(key, (defValue as Float))
        } else if ("Long" == type) {
            return sharedPreferences.getLong(key, (defValue as Long))
        } else if ("String" == type) {
            return sharedPreferences.getString(key, defValue as String)
        }
        return null
    }

    fun <T> putObject(key: String?, obj: T) {
        val gson = Gson()
        put(key, gson.toJson(obj))
    }

    fun <T> getObject(key: String?, tClass: Class<T>?): T? {
        val gson = Gson()
        val result = get(key, "") as String? ?: return null
        var t: T? = null
        try {
            t = gson.fromJson(result, tClass) as T
        } catch (e: Exception) {
        } finally {
            return t
        }
    }

    companion object {
        private const val FILE_NAME = "hello" //文件名
        private var mInstance: SharedPreferenceUtil? = null
        private var context: Context? = null
        fun getInstance(context: Context): SharedPreferenceUtil {
            Companion.context = context
            if (mInstance == null) {
                synchronized(SharedPreferenceUtil::class.java) {
                    if (mInstance == null) {
                        mInstance = SharedPreferenceUtil()
                    }
                }
            }
            return mInstance!!
        }
    }
}