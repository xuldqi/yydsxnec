package com.dn.sports.adapter

import com.chad.library.adapter.base.BaseQuickAdapter
import com.dn.sports.R
import com.dn.sports.bean.CardData
import com.dn.sports.utils.loadRes
import com.dn.sports.utils.setGone
import com.dn.sports.utils.setVisible
import com.dn.sports.adapter.BaseHolder
import kotlinx.android.synthetic.main.card_order_item.view.*

class CardOrderAdapter: BaseQuickAdapter<CardData, BaseHolder>(R.layout.card_order_item){

    override fun convert(holder: BaseHolder, item: CardData) {
        holder.containerView.apply {
            imIcon.loadRes(item.icon)
            tvName.text = item.name
            tvCheck.isChecked = item.isAdd
            if (holder.layoutPosition == 0) {
                if (item.isAdd) {
                    tvStatus.text = "已展示数据"
                } else {
                    tvStatus.text = "未展示数据"
                }
                tvStatus.setVisible()
            } else {
                val lastData = data.get(holder.layoutPosition - 1)
                tvStatus.setGone(lastData.isAdd != item.isAdd)
                if (item.isAdd) {
                    tvStatus.text = "已展示数据"
                } else {
                    tvStatus.text = "未展示数据"
                }
            }
        }
    }

}