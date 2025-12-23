package com.dn.sports.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import com.google.gson.reflect.TypeToken
import com.dn.sports.CustomTargetActivity
import com.dn.sports.R
import com.dn.sports.RefreshTodayCount
import com.dn.sports.activity.ChangeOrderActivity
import com.dn.sports.adcoinLogin.StepUserManager
import com.dn.sports.bean.CardData
import com.dn.sports.greendao.DbHelper
import com.dn.sports.jumprope.JumpRopeGuildActivity
import com.dn.sports.utils.*
import com.dn.sports.utils.DateUtils.getEveryDayTimestamps
import com.dn.sports.view.SportViewCard
import com.umeng.commonsdk.statistics.common.DataHelper
import kotlinx.android.synthetic.main.fragment_health_home.*
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode

class HealthFragment : BaseFragment() {


    override fun getViewByLayout(
        inflater: LayoutInflater?,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return inflater!!.inflate(R.layout.fragment_health_home, container, false)
    }

    override fun initViewAction(view: View?) {
    }

    var bt: View? = null
    var frame: View? = null
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
//        ringProgressBar.setProgress(60f)
//        ringProgressBar.setMaxProgress(100f)
        btMange.clickDelay {
            requireContext().jumpActivity(CustomTargetActivity::class.java)
        }
        btChangeOrder.clickDelay {
            requireContext().jumpActivity(ChangeOrderActivity::class.java)
        }
        layChangeOrder.clickDelay {
            requireContext().jumpActivity(ChangeOrderActivity::class.java)
        }
        val step = StepUserManager.getInstance().todaySteps
        val target = StepUserManager.getInstance().getTargetStepNum(requireContext())
        if (step >= target) {
            tvStep.text = "今日步数已达标"
        } else {
            tvStep.text = "还差${target - step}步达成目标"
        }
    }

    override fun openEventBus(): Boolean {
        return true
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onMessageEvent(event: RefreshTodayCount?) {
        view.findViewById<TextView>(R.id.tvTodayNums)?.text = event?.count?.toString()
        val step = event?.count ?: 0
        val target = StepUserManager.getInstance().getTargetStepNum(requireContext())
        if (step >= target) {
            tvStep.text = "今日步数已达标"
        } else {
            tvStep.text = "还差${target - step}步达成目标"
        }
    }

    var lastTartgert = 0

    override fun onResume() {
        super.onResume()
        cardList.forEach { view ->
            (view.parent as? ViewGroup)?.let { parentView ->
                parentView.removeView(view)
            }
        }
        initJumpRopeData()
        getInitData().forEach {
            if (it.isAdd) {
                val card = SportViewCard(this.requireContext())
                card.setData(it)
                llContent.addView(card, 2
                )
                cardList.add(card)
            }
        }
        tvTodayNums.text = StepUserManager.getInstance().todaySteps.toString()
        io {
            val targert = StepUserManager.getInstance().getTargetStepNum(requireContext())
            main {
                tvTarget?.text = "目标：${targert.toString()}"
                if (lastTartgert != targert) {
                    lastTartgert = targert
                    val current =
                        view.findViewById<TextView>(R.id.tvTodayNums)?.text.toString().toFloat()
                    ringProgressBar.setProgress(current)
                    ringProgressBar.setMaxProgress(targert.toFloat())
                }
            }
        }

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
        list.add(
            CardData(
                SportViewCard.CARD_TYPE_WALK,
                R.mipmap.icon_walk_small,
                "走路距离",
                true,
                0,
                R.mipmap.bg_walk,
                R.mipmap.walk_right
            )
        )
        list.add(
            CardData(
                SportViewCard.CARD_TYPE_HEAT,
                R.mipmap.icon_heat,
                "热量消耗",
                true,
                1,
                R.mipmap.bg_heat,
                R.mipmap.right_heat
            )
        )
        list.add(
            CardData(
                SportViewCard.CARD_TYPE_SPORT,
                R.mipmap.icon_dis,
                "运动距离",
                true,
                2,
                R.mipmap.bg_card,
                R.mipmap.right_sport
            )
        )
        list.add(
            CardData(
                SportViewCard.CARD_TYPE_TIME,
                R.mipmap.icon_time,
                "时间计时",
                true,
                3,
                R.mipmap.bg_time,
                R.mipmap.right_time
            )
        )
        list.add(
            CardData(
                SportViewCard.CARD_TYPE_BODY,
                R.mipmap.icon_body,
                "身体数据",
                true,
                4,
                R.mipmap.bg_body,
                R.mipmap.right_body
            )
        )
        list.add(
            CardData(
                SportViewCard.CARD_TYPE_WEIGHT,
                R.mipmap.icon_weight,
                "体重记录",
                true,
                5,
                R.mipmap.bg_weight,
                R.mipmap.right_weight
            )
        )
        list.reverse()
        return list
    }

    private fun initJumpRopeData() {
        val startJump = SharedPreferenceUtil.getInstance(requireContext()).get("startJump", 0L) as? Long
        bgJumpGuild.clickDelay {
            requireContext().jumpActivity(JumpRopeGuildActivity::class.java)
        }
        if (startJump != 0L) {
            val day = getEveryDayTimestamps(startJump ?: 0L, System.currentTimeMillis())
            tvjump.text = "${day.size}"
        }
    }

    override fun updateUserInfo() {
    }

    override fun clearUserInfo() {
    }
}