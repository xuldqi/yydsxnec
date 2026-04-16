package com.dn.sports.jumprope

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.dn.sports.R
import com.dn.sports.greendao.DbHelper
import com.dn.sports.ormbean.StepCountRecord
import kotlinx.android.synthetic.main.fragment_jump_rope_record.*

class JumpRecordFragment:Fragment() {

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_jump_rope_record, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        rvRecords.layoutManager = LinearLayoutManager(requireContext())
        loadData()
    }

    private fun loadData() {
        val history = DbHelper.getHistoryByType(7) ?: ArrayList()
        if (history.isEmpty()) {
            layEmpty.visibility = View.VISIBLE
            rvRecords.visibility = View.GONE
        } else {
            layEmpty.visibility = View.GONE
            rvRecords.visibility = View.VISIBLE
            rvRecords.adapter = RecordAdapter(history)
        }
    }

    private class RecordAdapter(val data: List<StepCountRecord>) : 
        RecyclerView.Adapter<RecordAdapter.ViewHolder>() {

        class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
            val tvType: TextView = view.findViewById(R.id.tvType)
            val tvTime: TextView = view.findViewById(R.id.tvTime)
            val tvDistance: TextView = view.findViewById(R.id.tvDistance)
            val imSport: ImageView = view.findViewById(R.id.imSport)
            val delete: View = view.findViewById(R.id.delete)
        }

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
            val view = LayoutInflater.from(parent.context).inflate(R.layout.item_sport_record, parent, false)
            return ViewHolder(view)
        }

        @android.annotation.SuppressLint("SetTextI18n")
        override fun onBindViewHolder(holder: ViewHolder, position: Int) {
            val item = data[position]
            holder.tvType.text = "跳绳训练"
            holder.tvTime.text = item.date
            holder.tvDistance.text = "${item.steps} 次"
            holder.imSport.visibility = View.GONE // 移除图标以腾出空间 (Remove icon for more space)
            holder.delete.visibility = View.GONE 
        }

        override fun getItemCount() = data.size
    }
}