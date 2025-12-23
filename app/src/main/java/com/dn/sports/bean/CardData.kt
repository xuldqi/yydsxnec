package com.dn.sports.bean

data class CardData(
    var type: Int,
    var icon: Int,
    var name: String,
    var isAdd: Boolean,
    var position: Int,
    var bgIcon: Int,
    var rightIcon: Int,
) : java.io.Serializable