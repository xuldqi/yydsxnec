package com.dn.sports.dialog

import android.content.Intent
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.DialogFragment
import com.dn.sports.MainActivity
import com.dn.sports.R
import com.dn.sports.StepApplication
import com.dn.sports.YSXYActivity
import com.dn.sports.adcoinLogin.chuanshanjia.AdManagerImpl.initSdk
import com.dn.sports.utils.SharedPreferenceUtil.Companion.getInstance
import com.dn.sports.utils.bigClick
import com.dn.sports.utils.clickDelay
import com.dn.sports.utils.dp
import kotlinx.android.synthetic.main.dialog_first_hint_for_user.tvPrivate
import kotlinx.android.synthetic.main.dialog_first_hint_for_user.tvUser

class UserFirstDialog:DialogFragment() {

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.dialog_first_hint_for_user, container, false)
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        isCancelable = false
        val window = dialog?.window
        window?.setGravity(Gravity.CENTER)
        window?.setDimAmount(0f)
        window?.setBackgroundDrawable(ColorDrawable(resources.getColor(R.color.transparent)))
        window?.setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)

        tvUser.bigClick(10.dp)
        tvPrivate.bigClick(10.dp)
        tvUser.clickDelay {
            val it = Intent(context, YSXYActivity::class.java)
            it.putExtra("type", 1)
            context?.startActivity(it)
        }
        tvPrivate.clickDelay {
            val it = Intent(context, YSXYActivity::class.java)
            it.putExtra("type", 2)
            context?.startActivity(it)
        }
        view.findViewById<View>(R.id.deny).setOnClickListener { System.exit(9) }
        view.findViewById<View>(R.id.ok).setOnClickListener {
            initSdk(StepApplication.getInstance())
            getInstance(context!!).put("userAgree", true)
            val it = Intent(context, MainActivity::class.java)
            context!!.startActivity(it)
            dismiss()
        }
    }


}