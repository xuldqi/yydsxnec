package com.dn.sports.jumprope.bean

import java.io.Serializable

data class JumpData(
    var date: Long,
    var stage: Int,
    var sate: Int,
    var rest: Boolean,
    var finished: Boolean,
) : Serializable