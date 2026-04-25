package com.dn.sports.jumprope

import androidx.lifecycle.viewModelScope
import com.dn.sports.common.BaseViewModel
import com.dn.sports.data.local.entities.SportRecordEntity
import com.dn.sports.data.repository.SportRepository
import com.dn.sports.utils.DateUtils
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

class JumpRopeViewModel(private val repository: SportRepository) : BaseViewModel() {

    data class JumpRopeUiState(
        val secondsElapsed: Long = 0L,
        val exerciseState: ExerciseState = ExerciseState.READY,
        val jumpCount: Int = 0,
        val calories: Int = 0
    )

    enum class ExerciseState { READY, RUNNING, PAUSED }

    private val _uiState = MutableStateFlow(JumpRopeUiState())
    val uiState: StateFlow<JumpRopeUiState> = _uiState.asStateFlow()

    private var timerJob: Job? = null

    fun startExercise() {
        if (_uiState.value.exerciseState != ExerciseState.RUNNING) {
            _uiState.update { it.copy(exerciseState = ExerciseState.RUNNING) }
            startTimer()
        }
    }

    fun pauseExercise() {
        if (_uiState.value.exerciseState == ExerciseState.RUNNING) {
            _uiState.update { it.copy(exerciseState = ExerciseState.PAUSED) }
            timerJob?.cancel()
        }
    }

    fun resumeExercise() {
        if (_uiState.value.exerciseState == ExerciseState.PAUSED) {
            _uiState.update { it.copy(exerciseState = ExerciseState.RUNNING) }
            startTimer()
        }
    }

    fun stopExercise() {
        timerJob?.cancel()
    }

    fun saveFinalRecord() {
        viewModelScope.launch {
            val state = _uiState.value
            if (state.secondsElapsed < 3) return@launch

            val entity = SportRecordEntity(
                id = 0,
                startTime = System.currentTimeMillis() - (state.secondsElapsed * 1000),
                useTime = state.secondsElapsed * 1000,
                steps = state.jumpCount,
                currentTime = System.currentTimeMillis(),
                date = DateUtils.getYMD(0),
                type = 7,
                subType = 0
            )
            repository.saveSportRecord(entity)
        }
    }

    private fun startTimer() {
        timerJob?.cancel()
        timerJob = viewModelScope.launch {
            while (true) {
                delay(1000)
                _uiState.update { currentState ->
                    val nextSeconds = currentState.secondsElapsed + 1
                    currentState.copy(
                        secondsElapsed = nextSeconds,
                        calories = calculateCalories(nextSeconds)
                    )
                }
            }
        }
    }

    fun updateJumpCount(count: Int) {
        _uiState.update { it.copy(jumpCount = count) }
    }

    private fun calculateCalories(seconds: Long): Int = (seconds / 60.0 * 11).toInt()

    override fun onCleared() {
        super.onCleared()
        timerJob?.cancel()
    }
}
