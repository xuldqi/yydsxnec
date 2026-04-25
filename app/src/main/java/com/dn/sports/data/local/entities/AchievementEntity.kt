package com.dn.sports.data.local.entities

import androidx.room.Entity
import androidx.room.Ignore
import androidx.room.PrimaryKey
import java.io.Serializable

/**
 * Entity to store user milestones and badges.
 */
@Entity(tableName = "achievements")
data class AchievementEntity(
    @PrimaryKey(autoGenerate = true) var id: Long,
    var name: String,
    var description: String,
    var type: Int,
    var targetValue: Int,
    var achievedDate: Long,
    var iconName: String
) : Serializable {
    @Ignore
    constructor() : this(
        id = 0,
        name = "",
        description = "",
        type = 0,
        targetValue = 0,
        achievedDate = 0,
        iconName = ""
    )
}
