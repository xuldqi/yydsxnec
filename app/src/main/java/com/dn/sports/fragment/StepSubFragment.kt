package com.dn.sports.fragment

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.activity.result.contract.ActivityResultContracts
import com.dn.sports.R
import com.dn.sports.activity.SetSportTargetActivity
import com.dn.sports.activity.SportRecordActivity
import com.dn.sports.dialog.CountDownDialog
import com.dn.sports.greendao.DbHelper.getHistoryByType
import com.dn.sports.utils.clickDelay
import com.dn.sports.utils.jumpActivity
import com.dn.sports.utils.toDistance
import com.dn.sports.utils.toast
import kotlinx.android.synthetic.main.fragment_sub_step.*

class StepSubFragment() : BaseFragment() {
    private var title: TextView? = null
    private var data: TextView? = null
    private var countDownDialog: CountDownDialog? = null
     var setSportTargetType = 0
//    private val setTargetType: TextView? = null
    override fun getViewByLayout(
        inflater: LayoutInflater?,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return inflater!!.inflate(R.layout.fragment_sub_step, container, false)
    }

    var type: Int = 0
    private val targetPickerLauncher =
        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
            val data = result.data ?: return@registerForActivityResult
            setSportTargetType = data.getIntExtra("set_sport_target_type", 0)
        }

    override fun initViewAction(view: View?) {
        view ?: return
        title = view.findViewById(R.id.title)
        data = view.findViewById(R.id.data)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
    }

    override fun onResume() {
        super.onResume()
        initWithType()
    }

    private val typeTotalDistance: String
        get() {
            val models = getHistoryByType(type)
            var steps = 0
            if (models != null) {
                for (item in models) {
                    steps += item.steps
                }
            }
            return steps.toDistance()
        }

    @SuppressLint("SetTextI18n")
    private fun initWithType() {
        if (type == TYPE_RUN_INDOOR) {
            title!!.text = "累计室内跑步 $typeTotalDistance (公里)"
        }
        if (type == TYPE_RUN_OUTDOOR) {
            title!!.text = "累计户外跑步 $typeTotalDistance (公里)"
        } else if (type == TYPE_FAST_WALK) {
            title!!.text = "累计健走 $typeTotalDistance (公里)"
        } else if (type == TYPE_ON_FOOT) {
            title!!.text = "累计徒步 $typeTotalDistance (公里)"
        } else if (type == TYPE_MOUNTAIN_CLIMBING) {
            title!!.text = "累计登山 $typeTotalDistance (公里)"
        }
        btLeft.clickDelay {
            val intent = Intent()
            intent.putExtra("set_sport_target_type", setSportTargetType)
            activity?.let { intent.setClass(it, SetSportTargetActivity::class.java) }
            targetPickerLauncher.launch(intent)
        }
        btRight.clickDelay {
            activity?.jumpActivity(SportRecordActivity::class.java) {
                it.putExtra("type", type)
            }
        }


        btGo.clickDelay {
            if (activity == null) return@clickDelay
            if (type == TYPE_RUN_INDOOR) {
                showCountDownDialog()
            } else {
                "户外轨迹功能暂时下线".toast()
            }
        }
        
        // 为 GO 按钮添加呼吸动效 (Micro-interaction: Pulse)
        val pulseAnim = android.view.animation.AnimationUtils.loadAnimation(context, R.anim.pulse_scale)
        btGo.startAnimation(pulseAnim)
    }

    private fun showCountDownDialog() {
        if (countDownDialog == null) {
            countDownDialog = CountDownDialog(activity)
        }
        countDownDialog!!.setType(type, setSportTargetType)
        countDownDialog!!.showDialogAtCenter()
    }

    val isCountDowning: Boolean
        get() = countDownDialog != null && countDownDialog!!.isShowing

    override fun updateUserInfo() {}
    override fun clearUserInfo() {}

    companion object {
        const val TYPE_RUN_OUTDOOR = 1
        const val TYPE_RUN_INDOOR = 2
        const val TYPE_FAST_WALK = 3
        const val TYPE_ON_FOOT = 4
        const val TYPE_MOUNTAIN_CLIMBING = 5
    }
}
