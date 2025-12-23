package com.dn.sports.adcoinLogin;

import android.util.Log;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

public class TaskManager {
    private static TaskManager taskManager;
    private ExecutorService executorService;

    public synchronized static TaskManager getManager() {
        if(taskManager == null){
            taskManager = new TaskManager();
        }
        return taskManager;
    }

    private TaskManager() {
        executorService = Executors.newCachedThreadPool();
    }

    public void executeTask(Runnable runnable){
        if(runnable == null){
            Log.e("TaskService","task error,runnable is null");
            return;
        }
        executorService.execute(runnable);
    }

    public void destroy(){
        try {
            executorService.shutdown();
            if(!executorService.awaitTermination(5*1000, TimeUnit.MILLISECONDS)){
                // 超时的时候向线程池中所有的线程发出中断(interrupted)。
                executorService.shutdownNow();
            }
        } catch (InterruptedException e) {
            // awaitTermination方法被中断的时候也中止线程池中全部的线程的执行。
            System.out.println("awaitTermination interrupted: " + e);
            executorService.shutdownNow();
        }
    }
}
