package com.dn.sports.utils

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.JsonElement
import com.google.gson.JsonObject
import org.json.JSONArray
import org.json.JSONObject
import java.lang.reflect.Type


object JSONUtils {
    private const val TAG = "JSONUtils"
    private val mGson = GsonBuilder().disableHtmlEscaping().create()

    /**
     * 获取GSON
     *
     * @return GSON实例
     */
    fun gsonInstance(): Gson {
        return mGson
    }

    /**
     * 从json字符串构造 clazz 的实例
     *
     * @param jsonString json字符串
     * @param clazz      目标转换对象的class类型
     * @param <T>        转换完成的类型实例
     * @return
     *
     *json字符串解析成功，返回SplashScreenItemsResult
     *
     * json字符串解析失败时，返回null
    </T> */
    fun <T> fromJsonString(jsonString: String, clazz: Class<T>?): T? {
        try {
            return gsonInstance().fromJson(jsonString, clazz)
        } catch (e: Exception) {
        }
        return null
    }

    /**
     * 从json字符串构造 List 的实例
     *
     * @param jsonString json字符串
     * @param typeOfT    目标转换对象的typeOfT类型
     * @param <T>        转换完成的类型实例
     * @return
     *
     *json字符串解析成功，T
     *
     * json字符串解析失败时，返回null
    </T> */
    fun <T> fromJsonString(jsonString: String?, typeOfT: Type?): T? {
        try {
            return gsonInstance().fromJson<Any>(jsonString, typeOfT) as T
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return null
    }

    /**
     * 从对象转换为json字符串
     *
     * @param object 对象实例
     * @return json字符串
     */
    fun toJsonString(`object`: Any?): String {
        try {
            return gsonInstance().toJson(`object`)
        } catch (e: Throwable) {
            e.printStackTrace()
        }
        return ""
    }

    const val JSON_INDENT = 4
    fun formatJson(body: String): String {
        var message = body
        try {
            if (body.startsWith("{")) {
                val jsonObject = JSONObject(body)
                message = jsonObject.toString(JSON_INDENT)
            } else if (body.startsWith("[")) {
                val json = JSONArray(body)
                message = json.toString(JSON_INDENT)
            }
        } catch (ex: Exception) {
            ex.printStackTrace()
        }
        return message
    }



    fun convert2JSONObject(o: Any?): JSONObject? {
        return try {
            JSONObject(toJsonString(o))
        } catch (e: Exception) {
            null
        }
    }
}

