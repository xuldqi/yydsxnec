package com.dn.sports.activity

import android.os.Bundle
import android.widget.TextView
import androidx.recyclerview.widget.ItemTouchHelper
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.gson.reflect.TypeToken
import com.dn.sports.R
import com.dn.sports.RefreshTodayCount
import com.dn.sports.adapter.CardOrderAdapter
import com.dn.sports.adcoinLogin.StepUserManager
import com.dn.sports.bean.CardData
import com.dn.sports.common.BaseActivity
import com.dn.sports.utils.JSONUtils
import com.dn.sports.utils.SharedPreferenceUtil
import com.dn.sports.view.SportViewCard
import kotlinx.android.synthetic.main.activity_change_order.*
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode
import java.util.*
import kotlin.collections.ArrayList

class ChangeOrderActivity: BaseActivity() {


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_change_order)
        setTitle("编辑卡片")
        initRv()
    }


    private fun getInitData():ArrayList<CardData> {
        val data = SharedPreferenceUtil.getInstance(this).get("order", "")
        if (data.toString().isNotEmpty()) {
            val type = object : TypeToken<List<CardData>>() {}.type
            val lists =
                JSONUtils.fromJsonString<List<CardData>>(data.toString(), type)
            if (!lists.isNullOrEmpty()) {
                return lists as ArrayList<CardData>
            }
        }
        val list = arrayListOf<CardData>()
        list.add(CardData(SportViewCard.CARD_TYPE_WALK,R.mipmap.icon_walk_small, "走路距离", true, 0,R.mipmap.bg_walk,R.mipmap.walk_right))
        list.add(CardData(SportViewCard.CARD_TYPE_HEAT,R.mipmap.icon_heat, "热量消耗", true, 1,R.mipmap.bg_heat,R.mipmap.right_heat))
        list.add(CardData(SportViewCard.CARD_TYPE_SPORT,R.mipmap.icon_dis, "运动距离", true, 2,R.mipmap.bg_card,R.mipmap.right_sport))
        list.add(CardData(SportViewCard.CARD_TYPE_TIME,R.mipmap.icon_time, "时间计时", true, 3,R.mipmap.bg_time,R.mipmap.right_time))
        list.add(CardData(SportViewCard.CARD_TYPE_BODY,R.mipmap.icon_body, "身体数据", true, 4,R.mipmap.bg_body,R.mipmap.right_body))
        list.add(CardData(SportViewCard.CARD_TYPE_WEIGHT,R.mipmap.icon_weight, "体重记录", true, 5,R.mipmap.bg_weight,R.mipmap.right_weight))

        return list
    }



    val adapter = CardOrderAdapter()

    private fun initRv() {
        rvChangeOrder.layoutManager = LinearLayoutManager(this)
        val datas = getInitData()
        adapter.setNewInstance(datas)
        rvChangeOrder.adapter = adapter
        val itemTouchHelperCallback = object : ItemTouchHelper.Callback() {
            override fun getMovementFlags(recyclerView: RecyclerView, viewHolder: RecyclerView.ViewHolder): Int {
                val dragFlags = ItemTouchHelper.UP or ItemTouchHelper.DOWN // able to move up and down
                val swipeFlags = 0 // disable swipe
                return makeMovementFlags(dragFlags, swipeFlags)
            }

            override fun onMove(
                recyclerView: RecyclerView,
                viewHolder: RecyclerView.ViewHolder,
                target: RecyclerView.ViewHolder
            ): Boolean {
                // swap positions in adapter

                val currentData = adapter.data[viewHolder.adapterPosition]
                val targetData = adapter.data[target.absoluteAdapterPosition]
                if (currentData.isAdd != targetData.isAdd) {
                    currentData.isAdd = !currentData.isAdd
                }

                Collections.swap(adapter.data, viewHolder.adapterPosition, target.adapterPosition)
                adapter.notifyDataSetChanged()
                saveOrder()
                return true
            }
            override fun onSwiped(viewHolder: RecyclerView.ViewHolder, direction: Int) {}
        }
        val itemTouchHelper = ItemTouchHelper(itemTouchHelperCallback)
        itemTouchHelper.attachToRecyclerView(rvChangeOrder)
        adapter.run {
            addChildClickViewIds(R.id.tvCheck)
            setOnItemChildClickListener { a, v, p ->
                if (v.id == R.id.tvCheck) {
                    val data = a.data[p] as? CardData
                    data?.isAdd = !(data?.isAdd ?: false)
                    refreshOrder(p, data?.isAdd ?: false)
                }
            }
        }
    }

    private fun refreshOrder(position: Int, add: Boolean) {
        val data = adapter.data.get(position)
        adapter.data.removeAt(position)
        if (add) {
            adapter.data.add(0, data)
        } else {
            adapter.data.add(data)
        }
        adapter.notifyDataSetChanged()
        saveOrder()
    }



    fun saveOrder(){
        SharedPreferenceUtil.getInstance(this).put("order",JSONUtils.toJsonString(adapter.data))
    }


}