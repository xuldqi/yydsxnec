package com.dn.sports.common

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.dn.sports.StepApplication

/**
 * Generic ViewModel Factory to handle manual injection of Repositories.
 */
class ViewModelFactory : ViewModelProvider.Factory {
    @Suppress("UNCHECKED_CAST")
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        return when {
            modelClass.isAssignableFrom(com.dn.sports.jumprope.JumpRopeViewModel::class.java) -> {
                com.dn.sports.jumprope.JumpRopeViewModel(
                    StepApplication.getInstance().repository
                ) as T
            }
            modelClass.isAssignableFrom(com.dn.sports.fragment.HealthViewModel::class.java) -> {
                com.dn.sports.fragment.HealthViewModel(
                    StepApplication.getInstance().repository
                ) as T
            }
            modelClass.isAssignableFrom(com.dn.sports.fragment.chart.ChartViewModel::class.java) -> {
                com.dn.sports.fragment.chart.ChartViewModel(
                    StepApplication.getInstance().repository
                ) as T
            }
            else -> throw IllegalArgumentException("Unknown ViewModel class: ${modelClass.name}")
        }
    }
}
