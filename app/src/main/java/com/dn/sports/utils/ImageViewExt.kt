package com.dn.sports.utils

import android.widget.ImageView
import androidx.core.content.ContextCompat
import com.bumptech.glide.Glide
import com.bumptech.glide.request.RequestOptions
import jp.wasabeef.glide.transformations.RoundedCornersTransformation

fun ImageView.loadRes(drawableId: Int) {
    val drawable = ContextCompat.getDrawable(this.context, drawableId)
    this.setImageDrawable(drawable)
}
fun ImageView.loadRes(
    drawable: Int, radius: Int=0, type: RoundedCornersTransformation.CornerType
    = RoundedCornersTransformation.CornerType.ALL
) {
    Glide.with(this)
        .load(drawable)
        .apply(
            RequestOptions.bitmapTransform(
                RoundedCornersTransformation(
                    radius.dp, 0, type
                )
            )
        ).into(this);
}

fun ImageView.loadImgUrlRound(
    url: String, radius: Int, type: RoundedCornersTransformation.CornerType
    = RoundedCornersTransformation.CornerType.ALL
) {
    Glide.with(this)
        .load(url)
        .apply(
            RequestOptions.bitmapTransform(
                RoundedCornersTransformation(
                    radius.dp, 0, type
                )
            )
        ).into(this);
}