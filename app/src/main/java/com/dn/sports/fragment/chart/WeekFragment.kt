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
import com.dn.sports.utils.*
import com.dn.sports.view.TimeRangeView
import com.github.aachartmodel.aainfographics.aachartcreator.AASeriesElement
import kotlinx.android.synthetic.main.fragment_week.aaChartView
import kotlinx.android.synthetic.main.fragment_week.cardView
import kotlinx.android.synthetic.main.fragment_week.timeRangeView
import kotlinx.android.synthetic.main.fragment_week.tvUnit

class WeekFragment : BaseFragment() {

    var chartType = 0

    override fun getViewByLayout(
        inflater: LayoutInflater?,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return inflater!!.inflate(R.layout.fragment_week, container, false)
    }

    override fun initViewAction(view: View?) {
    }

    override fun updateUserInfo() {
    }

    override fun clearUserInfo() {
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        timeRangeView.setMode(TimeRangeView.TIME_MODE_WEEK)

        io {
            val data =
                when(chartType){
                    ChartActivity.TYPE_DISTENCE -> getWalkData()
                    ChartActivity.TYPE_WEIGHT -> getWeightData()
                    else -> getHeatData()
                }

            val aaOptions =  ChartHelper.initChart(data, getWalkDate(), getChartTitle(),4)
            main {
                aaChartView.aa_drawChartWithChartOptions(aaOptions)

                cardView.chartType = chartType
                cardView.dateType = timeRangeView.currentTimeMode
                cardView.setTitle(data)
            }
        }
        timeRangeView.dateChange = {
            refreshData()
        }
        tvUnit.text=getChartTitle()
    }


    private fun refreshData() {
        /*仅仅更新了图表的series数组数据,不改动图表的其他内容*/
        io {
            val data =
                when(chartType){
                    ChartActivity.TYPE_DISTENCE -> getWalkData()
                    ChartActivity.TYPE_WEIGHT -> getWeightData()
                    else -> getHeatData()
                }
            main {
                aaChartView.aa_onlyRefreshTheChartDataWithChartOptionsSeriesArray(
                    arrayOf(
                        AASeriesElement()
                            .name("")
                            .showInLegend(false)
                            .data(data as Array<Any>)
                    )
                )
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
        val times =
            DateUtils.getEveryDayTimestamps(
                startTime,
//                DateUtils.getPreviousDayTimestamp(endTime, false).time
                endTime
            )
        val result = arrayListOf<Int>()
        times.forEach {
            result.add(0)
        }
        times.forEachIndexed { index, time ->
            datas.forEach { record ->
                if (DateUtils.getYearMonthDay(time) == DateUtils.getYearMonthDay(record.currentTime)) {
                    result[index] = record.steps
                }
            }
        }
        return result.toTypedArray()
    }


    private fun getHeatData() : Array<Int>{
        val startTime = timeRangeView.getStartAndEndTime()[0].time
        val endTime = timeRangeView.getStartAndEndTime()[1].time
        val datas = ChartDateHelper.getAllStepsData(startTime, endTime)
        val times =
            DateUtils.getEveryDayTimestamps(
                startTime,
//                DateUtils.getPreviousDayTimestamp(endTime, false).time
                endTime
            )
        val result = arrayListOf<Int>()
        times.forEach {
            result.add(0)
        }
        times.forEachIndexed { index, time ->
            datas.forEach { record ->
                if (DateUtils.getYearMonthDay(time) == DateUtils.getYearMonthDay(record.currentTime)) {
                    result[index]=record.steps.toKal()
                }
            }
        }
        return result.toTypedArray()
    }

    private fun getWalkDate(): Array<String> {
        val startTime = timeRangeView.getStartAndEndTime()[0].time
        val endTime = timeRangeView.getStartAndEndTime()[1].time
        val times =
            DateUtils.getEveryDayTimestamps(
                startTime,
                endTime
            )
        val result = mutableListOf<String>()
        times.forEach {
            result.add(DateUtils.getDay(it))
            LogUtils.d("monthDate", "${DateUtils.getDay(it)}")
        }
        return result.toTypedArray()
    }


    private fun getWeightData() : Array<Int>{
        val startTime = timeRangeView.getStartAndEndTime()[0].time
        val endTime = timeRangeView.getStartAndEndTime()[1].time
        val datas = ChartDateHelper.getAllWeightData(startTime, endTime)
        val times =
            DateUtils.getEveryDayTimestamps(
                startTime,
                endTime
            )
        val result = arrayListOf<Int>()
        times.forEach { _ ->
            result.add(0)
        }
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
            ChartActivity.TYPE_DISTENCE -> {
                "步"
            }
            ChartActivity.TYPE_WEIGHT -> {
                "千克"
            }
            else -> {
                "千卡"
            }
        }
    }

}