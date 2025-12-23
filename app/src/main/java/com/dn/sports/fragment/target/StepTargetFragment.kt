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

class StepTargetFragment:BaseFragment() {
    override fun getViewByLayout(
        inflater: LayoutInflater?,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return inflater!!.inflate(R.layout.fragment_step_target, container, false)

    }


    private val minStep = 1000
    private val maxStep = 20000
    var targetStepNum = 0
//    var targetWeightNum = StepUserManager.getInstance().getTargetWeightNum(requireContext())
//    var targetDistanceNum = StepUserManager.getInstance().getTargetDistanceNum(requireContext())

    var wheelView: WheelView ?=null
    override fun initViewAction(view: View?) {
        targetStepNum = StepUserManager.getInstance().getTargetStepNum(requireContext())
        val list = arrayListOf<Int>()
        for (i in minStep..maxStep step 1000) {
            list.add(i)
        }
        val customView = view?.findViewById<CustomWheelView>(R.id.customView)
        wheelView = customView?.getWheel()
//        wheelView?.setTextSize(45f)
        wheelView?.setData(list)
        customView?.setTextWidth(180,"步数")
        wheelView?.setSelectedPosition(list.indexOf(targetStepNum))
        wheelView?.isCyclic = true
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        tvNum.text = targetStepNum.toString()
        wheelView?.setOnItemSelectedListener(object : OnItemSelectedListener{
            override fun onItemSelected(
                wheelView: WheelView,
                adapter: ArrayWheelAdapter<*>,
                position: Int
            ) {
                tvNum.text =( adapter.getItem<Int>(position)).toString()
            }
        })
        tvUnit.text = "步"
        btConfirm.clickDelay {
            StepUserManager.getInstance()
                .setTargetStepNum(requireContext(), tvNum.text.toString().toInt())
            requireActivity().finish()
            "设置成功" .toast()
        }
    }

    override fun updateUserInfo() {

    }

    override fun clearUserInfo() {

    }
}