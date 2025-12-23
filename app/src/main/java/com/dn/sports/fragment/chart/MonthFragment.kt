package com.dn.sports.fragment.chart

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.github.aachartmodel.aainfographics.aachartcreator.AASeriesElement
import com.dn.sports.R
import com.dn.sports.activity.ChartActivity
import com.dn.sports.chart.ChartHelper
import com.dn.sports.common.LogUtils
import com.dn.sports.fragment.BaseFragment
import com.dn.sports.utils.*
import com.dn.sports.view.TimeRangeView
import kotlinx.android.synthetic.main.fragment_month.*

class MonthFragment : BaseFragment() {

    var chartType = 0

    override fun getViewByLayout(
        inflater: LayoutInflater?,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return inflater!!.inflate(R.layout.fragment_month, container, false)
    }

    override fun initViewAction(view: View?) {
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        timeRangeView.setMode(TimeRangeView.TIME_MODE_MOTH)
        io {
            val data =
                when(chartType){
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

    var monthTimes: List<Long>? = null

    private fun getWalkData(): Array<Int> {
        val startTime = timeRangeView.getStartAndEndTime()[0].time
        val endTime = timeRangeView.getStartAndEndTime()[1].time
        monthTimes =
            DateUtils.getEveryMonthTimestamps(
                startTime,
                DateUtils.getPreviousDayTimestamp(endTime, false).time
            )
        for (i in 1..12) {
            getEveryMonthData(i)
        }
        val result = mutableListOf<Int>()
        mothDataMap.forEach {
            result.add(getAverage(it.value))
        }
        return result.toTypedArray()
    }

    private fun getHeatData() : Array<Int>{
        val startTime = timeRangeView.getStartAndEndTime()[0].time
        val endTime = timeRangeView.getStartAndEndTime()[1].time
        monthTimes = DateUtils.getEveryMonthTimestamps(startTime, DateUtils.getPreviousDayTimestamp(endTime, false).time)
        for (i in 1..12) {
            getEveryMonthData(i,true)
        }
        val result = mutableListOf<Int>()
        mothDataMap.forEach {
            result.add(getAverage(it.value).toKal())
        }
        return result.toTypedArray()
    }


    private fun getWeightData() : Array<Int>{
        val startTime = timeRangeView.getStartAndEndTime()[0].time
        val endTime = timeRangeView.getStartAndEndTime()[1].time
        monthTimes = DateUtils.getEveryMonthTimestamps(startTime, DateUtils.getPreviousDayTimestamp(endTime, false).time)
        for (i in 1..12) {
            getEveryMonthWeightData(i)
        }
        val result = mutableListOf<Int>()
        mothDataMap.forEach {
            result.add(getAverage(it.value))
        }
        return result.toTypedArray()
    }


    //求一个数组的平均数
    private fun getAverage(array: Array<Int>): Int {
        if (array.isNullOrEmpty()) return 0
        var sum = 0
        array.forEach {
            sum += it
        }
        return sum / array.size
    }

    var mothDataMap = hashMapOf<Int, Array<Int>>()

    /**
     * index 1-12
     */
    private fun getEveryMonthData(index: Int,isAll:Boolean=false) {
        val startTime = monthTimes!![index - 1]
        val endTime = monthTimes!![index]
        val datas = if (!isAll) ChartDateHelper.getWalkStepData(startTime, endTime) else
            ChartDateHelper.getAllStepsData(startTime, endTime)
        val result = mutableListOf<Int>()
        datas.forEach {
            result.add(it.steps)
        }
        mothDataMap[index] = result.toTypedArray()
    }

    private fun getEveryMonthWeightData(index: Int) {
        val startTime = monthTimes!![index - 1]
        val endTime = monthTimes!![index]
        val datas = ChartDateHelper.getAllWeightData(startTime, endTime)
        val result = mutableListOf<Int>()
        datas?.forEach {
            result.add(it.data.toFloat().toInt())
        }
        mothDataMap[index] = result.toTypedArray()
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


    override fun updateUserInfo() {
    }

    override fun clearUserInfo() {
    }
}