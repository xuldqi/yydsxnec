package com.dn.sports.fragment.chart

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.dn.sports.R
import com.dn.sports.activity.ChartActivity
import com.dn.sports.chart.ChartHelper
import com.dn.sports.fragment.BaseFragment
import com.dn.sports.utils.ChartDateHelper
import com.dn.sports.utils.DateUtils
import com.dn.sports.utils.DateUtils.getPreviousDayTimestamp
import com.dn.sports.utils.io
import com.dn.sports.utils.main
import com.dn.sports.utils.toKal
import kotlinx.android.synthetic.main.fragment_month.*

class MonthFragment : BaseFragment() {

    var chartType = 0
    private var monthTimes: List<Long>? = null
    private val monthDataMap = linkedMapOf<Int, Array<Int>>()

    override fun getViewByLayout(
        inflater: LayoutInflater?,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return inflater!!.inflate(R.layout.fragment_month, container, false)
    }

    override fun initViewAction(view: View?) {}

    override fun updateUserInfo() {}

    override fun clearUserInfo() {}

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        timeRangeView.setMode(com.dn.sports.view.TimeRangeView.TIME_MODE_MOTH)
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
            val xData = arrayOf("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12")
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
        monthTimes = DateUtils.getEveryMonthTimestamps(startTime, getPreviousDayTimestamp(endTime, false).time)
        monthDataMap.clear()
        for (i in 1..12) {
            getEveryMonthData(i)
        }
        return monthDataMap.values.map { getAverage(it) }.toTypedArray()
    }

    private fun getHeatData(): Array<Int> {
        val startTime = timeRangeView.getStartAndEndTime()[0].time
        val endTime = timeRangeView.getStartAndEndTime()[1].time
        monthTimes = DateUtils.getEveryMonthTimestamps(startTime, getPreviousDayTimestamp(endTime, false).time)
        monthDataMap.clear()
        for (i in 1..12) {
            getEveryMonthData(i, true)
        }
        return monthDataMap.values.map { getAverage(it).toKal() }.toTypedArray()
    }

    private fun getWeightData(): Array<Int> {
        val startTime = timeRangeView.getStartAndEndTime()[0].time
        val endTime = timeRangeView.getStartAndEndTime()[1].time
        monthTimes = DateUtils.getEveryMonthTimestamps(startTime, getPreviousDayTimestamp(endTime, false).time)
        monthDataMap.clear()
        for (i in 1..12) {
            getEveryMonthWeightData(i)
        }
        return monthDataMap.values.map { getAverage(it) }.toTypedArray()
    }

    private fun getAverage(array: Array<Int>): Int {
        if (array.isEmpty()) return 0
        return array.sum() / array.size
    }

    private fun getEveryMonthData(index: Int, isAll: Boolean = false) {
        val startTime = monthTimes!![index - 1]
        val endTime = monthTimes!![index]
        val datas = if (!isAll) {
            ChartDateHelper.getWalkStepData(startTime, endTime)
        } else {
            ChartDateHelper.getAllStepsData(startTime, endTime)
        }
        monthDataMap[index] = datas.map { it.steps }.toTypedArray()
    }

    private fun getEveryMonthWeightData(index: Int) {
        val startTime = monthTimes!![index - 1]
        val endTime = monthTimes!![index]
        val datas = ChartDateHelper.getAllWeightData(startTime, endTime)
        monthDataMap[index] = datas?.map { it.data.toFloat().toInt() }?.toTypedArray() ?: emptyArray()
    }

    private fun getChartTitle(): String {
        return when (chartType) {
            ChartActivity.TYPE_DISTENCE -> "步"
            ChartActivity.TYPE_WEIGHT -> "千克"
            else -> "千卡"
        }
    }
}
