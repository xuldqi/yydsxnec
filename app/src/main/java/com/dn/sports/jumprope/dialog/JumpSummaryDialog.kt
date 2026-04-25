package com.dn.sports.jumprope.dialog

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.animation.AnimationUtils
import android.widget.TextView
import androidx.fragment.app.DialogFragment
import com.dn.sports.R
import com.dn.sports.utils.clickDelay

class JumpSummaryDialog : DialogFragment() {

    var durationText: String = ""
    var calories: Int = 0
    var jumpCount: Int = 0
    var onCheckInClicked: (() -> Unit)? = null

    companion object {
        fun newInstance(durationText: String, calories: Int, jumpCount: Int, onCheckIn: () -> Unit): JumpSummaryDialog {
            return JumpSummaryDialog().apply {
                this.durationText = durationText
                this.calories = calories
                this.jumpCount = jumpCount
                this.onCheckInClicked = onCheckIn
            }
        }
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        val view = inflater.inflate(R.layout.dialog_jump_summary, container, false)

        view.findViewById<TextView>(R.id.tvDuration).text = durationText
        view.findViewById<TextView>(R.id.tvCalories).text = calories.toString()
        view.findViewById<TextView>(R.id.tvJumps)?.text = jumpCount.toString()

        view.findViewById<TextView>(R.id.btnCheckIn).clickDelay {
            dismiss()
            onCheckInClicked?.invoke()
        }

        view.findViewById<TextView>(R.id.btnClose).clickDelay {
            dismiss()
            onCheckInClicked?.invoke()
        }

        view.startAnimation(AnimationUtils.loadAnimation(context, R.anim.pulse_scale))

        return view
    }

    override fun onStart() {
        super.onStart()
        dialog?.window?.setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        dialog?.window?.setBackgroundDrawableResource(android.R.color.transparent)
    }
}
