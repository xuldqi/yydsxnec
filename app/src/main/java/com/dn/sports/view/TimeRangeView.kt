package com.dn.sports.view

import android.content.Context
import android.util.AttributeSet
import android.view.LayoutInflater
import android.widget.FrameLayout
import com.dn.sports.R
import com.dn.sports.common.LogUtils
import com.dn.sports.utils.DateUtils
import com.dn.sports.utils.DateUtils.getDayEndTimestamp
import com.dn.sports.utils.DateUtils.getDayStartTimestamp
import com.dn.sports.utils.DateUtils.getFirstDayOfMonth
import com.dn.sports.utils.DateUtils.getFirstDayOfYear
import com.dn.sports.utils.DateUtils.getLastDayOfMonth
import com.dn.sports.utils.DateUtils.getLastDayOfYear
import com.dn.sports.utils.DateUtils.getPreviousMonth
import com.dn.sports.utils.DateUtils.getPreviousTearTimestamp
import com.dn.sports.utils.DateUtils.getPreviousWeekTimestamp
import com.dn.sports.utils.DateUtils.getWeekEndTimestamp
import com.dn.sports.utils.DateUtils.getWeekStartTimestamp
import com.dn.sports.utils.clickDelay
import kotlinx.android.synthetic.main.view_time_range.view.*
import java.util.*


/**
 * 图表时间选择器
 */
class TimeRangeView @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null
) : FrameLayout(context, attrs) {

    val TAG = "TimeRangeView"


    /**
     * 0:日 1:周 2:月
     */
    var currentTimeMode = 0

    companion object {
        var TIME_MODE_DAY = 0//日
        var TIME_MODE_WEEK = 1//周
        var TIME_MODE_MOTH = 2//月

        var mStartTime = Date()
        var mEndTime = Date()
    }


    var currentTime1 = Calendar.getInstance().time//时间起始点\当前时间
    var currentTime2 = getPreviousWeekTimestamp(Calendar.getInstance().timeInMillis)//时间结束点


    init {
        LayoutInflater.from(context).inflate(R.layout.view_time_range, this)
        leftImage.clickDelay {
            changeDate(false)
        }
        rightImage.clickDelay {
            changeDate(true)
        }
    }


    fun setMode(mode: Int) {
        currentTimeMode = mode
        when (mode) {
            TIME_MODE_DAY -> {
                currentTime1 = getWeekEndTimestamp(System.currentTimeMillis())
                currentTime2 = getWeekStartTimestamp(System.currentTimeMillis())
                tvTime.text =
                    "< ${DateUtils.getTime(currentTime2)}至${DateUtils.getTime(currentTime1)} >"
            }
            TIME_MODE_WEEK -> {
                currentTime1 = Calendar.getInstance().time
                tvTime.text = "< ${DateUtils.getTime(currentTime1, false)} >"
            }
            TIME_MODE_MOTH -> {
                currentTime1 = Calendar.getInstance().time
                tvTime.text = "< ${currentTime1.year + 1900}年 >"
            }
        }
    }


    private fun changeDate(isAdd: Boolean) {
        when (currentTimeMode) {
            TIME_MODE_DAY -> {
                currentTime1 = getPreviousWeekTimestamp(currentTime1.time, isAdd)
                currentTime2 = getPreviousWeekTimestamp(currentTime2.time, isAdd)
                tvTime.text =
                    "< ${DateUtils.getTime(currentTime2)}至${DateUtils.getTime(currentTime1)} >"
            }
            TIME_MODE_WEEK -> {
                currentTime1 = getPreviousMonth(currentTime1.time, isAdd)
                tvTime.text = "< ${DateUtils.getTime(currentTime1, false)} >"
            }
            TIME_MODE_MOTH -> {
                currentTime1 = getPreviousTearTimestamp(currentTime1.time, isAdd)
                tvTime.text = "< ${currentTime1.year + 1900}年 >"
            }
        }
        getStartAndEndTime()
        dateChange.invoke()
    }

    var dateChange = {}

    fun getStartAndEndTime(): Array<Date> {
        var startTime = Date()
        var endTime = Date()
        when (currentTimeMode) {
            TIME_MODE_DAY -> {
                startTime = currentTime2
                endTime = currentTime1
            }
            TIME_MODE_WEEK -> {
                startTime = getFirstDayOfMonth(currentTime1.time)
                endTime = getLastDayOfMonth(currentTime1.time)
            }
            TIME_MODE_MOTH -> {
                startTime = getFirstDayOfYear(currentTime1.time)
                endTime = getLastDayOfYear(currentTime1.time)
            }
        }
        startTime.time = getDayStartTimestamp(startTime.time)
        endTime = getDayEndTimestamp(endTime.time)
        LogUtils.d(TAG, "startTime ${DateUtils.getAllTime(startTime, true)}")
        LogUtils.d(TAG, "endTime ${DateUtils.getAllTime(endTime, true)}")
        mStartTime = startTime
        mEndTime = endTime
        return arrayOf(startTime, endTime)
    }


}