package com.dn.sports.data.local.entities

import androidx.room.Entity
import androidx.room.Ignore
import androidx.room.PrimaryKey
import java.io.Serializable

@Entity(tableName = "sport_records")
data class SportRecordEntity(
    @PrimaryKey(autoGenerate = true) var id: Long,
    var startTime: Long,
    var useTime: Long,
    var steps: Int,
    var currentTime: Long,
    var date: String,
    var type: Int,
    var subType: Int
) : Serializable {
    @Ignore
    constructor() : this(
        id = 0,
        startTime = 0,
        useTime = 0,
        steps = 0,
        currentTime = System.currentTimeMillis(),
        date = "",
        type = 0,
        subType = 0
    )
}
