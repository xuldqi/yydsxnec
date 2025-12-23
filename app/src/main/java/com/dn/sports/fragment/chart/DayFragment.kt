package com.dn.sports.fragment.chart

import android.os.Build
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.RequiresApi
import com.github.aachartmodel.aainfographics.aachartcreator.AASeriesElement
import com.dn.sports.R
import com.dn.sports.activity.ChartActivity.Companion.TYPE_DISTENCE
import com.dn.sports.activity.ChartActivity.Companion.TYPE_WEIGHT
import com.dn.sports.chart.ChartHelper
import com.dn.sports.common.LogUtils
import com.dn.sports.fragment.BaseFragment
import com.dn.sports.utils.*
import com.dn.sports.utils.DateUtils.getEveryDayTimestamps
import com.dn.sports.view.TimeRangeView
import kotlinx.android.synthetic.main.day_fragment.*
import kotlinx.coroutines.*

class DayFragment : BaseFragment() {

    var chartType = 0

    var mainScope = MainScope()

    override fun getViewByLayout(
        inflater: LayoutInflater?,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return inflater!!.inflate(R.layout.day_fragment, container, false)
    }


    override fun initViewAction(view: View?) {
    }

    override fun updateUserInfo() {
    }

    override fun clearUserInfo() {
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        timeRangeView.setMode(TimeRangeView.TIME_MODE_DAY)
        io {
            val data =
                when (chartType) {
                    TYPE_DISTENCE -> getWalkData()
                    TYPE_WEIGHT -> getWeightData()
                    else -> getHeatData()
                }
            val xData = arrayOf("周一", "周二", "周三", "周四", "周五", "周六", "周天")
            val aaOptions = ChartHelper.initChart(data, xData, getChartTitle())
            main {
                aaChartView.aa_drawChartWithChartOptions(aaOptions)
                cardView.chartType = chartType
                cardView.dateType = timeRangeView.currentTimeMode
                cardView.setTitle(data)
            }
        }
        tvUnit.text=getChartTitle()
        timeRangeView.dateChange = {
            refreshData()
        }
    }

    private fun refreshData() {
        /*仅仅更新了图表的series数组数据,不改动图表的其他内容*/
        io {
            val data =
                when (chartType) {
                    TYPE_DISTENCE -> getWalkData()
                    TYPE_WEIGHT -> getWeightData()
                    else -> getHeatData()
                }
            val xData = arrayOf("周一", "周二", "周三", "周四", "周五", "周六", "周天")
            val aaOptions = ChartHelper.initChart(data, xData, getChartTitle())
            main {
                aaChartView.aa_drawChartWithChartOptions(aaOptions)
                cardView.chartType = chartType
                cardView.dateType = timeRangeView.currentTimeMode
                cardView.setTitle(data)
            }
        }
    }


    override fun onDestroy() {
        super.onDestroy()
        mainScope.cancel()
    }

    private fun getWalkData(): Array<Int> {
        val startTime = timeRangeView.getStartAndEndTime()[0].time
        val endTime = timeRangeView.getStartAndEndTime()[1].time
        val datas = ChartDateHelper.getWalkStepData(startTime, endTime)
        val times = getEveryDayTimestamps(startTime, endTime)
        val result = arrayOf(0, 0, 0, 0, 0, 0, 0)
        times.forEachIndexed { index, time ->
            datas.forEach { record ->
                if (DateUtils.getYearMonthDay(time) == DateUtils.getYearMonthDay(record.currentTime)) {
                    if (index <= 6) {
                        result[index] = record.steps
                    }
                }
            }
        }
        return result
    }

    private fun getHeatData(): Array<Int> {
        val startTime = timeRangeView.getStartAndEndTime()[0].time
        val endTime = timeRangeView.getStartAndEndTime()[1].time
        val timeMap = mutableMapOf<String, Int>()
        getEveryDayTimestamps(startTime, endTime).forEach {
            timeMap[DateUtils.getYearMonthDay(it)] = 0
        }
        val datas = ChartDateHelper.getAllStepsData(startTime, endTime)
        timeMap.forEach { (t, u) ->
            LogUtils.d(DateUtils.TAG, "getHeatData:  $t")
            datas.forEach { step ->
                if (t == DateUtils.getYearMonthDay(step.currentTime)) {
                    timeMap[t] = timeMap[t]!! + step.steps
                }
            }
        }
        val result = arrayOf(0, 0, 0, 0, 0, 0, 0)
        var index = 0
        timeMap.forEach { (t, u) ->
            result[index++] = u.toKal()
        }
        return result
    }


    private fun getWeightData(): Array<Int> {
        val startTime = timeRangeView.getStartAndEndTime()[0].time
        val endTime = timeRangeView.getStartAndEndTime()[1].time
        val timeMap = mutableMapOf<String, Int>()
        getEveryDayTimestamps(startTime, endTime).forEach {
            timeMap[DateUtils.getYearMonthDay(it)] = 0
        }
        val datas = ChartDateHelper.getAllWeightData(startTime, endTime)
        timeMap.forEach { (t, u) ->
            LogUtils.d(DateUtils.TAG, "getWeightData time:  $t")
            datas?.forEach { body ->
                if (t == DateUtils.getYearMonthDay(body.time)) {
                    timeMap[t] = body.data.toDouble().toInt()
                    LogUtils.d(
                        DateUtils.TAG,
                        "getWeightData data:  ${body.data.toDouble().toInt()}"
                    )
                }
            }
        }
        val result = arrayOf(0, 0, 0, 0, 0, 0, 0)
        var index = 0
        timeMap.forEach { (t, u) ->
            result[index++] = u
        }
        return result
    }


    private fun getChartTitle(): String {
        return when (chartType) {
            TYPE_DISTENCE -> {
                "步"
            }
            TYPE_WEIGHT -> {
                "千克"
            }
            else -> {
                "千卡"
            }
        }
    }


}