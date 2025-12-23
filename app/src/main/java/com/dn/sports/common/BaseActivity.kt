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

    fun setTitle(title: String?) {
        findViewById<View>(R.id.btBack).setOnClickListener { v: View? -> finish() }
        (findViewById<View>(R.id.tvTitle) as TextView).text = title
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