package com.dn.sports.activity

import android.os.Bundle
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.GridLayoutManager
import com.dn.sports.R
import com.dn.sports.StepApplication
import com.dn.sports.common.BaseActivity
import com.dn.sports.data.local.entities.AchievementEntity
import kotlinx.android.synthetic.main.activity_achievement.*
import kotlinx.coroutines.flow.collect

class AchievementActivity : BaseActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_achievement)

        ivBack.setOnClickListener { finish() }

        val repository = (application as StepApplication).repository
        val adapter = AchievementAdapter()
        rvAchievements.layoutManager = GridLayoutManager(this, 2)
        rvAchievements.adapter = adapter

        lifecycleScope.launchWhenStarted {
            repository.getAchievementsFlow().collect { achievements ->
                if (achievements.isEmpty()) {
                    val presets = listOf(
                        AchievementEntity(1, "初试锋芒", "完成任意运动记录 1 次", 0, 1, System.currentTimeMillis(), "medal_start"),
                        AchievementEntity(2, "万步达人", "单日行走超过 10,000 步", 0, 10000, 0L, "medal_10000"),
                        AchievementEntity(3, "燃脂先锋", "单次消耗超过 300 千卡", 1, 300, 0L, "medal_cal"),
                        AchievementEntity(4, "绳彩飞扬", "单次连续跳绳超过 500 次", 2, 500, 0L, "medal_rope"),
                        AchievementEntity(5, "坚持不懈", "连续坚持运动 7 天", 3, 7, 0L, "medal_week"),
                        AchievementEntity(6, "半马英雄", "单次累计跑步超 21 公里", 4, 21, 0L, "medal_half_marathon")
                    )
                    adapter.submitList(presets)
                } else {
                    adapter.submitList(achievements)
                }
            }
        }
    }

    // Inner Adapter Class
    inner class AchievementAdapter : androidx.recyclerview.widget.RecyclerView.Adapter<AchievementViewHolder>() {
        private var items: List<AchievementEntity> = emptyList()

        fun submitList(newItems: List<AchievementEntity>) {
            items = newItems
            notifyDataSetChanged()
        }

        override fun onCreateViewHolder(parent: android.view.ViewGroup, viewType: Int): AchievementViewHolder {
            val view = android.view.LayoutInflater.from(parent.context).inflate(R.layout.item_achievement, parent, false)
            return AchievementViewHolder(view)
        }

        override fun onBindViewHolder(holder: AchievementViewHolder, position: Int) {
            val item = items[position]
            holder.medalName.text = item.name
            holder.medalDesc.text = item.description
            if (item.achievedDate > 0) {
                holder.achievedDate.text = "${com.dn.sports.utils.DateUtils.getYearMonthDay(item.achievedDate)} 获得 🏆"
                holder.achievedDate.setTextColor(android.graphics.Color.parseColor("#EF7437"))
                holder.itemView.alpha = 1.0f
            } else {
                holder.achievedDate.text = "待解锁 🔒"
                holder.achievedDate.setTextColor(android.graphics.Color.parseColor("#999999"))
                holder.itemView.alpha = 0.55f
            }
        }

        override fun getItemCount() = items.size
    }

    class AchievementViewHolder(view: android.view.View) : androidx.recyclerview.widget.RecyclerView.ViewHolder(view) {
        val medalName: android.widget.TextView = view.findViewById(R.id.tvMedalName)
        val medalDesc: android.widget.TextView = view.findViewById(R.id.tvMedalDesc)
        val achievedDate: android.widget.TextView = view.findViewById(R.id.tvAchievedDate)
        val medalIcon: android.widget.ImageView = view.findViewById(R.id.ivMedalIcon)
    }
}
