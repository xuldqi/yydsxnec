package com.dn.sports.dialog

import android.content.Intent
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.content.ContextCompat
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
        window?.setBackgroundDrawable(ColorDrawable(ContextCompat.getColor(requireContext(), R.color.transparent)))
        window?.setLayout(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)

        tvUser.bigClick(10.dp)
        tvPrivate.bigClick(10.dp)
        tvUser.clickDelay {
            val intent = Intent(context, YSXYActivity::class.java)
            intent.putExtra("type", 1)
            context?.startActivity(intent)
        }
        tvPrivate.clickDelay {
            val intent = Intent(context, YSXYActivity::class.java)
            intent.putExtra("type", 2)
            context?.startActivity(intent)
        }
        view.findViewById<View>(R.id.deny).setOnClickListener { 
            // 隐私合规：用户拒绝隐私政策时正常退出，不能使用System.exit强制杀进程
            activity?.finishAffinity()
        }
        view.findViewById<View>(R.id.ok).setOnClickListener {
            val safeContext = requireContext()
            getInstance(safeContext).put("userAgree", true)
            initSdk(StepApplication.getInstance())
            val intent = Intent(safeContext, MainActivity::class.java)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
            safeContext.startActivity(intent)
            activity?.finish()
            dismiss()
        }
    }


}
