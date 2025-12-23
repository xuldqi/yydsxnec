package com.dn.sports.utils

import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentPagerAdapter

class ContentPagerAdapter(
    fm: FragmentManager?,
    var tabFragments: ArrayList<Fragment>,
    var tabIndicators: Array<String>
) :
    FragmentPagerAdapter(fm!!) {
    override fun getItem(position: Int): Fragment {
        return tabFragments.get(position)
    }

    override fun getCount(): Int {
        return tabIndicators.size
    }

    override fun getPageTitle(position: Int): CharSequence? {
        return tabIndicators.get(position)
    }
}
