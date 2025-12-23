package com.dn.sports.utils

import androidx.viewpager.widget.ViewPager
import net.lucode.hackware.magicindicator.MagicIndicator

object MagicIndicatorHelper {

    fun bind(
        magicIndicator: MagicIndicator,
        viewPager: ViewPager,
        mIdArray: Array<String>? = null,
        pageChangeListener: ViewPager.OnPageChangeListener? = null
    ) {
        viewPager.addOnPageChangeListener(object : ViewPager.OnPageChangeListener {
            override fun onPageScrolled(
                position: Int,
                positionOffset: Float,
                positionOffsetPixels: Int
            ) {
                magicIndicator.onPageScrolled(position, positionOffset, positionOffsetPixels)
                pageChangeListener?.onPageScrolled(position, positionOffset, positionOffsetPixels)
            }

            override fun onPageSelected(position: Int) {
                magicIndicator.onPageSelected(position)
                pageChangeListener?.onPageSelected(position)
            }

            override fun onPageScrollStateChanged(state: Int) {
                magicIndicator.onPageScrollStateChanged(state)
                pageChangeListener?.onPageScrollStateChanged(state)
            }
        })
    }
}