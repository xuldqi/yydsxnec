package com.dn.sports.common

import android.graphics.Color
import android.os.Build
import android.os.Bundle
import android.view.View
import android.view.WindowManager
import android.widget.TextView
import androidx.fragment.app.FragmentActivity
import com.dn.sports.R
import com.dn.sports.StepApplication
import com.umeng.analytics.MobclickAgent
import com.dn.sports.utils.Utils
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.cancel
import org.greenrobot.eventbus.EventBus

abstract class BaseActivity : FragmentActivity() {

    var mainScope = MainScope()


    override fun onCreate(savedInstanceState: Bundle?) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val window = window
            val decorView = window.decorView
            val option = View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or View.SYSTEM_UI_FLAG_LAYOUT_STABLE
            decorView.systemUiVisibility = option
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                var ui = decorView.systemUiVisibility
                ui = ui or View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR
                decorView.systemUiVisibility = ui
            }
            window.statusBarColor = Color.TRANSPARENT
            //window.setNavigationBarColor(getResources().getColor(R.color.common_background_color));
        }
        StepApplication.getInstance().addActivity(this)
        super.onCreate(savedInstanceState)
        if (openEventBus()) {
            EventBus.getDefault().register(this)
        }
    }

    fun openEventBus(): Boolean {
        return false
    }

    override fun setContentView(layoutResID: Int) {
        super.setContentView(layoutResID)
        applyStatusBarPadding()
    }

    override fun setContentView(view: View) {
        super.setContentView(view)
        applyStatusBarPadding()
    }

    private fun applyStatusBarPadding() {
        val titleBar = findViewById<View>(R.id.layTitleBar)
        if (titleBar != null) {
            val statusBarHeight = Utils.getStatusBarHeight(this)
            titleBar.setPadding(0, statusBarHeight, 0, 0)
        }
    }

    fun setTitle(title: String?) {
        findViewById<View>(R.id.btBack)?.setOnClickListener { finish() }
        findViewById<TextView>(R.id.tvTitle)?.let {
            it.text = title
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        StepApplication.getInstance().removeActivity(this)
        if (openEventBus()) {
            EventBus.getDefault().unregister(this)
        }
        mainScope.cancel()
    }

    override fun onResume() {
        super.onResume()
        MobclickAgent.onResume(this)
    }

    override fun onPause() {
        super.onPause()
        MobclickAgent.onPause(this)
    }
}