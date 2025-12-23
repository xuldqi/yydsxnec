package com.dn.sports.activity

import android.content.Context
import android.graphics.Color
import android.os.Bundle
import android.view.View
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentStatePagerAdapter
import com.dn.sports.R
import com.dn.sports.activity.ChartActivity.Companion.type
import com.dn.sports.common.BaseActivity
import com.dn.sports.fragment.BaseFragment
import com.dn.sports.fragment.chart.DayFragment
import com.dn.sports.fragment.chart.MonthFragment
import com.dn.sports.fragment.chart.WeekFragment
import com.dn.sports.utils.DisplayUtils.dp2px
import com.dn.sports.utils.MagicIndicatorHelper.bind
import com.dn.sports.utils.dp
import kotlinx.android.synthetic.main.cart_act.*
import kotlinx.android.synthetic.main.step_count_record_item.*
import net.lucode.hackware.magicindicator.buildins.commonnavigator.CommonNavigator
import net.lucode.hackware.magicindicator.buildins.commonnavigator.abs.CommonNavigatorAdapter
import net.lucode.hackware.magicindicator.buildins.commonnavigator.abs.IPagerIndicator
import net.lucode.hackware.magicindicator.buildins.commonnavigator.abs.IPagerTitleView
import net.lucode.hackware.magicindicator.buildins.commonnavigator.indicators.LinePagerIndicator
import net.lucode.hackware.magicindicator.buildins.commonnavigator.titles.SimplePagerTitleView

/**
 * https://github.com/AAChartModel/AAChartCore-Kotlin
 *
 */
class ChartActivity : BaseActivity() {

    //热量     所有运动求和，按比例 入库
    //走路距离  当日步数，入库
    //体重记录  体重数据，入库
    private var chartType = 0

    companion object {
        var type = "type"
        var TYPE_HEAT = 0
        var TYPE_DISTENCE = 1
        var TYPE_WEIGHT = 2
    }


    var fragments = arrayListOf<BaseFragment>()
    var titles = arrayListOf<String>("日", "周", "月")

    /**
     *
     * 按照，时间戳
     *
     * 每日
     * 每周
     * 每月
     *
     * 来筛选
     *
     * 总数，最大，平均，达标次数
     *
     */

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.cart_act)
        chartType = intent.getIntExtra(ChartActivity.type, 0)
        setTitle("图标记录")
        DayFragment().let {
            it.chartType = chartType
            fragments.add(it)
        }
        WeekFragment().let {
            it.chartType = chartType
            fragments.add(it)
        }
        MonthFragment().let {
            it.chartType = chartType
            fragments.add(it)
        }
        initViewPager()
        when (chartType) {
            TYPE_HEAT -> setTitle("热量消耗")
            TYPE_DISTENCE -> setTitle("运动距离")
            TYPE_WEIGHT -> setTitle("体重记录")
        }
    }


    private fun initViewPager() {
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
                simplePagerTitleView.setPadding(dp2px(33), 0, dp2px(33), 0)
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
                indicator.mode = LinePagerIndicator.MODE_EXACTLY
                indicator.lineWidth = 16.dp.toFloat()
                indicator.roundRadius = dp2px(1.6f).toFloat()
                indicator.setColors(
                    Color.parseColor("#F37866")
                )
                return indicator
            }
        }
        indicator.navigator = commonNavigator
        bind(indicator, viewPager, null, null)
    }


}