package com.dn.sports.view

import android.content.Context
import android.util.AttributeSet
import android.view.LayoutInflater
import android.widget.FrameLayout
import com.dn.sports.R
import com.dn.sports.adcoinLogin.StepUserManager
import com.dn.sports.ormbean.BodyRecord
import com.dn.sports.ormbean.StepCountRecord
import com.dn.sports.utils.*
import kotlinx.android.synthetic.main.chart_card_view.view.*

class ChartCardView @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null
) : FrameLayout(context, attrs) {

    init {
        LayoutInflater.from(context).inflate(R.layout.chart_card_view, this)
    }

    /**
     * 0-热量
     * 1-距离
     * 2-体重
     */
    var chartType = 0

    /**
     * 0-日
     * 1-周
     * 2-月
     */
    var dateType = 0

    fun setTitle(data: Array<Int>) {
        getData()
        val time = when (dateType) {
            0 -> "日"
            1 -> "周"
            else -> "月"
        }
        when (chartType) {
            0 -> {
                tvTitle1.text = "总消耗"
                tvTitle2.text = "平均每${time}消耗"
                tvValue1.text = "${getSum(data)}千卡"
                tvValue2.text = "${getAvg(data)}千卡"
                tvValue3.text = "${days}天"
                tvValue4.text = "${max.toKal()}千卡"
            }
            1 -> {
                tvTitle1.text = "总距离"
                tvTitle2.text = "平均每${time}距离"
                tvValue1.text = "${getSum(data).toDistance()}公里"
                tvValue2.text = "${getAvg(data).toDistance()}公里"
                tvValue3.text = "${days}天"
                tvValue4.text = "${max.toDistance()}公里"
            }
            2 -> {
                tvTitle1.text = "历史最高"
                tvTitle2.text = "历史最低"
                layBottom.setGone()
                tvValue1.text = "${max}千克"
                tvValue2.text = "${min}千克"
//                tvValue3.text = "${days}天"
//                tvValue4.text = "${max}千克"
            }
        }
    }

    var targetStep = StepUserManager.getInstance().getTargetStepNum(this.context)
    var targetWeight = StepUserManager.getInstance().getTargetWeightNum(this.context)
    var targetHeat = StepUserManager.getInstance().getTargeHeatNum(this.context)

    //达标天数
    var days = 0
    var max = 0
    var min = 0


    fun getData() {
        var lastBeyondDate = ""
        val data = when (chartType) {
            0 -> ChartDateHelper.getAllStepsData(
                TimeRangeView.mStartTime.time, TimeRangeView.mEndTime.time
            )
            1 -> ChartDateHelper.getWalkStepData(
                TimeRangeView.mStartTime.time, TimeRangeView.mEndTime.time
            )
            else -> ChartDateHelper.getAllWeightData(
                TimeRangeView.mStartTime.time, TimeRangeView.mEndTime.time
            )
        }
        days = 0
        if (chartType == 0) {
            data?.forEach { step ->
                if (step is StepCountRecord) {
                    if (step.steps.toKal() >= targetHeat && lastBeyondDate != DateUtils.getYearMonthDay(
                            step.startTime
                        )
                    ) {
                        days++
                        if (lastBeyondDate.isEmpty()) {
                            lastBeyondDate = DateUtils.getYearMonthDay(step.currentTime.toLong())
                        }
                    }
                    if (step.steps > max) {
                        max = step.steps
                    }

                    if (step.steps < min) {
                        min = step.steps
                    }
                }
            }
        } else if (chartType == 1) {
            data?.forEach { step ->
                if (step is StepCountRecord) {
                    if (step.steps > targetStep && lastBeyondDate != DateUtils.getYearMonthDay(step.startTime)) {
                        days++
                        if (lastBeyondDate.isEmpty()) {
                            lastBeyondDate = DateUtils.getYearMonthDay(step.currentTime)
                        }
                    }
                    if (step.steps > max) {
                        max = step.steps
                    }

                    if (step.steps < min) {
                        min = step.steps
                    }
                }
            }
        } else {
            data?.forEach { body ->
                if (body is BodyRecord) {
                    if (body.data.toFloat()
                            .toInt() < targetWeight && lastBeyondDate != DateUtils.getYearMonthDay(
                            body.time
                        )
                    ) {
                        days++
                        if (lastBeyondDate.isEmpty()) {
                            lastBeyondDate = DateUtils.getYearMonthDay(body.time)
                        }
                    }

                    if (body.data.toFloat() > max) {
                        max = body.data.toFloat().toInt()
                    }
                    if (min == 0) {
                        min = body.data.toFloat().toInt()
                    }
                    if (body.data.toFloat() < min && body.data.toFloat() != 0f){
                        min = body.data.toFloat().toInt()
                    }
                }
            }
        }
    }

}

/**
 * 获取一个数组里最大值
 */
private fun getMax(data: Array<Int>): Int {
    var max = 0
    data.forEach {
        if (it > max) {
            max = it
        }
    }
    return max
}

/**
 * 获取数组最小值
 */
private fun getMin(data: Array<Int>, canBeZero: Boolean = true): Int {
    var min = 0
    data.forEach {
        if (it < min) {
            if (canBeZero) {
                min = it
            } else if (it != 0) {
                min = it
            }
        }
    }
    return min
}

/**
 * 数组求和
 */
private fun getSum(data: Array<Int>): Int {
    var sum = 0
    data.forEach {
        sum += it
    }
    return sum
}

/**
 * 数组求平均
 */
private fun getAvg(data: Array<Int>): Int {
    var sum = 0
    if (data.isNullOrEmpty()) {
        return 0
    }
    data.forEach {
        sum += it
    }
    return (sum.toFloat() / data.size).toInt()
}

