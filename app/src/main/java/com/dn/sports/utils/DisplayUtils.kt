package com.dn.sports.utils

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.res.Configuration
import android.content.res.Resources
import android.graphics.Point
import android.os.Build
import android.util.DisplayMetrics
import android.view.WindowManager
import me.jessyan.autosize.utils.AutoSizeUtils

@SuppressLint("StaticFieldLeak")
object DisplayUtils {


    private lateinit var sDisplayMetrics: DisplayMetrics
    private var mRes: Resources? = null

    /**
     * 获取屏幕宽度 单位：像素
     *
     * @return 屏幕宽度
     */
    var widthPixels = 0
        private set

    /**
     * 获取屏幕高度 单位：像素
     *
     * @return 屏幕高度
     */
    var heightPixels = 0
        private set
    private const val ROUND_DIFFERENCE = 0.5f
    var mContext: Context? = null

    /**
     * 初始化操作
     *
     * @param context context
     */
    fun init(context: Context) {
        mContext = context
        sDisplayMetrics = context.resources.displayMetrics
        mRes = context.resources
        widthPixels = sDisplayMetrics.widthPixels
        heightPixels = sDisplayMetrics.heightPixels
        //初始化 在Application中  会出现 宽高反过来的情况
        if (widthPixels > heightPixels) {
            val tempPixels = heightPixels
            heightPixels = widthPixels
            widthPixels = tempPixels
        }
    }//        if (EnvironmentUtils.isFlymeOs()) {
//            height = height * 2;
//        }
    /**
     * 获取状态栏高度
     *
     * @return 状态栏高度
     */
    val statusBarHeight: Int
        get() {
            if (mRes == null) {
                return 0
            }
            val defaultHeightInDp = 19
            var height = dp2px(defaultHeightInDp)
            try {
                val c = Class.forName("com.android.internal.R\$dimen")
                val obj = c.newInstance()
                val field = c.getField("status_bar_height")
                height = mRes!!.getDimensionPixelSize(field[obj].toString().toInt())
            } catch (e1: Exception) {
                e1.printStackTrace()
            }
            //        if (EnvironmentUtils.isFlymeOs()) {
            //            height = height * 2;
            //        }
            return height
        }

    /**
     * 获取屏幕宽度 单位：像素
     *
     * @return 屏幕宽度
     */
    val density: Float
        get() = if (sDisplayMetrics == null)
            0f
        else sDisplayMetrics!!.density

    /**
     * dp 转 px
     *
     * @param dp dp值
     * @return 转换后的像素值
     */
    fun dp2px(dp: Int): Int {
        return AutoSizeUtils.dp2px(mContext!!.applicationContext, dp.toFloat())
    }

    /**
     * dp 转 px
     *
     * @param dp dp值
     * @return 转换后的像素值
     */
    fun dp2px(dp: Float): Int {
        return AutoSizeUtils.dp2px(mContext!!.applicationContext, dp)
    }

    /**
     * sp 转 px
     *
     * @param sp
     * @return
     */
    fun sp2px(sp: Float): Int {
        return AutoSizeUtils.sp2px(mContext!!.applicationContext, sp)
    }

    /**
     * px 转 dp
     *
     * @param px px值
     * @return 转换后的dp值
     */
    fun px2dp(px: Int): Int {
        return if (sDisplayMetrics == null) {
            0
        } else (px / sDisplayMetrics!!.density + ROUND_DIFFERENCE).toInt()
    }

    /**
     * 获取dimen资源像素值
     *
     * @param dimenResId dimenResId
     * @return 像素值
     */
    fun getDimensionPixelSize(dimenResId: Int): Int {
        return if (mRes == null) {
            0
        } else mRes!!.getDimensionPixelSize(dimenResId)
    }

    /**
     * 取得手机状态栏的高度
     *
     * @return
     */
    val statusHeight: Int
        get() {
            if (mRes == null) {
                return 0
            }
            val defaultHeightInDp = 19
            var height = dp2px(defaultHeightInDp)
            try {
                val c = Class.forName("com.android.internal.R\$dimen")
                val obj = c.newInstance()
                val field = c.getField("status_bar_height")
                height = mRes!!.getDimensionPixelSize(field[obj].toString().toInt())
            } catch (e1: Exception) {
                e1.printStackTrace()
            }
            return height
        }

    /**
     * 通过反射，获取是否包含虚拟键
     *
     * @return
     */
    fun getHasVirtualKey(activity: Activity): Int {
        var dpi = 0
        val display = activity.windowManager.defaultDisplay
        val dm = DisplayMetrics()
        val c: Class<*>
        try {
            c = Class.forName("android.view.Display")
            val method = c.getMethod("getRealMetrics", DisplayMetrics::class.java)
            method.invoke(display, dm)
            dpi = dm.heightPixels
        } catch (e: Exception) {
            e.printStackTrace()
        }

        //获取屏幕尺寸，不包括虚拟功能高度<br><br>
        val height = activity.windowManager.defaultDisplay.height

//        LogUtils.e("aaaaaa", dpi +" , "+ height);
//        return dpi != height;//不相等说明有虚拟按键
        return dpi - height
    }

    // 全面屏高度适配，解决手机主播间下方没有铺满的问题
    // 如三星 S8获取手机屏幕高度的值不对，没包含系统状态栏
    // 参考https://blog.csdn.net/xu20082100226/article/details/80076351
    @Volatile
    private var mHasCheckAllScreen = false

    @Volatile
    private var mIsAllScreenDevice = false
    private const val PORTRAIT = 0
    private const val LANDSCAPE = 1

    @Volatile
    private var mRealSizes = ArrayList<Point>(2)

    // 低于 API 21的，都不会是全面屏。。。
    val isAllScreenDevice: Boolean
        get() {
            if (mHasCheckAllScreen) {
                return mIsAllScreenDevice
            }
            mHasCheckAllScreen = true
            mIsAllScreenDevice = false
            // 低于 API 21的，都不会是全面屏。。。
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
                return false
            }
            val windowManager: WindowManager? =
                mContext!!.getSystemService(Context.WINDOW_SERVICE) as WindowManager
            if (windowManager != null) {
                val display = windowManager.defaultDisplay
                val point = Point()
                display.getRealSize(point)
                val width: Float
                val height: Float
                if (point.x < point.y) {
                    width = point.x.toFloat()
                    height = point.y.toFloat()
                } else {
                    width = point.y.toFloat()
                    height = point.x.toFloat()
                }
                if (height / width >= 1.97f) {
                    mIsAllScreenDevice = true
                }
            }
            return mIsAllScreenDevice
        }

    val screenRealHeight: Int
        get() {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.JELLY_BEAN_MR1) {
                return heightPixels
            }
            var orientation = mContext!!.resources.configuration.orientation
            orientation =
                if (orientation == Configuration.ORIENTATION_PORTRAIT) PORTRAIT else LANDSCAPE
            if (mRealSizes.get(orientation) == null) {
                val windowManager: WindowManager =
                    mContext!!.getSystemService(Context.WINDOW_SERVICE) as WindowManager
                        ?: return heightPixels
                val display = windowManager.defaultDisplay
                var point = Point()
                display.getRealSize(point)
                mRealSizes[orientation] = point
            }
            return mRealSizes.get(orientation)!!.y
        }

    //end  全面屏高度适配
    val fullActivityHeight: Int
        get() {
            return if (!isAllScreenDevice) {
                heightPixels
            } else screenRealHeight
        }
}
