package com.dn.sports.fragment.chart

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.dn.sports.R
import com.dn.sports.activity.ChartActivity
import com.dn.sports.chart.ChartHelper
import com.dn.sports.common.LogUtils
import com.dn.sports.fragment.BaseFragment
import com.dn.sports.utils.ChartDateHelper
import com.dn.sports.utils.DateUtils
import com.dn.sports.utils.DateUtils.getEveryDayTimestamps
import com.dn.sports.utils.io
import com.dn.sports.utils.main
import com.dn.sports.utils.toKal
import kotlinx.android.synthetic.main.fragment_week.*

class WeekFragment : BaseFragment() {

    var chartType = 0

    override fun getViewByLayout(
        inflater: LayoutInflater?,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return inflater!!.inflate(R.layout.fragment_week, container, false)
    }

    override fun initViewAction(view: View?) {}

    override fun updateUserInfo() {}

    override fun clearUserInfo() {}

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        timeRangeView.setMode(com.dn.sports.view.TimeRangeView.TIME_MODE_WEEK)
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
                    ChartActivity.TYPE_DISTENCE -> getWalkData()
                    ChartActivity.TYPE_WEIGHT -> getWeightData()
                    else -> getHeatData()
                }
            val aaOptions = ChartHelper.initChart(data, getWalkDate(), getChartTitle(), 4)
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
        val result = MutableList(times.size) { 0 }
        times.forEachIndexed { index, time ->
            datas.forEach { record ->
                if (DateUtils.getYearMonthDay(time) == DateUtils.getYearMonthDay(record.currentTime)) {
                    result[index] = record.steps
                }
            }
        }
        return result.toTypedArray()
    }

    private fun getHeatData(): Array<Int> {
        val startTime = timeRangeView.getStartAndEndTime()[0].time
        val endTime = timeRangeView.getStartAndEndTime()[1].time
        val datas = ChartDateHelper.getAllStepsData(startTime, endTime)
        val times = getEveryDayTimestamps(startTime, endTime)
        val result = MutableList(times.size) { 0 }
        times.forEachIndexed { index, time ->
            datas.forEach { record ->
                if (DateUtils.getYearMonthDay(time) == DateUtils.getYearMonthDay(record.currentTime)) {
                    result[index] = record.steps.toKal()
                }
            }
        }
        return result.toTypedArray()
    }

    private fun getWalkDate(): Array<String> {
        val startTime = timeRangeView.getStartAndEndTime()[0].time
        val endTime = timeRangeView.getStartAndEndTime()[1].time
        val times = getEveryDayTimestamps(startTime, endTime)
        return times.map {
            val day = DateUtils.getDay(it)
            LogUtils.d("monthDate", day)
            day
        }.toTypedArray()
    }

    private fun getWeightData(): Array<Int> {
        val startTime = timeRangeView.getStartAndEndTime()[0].time
        val endTime = timeRangeView.getStartAndEndTime()[1].time
        val datas = ChartDateHelper.getAllWeightData(startTime, endTime)
        val times = getEveryDayTimestamps(startTime, endTime)
        val result = MutableList(times.size) { 0 }
        times.forEachIndexed { index, time ->
            datas?.forEach { record ->
                if (DateUtils.getYearMonthDay(time) == DateUtils.getYearMonthDay(record.time)) {
                    result[index] = record.data.toDouble().toInt()
                }
            }
        }
        return result.toTypedArray()
    }

    private fun getChartTitle(): String {
        return when (chartType) {
            ChartActivity.TYPE_DISTENCE -> "步"
            ChartActivity.TYPE_WEIGHT -> "千克"
            else -> "千卡"
        }
    }
}
