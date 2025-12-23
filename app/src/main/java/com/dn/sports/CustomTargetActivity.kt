package com.dn.sports

import android.content.Context
import android.graphics.Color
import android.os.Bundle
import android.view.View
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.viewpager.widget.ViewPager
import com.dn.sports.adcoinLogin.StepUserManager
import com.dn.sports.common.BaseActivity
import com.dn.sports.fragment.target.DistenceTargetFragment
import com.dn.sports.fragment.target.HeatFragment
import com.dn.sports.fragment.target.StepTargetFragment
import com.dn.sports.fragment.target.WeightTargetFragment
import com.dn.sports.utils.ContentPagerAdapter
import com.dn.sports.utils.DisplayUtils.dp2px
import com.dn.sports.utils.MagicIndicatorHelper.bind
import com.dn.sports.utils.Utils
import kotlinx.android.synthetic.main.activity_custom_activity.*
import net.lucode.hackware.magicindicator.buildins.commonnavigator.CommonNavigator
import net.lucode.hackware.magicindicator.buildins.commonnavigator.abs.CommonNavigatorAdapter
import net.lucode.hackware.magicindicator.buildins.commonnavigator.abs.IPagerIndicator
import net.lucode.hackware.magicindicator.buildins.commonnavigator.abs.IPagerTitleView
import net.lucode.hackware.magicindicator.buildins.commonnavigator.indicators.LinePagerIndicator
import net.lucode.hackware.magicindicator.buildins.commonnavigator.titles.SimplePagerTitleView

class CustomTargetActivity : BaseActivity() {

    private val unitStep = 100
    private val minWeight = 0f
    private val maxWeight = 200f
    private val unitWeight = 0.5f
    private val minDistance = 1000
    private val maxDistance = 45000
    private val unitDistance = 100



    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_custom_activity)
        findViewById<View>(R.id.back_btn).setOnClickListener { finish() }
        (findViewById<View>(R.id.title) as TextView).text = "目标管理"
        findViewById<View>(R.id.root).setPadding(0, Utils.getStatusBarHeight(this), 0, 0)
        val targetStepNum = StepUserManager.getInstance().getTargetStepNum(this)
        val targetWeightNum = StepUserManager.getInstance().getTargetWeightNum(this)
        val targetDistanceNum = StepUserManager.getInstance().getTargetDistanceNum(this)
        initTag(viewPager)
        initViewPager(viewPager)
    }

    var tabIndicators = arrayOf("步数", "体重", "距离", "热量")
    var commonNavigator :CommonNavigator?=null
    var tabFragments = ArrayList<Fragment>()

    private fun initTag(mContentVp: ViewPager) {
        commonNavigator = CommonNavigator(this)
        commonNavigator!!.adapter = object : CommonNavigatorAdapter() {
            override fun getCount(): Int {
                return tabIndicators.size
            }

            override fun getTitleView(context: Context, index: Int): IPagerTitleView {
                val simplePagerTitleView = SimplePagerTitleView(context)
                val title: String = tabIndicators.get(index)
                simplePagerTitleView.text = title
                simplePagerTitleView.setPadding(dp2px(23), 0, dp2px(23), 0)
                simplePagerTitleView.textSize = 16f
                simplePagerTitleView.selectedColor = Color.parseColor("#F37866")
                simplePagerTitleView.normalColor = Color.parseColor("#44464D")
                simplePagerTitleView.setOnClickListener { v: View? ->
                    mContentVp.currentItem = index
                }
                return simplePagerTitleView
            }

            override fun getIndicator(context: Context): IPagerIndicator {
                val indicator = LinePagerIndicator(context)
                indicator.mode = LinePagerIndicator.MODE_WRAP_CONTENT
                indicator.roundRadius = dp2px(1.6f).toFloat()
                indicator.setColors(
                    Color.parseColor("#F37866")
                )
                return indicator
            }
        }
    }

    private fun initViewPager(mContentVp: ViewPager) {
        tabFragments.add(StepTargetFragment())
        tabFragments.add(WeightTargetFragment())
        tabFragments.add(DistenceTargetFragment())
        tabFragments.add(HeatFragment())

        val contentAdapter =
            ContentPagerAdapter(supportFragmentManager, tabFragments, tabIndicators)
        mContentVp.setAdapter(contentAdapter)
        mContentVp.setOffscreenPageLimit(2)
        tl_tab.navigator = commonNavigator
        bind(tl_tab, mContentVp, null, null)
        mContentVp.currentItem = 0
    }

//    StepUserManager.getInstance().setTargetDistanceNum(this@CustomTargetActivity , num)


}