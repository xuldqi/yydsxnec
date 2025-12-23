package com.dn.sports.database;

import android.content.ContentValues;
import android.database.Cursor;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.Log;

import java.util.ArrayList;
import java.util.List;

//todo db
public class StepsCountModel implements Parcelable {
    public int id = 0;
    public long startTime = 0;
    public long useTime = 0;
    public int steps = 0;

    /**
     *     public static final int TYPE_RUN_OUTDOOR = 1;
     *     public static final int TYPE_RUN_INDOOR = 2;
     *     public static final int TYPE_FAST_WALK = 3;
     *     public static final int TYPE_ON_FOOT = 4;
     *     public static final int TYPE_MOUNTAIN_CLIMBING = 5;
     */
    public int type = 0;
    public int subType = 0;

    public int getId() {
        return id;
    }

    public void setId(int id) {
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

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(id);
        dest.writeLong(startTime);
        dest.writeLong(useTime);
        dest.writeInt(steps);
        dest.writeInt(type);
        dest.writeInt(subType);
    }

    public static final Creator<StepsCountModel> CREATOR = new Creator<StepsCountModel>() {

        @Override
        public StepsCountModel createFromParcel(Parcel source) {
            StepsCountModel prisonModel = new StepsCountModel();
            prisonModel.setId(source.readInt());
            prisonModel.setStartTime(source.readLong());
            prisonModel.setUseTime(source.readLong());
            prisonModel.setSteps(source.readInt());
            prisonModel.setType(source.readInt());
            prisonModel.setSubType(source.readInt());
            return prisonModel;
        }

        @Override
        public StepsCountModel[] newArray(int size) {
            return new StepsCountModel[size];
        }
    };

    @Override
    public String toString() {
        return "id:"+id+",date:"+startTime+",steps:"+steps+",type:"+type;
    }

    /**
     * 从游标构建model数据
     *
     * @param cursor
     * @return
     */
    public StepsCountModel setModelData(Cursor cursor) {

        if (null == cursor) {
            return null;
        }
        // ID
        int index = -1;
        index = cursor.getColumnIndex(DatabaseHelper.StepCountDbColumns.COLUMN_ID);
        if (index != -1) {
            this.id = cursor.getInt(index);
        }
        // 锁机开始时间戳
        index = cursor.getColumnIndex(DatabaseHelper.StepCountDbColumns.COLUMN_TIME);
        if (index != -1) {
            this.startTime = cursor.getLong(index);
        }
        // 锁机日期
        index = cursor.getColumnIndex(DatabaseHelper.StepCountDbColumns.COLUMN_USE_TIME);
        if (index != -1) {
            this.useTime = cursor.getLong(index);
        }
        // 锁机结束时间戳
        index = cursor.getColumnIndex(DatabaseHelper.StepCountDbColumns.COLUMN_STEPS);
        if (index != -1) {
            this.steps = cursor.getInt(index);
        }
        // 锁机时长
        index = cursor.getColumnIndex(DatabaseHelper.StepCountDbColumns.COLUMN_TYPE);
        if (index != -1) {
            this.type = cursor.getInt(index);
        }
        // 锁机是否打断
        index = cursor.getColumnIndex(DatabaseHelper.StepCountDbColumns.COLUMN_SUB_TYPE);
        if (index != -1) {
            this.subType = cursor.getInt(index);
        }
        return this;
    }

    /**
     * 通过model构建ContentValues数据
     *
     * @return
     */
    public ContentValues getDbData() {

        ContentValues contentValues = new ContentValues();
        contentValues.put(DatabaseHelper.StepCountDbColumns.COLUMN_TIME, this.startTime);
        contentValues.put(DatabaseHelper.StepCountDbColumns.COLUMN_USE_TIME, this.useTime);
        contentValues.put(DatabaseHelper.StepCountDbColumns.COLUMN_STEPS, this.steps);
        contentValues.put(DatabaseHelper.StepCountDbColumns.COLUMN_TYPE, this.type);
        contentValues.put(DatabaseHelper.StepCountDbColumns.COLUMN_SUB_TYPE, this.subType);
        return contentValues;
    }
}
