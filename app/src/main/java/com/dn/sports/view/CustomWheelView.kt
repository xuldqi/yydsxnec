package com.dn.sports.view

import android.content.Context
import android.util.AttributeSet
import android.view.LayoutInflater
import android.widget.FrameLayout
import androidx.annotation.ColorRes
import androidx.core.view.updateLayoutParams
import com.dn.sports.R
import com.dn.sports.utils.color
import com.dn.sports.utils.dp
import com.zyyoona7.wheel.WheelView
import kotlinx.android.synthetic.main.view_custom_wheel.view.*

class CustomWheelView  @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null
) : FrameLayout(context, attrs) {


    init {
        LayoutInflater.from(context).inflate(R.layout.view_custom_wheel, this)
    }


    fun getWheel(): WheelView {
        return wheelview
    }

    fun setTextWidth(myWidth: Int,text: String) {
        bgText.updateLayoutParams<FrameLayout.LayoutParams> {
            width = myWidth.dp
        }
        tvMyUnit.text = text
    }

    fun setTextSpce(myWidth: Int){
        tvSpace.updateLayoutParams<FrameLayout.LayoutParams> {
            width = myWidth.dp
        }
    }

    fun setBglolor(@ColorRes color:Int){
        imBg.setBackgroundColor(color.color())
        tvSpace.setBackgroundColor(color.color())
    }


}