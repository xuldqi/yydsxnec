package com.dn.sports.adapter

import com.chad.library.adapter.base.BaseQuickAdapter
import com.dn.sports.R
import com.dn.sports.ormbean.StepCountRecord
import com.dn.sports.utils.DateUtils
import com.dn.sports.utils.Utils

import com.dn.sports.utils.loadRes
import kotlinx.android.synthetic.main.item_sport_record.view.*

class SportRecordAdapter :
    BaseQuickAdapter<StepCountRecord, BaseHolder>(R.layout.item_sport_record) {

    override fun convert(holder: BaseHolder, item: StepCountRecord) {
        holder.itemView.apply {
            imSport.loadRes(
                when (item.type) {
                    1 -> R.mipmap.icon_room_out_run
                    2 -> R.mipmap.icon_room_in_run
                    3 -> R.mipmap.icon_walking
                    4 -> R.mipmap.icon_on_foot
                    5 -> R.mipmap.icon_climb
                    else -> R.mipmap.icon_room_out_run
                }
            )
            when (item.type) {
                1 -> tvType.text = "户外跑"
                2 -> tvType.text = "室内跑"
                3 -> tvType.text = "健走"
                4 -> tvType.text = "徒步"
                5 -> tvType.text = "登山"
            }
            tvTime.text = DateUtils.getDate2String(item.startTime, "MM月dd日HH时")
            var timeNum = item.useTime
            var text = ""
            val hour: Int = (timeNum / (60 * 60 * 1000)).toInt()
            if (hour > 1) {
                text = hour.toString() + "时"
            }
            timeNum -= 60 * 60 * 1000 * hour
            val min: Int = (timeNum / (60 * 1000)).toInt()
            text = if (min > 9) {
                text + min + "分"
            } else {
                text + "0" + min + "分"
            }
            timeNum -= 60 * 1000 * min
            val second: Int = (timeNum / 1000).toInt()
            text = if (second > 9) {
                text + second + "秒"
            } else {
                text + "0" + second + "秒"
            }
            duration.text = text
            Utils.getDistanceByStep(item.steps).let {
                tvDistance.text = "${it}公里"
            }
        }
    }


}