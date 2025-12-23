package com.dn.sports.activity

import android.os.Bundle
import com.dn.sports.R
import com.dn.sports.common.BaseActivity

/**
 * 第三方SDK共享清单页面
 * 展示APP使用的第三方SDK及其数据共享情况
 */
class SdkShareListActivity : BaseActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_sdk_share_list)
        setTitle("第三方SDK共享清单")
    }
}
