package com.dn.sports.data.local.dao

import androidx.room.*
import com.dn.sports.data.local.entities.SportRecordEntity
import kotlinx.coroutines.flow.Flow

@Dao
interface SportRecordDao {

    @Query("SELECT * FROM sport_records ORDER BY currentTime DESC")
    fun getAllRecordsFlow(): Flow<List<SportRecordEntity>>

    @Query("SELECT * FROM sport_records WHERE date = :date")
    fun getRecordsByDate(date: String): List<SportRecordEntity>

    @Query("SELECT * FROM sport_records WHERE date = :recordDate AND type = :recordType LIMIT 1")
    fun getRecordByDateAndType(recordDate: String, recordType: Int): SportRecordEntity?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun insertRecord(record: SportRecordEntity)

    @Delete
    fun deleteRecord(record: SportRecordEntity)

    @Query("SELECT * FROM sport_records WHERE currentTime BETWEEN :startTime AND :endTime ORDER BY currentTime ASC")
    fun getRecordsInRange(startTime: Long, endTime: Long): List<SportRecordEntity>

    @Query("SELECT SUM(steps) FROM sport_records WHERE currentTime BETWEEN :startTime AND :endTime AND type = 6")
    fun getTotalStepsInRange(startTime: Long, endTime: Long): Int?

    @Query("SELECT MAX(steps) FROM sport_records WHERE type = 6")
    fun getMaxStepsAllTime(): Int?

    @Query("SELECT * FROM sport_records WHERE type = 7 ORDER BY currentTime DESC LIMIT 1")
    fun getLatestJumpRopeRecord(): SportRecordEntity?

    @Query("DELETE FROM sport_records")
    fun deleteAll()
}
