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
                adapter.submitList(achievements)
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
            holder.achievedDate.text = "${com.dn.sports.utils.DateUtils.getYearMonthDay(item.achievedDate)} 获得"
            // icon mapping logic could be added here
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
