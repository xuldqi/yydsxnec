package com.dn.sports.view

import android.content.Context
import android.content.Intent
import android.util.AttributeSet
import android.view.LayoutInflater
import android.widget.FrameLayout
import android.widget.RelativeLayout
import androidx.core.view.updateLayoutParams
import com.angcyo.widget.span.span
import com.dn.sports.*
import com.dn.sports.activity.ChartActivity
import com.dn.sports.activity.SportRecordActivity
import com.dn.sports.bean.CardData
import com.dn.sports.greendao.DbHelper
import com.dn.sports.target.StepCountTargetActivity
import com.dn.sports.utils.*
import kotlinx.android.synthetic.main.view_sport_card.view.*
import org.greenrobot.eventbus.EventBus
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode

class SportViewCard @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null
) : FrameLayout(context, attrs) {

    companion object {
        /**
         * 走路距离
         */
        val CARD_TYPE_WALK = 0

        /**
         * 时间计时
         */
        val CARD_TYPE_TIME = 1

        /**
         * 体重记录
         */
        val CARD_TYPE_WEIGHT = 2

        /**
         * 运动距离
         */
        val CARD_TYPE_SPORT = 3

        /**
         * 身体数据
         */
        val CARD_TYPE_BODY = 4

        /**
         * 热量消耗
         */
        val CARD_TYPE_HEAT = 5
    }


    var cardType = 0


    init {
        LayoutInflater.from(context).inflate(R.layout.view_sport_card, this)
        EventBus.getDefault().register(this)
    }

    var mData: CardData? = null

    fun setData(data: CardData) {
        mData = data
        tvName.text = data.name

        when(data.type){
            CARD_TYPE_WALK -> {
                imIcon.loadRes(R.mipmap.icon_walk_small)
                bgParent.loadRes(R.mipmap.bg_walk)
                imRight.loadRes(R.mipmap.walk_right)
            }
            CARD_TYPE_TIME -> {
                imIcon.loadRes(R.mipmap.icon_time)
                bgParent.loadRes(R.mipmap.bg_time)
                imRight.loadRes(R.mipmap.right_time)
            }
            CARD_TYPE_SPORT -> {
                imIcon.loadRes(R.mipmap.icon_dis)
                bgParent.loadRes(R.mipmap.bg_card)
                imRight.loadRes(R.mipmap.right_sport)
            }
            CARD_TYPE_BODY -> {
                imIcon.loadRes(R.mipmap.icon_body)
                bgParent.loadRes(R.mipmap.bg_body)
                imRight.loadRes(R.mipmap.right_body)
            }
            CARD_TYPE_HEAT -> {
                imIcon.loadRes(R.mipmap.icon_heat)
                bgParent.loadRes(R.mipmap.bg_heat)
                imRight.loadRes(R.mipmap.right_heat)
            }
            CARD_TYPE_WEIGHT -> {
                imIcon.loadRes(R.mipmap.icon_weight)
                bgParent.loadRes(R.mipmap.bg_weight)
                imRight.loadRes(R.mipmap.right_weight)
            }
        }




        if (data.rightIcon == R.mipmap.right_weight) {
            imRight.updateLayoutParams<RelativeLayout.LayoutParams> {
                width = 57.dp
                height = 57.dp
                bottomMargin = 17.dp
            }
        }
        clickDelay {
            when (data.type) {
                CARD_TYPE_WALK -> {
                    getAct()?.jumpActivity(ChartActivity::class.java) {
                        it.putExtra(ChartActivity.type, ChartActivity.TYPE_DISTENCE)
                    }
                }
                CARD_TYPE_TIME -> {
                    getAct()?.jumpActivity(CountTimeActivity::class.java)
                }
                CARD_TYPE_SPORT -> {
                    val it = Intent(getAct(), SportRecordActivity::class.java)
                    getAct()?.startActivity(it)

                }
                CARD_TYPE_HEAT -> {
                    getAct()?.jumpActivity(ChartActivity::class.java) {
                        it.putExtra(ChartActivity.type, ChartActivity.TYPE_HEAT)
                    }
                }
                CARD_TYPE_BODY -> {
                    getAct()?.jumpActivity(BodyRecordActivity::class.java)
                }
                CARD_TYPE_WEIGHT -> {
                    getAct()?.jumpActivity(ChartActivity::class.java) {
                        it.putExtra(ChartActivity.type, ChartActivity.TYPE_WEIGHT)
                    }
                }
            }
        }
        refreshData()
    }

    var stepValue = ""
    var sportDis = ""
    var heatValue = 0f


    private fun getSportData() {
        stepValue = DbHelper.getTodayCount().toDistance()
        heatValue = DbHelper.getTodayAllSportCount().toKal().toFloat()
        sportDis = DbHelper.getSportData()
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onMessageEvent(event: RefreshTodayCount?) {
        refreshData()
    }

     private fun refreshData(){
        getSportData()
        when (mData?.type) {
            CARD_TYPE_WALK -> {
                setTextValue("今日行走 ", stepValue, " 公里")
            }
            CARD_TYPE_HEAT -> {
                setTextValue("今日消耗热量 ", heatValue, " 千卡")
            }
            CARD_TYPE_BODY -> {
                tvTips.text = "查看身体数据"
            }
            CARD_TYPE_SPORT -> {
                if (sportDis.isNotEmpty() || sportDis == "0") {
                    tvTips.text = "暂时还没有记录"
                } else {
                    tvTips.text = "今日运动距离：${sportDis} 千米"
                }
            }
            CARD_TYPE_WEIGHT -> {
                tvTips.text = "查看体重数据"
            }
            CARD_TYPE_TIME -> {
                tvTips.text = "开始计时"
                tvMore.setVisible()
            }
        }
    }




    private fun setTextValue(msg1: String, value: Any, msg2: String) {
        val msg = span {
            append(msg1) {}.append(value.toString()) {
                foregroundColor = R.color.black.color()
            }.append(msg2)
        }
        tvTips.text = msg
    }


}