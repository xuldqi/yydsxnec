package com.dn.sports.fragment

import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.fragment.app.viewModels
import androidx.lifecycle.lifecycleScope
import com.dn.sports.CountStepsActivity
import com.dn.sports.CustomTargetActivity
import androidx.fragment.app.viewModels
import androidx.lifecycle.lifecycleScope
import com.dn.sports.R
import com.dn.sports.RefreshTodayCount
import com.dn.sports.activity.ChangeOrderActivity
import com.dn.sports.adcoinLogin.StepUserManager
import com.dn.sports.bean.CardData
import com.dn.sports.common.ViewModelFactory
import com.dn.sports.greendao.DbHelper
import com.dn.sports.jumprope.JumpRopeGuildActivity
import com.dn.sports.utils.*
import com.dn.sports.utils.DateUtils.getEveryDayTimestamps
import com.dn.sports.view.SportViewCard
import com.google.gson.reflect.TypeToken
import com.umeng.commonsdk.statistics.common.DataHelper
import kotlinx.android.synthetic.main.fragment_health_home.*
import kotlinx.coroutines.flow.collect
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode

class HealthFragment : BaseFragment() {


    private val viewModel: HealthViewModel by viewModels { ViewModelFactory() }

    override fun getViewByLayout(
        inflater: LayoutInflater?,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return inflater!!.inflate(R.layout.fragment_health_home, container, false)
    }

    override fun initViewAction(view: View?) {
        view?.findViewById<View>(R.id.health_root_container)?.setPadding(0, Utils.getStatusBarHeight(activity), 0, 0)
    }

    var bt: View? = null
    var frame: View? = null
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        initClickListeners()
        observeViewModel()
    }

    private fun initClickListeners() {
        btMange.clickDelay {
            requireContext().jumpActivity(CustomTargetActivity::class.java)
        }
        btChangeOrder.clickDelay {
            requireContext().jumpActivity(ChangeOrderActivity::class.java)
        }
        layChangeOrder.clickDelay {
            requireContext().jumpActivity(ChangeOrderActivity::class.java)
        }
        bgJumpGuild.clickDelay {
            requireContext().jumpActivity(JumpRopeGuildActivity::class.java)
        }
    }

    private fun observeViewModel() {
        lifecycleScope.launchWhenStarted {
            viewModel.uiState.collect { state ->
                updateUI(state)
            }
        }
    }

    private fun updateUI(state: HealthViewModel.HealthUiState) {
        // Update Step Numbers & Info
        tvTodayNums?.text = state.todaySteps.toString()
        tvTodayKcal?.text = state.calories
        tvTodayDistance?.text = state.distance
        tvjump?.text = "${state.jumpRopeCount} 次"

        if (state.todaySteps >= state.targetSteps) {
            tvStep?.text = "今日步数已达标"
            checkAndShowCelebration()
        } else {
            tvStep?.text = "还差${state.targetSteps - state.todaySteps}步达成目标"
        }

        // Update Rings (Modern Reactive Update)
        multiRingsView?.setProgress(state.stepsRatio, state.calRatio, state.distRatio)
    }

    override fun openEventBus(): Boolean {
        return true
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onMessageEvent(event: RefreshTodayCount?) {
        event?.count?.let {
            viewModel.updateStepStats(it)
        }
    }

    var lastTartgert = 0

    private var lastShownSteps = 0

    override fun onResume() {
        super.onResume()
        viewModel.refreshAll()

        // Refresh cards
        cardList.forEach { (it.parent as? ViewGroup)?.removeView(it) }
        cardList.clear()

        getInitData().forEach {
            val card = SportViewCard(this.requireContext())
            card.setData(it)
            llContent.addView(card, llContent.childCount - 1)
            cardList.add(card)
        }
    }

    /**
     * 检查并弹出达标庆贺弹窗 (一天仅触发一次)
     */
    private fun checkAndShowCelebration() {
        val today = DateUtils.getYMD(0)
        val lastCelebrationDate = SharedPreferenceUtil.getInstance(requireContext()).get("last_celebration_date", "") as String
        if (lastCelebrationDate != today) {
            showGoalCelebrationDialog()
            SharedPreferenceUtil.getInstance(requireContext()).put("last_celebration_date", today)
        }
    }

    private fun showGoalCelebrationDialog() {
        val dialog = android.app.Dialog(requireContext())
        dialog.setContentView(R.layout.dialog_goal_celebration)
        dialog.window?.setBackgroundDrawable(android.graphics.drawable.ColorDrawable(android.graphics.Color.TRANSPARENT))

        dialog.findViewById<View>(R.id.btnConfirm).setOnClickListener {
            dialog.dismiss()
        }

        dialog.show()
    }

    var cardList = ArrayList<SportViewCard>()

    private fun getInitData(): ArrayList<CardData> {
        val data = SharedPreferenceUtil.getInstance(requireContext()).get("order", "")
        if (data.toString().isNotEmpty()) {
            val type = object : TypeToken<List<CardData>>() {}.type
            val lists =
                JSONUtils.fromJsonString<List<CardData>>(data.toString(), type)
            if (!lists.isNullOrEmpty()) {
                lists as ArrayList<CardData>
                lists.reverse()
                return lists
            }
        }
        val list = arrayListOf<CardData>()
        list.add(CardData(SportViewCard.CARD_TYPE_WALK, R.mipmap.icon_walk_small, "走路距离", true, 0, R.mipmap.bg_walk, R.mipmap.walk_right))
        list.add(CardData(SportViewCard.CARD_TYPE_HEAT, R.mipmap.icon_heat, "热量消耗", true, 1, R.mipmap.bg_heat, R.mipmap.right_heat))
        list.add(CardData(SportViewCard.CARD_TYPE_SPORT, R.mipmap.icon_dis, "运动距离", true, 2, R.mipmap.bg_card, R.mipmap.right_sport))
        list.add(CardData(SportViewCard.CARD_TYPE_TIME, R.mipmap.icon_time, "时间计时", true, 3, R.mipmap.bg_time, R.mipmap.right_time))
        list.add(CardData(SportViewCard.CARD_TYPE_BODY, R.mipmap.icon_body, "身体数据", true, 4, R.mipmap.bg_body, R.mipmap.right_body))
        list.add(CardData(SportViewCard.CARD_TYPE_WEIGHT, R.mipmap.icon_weight, "体重记录", true, 5, R.mipmap.bg_weight, R.mipmap.right_weight))
        list.reverse()
        return list
    }

    override fun updateUserInfo() {
    }

    override fun clearUserInfo() {
    }
}