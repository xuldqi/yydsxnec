package com.dn.sports.fragment

import android.annotation.SuppressLint
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import com.dn.sports.*

import com.dn.sports.activity.SettingActivity
import com.dn.sports.activity.ShareAppActivity
import com.dn.sports.activity.SportRecordActivity
import com.dn.sports.adcoinLogin.GetImageSync
import com.dn.sports.adcoinLogin.StepUserManager
import com.dn.sports.common.Constant
import com.dn.sports.utils.ChartDateHelper
import com.dn.sports.utils.DateUtils
import com.dn.sports.utils.DateUtils.getDurationTime
import com.dn.sports.utils.Utils
import com.tencent.mm.opensdk.modelmsg.SendAuth
import com.tencent.mm.opensdk.openapi.IWXAPI
import com.tencent.mm.opensdk.openapi.WXAPIFactory
import kotlinx.android.synthetic.main.day_fragment.*
import kotlinx.android.synthetic.main.fragment_setting.*
import java.util.*

class SettingFragment : BaseFragment() {
    private var api: IWXAPI? = null
    private var currentCoin: TextView? = null
    private var totalCoin: TextView? = null
    private var currentMoney: TextView? = null
    private var userImage: ImageView? = null
    private var userText: TextView? = null
    private var qucickLogin: TextView? = null
//    var tvStep: TextView? = null
//    var tvTimes: TextView? = null
override fun getViewByLayout(
    inflater: LayoutInflater?,
    container: ViewGroup?,
    savedInstanceState: Bundle?
): View {
        return inflater!!.inflate(R.layout.fragment_setting, container, false)
    }

    override fun initViewAction(view: View?) {

    }

    private fun initWXLogin() {
        api = WXAPIFactory.createWXAPI(
            activity, Constant.WX_LOGIN.getWxAppId(
                activity
            ), true
        )
        api?.registerApp(Constant.WX_LOGIN.getWxAppId(activity))
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val stateBarH = Utils.getStatusBarHeight(activity)
        root.setPadding(0, stateBarH, 0, 0)
//        initWXLogin()
//        view.findViewById<View>(R.id.wx_login).setOnClickListener(
//            View.OnClickListener {
//                if (!StepUserManager.getInstance().isNeedLogin) {
//                    val it = Intent(activity, UserInfoActivity::class.java)
//                    startActivity(it)
//                    return@OnClickListener
//                }
//                val req = SendAuth.Req()
//                req.scope = "snsapi_userinfo"
//                req.state = "wechat_sdk_demo_test"
//                api!!.sendReq(req)
//            })
//        val tvStep = view.findViewById<TextView>(R.id.tvSteps)
//        val tvTimes = view.findViewById<TextView>(R.id.tvTimes)

        val minute = getDurationTime(getWalkTime())
        tvSteps.text = "总步数: ${getWalkData().toString()}步"
        tvTimes.text = "总运动时长: ${minute}"

        invite_friend.setOnClickListener(
            View.OnClickListener {
                val it = Intent(activity, SportRecordActivity::class.java)
                startActivity(it)
            })
//        view.findViewById<View>(R.id.my_money_layout)
//            .setOnClickListener(object : View.OnClickListener {
//                override fun onClick(view: View) {
//                    if (StepUserManager.getInstance().userInfo != null) {
//                        val it = Intent(activity, MyMoneyActivity::class.java)
//                        startActivity(it)
//                    }
//                }
//            })
//        if (!StepApplication.getInstance().isShowMasonTask) {
//            view.findViewById<View>(R.id.my_money_layout).visibility = View.GONE
//            //            view.findViewById(R.id.invite_friend).setVisibility(View.GONE);
////            view.findViewById(R.id.share_to_friends).setVisibility(View.GONE);
//            view.findViewById<View>(R.id.coin_record_list).visibility = View.GONE
//        }
        contact_us.setOnClickListener(object : View.OnClickListener {
            override fun onClick(view: View) {
                val intent = Intent(activity, SettingActivity::class.java)
                startActivity(intent)
            }
        })
        user_xy.setOnClickListener(object : View.OnClickListener {
            override fun onClick(v: View) {
                val it = Intent(activity, BodyRecordActivity::class.java)
                startActivity(it)
            }
        })
        currentCoin = view.findViewById(R.id.current_coin)
        totalCoin = view.findViewById(R.id.total_coin)
        currentMoney = view.findViewById(R.id.current_money)
        userImage = view.findViewById(R.id.user_image)
        userText = view.findViewById(R.id.user_name)
        qucickLogin = view.findViewById(R.id.quick_login)
        rate_us.setOnClickListener(object : View.OnClickListener {
            override fun onClick(v: View) {
                try {
                    val uri = Uri.parse("market://details?id=" + activity!!.packageName)
                    val intent = Intent(Intent.ACTION_VIEW, uri)
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    startActivity(intent)
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }
        })
        common_problem.setOnClickListener(object : View.OnClickListener {
            override fun onClick(view: View) {
                val it = Intent(activity, CommonProblemActivity::class.java)
                startActivity(it)
            }
        })
        coin_record_list .setOnClickListener(object : View.OnClickListener {
            override fun onClick(view: View) {
                val it = Intent(activity, CoinRecordActivity::class.java)
                startActivity(it)
            }
        })
        share_to_friends.setOnClickListener { view12: View? ->
            val it: Intent = Intent(getActivity(), ShareAppActivity::class.java)
            it.putExtra("share_app", true)
            startActivity(it)
        }
        tvShare.setOnClickListener { view1: View? ->
            val it: Intent = Intent(getActivity(), ShareAppActivity::class.java)
            it.putExtra("share_app", true)
            startActivity(it)
        }
        updateUserInfo()
    }

    private fun getWalkData(): Int {
        val currentTime1 =
            DateUtils.getDayStartTimestamp(DateUtils.getWeekEndTimestamp(System.currentTimeMillis()).time)
        val currentTime2 =
            DateUtils.getDayStartTimestamp(DateUtils.getWeekStartTimestamp(System.currentTimeMillis()).time)
        val datas = ChartDateHelper.getWalkStepData(currentTime2, currentTime1)
        var step = 0
        datas.forEach { record ->
            step += record.steps
        }
        return step
    }

    private fun getWalkTime(): Int {
        val currentTime1 =
            DateUtils.getDayStartTimestamp(DateUtils.getWeekEndTimestamp(System.currentTimeMillis()).time)
        val currentTime2 =
            DateUtils.getDayStartTimestamp(DateUtils.getWeekStartTimestamp(System.currentTimeMillis()).time)
        val datas = ChartDateHelper.getAllStepsData(currentTime2, currentTime1)
        var times = 0L
        datas.forEach { record ->
            times += record.useTime
        }
        return (times/1000).toInt()
    }

    override fun updateUserInfo() {
//        val user = StepUserManager.getInstance().userInfo
//        if (user != null) {
//            //超过24小时就小时
//            if (System.currentTimeMillis() - user.createTime.time >= 24 * 60 * 60 * 1000) {
////                if(view != null)
////                    view.findViewById(R.id.invite_friend).setVisibility(View.GONE);
//            }
//            if (totalCoin != null) totalCoin!!.text = user.total_mount.toInt()
//                .toString() + resources.getString(R.string.coin)
//            if (currentCoin != null) currentCoin!!.text =
//                user.balance.toInt().toString() + resources.getString(R.string.coin)
//            if (currentMoney != null) currentMoney!!.text =
//                StepUserManager.coinToMoney(user.balance) + resources.getString(R.string.unit_money)
//            if (StepUserManager.getInstance().isNeedLogin) {
//                if (totalCoin != null) userImage!!.setImageResource(R.mipmap.user_image)
//                if (userText != null) userText!!.text =
//                    resources.getString(R.string.unregister_user)
//                if (qucickLogin != null) qucickLogin!!.text =
//                    resources.getString(R.string.quick_login)
//                if (view != null) view.findViewById<View>(R.id.coin_record_list).visibility =
//                    View.INVISIBLE
//            } else {
//                if (userImage != null) GetImageSync(userImage, activity).execute(user.headImg)
//                if (userText != null) userText!!.text = user.nickname
//                if (view != null && StepApplication.getInstance().isShowMasonTask) view.findViewById<View>(
//                    R.id.coin_record_list
//                ).visibility = View.VISIBLE
//                if (qucickLogin != null) qucickLogin!!.text =
//                    resources.getString(R.string.my_invite_code) + ":" + user.inviteCode
//            }
//        } else {
//            if (userImage != null) userImage!!.setImageResource(R.mipmap.user_image)
//            if (userText != null) userText!!.text = resources.getString(R.string.unregister_user)
//            if (qucickLogin != null) qucickLogin!!.text = resources.getString(R.string.quick_login)
//            if (view != null && StepApplication.getInstance().isShowMasonTask) {
//                view.findViewById<View>(R.id.coin_record_list).visibility =
//                    View.INVISIBLE
//                //                view.findViewById(R.id.invite_friend).setVisibility(View.VISIBLE);
//            }
//        }
    }

    override fun clearUserInfo() {
//        userImage!!.setImageResource(R.mipmap.user_image)
//        userText!!.text = resources.getString(R.string.unregister_user)
//        qucickLogin!!.text = resources.getString(R.string.quick_login)
//        totalCoin!!.text = "0" + resources.getString(R.string.coin)
//        currentCoin!!.text = "0" + resources.getString(R.string.coin)
//        currentMoney!!.text = "0" + resources.getString(R.string.unit_money)
//        if (view != null && StepApplication.getInstance().isShowMasonTask) {
//            view.findViewById<View>(R.id.coin_record_list).visibility = View.INVISIBLE
//            //            view.findViewById(R.id.invite_friend).setVisibility(View.VISIBLE);
//        }
    }
}