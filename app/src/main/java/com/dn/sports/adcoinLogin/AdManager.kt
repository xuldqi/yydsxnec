package com.dn.sports.adcoinLogin

import android.app.Activity

interface AdManager {



    fun showAd(activity: Activity, adType: String,askPermiss:Boolean)



    companion object {
        const val AD_TYPE_REWARD = 1
        const val AD_TYPE_INTERSTITIAL = 2
        const val AD_TYPE_BANNER = 3
    }

}