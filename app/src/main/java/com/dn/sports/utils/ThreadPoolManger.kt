package com.dn.sports.utils

import android.os.Handler
import java.util.concurrent.LinkedBlockingQueue
import java.util.concurrent.ThreadPoolExecutor
import java.util.concurrent.TimeUnit

object ThreadPoolManger {

    var handler = Handler()
    var executor = ThreadPoolExecutor(
        3,  // 核心线程数量
        10,  // 最大线程数量
        60,  // 空闲线程存活时间
        TimeUnit.SECONDS,  // 存活时间的单位
        LinkedBlockingQueue(),  // 任务队列,
        ThreadPoolExecutor.DiscardOldestPolicy()
    )

    fun executeIO(runnable: Runnable?) {
        executor.execute(runnable)
    }

    fun excuteMain(runnable: Runnable?) {
        if (runnable != null) {
            handler.post(runnable)
        }
    }

}