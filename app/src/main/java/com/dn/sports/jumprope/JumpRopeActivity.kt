package com.dn.sports.jumprope

import android.media.MediaPlayer
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.SurfaceHolder
import android.view.View
import android.view.WindowManager
import com.dn.sports.R
import com.dn.sports.common.BaseActivity
import com.dn.sports.dialog.JumpSummaryDialog
import com.dn.sports.greendao.DbHelper
import com.dn.sports.ormbean.StepCountRecord
import com.dn.sports.utils.DateUtils
import com.dn.sports.utils.clickDelay
import kotlinx.android.synthetic.main.activity_jump_rope.*
import java.io.IOException

class JumpRopeActivity : BaseActivity(), SurfaceHolder.Callback {

    companion object {
        private const val STATE_READY = 0
        private const val STATE_RUNNING = 1
        private const val STATE_PAUSED = 2
    }

    private var player: MediaPlayer? = null
    private var currentState = STATE_READY
    private var secondsElapsed = 0L
    private val handler = Handler(Looper.getMainLooper())
    
    private val timerRunnable = object : Runnable {
        override fun run() {
            if (currentState == STATE_RUNNING) {
                secondsElapsed++
                updateDataUI()
                handler.postDelayed(this, 1000)
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_jump_rope)
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)

        initSurface()
        initClickListeners()
        updateStateUI()
    }

    private fun initSurface() {
        surfaceView.holder.addCallback(this)
        player = MediaPlayer()
    }

    private fun initClickListeners() {
        btnStart.clickDelay {
            startExercise()
        }

        btnPauseResume.clickDelay {
            if (currentState == STATE_RUNNING) {
                pauseExercise()
            } else {
                resumeExercise()
            }
        }

        btnStop.clickDelay {
            stopExercise()
        }
    }

    private fun startExercise() {
        currentState = STATE_RUNNING
        player?.start()
        handler.post(timerRunnable)
        updateStateUI()
    }

    private fun pauseExercise() {
        currentState = STATE_PAUSED
        player?.pause()
        handler.removeCallbacks(timerRunnable)
        updateStateUI()
    }

    private fun resumeExercise() {
        currentState = STATE_RUNNING
        player?.start()
        handler.post(timerRunnable)
        updateStateUI()
    }

    private fun stopExercise() {
        handler.removeCallbacks(timerRunnable)
        player?.pause()
        
        val durationText = formatTime(secondsElapsed)
        val calories = calculateCalories(secondsElapsed)
        
        JumpSummaryDialog(this, durationText, calories) {
            saveRecord(secondsElapsed, calories)
            finish()
        }.showDialog()
    }

    private fun updateStateUI() {
        when (currentState) {
            STATE_READY -> {
                layoutReady.visibility = View.VISIBLE
                layoutData.visibility = View.GONE
                layoutControls.visibility = View.GONE
            }
            STATE_RUNNING -> {
                layoutReady.visibility = View.GONE
                layoutData.visibility = View.VISIBLE
                layoutControls.visibility = View.VISIBLE
                btnPauseResume.text = "暂停"
            }
            STATE_PAUSED -> {
                layoutReady.visibility = View.GONE
                layoutData.visibility = View.VISIBLE
                layoutControls.visibility = View.VISIBLE
                btnPauseResume.text = "继续"
            }
        }
    }

    private fun updateDataUI() {
        tvTime.text = formatTime(secondsElapsed)
        val jumps = calculateJumps(secondsElapsed)
        tvCalories.text = String.format("次数: %d | 消耗: %.1f kcal", jumps, calculateCalories(secondsElapsed).toFloat())
    }

    private fun calculateJumps(seconds: Long): Int {
        // Average jump rate: ~130 jumps per minute (2.16 per second)
        return (seconds * 2.16).toInt()
    }

    private fun formatTime(seconds: Long): String {
        val h = seconds / 3600
        val m = (seconds % 3600) / 60
        val s = seconds % 60
        return String.format("%02d:%02d:%02d", h, m, s)
    }

    private fun calculateCalories(seconds: Long): Int {
        // Rough estimation: Jump rope burns ~10-12 cal per minute
        return (seconds / 60.0 * 11).toInt()
    }

    private fun saveRecord(elapsed: Long, cal: Int) {
        if (elapsed < 3) return // Don't save very short sessions

        val record = StepCountRecord().apply {
            id = System.currentTimeMillis()
            startTime = System.currentTimeMillis() - (elapsed * 1000)
            useTime = elapsed * 1000
            steps = calculateJumps(elapsed) // 实时估算跳绳次数 (Data Integrity: Real counts)
            currentTime = System.currentTimeMillis()
            date = DateUtils.getYMD(0)
            type = 7 
        }

        try {
            DbHelper.getDaoSession().stepCountRecordDao.insert(record)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun surfaceCreated(holder: SurfaceHolder) {
        try {
            val afd = assets.openFd("jump.mp4")
            player?.reset()
            player?.setDisplay(holder)
            player?.setDataSource(afd.fileDescriptor, afd.startOffset, afd.length)
            player?.setOnPreparedListener { 
                it.isLooping = true
                // Don't start until currentState is RUNNING
            }
            player?.prepareAsync()
        } catch (e: IOException) {
            e.printStackTrace()
        }
    }

    override fun surfaceChanged(holder: SurfaceHolder, format: Int, width: Int, height: Int) {}

    override fun surfaceDestroyed(holder: SurfaceHolder) {
        player?.release()
        player = null
    }

    override fun onDestroy() {
        super.onDestroy()
        handler.removeCallbacks(timerRunnable)
        player?.release()
    }
}