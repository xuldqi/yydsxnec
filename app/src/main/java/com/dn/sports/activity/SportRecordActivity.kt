package com.dn.sports.activity

import android.content.Context
import android.graphics.Color
import android.os.Bundle
import android.view.View
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentStatePagerAdapter
import com.dn.sports.R
import com.dn.sports.bean.StepCountRecordDao
import com.dn.sports.common.BaseActivity
import com.dn.sports.fragment.BaseFragment
import com.dn.sports.fragment.SportRecordFragment
import com.dn.sports.greendao.DbHelper
import com.dn.sports.ormbean.StepCountRecord
import com.dn.sports.utils.DisplayUtils
import com.dn.sports.utils.MagicIndicatorHelper
import kotlinx.android.synthetic.main.activity_sport_record.*
import net.lucode.hackware.magicindicator.buildins.commonnavigator.CommonNavigator
import net.lucode.hackware.magicindicator.buildins.commonnavigator.abs.CommonNavigatorAdapter
import net.lucode.hackware.magicindicator.buildins.commonnavigator.abs.IPagerIndicator
import net.lucode.hackware.magicindicator.buildins.commonnavigator.abs.IPagerTitleView
import net.lucode.hackware.magicindicator.buildins.commonnavigator.indicators.LinePagerIndicator
import net.lucode.hackware.magicindicator.buildins.commonnavigator.titles.SimplePagerTitleView

class SportRecordActivity : BaseActivity() {


    var fragments = arrayListOf<BaseFragment>()
    var titles = arrayListOf<String>("全部", "户外跑", "室内跑", "健走", "徒步", "登山")

    var type = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        type = intent.getIntExtra("type", 0)
        setContentView(R.layout.activity_sport_record)
        getAllData()
        setTitle("运动记录")
        for (i in 0..5) {
            SportRecordFragment().let {
                fragments.add(it)
                when(i){
                    0->it.sportType=0
                    1->it.sportType=1
                    2->it.sportType=2
                    3->it.sportType=3
                    4->it.sportType=4
                    5->it.sportType=5
                }
            }
        }
        initViewPager()
//        if (type in 0..5) {
//            viewPager.currentItem = type
//        }
    }

    var list : ArrayList<StepCountRecord>? = null

    private fun getAllData() {
         list = (DbHelper.getDaoSession().stepCountRecordDao.queryBuilder()
             .where(StepCountRecordDao.Properties.Type.notEq(6))
             .orderDesc(StepCountRecordDao.Properties.Id)
             .build().list()
                 as? ArrayList<StepCountRecord>)
    }


    private fun initViewPager() {
        titles = arrayListOf<String>("全部", "户外跑", "室内跑", "健走", "徒步", "登山")
        viewPager.adapter = object : FragmentStatePagerAdapter(supportFragmentManager) {
            override fun getCount(): Int {
                return fragments.size
            }

            override fun getItem(position: Int): Fragment {
                return fragments[position]
            }

        }
        val commonNavigator = CommonNavigator(this)
        commonNavigator.adapter = object : CommonNavigatorAdapter() {
            override fun getCount(): Int {
                return fragments.size
            }

            override fun getTitleView(context: Context?, index: Int): IPagerTitleView {
                val simplePagerTitleView = SimplePagerTitleView(context)
                val title: String = titles.get(index)
                simplePagerTitleView.text = title
                simplePagerTitleView.setPadding(
                    DisplayUtils.dp2px(9),
                    0,
                    DisplayUtils.dp2px(9),
                    0
                )
                simplePagerTitleView.textSize = 16f
                simplePagerTitleView.selectedColor = Color.parseColor("#F37866")
                simplePagerTitleView.normalColor = Color.parseColor("#44464D")
                simplePagerTitleView.setOnClickListener { v: View? ->
                    viewPager.currentItem = index
                }
                return simplePagerTitleView
            }

            override fun getIndicator(context: Context?): IPagerIndicator {
                val indicator = LinePagerIndicator(context)
                indicator.mode = LinePagerIndicator.MODE_WRAP_CONTENT
//                indicator.lineWidth = 16.dp.toFloat()
                indicator.roundRadius = DisplayUtils.dp2px(1.6f).toFloat()
                indicator.setColors(
                    Color.parseColor("#F37866")
                )
                return indicator
            }
        }
        indicator.navigator = commonNavigator
        MagicIndicatorHelper.bind(indicator, viewPager, null, null)
    }


}