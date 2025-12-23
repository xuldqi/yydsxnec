package com.dn.sports.activity

import android.content.Intent
import android.os.Bundle
import com.dn.sports.BuildConfig
import com.dn.sports.R
import com.dn.sports.YSXYActivity
import com.dn.sports.common.BaseActivity
import com.dn.sports.utils.SharedPreferenceUtil
import com.dn.sports.utils.clickDelay
import com.dn.sports.utils.copy
import com.dn.sports.utils.jumpActivity
import kotlinx.android.synthetic.main.setting_activity.*

class SettingActivity : BaseActivity() {


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.setting_activity)
        val open = SharedPreferenceUtil.getInstance(this).get("testFeedMessage", true) as Boolean
        testFeedMessageCheckBox.isChecked = open
        testFeedMessageCheckBox.clickDelay {
            testFeedMessageCheckBox.isChecked = !testFeedMessageCheckBox.isChecked
            SharedPreferenceUtil.getInstance(this)
                .put("testFeedMessage", testFeedMessageCheckBox.isChecked)
        }
        tvContact.clickDelay {
            "1993323469@qq.com".copy()
        }
        imContact.clickDelay {
            "1993323469@qq.com".copy()
        }
        setTitle("设置")

        val userClick = {
            jumpActivity(YSXYActivity::class.java) {
                it.putExtra("type", 1)
            }
        }
        tvUserTips.clickDelay { userClick.invoke() }
        imUser.clickDelay { userClick.invoke() }

        val userClick2 = {
            jumpActivity(YSXYActivity::class.java) {
                it.putExtra("type", 2)
            }
        }
        tvPrivacyTips.clickDelay { userClick2.invoke() }
        imPrivacy.clickDelay { userClick2.invoke() }
        
        // 已收集个人信息清单入口
        val privacyInfoClick = {
            jumpActivity(PrivacyInfoListActivity::class.java)
        }
        tvPrivacyInfoList?.clickDelay { privacyInfoClick.invoke() }
        imPrivacyInfoList?.clickDelay { privacyInfoClick.invoke() }
        
        // 第三方SDK共享清单入口
        val sdkShareClick = {
            jumpActivity(SdkShareListActivity::class.java)
        }
        tvSdkShareList?.clickDelay { sdkShareClick.invoke() }
        imSdkShareList?.clickDelay { sdkShareClick.invoke() }
        
        tvVision?.setText("v${BuildConfig.VERSION_NAME}")
    }
}