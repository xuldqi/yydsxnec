package com.dn.sports.dialog

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import com.dn.sports.R
import com.dn.sports.utils.clickDelay

class JumpSummaryDialog(
    context: Context,
    private val durationText: String,
    private val calories: Int,
    private val onCheckInClicked: () -> Unit
) : BasePopup(context, ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT) {

    private lateinit var view: View

    override fun createDialogView(context: Context, inflater: LayoutInflater): View {
        view = inflater.inflate(R.layout.dialog_jump_summary, null)
        
        view.findViewById<TextView>(R.id.tvDuration).text = durationText
        view.findViewById<TextView>(R.id.tvCalories).text = calories.toString()
        
        view.findViewById<TextView>(R.id.btnCheckIn).clickDelay {
            dismissDialog()
            onCheckInClicked()
        }
        
        view.findViewById<TextView>(R.id.btnClose).clickDelay {
            dismissDialog()
            onCheckInClicked() // Both buttons eventually finish the session
        }
        
        return view
    }

    override fun onDismissDialog() {
        // No-op
    }
}
