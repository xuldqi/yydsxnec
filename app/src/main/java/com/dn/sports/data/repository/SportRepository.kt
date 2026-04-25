package com.dn.sports.data.repository

import com.dn.sports.data.local.dao.SportRecordDao
import com.dn.sports.data.local.entities.SportRecordEntity
import com.dn.sports.greendao.DbHelper
import com.dn.sports.ormbean.StepCountRecord
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

/**
 * Repository that bridges the gap between modern Room persistence and legacy GreenDao.
 * This ensures data integrity during the migration phase.
 */
class SportRepository(
    private val sportRecordDao: SportRecordDao,
    private val achievementDao: com.dn.sports.data.local.dao.AchievementDao
) {

    suspend fun upsertDailyStepsRecord(
        steps: Int,
        currentTime: Long = System.currentTimeMillis()
    ) = withContext(Dispatchers.IO) {
        val date = com.dn.sports.utils.DateUtils.getYMD(0)
        val existing = sportRecordDao.getRecordByDateAndType(date, 6)
        val entity = existing?.apply {
            startTime = currentTime
            useTime = 0
            this.steps = steps
            this.currentTime = currentTime
            this.date = date
            type = 6
            subType = 0
        } ?: SportRecordEntity(
            id = 0,
            startTime = currentTime,
            useTime = 0,
            steps = steps,
            currentTime = currentTime,
            date = date,
            type = 6,
            subType = 0
        )

        sportRecordDao.insertRecord(entity)
        syncToLegacy(entity)
        checkAndUnlockAchievements(entity)
    }

    /**
     * Inserts a record into both legacy GreenDao (for compatibility) and Room.
     */
    suspend fun saveSportRecord(entity: SportRecordEntity) = withContext(Dispatchers.IO) {
        // 1. Save to Room
        sportRecordDao.insertRecord(entity)

        // 2. Sync to legacy GreenDao
        syncToLegacy(entity)

        // 3. Check Achievements
        checkAndUnlockAchievements(entity)
    }

    private fun syncToLegacy(entity: SportRecordEntity) {
        try {
            val legacyRecord = StepCountRecord().apply {
                id = entity.id.takeIf { it != 0L }
                startTime = entity.startTime
                useTime = entity.useTime
                steps = entity.steps
                currentTime = entity.currentTime
                date = entity.date
                type = entity.type
                subType = entity.subType
            }
            DbHelper.getDaoSession().stepCountRecordDao.insertOrReplace(legacyRecord)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private suspend fun checkAndUnlockAchievements(entity: SportRecordEntity) {
        if (entity.type == 6 && entity.steps >= 10000) {
            val existing = achievementDao.getAchievement(0, 10000)
            if (existing == null) {
                achievementDao.insertAchievement(com.dn.sports.data.local.entities.AchievementEntity(
                    id = 0,
                    name = "万步达人",
                    description = "单日行走超过 10,000 步",
                    type = 0,
                    targetValue = 10000,
                    achievedDate = System.currentTimeMillis(),
                    iconName = "medal_steps_10000"
                ))
            }
        }
    }

    /**
     * Range based queries for charts
     */
    suspend fun getRecordsInRange(start: Long, end: Long) = withContext(Dispatchers.IO) {
        sportRecordDao.getRecordsInRange(start, end)
    }

    suspend fun getTotalStepsInRange(start: Long, end: Long) = withContext(Dispatchers.IO) {
        sportRecordDao.getTotalStepsInRange(start, end) ?: 0
    }

    suspend fun getMaxStepsAllTime() = withContext(Dispatchers.IO) {
        sportRecordDao.getMaxStepsAllTime() ?: 0
    }

    /**
     * Logic to fetch all records, potentially merging or migrating if needed.
     */
    fun getAllRecordsFlow() = sportRecordDao.getAllRecordsFlow()

    fun getAchievementsFlow() = achievementDao.getAllAchievementsFlow()
}
