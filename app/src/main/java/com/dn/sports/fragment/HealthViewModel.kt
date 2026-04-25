package com.dn.sports.fragment

import androidx.lifecycle.viewModelScope
import com.dn.sports.adcoinLogin.StepUserManager
import com.dn.sports.common.BaseViewModel
import com.dn.sports.data.repository.SportRepository
import com.dn.sports.greendao.DbHelper
import com.dn.sports.utils.DateUtils
import com.dn.sports.utils.Utils
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class HealthViewModel(private val repository: SportRepository) : BaseViewModel() {

    data class HealthUiState(
        val todaySteps: Int = 0,
        val targetSteps: Int = 8000,
        val calories: String = "0 kcal",
        val distance: String = "0.00 km",
        val jumpRopeCount: Int = 0,
        val stepsRatio: Float = 0f,
        val calRatio: Float = 0f,
        val distRatio: Float = 0f
    )

    private val _uiState = MutableStateFlow(HealthUiState())
    val uiState: StateFlow<HealthUiState> = _uiState.asStateFlow()

    init {
        refreshAll()
        observeRecords()
    }

    fun refreshAll() {
        val today = StepUserManager.getInstance().todaySteps
        // For now, keep using StepUserManager for 'todaySteps' until StepServices is refactored to Room
        updateStepStats(today)
    }

    private fun observeRecords() {
        viewModelScope.launch {
            repository.getAllRecordsFlow().collect { records ->
                val todayJumpCount = getTodayJumpCount(records)
                _uiState.update { it.copy(jumpRopeCount = todayJumpCount) }
            }
        }
    }

    private suspend fun getTodayJumpCount(
        records: List<com.dn.sports.data.local.entities.SportRecordEntity>
    ): Int = withContext(Dispatchers.Default) {
        val today = DateUtils.getYMD(0)
        val roomTotal = records.filter { it.date == today && it.type == 7 }.sumOf { it.steps }
        if (roomTotal > 0) {
            roomTotal
        } else {
            DbHelper.getHistoryByType(7)?.filter { it.date == today }?.sumOf { it.steps } ?: 0
        }
    }

    fun updateStepStats(steps: Int) {
        val target = StepUserManager.getInstance().getTargetStepNum(com.dn.sports.StepApplication.getInstance())
        val calories = Utils.getKalByStep(steps)
        val distance = Utils.getDistanceByStep(steps)

        val stepsRatio = if (target > 0) steps.toFloat() / target.toFloat() else 0f
        val calRatio = calories.toFloat() / 300f // 300 kcal as a soft target
        val distRatio = (distance.replace("km","").trim().toFloatOrNull() ?: 0f) / 5.0f // 5km as a soft target

        _uiState.update {
            it.copy(
                todaySteps = steps,
                targetSteps = target,
                calories = "$calories kcal",
                distance = distance,
                stepsRatio = stepsRatio,
                calRatio = calRatio,
                distRatio = distRatio
            )
        }
    }
}
