package com.dn.sports.fragment.target

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.dn.sports.R
import com.dn.sports.adcoinLogin.StepUserManager
import com.dn.sports.fragment.BaseFragment
import com.dn.sports.utils.clickDelay
import com.dn.sports.utils.toast
import com.dn.sports.view.CustomWheelView
import com.zyyoona7.wheel.WheelView
import com.zyyoona7.wheel.adapter.ArrayWheelAdapter
import com.zyyoona7.wheel.listener.OnItemSelectedListener
import kotlinx.android.synthetic.main.fragment_step_target.*
import kotlinx.android.synthetic.main.view_custom_wheel.*

class WeightTargetFragment: BaseFragment() {
    override fun getViewByLayout(
        inflater: LayoutInflater?,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return inflater!!.inflate(R.layout.fragment_step_target, container, false)

    }


    private val minStep = 10
    private val maxStep = 200
    var targetStepNum = 0f
//    var targetWeightNum = StepUserManager.getInstance().getTargetWeightNum(requireContext())
//    var targetDistanceNum = StepUserManager.getInstance().getTargetDistanceNum(requireContext())

    var wheelView: WheelView ?=null
    override fun initViewAction(view: View?) {
        targetStepNum = StepUserManager.getInstance().getTargetWeightNum(requireContext()).toFloat()
        val list = arrayListOf<Float>()
        //等差数列，公差为0.5
        for (i in 0..190*2) {
            list.add(10 + (i - 1) * 0.5f)
        }

        val customView = view?.findViewById<CustomWheelView>(R.id.customView)
        wheelView = customView?.getWheel()
//        wheelView?.setTextSize(45f)
        wheelView?.setData(list)
        wheelview?.scaleX
        customView?.setTextWidth(180,"kg")
        wheelView?.setSelectedPosition(list.indexOf(targetStepNum))
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        tvNum.text = targetStepNum.toString()
        wheelView?.setOnItemSelectedListener(object : OnItemSelectedListener {
            override fun onItemSelected(
                wheelView: WheelView,
                adapter: ArrayWheelAdapter<*>,
                position: Int
            ) {
                tvNum.text =( adapter.getItem<Int>(position)).toString()
            }
        })
        tvUnit.text = "千克"
        btConfirm.clickDelay {
            StepUserManager.getInstance()
                .setTargetWeightNum(requireContext(), tvNum.text.toString().toFloat())
            requireActivity().finish()
            "设置成功" .toast()
        }
    }

    override fun updateUserInfo() {

    }

    override fun clearUserInfo() {

    }
}