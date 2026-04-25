package com.dn.sports.jumprope

import android.media.MediaPlayer
import android.os.Bundle
import android.view.SurfaceHolder
import android.view.View
import android.view.WindowManager
import android.view.HapticFeedbackConstants
import androidx.activity.viewModels
import androidx.lifecycle.lifecycleScope
import com.dn.sports.R
import com.dn.sports.common.BaseActivity
import com.dn.sports.common.ViewModelFactory
import com.dn.sports.jumprope.dialog.JumpSummaryDialog
import com.dn.sports.utils.clickDelay
import kotlinx.android.synthetic.main.activity_jump_rope.*
import kotlinx.coroutines.flow.collect
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.content.Context
import java.io.IOException

class JumpRopeActivity : BaseActivity(), SurfaceHolder.Callback, SensorEventListener {

    private var sensorManager: SensorManager? = null
    private var accelerometer: Sensor? = null
    private var mRealJumps = 0
    private var lastTimestamp: Long = 0
    private val JUMP_THRESHOLD = 12.0f // 垂直加速度阈值 (Vertical acceleration threshold)
    private val MIN_INTERVAL = 250L // 两次跳跃最小间隔 (Minimum interval between jumps)

    private val viewModel: JumpRopeViewModel by viewModels { ViewModelFactory() }
    private var player: MediaPlayer? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_jump_rope)
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)

        initSurface()
        initClickListeners()
        initSensor()
        observeViewModel()
    }

    private fun initSensor() {
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        accelerometer = sensorManager?.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
    }

    private fun observeViewModel() {
        lifecycleScope.launchWhenStarted {
            viewModel.uiState.collect { state ->
                updateUI(state)
            }
        }
    }

    private fun updateUI(state: JumpRopeViewModel.JumpRopeUiState) {
        // Update State UI
        when (state.exerciseState) {
            JumpRopeViewModel.ExerciseState.READY -> {
                layoutReady.visibility = View.VISIBLE
                layoutData.visibility = View.GONE
                layoutControls.visibility = View.GONE
            }
            JumpRopeViewModel.ExerciseState.RUNNING -> {
                layoutReady.visibility = View.GONE
                layoutData.visibility = View.VISIBLE
                layoutControls.visibility = View.VISIBLE
                btnPauseResume.text = "暂停"
                player?.start()
            }
            JumpRopeViewModel.ExerciseState.PAUSED -> {
                layoutReady.visibility = View.GONE
                layoutData.visibility = View.VISIBLE
                layoutControls.visibility = View.VISIBLE
                btnPauseResume.text = "继续"
                player?.pause()
            }
        }

        // Update Data UI
        tvTime.text = formatTime(state.secondsElapsed)
        tvCalories.text = String.format("次数: %d | 消耗: %.1f kcal", mRealJumps, state.calories.toFloat())
    }

    private fun initSurface() {
        surfaceView.holder.addCallback(this)
        player = MediaPlayer()
    }

    private fun initClickListeners() {
        btnStart.clickDelay {
            viewModel.startExercise()
            accelerometer?.let {
                sensorManager?.registerListener(this, it, SensorManager.SENSOR_DELAY_UI)
            }
        }

        btnPauseResume.clickDelay {
            val state = viewModel.uiState.value.exerciseState
            if (state == JumpRopeViewModel.ExerciseState.RUNNING) {
                viewModel.pauseExercise()
                sensorManager?.unregisterListener(this)
            } else {
                viewModel.resumeExercise()
                accelerometer?.let {
                    sensorManager?.registerListener(this, it, SensorManager.SENSOR_DELAY_UI)
                }
            }
        }

        btnStop.clickDelay {
            stopExercise()
        }
    }

    private fun stopExercise() {
        viewModel.stopExercise()
        player?.pause()
        sensorManager?.unregisterListener(this)

        // Provide Haptic Feedback
        window.decorView.performHapticFeedback(HapticFeedbackConstants.LONG_PRESS)

        val state = viewModel.uiState.value
        val durationText = formatTime(state.secondsElapsed)
        val calories = state.calories

        JumpSummaryDialog.newInstance(durationText, calories, mRealJumps) {
            // In a real implementation, you would save the mRealJumps value here
            viewModel.saveFinalRecord()
            finish()
        }.show(supportFragmentManager, "JumpSummaryDialog")
    }

    private fun formatTime(seconds: Long): String {
        val h = seconds / 3600
        val m = (seconds % 3600) / 60
        val s = seconds % 60
        return String.format("%02d:%02d:%02d", h, m, s)
    }

    override fun onSensorChanged(event: SensorEvent?) {
        if (event?.sensor?.type == Sensor.TYPE_ACCELEROMETER && viewModel.uiState.value.exerciseState == JumpRopeViewModel.ExerciseState.RUNNING) {
            val z = event.values[2]
            val currentTime = System.currentTimeMillis()

            if (z > JUMP_THRESHOLD && (currentTime - lastTimestamp) > MIN_INTERVAL) {
                mRealJumps++
                lastTimestamp = currentTime
                viewModel.updateJumpCount(mRealJumps) // 将真实传感器计次推送到 ViewModel (Push real sensor count to VM)
            }
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}

    override fun surfaceCreated(holder: SurfaceHolder) {
        try {
            val afd = assets.openFd("jump.mp4")
            player?.reset()
            player?.setDisplay(holder)
            player?.setDataSource(afd.fileDescriptor, afd.startOffset, afd.length)
            player?.setOnPreparedListener {
                it.isLooping = true
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
        player?.release()
    }
}
