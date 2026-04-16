package com.dn.sports.fragment

import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import com.dn.sports.CountStepsActivity
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
import com.google.gson.reflect.TypeToken
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
        view?.findViewById<View>(R.id.health_root_container)?.setPadding(0, Utils.getStatusBarHeight(activity), 0, 0)
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

    private var lastShownSteps = 0

    override fun onResume() {
        super.onResume()
        // --- 核心刷新逻辑：清理旧视图防止重复 (UI Fix: Clear old cards) ---
        cardList.forEach { view ->
            (view.parent as? ViewGroup)?.let { parentView ->
                parentView.removeView(view)
            }
        }
        cardList.clear() // 必须清理列表，防止重复添加 (Crucial: Prevent duplication)

        val todaySteps = StepUserManager.getInstance().todaySteps
        val targetSteps = StepUserManager.getInstance().getTargetStepNum(requireContext())

        // --- 环下多维数据矩阵绑定 (Bottom Metrics Row Data Binding) ---
        val multiRingsView = view?.findViewById<MultiActivityRingsView>(R.id.multiRingsView)
        val tvTodayKcal = view?.findViewById<TextView>(R.id.tvTodayKcal)
        val tvTodayDistance = view?.findViewById<TextView>(R.id.tvTodayDistance)
        
        // 核心比例计算 (Core Ratios)
        val stepsRatio = if (targetSteps > 0) todaySteps.toFloat() / targetSteps.toFloat() else 0f
        val calRatio = (Utils.getKalByStep(todaySteps).toFloat()) / 300f
        val distRatio = try { 
            Utils.getDistanceByStep(todaySteps).replace("km","").trim().toFloat() / 5.0f 
        } catch (e: Exception) { 0f }

        // 2. 动效更新逻辑 (UI Optimization: Footer Sync)
        if (todaySteps != lastShownSteps) {
            val animator = android.animation.ValueAnimator.ofInt(lastShownSteps, todaySteps)
            animator.duration = 1000
            animator.interpolator = android.view.animation.DecelerateInterpolator()
            animator.addUpdateListener { animation ->
                val value = animation.animatedValue as Int
                tvTodayNums?.text = value.toString()
                
                // 同步更新底座数据 (Update Footer Metrics)
                tvTodayKcal?.text = "${Utils.getKalByStep(value)} kcal"
                tvTodayDistance?.text = Utils.getDistanceByStep(value)
                
                // 实时同步三环进度 (Real-time Sync Rings)
                val currentRatio = if (targetSteps > 0) value.toFloat() / targetSteps.toFloat() else 0f
                multiRingsView?.setProgress(
                    currentRatio, 
                    currentRatio * 0.8f + (calRatio * 0.2f), 
                    currentRatio * 0.6f + (distRatio * 0.4f)
                )
            }
            animator.addListener(object : android.animation.AnimatorListenerAdapter() {
                override fun onAnimationEnd(animation: android.animation.Animator) {
                    if (todaySteps >= targetSteps && targetSteps > 0) {
                        checkAndShowCelebration()
                    }
                }
            })
            animator.start()
            lastShownSteps = todaySteps
        } else {
            tvTodayNums?.text = todaySteps.toString()
            tvTodayKcal?.text = "${Utils.getKalByStep(todaySteps)} kcal"
            tvTodayDistance?.text = Utils.getDistanceByStep(todaySteps)
            multiRingsView?.setProgress(stepsRatio, calRatio, distRatio)
            if (todaySteps >= targetSteps && targetSteps > 0) {
                checkAndShowCelebration()
            }
        }

        initJumpRopeData()
        getInitData().forEach {
            val card = SportViewCard(this.requireContext())
            card.setData(it)
            // 插入位置调整：放在跳绳下面，编辑按钮上面 (Insert below Jump Rope, above Edit)
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
        bgJumpGuild.clickDelay {
            requireContext().jumpActivity(JumpRopeGuildActivity::class.java)
        }
        
        // 从数据库聚合今日跳绳总次数 (Data Sync: Today's aggregated jumps)
        io {
            val today = DateUtils.getYMD(0)
            val history = DbHelper.getHistoryByType(7)
            val todayJumps = history?.filter { it.date == today }?.sumBy { it.steps } ?: 0
            main {
                tvjump?.text = "$todayJumps 次"
            }
        }
    }

    override fun updateUserInfo() {
    }

    override fun clearUserInfo() {
    }
}