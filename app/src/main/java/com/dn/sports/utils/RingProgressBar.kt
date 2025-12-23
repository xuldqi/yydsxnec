package com.dn.sports.utils
import android.content.Context
import android.graphics.*
import android.util.AttributeSet
import android.view.View
import com.dn.sports.utils.DisplayUtils.dp2px

class RingProgressBar(context: Context, attrs: AttributeSet?) : View(context, attrs) {

    private var progress = 0f // 当前进度值

    private var maxProgress = 100f // 进度条的最大值

    // 绘制画笔
    private val paint = Paint(Paint.ANTI_ALIAS_FLAG)

    init {
        // 设置画笔的颜色和样式
        paint.color = Color.BLUE
        paint.style = Paint.Style.STROKE
        paint.strokeWidth = DisplayUtils.dp2px(5).toFloat()
    }

    var bgColor="#FFC8BC"

    override fun onDraw(canvas: Canvas?) {
        super.onDraw(canvas)
        // 绘制背景圆环
        paint.strokeCap = Paint.Cap.ROUND
        paint.color = Color.parseColor("#FFFFFF")
        paint.style = Paint.Style.FILL
        canvas?.drawArc(
            width / 6f, height / 6f, width * 5f / 6f, height * 5f / 6f,
            -90f, 360f, true, paint
        )
        paint.style = Paint.Style.STROKE
        paint.strokeWidth = DisplayUtils.dp2px(10).toFloat()
        paint.color = Color.parseColor(bgColor)
        paint.isAntiAlias = true
        canvas?.drawCircle(width / 2f, height / 2f, width / 3f, paint)
        // 绘制实际进度圆环
        paint.color = Color.parseColor("#FF6E4B")
        val sweepAngle = progress / maxProgress * 360f
        canvas?.drawArc(
            width / 6f, height / 6f, width * 5f / 6f, height * 5f / 6f,
            -90f, sweepAngle, false, paint
        )
        // 绘制进度圆点
        paint.style = Paint.Style.FILL
        val radians = Math.toRadians((sweepAngle-90).toDouble())
        val x = width / 2f + (width / 3f * Math.cos(radians)).toFloat()
        val y = height / 2f + (width / 3f * Math.sin(radians)).toFloat()

        paint.color = Color.parseColor("#333333")
        canvas?.drawCircle(x, y, dp2px( 9.5f).toFloat(), paint)
        paint.color = Color.parseColor("#FFFFFF")
        canvas?.drawCircle(x, y, dp2px( 9.3f).toFloat(), paint)
        paint.color = Color.parseColor("#FF6E4B")
        canvas?.drawCircle(x, y, dp2px( 4.5f).toFloat(), paint)

    }

    // 设置进度值
    fun setProgress(progress: Float) {
        this.progress = progress
        invalidate()
    }

    // 设置最大进度值
    fun setMaxProgress(maxProgress: Float) {
        this.maxProgress = maxProgress
        invalidate()
    }
}