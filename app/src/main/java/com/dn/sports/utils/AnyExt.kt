package com.dn.sports.utils





fun Any.io(runnable: Runnable){
    ThreadPoolManger.executeIO(runnable)
}


fun Any.main(runnable: Runnable){
    ThreadPoolManger.excuteMain(runnable)
}