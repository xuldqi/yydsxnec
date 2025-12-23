package com.dn.sports.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import com.dn.sports.R
import com.dn.sports.activity.SportRecordActivity
import com.dn.sports.adapter.SportRecordAdapter
import com.dn.sports.dialog.HintDialog
import com.dn.sports.greendao.DbHelper.getDaoSession
import com.dn.sports.ormbean.StepCountRecord
import com.dn.sports.utils.toast
import kotlinx.android.synthetic.main.fragment_sport_record.*

class SportRecordFragment : BaseFragment() {
    override fun getViewByLayout(
        inflater: LayoutInflater?,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        return inflater!!.inflate(R.layout.fragment_sport_record, container, false)
    }

    override fun initViewAction(view: View?) {
    }

    override fun updateUserInfo() {
    }

    override fun clearUserInfo() {
    }

    var sportType = 0

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        initRv()
    }

    var adapter= SportRecordAdapter()

    private fun initRv() {
        rvData.layoutManager = LinearLayoutManager(context)
        getData()
        adapter.addChildClickViewIds(R.id.delete)
        adapter.setEmptyView(R.layout.layout_empty)
        adapter.setOnItemChildClickListener{a,v,p->
            if (v.id == R.id.delete) {
                val data = adapter.data[p] as? StepCountRecord
                val hintDialog = HintDialog(requireContext(), false)
                hintDialog.setExitCountTime("确定要删除这条运动记录吗") {
                    adapter.data.remove(data)
                    adapter.notifyDataSetChanged()
                    getDaoSession().stepCountRecordDao.delete(data)
                    "删除成功".toast()
                    hintDialog.dismissDialog()
                }
                hintDialog.showDialogAtCenter()
            }
        }
    }

    private fun getData() {
        (activity as? SportRecordActivity)?.list?.let {
            rvData.adapter = adapter
            val showData = mutableListOf<StepCountRecord>()
            it.forEach {
                if (it.type == sportType) {
                    showData.add(it)
                }
            }
            if (sportType == 0) {
                adapter.setNewInstance(it)
            } else {
                adapter.setNewInstance(showData)
            }
        }
    }

}