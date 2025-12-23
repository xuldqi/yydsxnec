package com.dn.sports.greendao

import android.annotation.SuppressLint
import com.dn.sports.RefreshTodayCount
import com.dn.sports.StepApplication
import com.dn.sports.bean.DaoMaster
import com.dn.sports.bean.DaoSession
import com.dn.sports.bean.StepCountRecordDao
import com.dn.sports.ormbean.StepCountRecord
import com.dn.sports.utils.DateUtils
import com.dn.sports.utils.toDistance
import org.greenrobot.eventbus.EventBus

object DbHelper {
    @SuppressLint("StaticFieldLeak")
    private var helper: DaoMaster.OpenHelper? = null

    var TAG = "DbHelper"

    fun getDaoSession(): DaoSession {
        if (helper == null) {
            helper = DaoMaster.DevOpenHelper(
                StepApplication.getInstance().applicationContext,
                "step-db",
                null
            )
        }
        val db = helper!!.writableDatabase
        return DaoMaster(db).newSession()
    }

    fun getTodayCount():Int {
        //查询今天的日期下的步数
        val qb = getDaoSession().stepCountRecordDao.queryBuilder()
        // 查询CurrentTime 是否和当前时间是同一天
        qb.where(StepCountRecordDao.Properties.Date.eq(DateUtils.getYMD(0)),StepCountRecordDao.Properties.Type.eq(6)).build()
        val datas = qb.list()
        if (!datas.isNullOrEmpty()){
           return datas[0].steps
        }
        return 0
    }


    /**
     * 查询历史所有的某种类型的运动数据
     *
     * 1- 户外跑步
     * 2- 室内跑步
     * 3- 健走
     * 4- 徒步
     * 5- 登山
     * 6- 走路
     */
    fun getHistoryByType(type: Int): ArrayList<StepCountRecord>? {
        return (getDaoSession().stepCountRecordDao.queryBuilder()
            .where(StepCountRecordDao.Properties.Type.eq(type))
            .orderDesc(StepCountRecordDao.Properties.Id)
            .build().list()
                as? ArrayList<StepCountRecord>)
    }



    //查询今天的日期下的步数
    fun getTodayAllSportCount():Int {
        val qb = getDaoSession().stepCountRecordDao.queryBuilder()
        // 查询CurrentTime 是否和当前时间是同一天
        qb.where(StepCountRecordDao.Properties.Date.eq(DateUtils.getYMD(0))).build()
        val datas = qb.list()
        var step = 0
        datas?.forEach {
            step += it.steps
        }
        return step
    }


    fun getSportData():String {
        val qb = getDaoSession().stepCountRecordDao.queryBuilder()
        val datas = qb
            .where(
                StepCountRecordDao.Properties.Date.eq(DateUtils.getYMD(0)),
                StepCountRecordDao.Properties.Type.notEq(6)
            ).orderAsc(StepCountRecordDao.Properties.CurrentTime)
            .build().list()
        var step = 0
        datas?.forEach {
            step += it.steps
        }
        return step.toDistance()

    }

    @JvmStatic
    fun saveTodayCount(count: Int) {
        val qb = getDaoSession().stepCountRecordDao.queryBuilder()
        val datas = qb
            .where(
                StepCountRecordDao.Properties.Date.eq(DateUtils.getYMD(0)),
                StepCountRecordDao.Properties.Type.eq(6)
            )
            .build()
        if (!datas.list().isNullOrEmpty()) {
            //如果有数据，更新数据
            (datas.list()[0] as StepCountRecord).let {
                it.steps = count
                it.currentTime = System.currentTimeMillis()
                getDaoSession().stepCountRecordDao.update(datas.list()[0])
            }
        } else {
            val data = StepCountRecord().apply {
                id = System.currentTimeMillis()
                currentTime = System.currentTimeMillis()
                steps = count
                type = 6
                date = DateUtils.getYMD(0)
            }
            getDaoSession().stepCountRecordDao.insert(data)
        }
        EventBus.getDefault().post(RefreshTodayCount(count))
    }
}