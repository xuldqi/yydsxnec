package com.dn.sports.jumprope

import android.os.Bundle
import android.view.SurfaceHolder
import android.view.WindowManager
import com.dn.sports.R
import com.dn.sports.common.BaseActivity
import kotlinx.android.synthetic.main.activity_jump_rope.surfaceView
import android.media.MediaPlayer
import java.io.IOException


class JumpRopeActivity : BaseActivity(), SurfaceHolder.Callback {

    private var player: MediaPlayer? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_jump_rope)
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        surfaceView.let {
            surfaceView!!.holder.addCallback(this)
            player = MediaPlayer()
        }
    }

    override fun surfaceCreated(holder: SurfaceHolder) {
        try {
            val afd = assets.openFd("jump.mp4")
            player?.reset()
            player?.setDisplay(holder)
            player?.setDataSource(afd.fileDescriptor, afd.startOffset, afd.length)
            player?.setOnPreparedListener { it.start() }
            player?.isLooping = true
            player?.prepareAsync()
        } catch (e: IOException) {
            e.printStackTrace()
        }
    }

    override fun surfaceChanged(holder: SurfaceHolder, format: Int, width: Int, height: Int) {
    }

    override fun surfaceDestroyed(holder: SurfaceHolder) {
        player?.stop()
        player?.release()
        player = null
    }

    override fun onPause() {
        super.onPause()
        player?.pause()
    }

    override fun onDestroy() {
        super.onDestroy()
        player?.release()
        player = null
    }
}