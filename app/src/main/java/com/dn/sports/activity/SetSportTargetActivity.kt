package com.dn.sports.activity

import android.content.Intent
import android.os.Bundle
import com.dn.sports.R
import com.dn.sports.adcoinLogin.StepUserManager
import com.dn.sports.common.BaseActivity
import com.dn.sports.utils.clickDelay
import com.dn.sports.utils.toast
import com.dn.sports.view.CustomWheelView
import com.zyyoona7.wheel.WheelView
import com.zyyoona7.wheel.adapter.ArrayWheelAdapter
import com.zyyoona7.wheel.listener.OnItemSelectedListener
import kotlinx.android.synthetic.main.fragment_step_target.*
import kotlinx.android.synthetic.main.view_custom_wheel.*

class SetSportTargetActivity : BaseActivity() {

    private var type = 0f

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        type = getIntent().getIntExtra("set_sport_target_type", 0).toFloat()
        setContentView(R.layout.activity_set_sport_target_new)
        setTitle("设置运动目标")
        val targetStepNum = StepUserManager.getInstance().getSportTargetNum(this, type)
        val list = mutableListOf<Int>(400,800,1000, 3000, 4000, 5000, 6000, 7000, 8000,9000,10000,15000,21500,42500)
        val wheelView = customView?.getWheel()
        wheelView?.setData(list)
        wheelview?.scaleX
        customView?.setTextWidth(180, "米")
        wheelView?.setSelectedPosition(list.indexOf(targetStepNum.toInt()))
        tvNum.text = targetStepNum.toString()
        wheelView?.setOnItemSelectedListener(object : OnItemSelectedListener {
            override fun onItemSelected(
                wheelView: WheelView,
                adapter: ArrayWheelAdapter<*>,
                position: Int
            ) {
                tvNum.text = (adapter.getItem<Int>(position)).toString()
            }
        })
        tvUnit.text = "米"
        btConfirm.clickDelay {
            StepUserManager.getInstance()
                .setSportTargetNum(this, tvNum.text.toString().toFloat(),type)
            val intent = Intent()
            intent.putExtra("set_sport_target_type", type)
            setResult(10001, intent)
            finish()
        }
    }


}