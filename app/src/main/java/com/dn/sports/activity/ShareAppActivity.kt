package com.dn.sports.activity

import android.content.Intent
import android.graphics.Bitmap
import android.os.Build
import android.os.Bundle
import androidx.core.content.FileProvider
import com.angcyo.widget.span.span
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.bumptech.glide.request.RequestOptions
import com.luck.picture.lib.basic.PictureSelector
import com.luck.picture.lib.entity.LocalMedia
import com.luck.picture.lib.interfaces.OnResultCallbackListener
import com.dn.sports.R
import com.dn.sports.common.BaseActivity
import com.dn.sports.greendao.DbHelper
import com.dn.sports.utils.*
import jp.wasabeef.glide.transformations.RoundedCornersTransformation
import jp.wasabeef.glide.transformations.RoundedCornersTransformation.CornerType
import kotlinx.android.synthetic.main.share_app_act.*
import java.io.File

class ShareAppActivity : BaseActivity() {

    private val picpath by lazy { File(cacheDir, "share_${hashCode()}.jpg").absolutePath }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.share_app_act)
        setTitle("分享步数")
        btConfirm.clickDelay {
            savePic2Local()
        }
        imShare.round(8)
        imShare.round(8)
        btReset.clickDelay {
            changePic(1){
                Glide.with(this)
                    .load(File(it))
                    .diskCacheStrategy(DiskCacheStrategy.NONE) // 不使用磁盘缓存
                    .apply(
                        RequestOptions.bitmapTransform(
                            RoundedCornersTransformation(
                                8.dp, 0, CornerType.ALL
                            )
                        )
                    )
                    .centerCrop()
                    .skipMemoryCache(true) // 不使用内存缓存
                    .into(imShare)
            }
        }
        val step = DbHelper.getTodayCount()

        tvStep.text = span {
            append("${step}")
            append("步") {
                fontSize = 12.dp
            }
        }

        tvHeat.text = span {
            append("${step.toKal()}")
            append("千卡") {
                fontSize = 12.dp
            }
        }

        tvDate.text = "${DateUtils.getMonth()}/${DateUtils.getDay()}"
        tvYear.text = "${DateUtils.getYear()}"
    }


    private fun savePic2Local() {
        laySharePic.setDrawingCacheEnabled(true)
        laySharePic.buildDrawingCache()
        var bitmap: Bitmap? = laySharePic.getDrawingCache(true)
        if (bitmap != null) {
            bitmap = Bitmap.createBitmap(bitmap)
            io {
                BitmapUtils.saveBitmap(
                    bitmap,
                    picpath,
                    object : BitmapUtils.SharePictureCallBack {
                        override fun onsuccess() {
                            main {
                                shareToSystem()
                            }
                        }

                        override fun onFailed(e: Exception?) {
                            main {
                                "分享图片生成失败".toast()
                            }
                        }
                    })
            }
        }
        laySharePic.setDrawingCacheEnabled(false)
    }

    private fun shareToSystem() {
        val shareFile = File(picpath)
        if (!shareFile.exists()) {
            "分享图片不存在".toast()
            return
        }
        val uri = FileProvider.getUriForFile(this, "com.dn.sports.fileprovider", shareFile)
        val intent = Intent(Intent.ACTION_SEND).apply {
            type = "image/jpeg"
            putExtra(Intent.EXTRA_STREAM, uri)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }
        startActivity(Intent.createChooser(intent, getString(R.string.share_to_app_title)))
    }


//    fileType 1:image 2:video
    fun changePic(fileType: Int,
                   uploadSuccess: (path: String) -> Unit){
        PictureSelector.create(this)
            .openGallery(fileType)
            .setImageEngine(GlideEngine)
            .setMaxSelectNum(1)
            .setMinSelectNum(1)
            .isGif(true)
            .forResult(getResult(uploadSuccess))

    }

    private fun getResult(
        onGetFile: (path: String) -> Unit
    ): OnResultCallbackListener<LocalMedia?> {
        return object : OnResultCallbackListener<LocalMedia?> {
            override fun onResult(result: ArrayList<LocalMedia?>?) {
                if (result != null && result.size == 1) {
                    result[0]?.realPath?.let {
                        onGetFile.invoke(it)
                    }
                }
            }
            override fun onCancel() {}
        }
    }
}
