package com.dn.sports.adcoinLogin.model;

import androidx.annotation.NonNull;

import java.util.Date;

/**
 * 任务Model
 */
public class TaskModel {
    public static final int FINISHED = 0; //已完成(未领取奖励)
    public static final int REWARDED = 1; //已完成(已领取)
    public static final int UNFINISH = 2; //未完成

    public static final int CATEGORY_BASE = 0; //自有任务
    public static final int CATEGORY_SHANHU = 1; //珊瑚任务

    public int id; //数据库ID
    public String orderId;//订单号
    public Date createTime; //创建时间
    public int type;//重复类型  0 不重复     1 每日重复
    public int amount; //任务奖励金币数
    public int target; //目标数量
    public String des;//任务描述
    public String taskName;//任务名称
    public String userId;//用户ID
    public int state;//状态   0 已完成(未领取奖励)    1已完成(已领取)   2 未完成
    public int category;//类型 0 自有    1 珊瑚
    public int taskId; //任务ID
    public int finishCount; //已完成次数
    public int limite; //周期内可完成次数
    public int totalAmount;

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public int getFinishCount() {
        return finishCount;
    }

    public void setFinishCount(int finishCount) {
        this.finishCount = finishCount;
    }

    public int getLimite() {
        return limite;
    }

    public void setLimite(int limite) {
        this.limite = limite;
    }

    public TaskModel() {}

    public int getTaskId() {
        return taskId;
    }

    public void setTaskId(int taskId) {
        this.taskId = taskId;
    }

    public int getCategory() {
        return category;
    }

    public void setCategory(int category) {
        this.category = category;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }

    public int getTarget() {
        return target;
    }

    public void setTarget(int target) {
        this.target = target;
    }

    public String getDes() {
        return des;
    }

    public void setDes(String des) {
        this.des = des;
    }

    public String getTaskName() {
        return taskName;
    }

    public void setTaskName(String taskName) {
        this.taskName = taskName;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public int getState() {
        return state;
    }

    public void setState(int state) {
        this.state = state;
    }

    public int getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(int totalAmount) {
        this.totalAmount = totalAmount;
    }


    public void replaceTaskData(TaskModel taskModel){
        if(taskModel == null || taskModel.getTaskId() != taskId)
            return;

        id = taskModel.getId();
        orderId = taskModel.getOrderId();
        createTime = taskModel.getCreateTime();
        type = taskModel.getType();
        amount = taskModel.getAmount();
        target = taskModel.getTarget();
        des = taskModel.getDes();
        taskName = taskModel.getTaskName();
        userId = taskModel.getUserId();
        state = taskModel.getState();
        category = taskModel.getCategory();
        finishCount = taskModel.getFinishCount();
        limite = taskModel.getLimite();
        totalAmount = taskModel.getTotalAmount();
    }

    @NonNull
    @Override
    public String toString() {
        return "taskId:"+taskId+",taskName"+taskName+",limit:"+limite+",finish:"+finishCount+",amount:"+amount+",state:"+state;
    }
}
