package com.dn.sports.utils

import com.dn.sports.activity.ChartActivity
import com.dn.sports.common.LogUtils
import java.text.ParseException
import java.text.SimpleDateFormat
import java.util.*

object DateUtils {
    var TAG = "DateUtils"
    fun getTime(mDate: String?): Long {
        if (isDate(mDate, "yyyy-MM-dd hh:mm:ss")) {
            val df = SimpleDateFormat("yyyy-MM-dd hh:mm:ss")
            try {
                val date = df.parse(mDate)
                return date.time
            } catch (e: ParseException) {
                e.printStackTrace()
            }
        }
        return 0
    }

    /**
     * 获取当前的月份
     */
    fun getMonth(): String {
        val df = SimpleDateFormat("MM")
        return df.format(Date())
    }

    /**
     * 获取当前的年份
     */
    fun getYear(): String {
        val df = SimpleDateFormat("yyyy")
        return df.format(Date())
    }

    /**
     * 获取当前的日期
     */
    fun getDay(): String {
        val df = SimpleDateFormat("dd")
        return df.format(Date())
    }


    /**
     * 转换成2023年6月的格式
     */
    fun getTime(mDate: Date,needDay:Boolean=true): String {
        val df = if (needDay) SimpleDateFormat("yyyy年MM月dd日") else SimpleDateFormat("yyyy年MM月")
        return df.format(mDate)
    }

    fun getAllTime(mDate: Date,needDay:Boolean=true): String {
        val df = if (needDay) SimpleDateFormat("yyyy-MM-dd HH:mm:ss") else SimpleDateFormat("yyyy-MM-dd hh:mm:ss")
        return df.format(mDate)
    }


    @JvmStatic
    fun getDate2String(time: Long, pattern: String?="yyyy-MM-dd HH:mm:ss"): String {
        val date = Date(time)
        val format = SimpleDateFormat(pattern, Locale.getDefault())
        return format.format(date)
    }

    @JvmStatic
    fun getYMD(offset: Int): String {
        val calendar = Calendar.getInstance()
        calendar.add(Calendar.DAY_OF_MONTH, offset)
        val year = calendar[Calendar.YEAR] //获取年份
        val month = calendar[Calendar.MONTH] + 1 //获取月份
        val day = calendar[Calendar.DATE] //获取日
        var temp = Integer.toString(year)
        temp += if (month < 10) {
            "/0$month"
        } else {
            "/$month"
        }
        temp += if (day < 10) {
            "/0$day"
        } else {
            "/$day"
        }
        return temp
    }

    /**
     * 把秒数转成时分秒
     */


    @JvmStatic
    fun getMD(offset: Int): String {
        val calendar = Calendar.getInstance()
        calendar.add(Calendar.DAY_OF_MONTH, offset)
        val month = calendar[Calendar.MONTH] + 1 //获取月份
        val day = calendar[Calendar.DATE] //获取日
        var temp = Integer.toString(month)
        temp += if (day < 10) {
            "/0$day"
        } else {
            "/$day"
        }
        return temp
    }

    @JvmStatic
    fun getDateMD(date: Date?): String {
        val calendar = Calendar.getInstance()
        calendar.time = date
        val month = calendar[Calendar.MONTH] + 1 //获取月份
        val day = calendar[Calendar.DATE] //获取日
        var temp = Integer.toString(month)
        temp += if (day < 10) {
            "/0$day"
        } else {
            "/$day"
        }
        return temp
    }

    @JvmStatic
    fun getDateMD(date: Long): String {
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = date
        val month = calendar[Calendar.MONTH] + 1 //获取月份
        val day = calendar[Calendar.DATE] //获取日
        var temp = Integer.toString(month)
        temp += if (day < 10) {
            "/0$day"
        } else {
            "/$day"
        }
        LogUtils.d(TAG,"getDateMD:  ${temp }")
        return temp
    }

    fun isDate(str_input: String?, rDateFormat: String?): Boolean {
        if (!isNull(str_input)) {
            val formatter = SimpleDateFormat(rDateFormat)
            formatter.isLenient = false
            try {
                formatter.format(formatter.parse(str_input))
            } catch (e: Exception) {
                return false
            }
            return true
        }
        return false
    }

    fun isNull(str: String?): Boolean {
        return str == null
    }

    fun getCurrentYear(): Int {
        val calendar = Calendar.getInstance()
        return calendar[Calendar.YEAR]
    }

    fun getCurrentMonth(): Int {
        val calendar = Calendar.getInstance()
        return calendar[Calendar.MONTH]
    }



    fun getPreviousMonth(timestamp: Long,isAdd:Boolean): Date {
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = timestamp
        calendar.add(Calendar.MONTH, if (isAdd) 1 else -1)
        return calendar.time
    }

    /**
     * 获取指定时间的前一个天，返回时间戳
     */
    fun getPreviousDayTimestamp(timestamp: Long,isAdd:Boolean): Date {
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = timestamp
        calendar.add(Calendar.DAY_OF_MONTH, if (isAdd) 1 else -1)
        return calendar.time
    }

    fun getPreviousTearTimestamp(timestamp: Long,isAdd:Boolean): Date {
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = timestamp
        calendar.add(Calendar.YEAR, if (isAdd) 1 else -1)
        return calendar.time
    }


    fun getPreviousWeekTimestamp(timestamp: Long,isAdd:Boolean): Date {
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = timestamp
        calendar.add(Calendar.WEEK_OF_YEAR, if (isAdd) 1 else -1)
        return calendar.time
    }


    /**
     * 获取本周开始时间戳
     */
    fun getWeekStartTimestamp(timestamp: Long): Date {
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = getDayStartTimestamp(timestamp)
        LogUtils.d("getWeekStartTimestamp", "week ${calendar[Calendar.DAY_OF_WEEK]}")
        if (calendar[Calendar.DAY_OF_WEEK] == Calendar.SUNDAY) {
            calendar.timeInMillis = calendar.timeInMillis - 6 * 24 * 60 * 60 * 1000
        } else {
            calendar[Calendar.DAY_OF_WEEK] = Calendar.MONDAY
        }

        LogUtils.d("getWeekStartTimestamp", "start ${getDate2String(timestamp)}")
        LogUtils.d("getWeekStartTimestamp","end ${calendar.time}")
        return calendar.time
    }


    /**
     * 获取本周结束时间戳
     */
    fun getWeekEndTimestamp(timestamp: Long): Date {
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = getDayEndTimestamp(timestamp).time
        if (calendar[Calendar.DAY_OF_WEEK] != Calendar.SUNDAY) {
            calendar[Calendar.DAY_OF_WEEK] = Calendar.SUNDAY
            calendar.add(Calendar.WEEK_OF_YEAR, 1)
        }
        return calendar.time
    }



    /**
     * 获取指周的后一周，返回时间戳
     */
     fun getNextWeekTimestamp(timestamp: Long): Date {
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = timestamp
        calendar.add(Calendar.WEEK_OF_YEAR, 1)
        return calendar.time
    }

    fun getPreviousWeekTimestamp(timestamp: Long): Date {
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = timestamp
        calendar.add(Calendar.WEEK_OF_YEAR, -1)
        return calendar.time
    }




    /**
     * 给定一个时间戳，获取这个时间戳所在月的第一天的时间戳
     */
    fun getFirstDayOfMonth(timestamp: Long): Date {
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = timestamp
        calendar[Calendar.MILLISECOND] = 0
        calendar[Calendar.DAY_OF_MONTH] = 1
        return calendar.time
    }

    /**
     * 给定一个时间戳，获取这个时间戳所在月的最后一天的时间戳
     */
    fun getLastDayOfMonth(timestamp: Long): Date {
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = timestamp
        calendar[Calendar.MILLISECOND] = 0
        calendar[Calendar.DAY_OF_MONTH] = 1
        calendar.add(Calendar.MONTH, 1)
        calendar.add(Calendar.DAY_OF_MONTH, -1)
        return calendar.time
    }

    /**
     * 给定一个时间戳，获取这个时间戳所在年的最后一天的时间戳
     */
    fun getLastDayOfYear(timestamp: Long): Date {
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = timestamp
        calendar[Calendar.MILLISECOND] = 0
        calendar[Calendar.DAY_OF_MONTH] = 1
        calendar[Calendar.MONTH] = 0
        calendar.add(Calendar.YEAR, 1)
        calendar.add(Calendar.DAY_OF_MONTH, -1)
        return calendar.time
    }

    /**
     * 给定一个时间戳，获取这个时间戳所在年的第一天的时间戳
     */
    fun getFirstDayOfYear(timestamp: Long): Date {
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = getDayStartTimestamp(timestamp)
        calendar[Calendar.MILLISECOND] = 0
        calendar[Calendar.DAY_OF_MONTH] = 1
        calendar[Calendar.MONTH] = 0
        return calendar.time
    }

    /**
     * 返回当前时间戳的年份+月份+日期
     */
    fun getYearMonthDay(timestamp: Long): String {
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = timestamp
        val year = calendar[Calendar.YEAR]
        val month = calendar[Calendar.MONTH] + 1
        val day = calendar[Calendar.DAY_OF_MONTH]
        var temp = Integer.toString(year)
        temp += if (month < 10) {
            "/0$month"
        } else {
            "/$month"
        }
        temp += if (day < 10) {
            "/0$day"
        } else {
            "/$day"
        }
        LogUtils.d(TAG,"getDateMD:  ${temp }")
        return temp
    }

    /**
     * 返回当前时间戳的日期
     */
    fun getDay(timestamp: Long): String {
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = timestamp
        val day = calendar[Calendar.DAY_OF_MONTH]
        var temp = ""
        temp += if (day < 10) {
            "$day"
        } else {
            "$day"
        }
        return temp
    }

    /**
     * 获取当天的结束时间戳,24点   进制
     */
    fun getDayEndTimestamp(timestamp: Long): Date {
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = timestamp
        calendar[Calendar.HOUR_OF_DAY] = 23
        calendar[Calendar.MINUTE] = 59
        calendar[Calendar.SECOND] = 59
        return calendar.time        // 23:59:59 99
    }

    /**
     * 给定两个时间戳，返回这两个时间戳之间的 每一天的初始时间戳 的集合
     */
    fun getEveryDayTimestamps(startTimestamp: Long, endTimestamp: Long): List<Long> {
        LogUtils.d("getEveryDayTimestamps","start:  ${getYearMonthDay(startTimestamp) }")
        LogUtils.d("getEveryDayTimestamps","end:  ${getYearMonthDay(endTimestamp) }")
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = startTimestamp
        val startYear = calendar[Calendar.YEAR]
        val startMonth = calendar[Calendar.MONTH]
        val startDay = calendar[Calendar.DAY_OF_MONTH]
        calendar.timeInMillis = endTimestamp
        val endYear = calendar[Calendar.YEAR]
        val endMonth = calendar[Calendar.MONTH]
        val endDay = calendar[Calendar.DAY_OF_MONTH]
        val timestamps: MutableList<Long> = ArrayList()
        if (startYear == endYear && startMonth == endMonth && startDay == endDay) {
            timestamps.add(getDayStartTimestamp(startTimestamp))
        } else {
            calendar.timeInMillis = startTimestamp
            timestamps.add(getDayStartTimestamp(startTimestamp))
            while (calendar[Calendar.YEAR] != endYear || calendar[Calendar.MONTH] != endMonth || calendar[Calendar.DAY_OF_MONTH] != endDay) {
                calendar.add(Calendar.DAY_OF_MONTH, 1)
                timestamps.add(getDayStartTimestamp(calendar.timeInMillis))
            }
        }
        LogUtils.d("getEveryDayTimestamps","first :  ${getYearMonthDay(timestamps[0]) }")
        LogUtils.d("getEveryDayTimestamps","last :  ${getYearMonthDay(timestamps[timestamps.size-1]) }")
        LogUtils.d("getEveryDayTimestamps","size :  ${timestamps.size }")


        return timestamps
    }

    /**
     * 给定两个时间戳，返回这两个时间戳之间的 每一月的初始时间戳 的集合
     */
    fun getEveryMonthTimestamps(startTimestamp: Long, endTimestamp: Long): List<Long> {
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = startTimestamp
        val startYear = calendar[Calendar.YEAR]
        val startMonth = calendar[Calendar.MONTH]
        calendar.timeInMillis = endTimestamp
        val endYear = calendar[Calendar.YEAR]
        val endMonth = calendar[Calendar.MONTH]
        val timestamps: MutableList<Long> = ArrayList()
        if (startYear == endYear && startMonth == endMonth) {
            timestamps.add(getFirstDayOfMonth(startTimestamp).time)
            LogUtils.d("getEveryMonthTimestamps","add :  ${getYearMonthDay(getFirstDayOfMonth(startTimestamp).time) }")
        } else {
            calendar.timeInMillis = startTimestamp
            timestamps.add(getFirstDayOfMonth(startTimestamp).time)
            LogUtils.d("getEveryMonthTimestamps","add :  ${getYearMonthDay(getFirstDayOfMonth(startTimestamp).time )}")
            while (calendar[Calendar.YEAR] != endYear || calendar[Calendar.MONTH] != endMonth) {
                calendar.add(Calendar.MONTH, 1)
                timestamps.add(getFirstDayOfMonth(calendar.timeInMillis).time)
                LogUtils.d("getEveryMonthTimestamps","add :  ${getYearMonthDay(getFirstDayOfMonth(calendar.timeInMillis).time) }")
            }
        }
        timestamps.add(getLastDayOfMonth(endTimestamp).time)
        return timestamps
    }



    /**
     * 给定时间戳，返回当天的初始时间戳
     */
     fun getDayStartTimestamp(timestamp: Long): Long {
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = timestamp
        calendar[Calendar.MILLISECOND] = 0
        calendar[Calendar.SECOND] = 0
        calendar[Calendar.MINUTE] = 0
        calendar[Calendar.HOUR_OF_DAY] = 0
        return calendar.timeInMillis
    }


    /**
     * 把指定秒数转化成小时/分钟 的时常格式
     */
    fun getDurationTime(duration: Int): String {
        val hour = duration / 3600
        val minute = duration % 3600 / 60
        val second = duration % 60
        var temp = ""
        if (hour > 0) {
            temp += if (hour < 10) {
                "0$hour 小时"
            } else {
                "$hour 小时"
            }
        }
        temp += if (minute < 10) {
            "0$minute 分钟"
        } else {
            "$minute 分钟"
        }

        temp += if (second < 10) {
            "0$second 秒"
        } else {
            "$second 秒 "
        }
        return temp
    }





}