package com.dn.sports.chart

import com.github.aachartmodel.aainfographics.aachartcreator.*
import com.github.aachartmodel.aainfographics.aaoptionsmodel.AAStyle
import com.github.aachartmodel.aainfographics.aaoptionsmodel.AATitle
import com.github.aachartmodel.aainfographics.aaoptionsmodel.AAXAxis
import com.github.aachartmodel.aainfographics.aaoptionsmodel.AAYAxis
import com.dn.sports.utils.ceil
import com.dn.sports.utils.floor

object ChartHelper {


    /**
     * 获取X轴 AAXAxis 配置
     */
    fun initChart(
        data: Array<Int>,
        xName: Array<String>,
        title: String,
        xInterval: Int = 0
    ): AAOptions {
        val max = data.maxOrNull() ?: 0.ceil()
        val min = data.minOrNull() ?: 0.floor()
        val aaChartModel = AAChartModel()
            .chartType(AAChartType.Areaspline)
            .backgroundColor("#f5f5f5")
            .markerRadius(0)
            .yAxisReversed(true)
            .colorsTheme(arrayOf("#F28E83", "#7fF6DCD9"))
            .xAxisGridLineWidth(1)
            .series(
                arrayOf(
                    AASeriesElement()
                        .name("")
                        .showInLegend(false)
                        .data(data as Array<Any>)
                )
            )
            .xAxisVisible(true)
        val aaOptions = aaChartModel.aa_toAAOptions()
        val aaXAxis = AAXAxis()
            .reversed(aaChartModel.xAxisReversed)
            .gridLineWidth(aaChartModel.xAxisGridLineWidth) //x轴网格线宽度
            .title(AATitle())
            //设置x轴坐标点名称
            .categories(xName)
            .visible(aaChartModel.xAxisVisible) //x轴是否可见
            .tickInterval(xInterval) //x轴坐标点间隔数
        val title = AATitle()
            .style(
                AAStyle()
                    .color("#00000000")
            )
            .text(title)
        val aayAxis = AAYAxis()
            .gridLineWidth(aaChartModel.yAxisGridLineWidth) //x轴网格线宽度
            .title(title)
            .min(min)
            .max(max)
            .minTickInterval((max - min) / 3)
            .opposite(true)
            .visible(aaChartModel.yAxisVisible) //x轴是否可见
            .tickInterval(0) //x轴坐标点间隔数
        aaOptions.xAxisArray = arrayOf(aaXAxis)
        aaOptions.yAxisArray = arrayOf(aayAxis)
        return aaOptions
    }
}