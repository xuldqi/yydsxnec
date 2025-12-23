package com.dn.sports.ormbean;

import org.greenrobot.greendao.annotation.Entity;
import org.greenrobot.greendao.annotation.Id;

import java.io.Serializable;

import org.greenrobot.greendao.annotation.Generated;
import org.greenrobot.greendao.annotation.Property;

@Entity(nameInDb = "step_record_new")

public class StepCountRecord implements Serializable {

    final static long serialVersionUID = -1;

    @Id(autoincrement = true)
    public Long id = 0L;

    @Property
    public long startTime = 0;

    @Property
    public long useTime = 0;

    @Property
    public int steps = 0;

    @Property
    public long currentTime = 0;

    @Property
    public String date = "";


    // public static final int TYPE_RUN_OUTDOOR = 1;
//     *     public static final int TYPE_RUN_INDOOR = 2;
//     *     public static final int TYPE_FAST_WALK = 3;
//     *     public static final int TYPE_ON_FOOT = 4;
//     *     public static final int TYPE_MOUNTAIN_CLIMBING = 5;
//     *
//     *     走路步数------ 6
    @Property
    public int type = 0;
    @Property
    public int subType = 0;

    @Generated(hash = 380955958)
    public StepCountRecord(Long id, long startTime, long useTime, int steps,
                           long currentTime, String date, int type, int subType) {
        this.id = id;
        this.startTime = startTime;
        this.useTime = useTime;
        this.steps = steps;
        this.currentTime = currentTime;
        this.date = date;
        this.type = type;
        this.subType = subType;
    }

    @Generated(hash = 816808471)
    public StepCountRecord() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public long getStartTime() {
        return startTime;
    }

    public void setStartTime(long startTime) {
        this.startTime = startTime;
    }

    public long getUseTime() {
        return useTime;
    }

    public void setUseTime(long useTime) {
        this.useTime = useTime;
    }

    public int getSteps() {
        return steps;
    }

    public void setSteps(int steps) {
        this.steps = steps;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public int getSubType() {
        return subType;
    }

    public void setSubType(int subType) {
        this.subType = subType;
    }

    public long getCurrentTime() {
        return this.currentTime;
    }

    public void setCurrentTime(long currentTime) {
        this.currentTime = currentTime;
    }

    public String getDate() {
        return this.date;
    }

    public void setDate(String date) {
        this.date = date;
    }
}
