package com.dn.sports.utils

import android.content.Context
import com.bumptech.glide.Glide
import com.bumptech.glide.GlideBuilder
import com.bumptech.glide.Registry
import com.bumptech.glide.annotation.GlideModule
import com.bumptech.glide.load.DecodeFormat
import com.bumptech.glide.load.engine.bitmap_recycle.LruBitmapPool
import com.bumptech.glide.load.engine.cache.LruResourceCache
import com.bumptech.glide.load.engine.cache.MemorySizeCalculator
import com.bumptech.glide.load.model.GlideUrl
import com.bumptech.glide.module.AppGlideModule
import com.bumptech.glide.request.RequestOptions
import java.io.InputStream

@GlideModule(glideName = "YGlideApp")
class YGlideModule : AppGlideModule() {

    override fun applyOptions(context: Context, builder: GlideBuilder) {
        val calculator = MemorySizeCalculator.Builder(context)
            .setMemoryCacheScreens(1f)
            .setBitmapPoolScreens(1f)
            .build()
        //内存缓存
        builder.setMemoryCache(LruResourceCache(calculator.memoryCacheSize.toLong()))
        //Bitmap池
        builder.setBitmapPool(LruBitmapPool(calculator.bitmapPoolSize.toLong()))
        //内部不使用无限制的线程池
        //设置图片质量565减少图片加载所耗内存
        builder.setDefaultRequestOptions(
            RequestOptions().format(DecodeFormat.PREFER_RGB_565)
                .useUnlimitedSourceGeneratorsPool(false)
        )

    }


    override fun isManifestParsingEnabled(): Boolean {
        return false
    }
}
