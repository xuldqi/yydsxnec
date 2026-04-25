package com.dn.sports.common

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.launch

/**
 * Modern BaseViewModel focusing on Coroutines and State/Event management.
 */
abstract class BaseViewModel : ViewModel() {

    // One-shot events (e.g., Toast, Dialog, Finish)
    private val _eventFlow = MutableSharedFlow<ViewModelEvent>()
    val eventFlow = _eventFlow.asSharedFlow()

    fun emitEvent(event: ViewModelEvent) {
        viewModelScope.launch {
            _eventFlow.emit(event)
        }
    }

    sealed class ViewModelEvent {
        data class ShowToast(val message: String) : ViewModelEvent()
        data class FinishActivity(val result: Any? = null) : ViewModelEvent()
    }
}
