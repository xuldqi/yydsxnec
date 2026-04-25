package com.dn.sports.chart

import com.github.aachartmodel.aainfographics.aachartcreator.*
import com.github.aachartmodel.aainfographics.aaoptionsmodel.*
/**
 * Modernized ChartHelper with Premium Visualization styles.
 */
object ChartHelper {

    fun initChart(
        data: Array<Int>,
        xName: Array<String>,
        titleString: String,
        xInterval: Int = 0
    ): AAOptions {
        // Premium Gradient: From Semi-transparent Main Color to Transparent
        val gradientColor = mapOf(
            "linearGradient" to mapOf("x1" to 0, "y1" to 0, "x2" to 0, "y2" to 1),
            "stops" to arrayOf(
                arrayOf(0, "#F37866"),
                arrayOf(1, "rgba(243, 120, 102, 0)")
            )
        )

        val aaChartModel = AAChartModel()
            .chartType(AAChartType.Areaspline)
            .backgroundColor("#00000000") // Transparent
            .markerRadius(4)
            .markerSymbol(AAChartSymbolType.Circle)
            .markerSymbolStyle(AAChartSymbolStyleType.BorderBlank)
            .yAxisReversed(false) // Standard orientation
            .colorsTheme(arrayOf("#F37866"))
            .series(
                arrayOf(
                    AASeriesElement()
                        .name(titleString)
                        .showInLegend(false)
                        .fillColor(gradientColor) // Gradient Fill
                        .lineWidth(3f)
                        .data(data.map { it }.toTypedArray())
                )
            )
            .xAxisVisible(true)
            .yAxisVisible(true)

        val aaOptions = aaChartModel.aa_toAAOptions()

        // Refine X-Axis
        aaOptions.xAxis?.apply {
            categories(xName)
            gridLineWidth(0f)
            labels(AALabels().style(AAStyle().color("#999999").fontSize(11)))
            tickInterval(xInterval)
        }

        // Refine Y-Axis
        aaOptions.yAxis?.apply {
            gridLineDashStyle("Dash")
            gridLineWidth(0.5f)
            gridLineColor("#E0E0E0")
            labels(AALabels().style(AAStyle().color("#999999").fontSize(11)))
            title(AATitle().text(""))
            opposite(false)
            min(0f)
        }

        // Tooltip Styling
        aaOptions.tooltip?.apply {
            enabled(true)
            backgroundColor("#FFFFFF")
            borderRadius(8f)
            style(AAStyle().color("#333333"))
        }

        return aaOptions
    }
}
