package com.dn.sports.utils

import com.dn.sports.bean.BodyRecordDao
import com.dn.sports.bean.DaoSession
import com.dn.sports.bean.StepCountRecordDao
import com.dn.sports.greendao.DbHelper
import com.dn.sports.greendao.DbHelper.getDaoSession
import com.dn.sports.ormbean.BodyRecord
import com.dn.sports.ormbean.StepCountRecord

object ChartDateHelper {

    fun getWalkStepData(start: Long, end: Long): List<StepCountRecord> {
        val qb = getDaoSession().stepCountRecordDao.queryBuilder()
        val datas = qb
            .where(
                StepCountRecordDao.Properties.CurrentTime.between(start, end),
                StepCountRecordDao.Properties.Type.eq(6)
            ).orderAsc(StepCountRecordDao.Properties.CurrentTime)
            .build()
        return datas.list()
    }


    fun getAllStepsData(start: Long, end: Long): List<StepCountRecord> {
        val qb = getDaoSession().stepCountRecordDao.queryBuilder()
        val datas = qb
            .where(
                StepCountRecordDao.Properties.CurrentTime.between(start, end),
//                StepCountRecordDao.Properties.Type.eq(6)
            ).orderAsc(StepCountRecordDao.Properties.CurrentTime)
            .build()
        return datas.list()
    }


    /**
     * 获取体重数据
     */
    fun getAllWeightData(start: Long, end: Long): MutableList<BodyRecord>? {
        val qb = getDaoSession().bodyRecordDao.queryBuilder()
        val datas = qb
            .where(
                BodyRecordDao.Properties.Time.between(start, end),
                BodyRecordDao.Properties.Type.eq(2)
            ).orderAsc(BodyRecordDao.Properties.Time)
            .build()
        return datas.list()
    }



}