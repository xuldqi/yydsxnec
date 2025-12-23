package com.dn.sports.activity

import android.os.Bundle
import com.dn.sports.R
import com.dn.sports.common.BaseActivity

/**
 * 已收集个人信息清单页面
 * 展示APP收集的用户个人信息类型及用途
 */
class PrivacyInfoListActivity : BaseActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_privacy_info_list)
        setTitle("已收集个人信息清单")
    }
}
