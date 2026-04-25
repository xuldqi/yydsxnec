package com.dn.sports.fragment.chart

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.dn.sports.R
import com.dn.sports.activity.ChartActivity.Companion.TYPE_DISTENCE
import com.dn.sports.activity.ChartActivity.Companion.TYPE_WEIGHT
import com.dn.sports.chart.ChartHelper
import com.dn.sports.fragment.BaseFragment
import com.dn.sports.utils.ChartDateHelper
import com.dn.sports.utils.DateUtils
import com.dn.sports.utils.DateUtils.getEveryDayTimestamps
import com.dn.sports.utils.io
import com.dn.sports.utils.main
import com.dn.sports.utils.toKal
import kotlinx.android.synthetic.main.day_fragment.*

class DayFragment : BaseFragment() {

    var chartType = 0

    override fun getViewByLayout(
        inflater: LayoutInflater?,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return inflater!!.inflate(R.layout.day_fragment, container, false)
    }

    override fun initViewAction(view: View?) {}

    override fun updateUserInfo() {}

    override fun clearUserInfo() {}

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        timeRangeView.setMode(com.dn.sports.view.TimeRangeView.TIME_MODE_DAY)
        refreshData()
        tvUnit.text = getChartTitle()
        timeRangeView.dateChange = {
            refreshData()
        }
    }

    fun refreshData() {
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

    private fun getWalkData(): Array<Int> {
        val startTime = timeRangeView.getStartAndEndTime()[0].time
        val endTime = timeRangeView.getStartAndEndTime()[1].time
        val datas = ChartDateHelper.getWalkStepData(startTime, endTime)
        val times = getEveryDayTimestamps(startTime, endTime)
        val result = arrayOf(0, 0, 0, 0, 0, 0, 0)
        times.forEachIndexed { index, time ->
            datas.forEach { record ->
                if (DateUtils.getYearMonthDay(time) == DateUtils.getYearMonthDay(record.currentTime) && index <= 6) {
                    result[index] = record.steps
                }
            }
        }
        return result
    }

    private fun getHeatData(): Array<Int> {
        val startTime = timeRangeView.getStartAndEndTime()[0].time
        val endTime = timeRangeView.getStartAndEndTime()[1].time
        val timeMap = linkedMapOf<String, Int>()
        getEveryDayTimestamps(startTime, endTime).forEach {
            timeMap[DateUtils.getYearMonthDay(it)] = 0
        }
        val datas = ChartDateHelper.getAllStepsData(startTime, endTime)
        timeMap.keys.forEach { day ->
            datas.forEach { step ->
                if (day == DateUtils.getYearMonthDay(step.currentTime)) {
                    timeMap[day] = (timeMap[day] ?: 0) + step.steps
                }
            }
        }
        return timeMap.values.map { it.toKal() }.toTypedArray()
    }

    private fun getWeightData(): Array<Int> {
        val startTime = timeRangeView.getStartAndEndTime()[0].time
        val endTime = timeRangeView.getStartAndEndTime()[1].time
        val timeMap = linkedMapOf<String, Int>()
        getEveryDayTimestamps(startTime, endTime).forEach {
            timeMap[DateUtils.getYearMonthDay(it)] = 0
        }
        val datas = ChartDateHelper.getAllWeightData(startTime, endTime)
        timeMap.keys.forEach { day ->
            datas?.forEach { body ->
                if (day == DateUtils.getYearMonthDay(body.time)) {
                    timeMap[day] = body.data.toDouble().toInt()
                }
            }
        }
        return timeMap.values.toTypedArray()
    }

    private fun getChartTitle(): String {
        return when (chartType) {
            TYPE_DISTENCE -> "步"
            TYPE_WEIGHT -> "千克"
            else -> "千卡"
        }
    }
}
