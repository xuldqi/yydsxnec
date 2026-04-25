package com.dn.sports.fragment.chart

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.dn.sports.data.local.entities.SportRecordEntity
import com.dn.sports.data.repository.SportRepository
import com.dn.sports.utils.DateUtils
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import java.util.*

class ChartViewModel(private val repository: SportRepository) : ViewModel() {

    data class ChartUiState(
        val data: Array<Int> = emptyArray(),
        val xLabels: Array<String> = emptyArray(),
        val totalValue: String = "0",
        val averageValue: String = "0",
        val isLoading: Boolean = false
    )

    private val _uiState = MutableStateFlow(ChartUiState())
    val uiState: StateFlow<ChartUiState> = _uiState

    fun loadData(chartType: Int, startTime: Long, endTime: Long) {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true)

            val records = repository.getRecordsInRange(startTime, endTime)

            // Calculate how many days are in this range
            val diffMs = endTime - startTime
            val dayCount = (diffMs / (24 * 60 * 60 * 1000L)).toInt() + 1

            val result = processDataByRange(records, startTime, dayCount, chartType)

            val sum = result.first.sum()
            _uiState.value = ChartUiState(
                data = result.first,
                xLabels = result.second,
                totalValue = sum.toString(),
                averageValue = if (dayCount > 0) (sum / dayCount).toString() else "0",
                isLoading = false
            )
        }
    }

    private fun processDataByRange(
        records: List<SportRecordEntity>,
        startTime: Long,
        dayCount: Int,
        chartType: Int
    ): Pair<Array<Int>, Array<String>> {
        val result = Array(dayCount) { 0 }
        val labels = Array(dayCount) { "" }
        val calendar = Calendar.getInstance()

        for (i in 0 until dayCount) {
            val recordTime = startTime + i * 24 * 60 * 60 * 1000L
            calendar.timeInMillis = recordTime

            // Labels: For Daily/Weekly use Day Name, for Month use Day Number
            labels[i] = if (dayCount <= 7) {
                getDayName(calendar.get(Calendar.DAY_OF_WEEK))
            } else {
                calendar.get(Calendar.DAY_OF_MONTH).toString()
            }

            val daySum = records.filter {
                DateUtils.getYearMonthDay(it.currentTime) == DateUtils.getYearMonthDay(recordTime)
            }.sumOf {
                // Adjust based on chart type (Steps for type 6, or calculate kcal)
                if (chartType == 2) { // Logic for distance/weight might vary, but for steps:
                    it.steps
                } else {
                    it.steps // Default to steps for now
                }
            }

            result[i] = daySum
        }

        return Pair(result, labels)
    }

    private fun getDayName(dayOfWeek: Int): String {
        return when (dayOfWeek) {
            Calendar.MONDAY -> "周一"
            Calendar.TUESDAY -> "周二"
            Calendar.WEDNESDAY -> "周三"
            Calendar.THURSDAY -> "周四"
            Calendar.FRIDAY -> "周五"
            Calendar.SATURDAY -> "周六"
            Calendar.SUNDAY -> "周日"
            else -> ""
        }
    }
}
