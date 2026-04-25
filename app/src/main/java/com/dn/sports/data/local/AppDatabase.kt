package com.dn.sports.data.local

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import com.dn.sports.data.local.dao.SportRecordDao
import com.dn.sports.data.local.entities.SportRecordEntity

@Database(entities = [SportRecordEntity::class, com.dn.sports.data.local.entities.AchievementEntity::class], version = 2, exportSchema = false)
abstract class AppDatabase : RoomDatabase() {

    abstract fun sportRecordDao(): SportRecordDao
    abstract fun achievementDao(): com.dn.sports.data.local.dao.AchievementDao

    companion object {
        @Volatile
        private var INSTANCE: AppDatabase? = null

        fun getDatabase(context: Context): AppDatabase {
            return INSTANCE ?: synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    AppDatabase::class.java,
                    "sport_database"
                ).build()
                INSTANCE = instance
                instance
            }
        }
    }
}
