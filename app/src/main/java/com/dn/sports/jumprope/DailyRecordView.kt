package com.dn.sports.jumprope

import android.content.Context
import android.util.AttributeSet
import android.view.LayoutInflater
import android.widget.FrameLayout
import com.dn.sports.R

class DailyRecordView @JvmOverloads constructor(
        context: Context, attrs: AttributeSet? = null
) : FrameLayout(context, attrs) {

    final val STATE_PASSED_TODAY_ = 0
    final val STATE_PASSED = 1
    final val STATE_PASSED_FEATURE_ = 2

    init {
        LayoutInflater.from(context).inflate(R.layout.daily_record_view, this)

    }

}