package com.dn.sports.dialog

import android.content.Context
import android.os.Handler
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import com.dn.sports.R
import com.dn.sports.database.BodyRecordModel
import com.dn.sports.fragment.RecordSubFragment
import com.dn.sports.view.CustomWheelView
import com.dn.sports.view.Rulerview
import com.zyyoona7.wheel.WheelView
import com.zyyoona7.wheel.adapter.ArrayWheelAdapter
import com.zyyoona7.wheel.listener.OnItemSelectedListener
import kotlinx.android.synthetic.main.fragment_step_target.*
import kotlinx.android.synthetic.main.view_custom_wheel.*

class RulerViewPickDialog(context: Context?) :
    BasePopup(context, ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT) {
    private var title: TextView? = null
    private var data: TextView? = null
    private var ok: View? = null
    var customView: CustomWheelView? = null
    var rulerData = 0f
        private set

    override fun createDialogView(context: Context, inflater: LayoutInflater): View {
        val view = inflater.inflate(R.layout.dialog_ruler_pick, null)
        title = view.findViewById(R.id.title)
        data = view.findViewById(R.id.data)
        view.findViewById<View>(R.id.deny).setOnClickListener(
            View.OnClickListener { dismissDialog() })
        ok = view.findViewById(R.id.auth)
        customView = view.findViewById<CustomWheelView>(R.id.customView)
        return view
    }

    var list = arrayListOf<Int>()
    var listWeight = arrayListOf<Float>()

    fun initWithType(
        titleContent: String?,
        type: Int,
        listener: View.OnClickListener?,
        current: Float
    ) {
        ok!!.setOnClickListener(listener)
        title!!.text = titleContent
        var min = 0
        var max = 0
        var step = 10
        var target = current
        var unit="厘米"
        if (type == RecordSubFragment.TYPE_HEIGHT) {
            min = 20
            max = 260
            if (target == 0f) {
                target = 165f
            }
        } else if (type == RecordSubFragment.TYPE_WEIGHT) {
            min = 5
            max = 300
            step = 1
            if (target == 0f) {
                target = 55f
            }
            unit="千克"
        } else if (type == RecordSubFragment.TYPE_XW) {
            min = 10
            max = 200
            if (target == 0f) {
                target = 80f
            }
        } else if (type == RecordSubFragment.TYPE_YW) {
            min = 10
            max = 200

            if (target == 0f) {
                target = 65f
            }
        } else if (type == RecordSubFragment.TYPE_TW) {
            min = 10
            max = 200
            if (target == 0f) {
                target = 80f
            }
        } else if (type == RecordSubFragment.TYPE_SBW) {
            min = 10
            max = 100
            if (target == 0f) {
                target = 30f
            }
        } else if (type == RecordSubFragment.TYPE_DTW) {
            min = 10
            max = 100
            if (target == 0f) {
                target = 40f
            }
        } else if (type == RecordSubFragment.TYPE_XTW) {
            min = 10
            max = 100
            if (target == 0f) {
                target = 30f
            }
        }

        for (i in min * 10..max * 10 step step) {

            if (type == RecordSubFragment.TYPE_WEIGHT) {
                listWeight.add(i / 10f)
            }else{
                list.add(i / 10)
            }
        }

        val wheelView = customView?.getWheel()
        if (type == RecordSubFragment.TYPE_WEIGHT) {
            wheelView?.setData(listWeight)
        }else{
            wheelView?.setData(list)

        }
        customView?.setTextWidth(130, unit)
        customView?.setBglolor(R.color.white)
        var index = 0
        if (type == RecordSubFragment.TYPE_WEIGHT) {
            index = listWeight.indexOf(target)
        } else {
            index = list.indexOf(target.toInt())
        }

        if (type == RecordSubFragment.TYPE_WEIGHT) {
            if (index > -1 && index < listWeight.size) {
                wheelView?.setSelectedPosition(index)
            }
        }else{
            if (index > -1 && index < list.size) {
                wheelView?.setSelectedPosition(index)
            }

        }

        wheelView?.isCyclic=true
        wheelView?.setOnItemSelectedListener(object : OnItemSelectedListener {
            override fun onItemSelected(
                wheelView: WheelView,
                adapter: ArrayWheelAdapter<*>,
                position: Int
            ) {
                if (type == RecordSubFragment.TYPE_WEIGHT) {
                    rulerData = adapter.getItem<Float>(position)?.toFloat() ?: 0f
                }else{
                    rulerData = adapter.getItem<Int>(position)?.toFloat() ?: 0f
                }
            }
        })


    }

    override fun onDismissDialog() {}
}