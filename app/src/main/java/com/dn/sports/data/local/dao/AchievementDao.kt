package com.dn.sports.data.local.dao

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import com.dn.sports.data.local.entities.AchievementEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface AchievementDao {
    @Query("SELECT * FROM achievements ORDER BY achievedDate DESC")
    fun getAllAchievementsFlow(): Flow<List<AchievementEntity>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun insertAchievement(achievement: AchievementEntity)

    @Query("SELECT * FROM achievements WHERE type = :achievementType AND targetValue = :target LIMIT 1")
    fun getAchievement(achievementType: Int, target: Int): AchievementEntity?
}
