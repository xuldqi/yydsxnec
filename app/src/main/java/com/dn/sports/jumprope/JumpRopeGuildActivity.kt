package com.dn.sports.jumprope

import android.graphics.Color
import android.os.Bundle
import com.dn.sports.R
import com.dn.sports.common.BaseActivity
import com.dn.sports.utils.clickDelay
import com.dn.sports.utils.jumpActivity
import com.dn.sports.utils.setVisible
import kotlinx.android.synthetic.main.activity_jump_rope_guild.container
import kotlinx.android.synthetic.main.activity_jump_rope_guild.tabGuild
import kotlinx.android.synthetic.main.activity_jump_rope_guild.tabGuildLine
import kotlinx.android.synthetic.main.activity_jump_rope_guild.tabRecord
import kotlinx.android.synthetic.main.activity_jump_rope_guild.tabRecordLine
import kotlinx.android.synthetic.main.activity_jump_rope_guild.tvStart

class JumpRopeGuildActivity : BaseActivity() {
//    RopeClassGulidFragment

    var ropeGuildFragment: RopeClassGulidFragment? = null
    var jumpRecordFragment: JumpRecordFragment? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_jump_rope_guild)
        switchFragment(0);
        tabGuild.clickDelay {
            switchFragment(0)
            tabRecord.setTextColor(Color.parseColor("#C39891"))
            tabGuild.setTextColor(Color.parseColor("#894439"))
            tabGuildLine.setVisible(true)
            tabRecordLine.setVisible(false)
        }
        tabRecord.clickDelay {
            switchFragment(1)
            tabGuild.setTextColor(Color.parseColor("#C39891"))
            tabRecord.setTextColor(Color.parseColor("#894439"))
            tabGuildLine.setVisible(false)
            tabRecordLine.setVisible(true)
        }
        tvStart.clickDelay {
            jumpActivity(JumpRopeActivity::class.java)

        }

    }

    private fun switchFragment(index: Int) {
        if (index == 0) {
            supportFragmentManager.beginTransaction().apply {
                jumpRecordFragment?.let { hide(it) }
                if (ropeGuildFragment == null) {
                    ropeGuildFragment = RopeClassGulidFragment();
                    add(R.id.container, ropeGuildFragment!!, "RopeClassGulidFragment")
                } else {
                    show(ropeGuildFragment!!)
                }
                commitAllowingStateLoss()
            }
        } else {
            supportFragmentManager.beginTransaction().apply {
                ropeGuildFragment?.let { hide(it) }
                if (jumpRecordFragment == null) {
                    jumpRecordFragment = JumpRecordFragment();
                    add(R.id.container, jumpRecordFragment!!, "RopeClassGulidFragment")
                } else {
                    show(jumpRecordFragment!!)
                }
                commitAllowingStateLoss()
            }
        }
    }

}

