package com.dn.sports.utils

import android.content.Context
import android.graphics.*
import android.util.AttributeSet
import android.view.View

/**
 * Premium Multi-Activity Rings View
 * Inspired by Apple Watch Activity Rings.
 * Supports 3 independent rings and handles progress > 100% (with wrap-around).
 */
class MultiActivityRingsView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0
) : View(context, attrs, defStyleAttr) {

    // Progress values (0.0 to 1.0, can exceed 1.0)
    private var innerProgress = 0f  // Red (e.g., Steps)
    private var middleProgress = 0f // Purple (e.g., Calories)
    private var outerProgress = 0f  // Green (e.g., Distance)

    private val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.STROKE
        strokeCap = Paint.Cap.ROUND
    }

    // Classic Sport Colors (Reverted)
    private val innerColor = Color.parseColor("#FF5252")  // Coral Red
    private val middleColor = Color.parseColor("#9C27B0") // Purple
    private val outerColor = Color.parseColor("#4CAF50")  // Success Green

    private val bgAlpha = 0.2f // Soft background track transparency

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)

        val size = Math.min(width, height).toFloat()
        val centerX = width / 2f
        val centerY = height / 2f
        val strokeWidth = size * 0.08f // Adaptive stroke width
        paint.strokeWidth = strokeWidth

        val spacing = strokeWidth * 1.2f // Gap between rings

        // Outer Ring (Green)
        drawRing(canvas, centerX, centerY, (size / 2) - strokeWidth / 2, outerProgress, outerColor)

        // Middle Ring (Purple)
        drawRing(canvas, centerX, centerY, (size / 2) - strokeWidth / 2 - spacing, middleProgress, middleColor)

        // Inner Ring (Red)
        drawRing(canvas, centerX, centerY, (size / 2) - strokeWidth / 2 - spacing * 2, innerProgress, innerColor)
    }

    private fun drawRing(canvas: Canvas, cx: Float, cy: Float, radius: Float, progress: Float, color: Int) {
        val rect = RectF(cx - radius, cy - radius, cx + radius, cy + radius)

        // 1. Draw Background Track
        paint.color = color
        paint.alpha = (255 * bgAlpha).toInt()
        canvas.drawCircle(cx, cy, radius, paint)

        // 2. Draw Progress Arc
        paint.alpha = 255
        
        // Handling Wrap-around for progress > 1.0
        val actualProgress = progress
        val sweepAngle = Math.min(actualProgress, 1.0f) * 360f
        
        // Main arc
        canvas.drawArc(rect, -90f, sweepAngle, false, paint)

        // If progress > 100%, draw the "wrap around" part with an overlap effect
        if (actualProgress > 1.0f) {
            val extraSweep = (actualProgress - 1.0f) * 360f
            // We draw the overlap with a slightly different shadow or just overlapping
            // To make it look premium, we can add a small shadow at the start of the overlap
            canvas.drawArc(rect, -90f, Math.min(extraSweep, 360f), false, paint)
        }
    }

    /**
     * Set progress for all rings. Values are 0.0f to infinity.
     */
    fun setProgress(inner: Float, middle: Float, outer: Float) {
        this.innerProgress = inner
        this.middleProgress = middle
        this.outerProgress = outer
        invalidate()
    }

    // Individual setters for convenience
    fun setInnerProgress(p: Float) { this.innerProgress = p; invalidate() }
    fun setMiddleProgress(p: Float) { this.middleProgress = p; invalidate() }
    fun setOuterProgress(p: Float) { this.outerProgress = p; invalidate() }
}
