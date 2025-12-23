package com.dn.sports.database;

import android.content.ContentValues;
import android.database.Cursor;
import android.os.Parcel;
import android.os.Parcelable;


//todo db
public class CustomTargetModel implements Parcelable {

    private int id;

    private String title;

    private String hint;

    private int allTimes = 1;

    private int finishTime = 0;

    private int isLoop = 0;

    private String achieveDateList;

    private long createDate;

    private long lastDate;

    private long targetDate;

    private int targetType;

    private String sync1;

    private String sync2;

    private String sync3;

    private String sync4;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getHint() {
        return hint;
    }

    public void setHint(String hint) {
        this.hint = hint;
    }

    public int getAllTimes() {
        return allTimes;
    }

    public void setAllTimes(int allTimes) {
        this.allTimes = allTimes;
    }

    public int getFinishTime() {
        return finishTime;
    }

    public void setFinishTime(int finishTime) {
        this.finishTime = finishTime;
    }

    public int getIsLoop() {
        return isLoop;
    }

    public void setIsLoop(int isLoop) {
        this.isLoop = isLoop;
    }

    public String getAchieveDateList() {
        return achieveDateList;
    }

    public void setAchieveDateList(String achieveDateList) {
        this.achieveDateList = achieveDateList;
    }

    public long getCreateDate() {
        return createDate;
    }

    public void setCreateDate(long createDate) {
        this.createDate = createDate;
    }

    public long getLastDate() {
        return lastDate;
    }

    public void setLastDate(long lastDate) {
        this.lastDate = lastDate;
    }

    public long getTargetDate() {
        return targetDate;
    }

    public void setTargetDate(long targetDate) {
        this.targetDate = targetDate;
    }

    public int getTargetType() {
        return targetType;
    }

    public void setTargetType(int targetType) {
        this.targetType = targetType;
    }

    public String getSync1() {
        return sync1;
    }

    public void setSync1(String sync1) {
        this.sync1 = sync1;
    }

    public String getSync2() {
        return sync2;
    }

    public void setSync2(String sync2) {
        this.sync2 = sync2;
    }

    public String getSync3() {
        return sync3;
    }

    public void setSync3(String sync3) {
        this.sync3 = sync3;
    }

    public String getSync4() {
        return sync4;
    }

    public void setSync4(String sync4) {
        this.sync4 = sync4;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(id);
        dest.writeString(title);
        dest.writeString(hint);
        dest.writeInt(allTimes);
        dest.writeInt(finishTime);
        dest.writeInt(isLoop);
        dest.writeString(achieveDateList);
        dest.writeLong(createDate);
        dest.writeLong(lastDate);
        dest.writeLong(targetDate);
        dest.writeInt(targetType);
        dest.writeString(sync1);
        dest.writeString(sync2);
        dest.writeString(sync3);
        dest.writeString(sync4);
    }

    public static final Creator<CustomTargetModel> CREATOR = new Creator<CustomTargetModel>() {

        @Override
        public CustomTargetModel createFromParcel(Parcel source) {
            CustomTargetModel prisonModel = new CustomTargetModel();
            prisonModel.setId(source.readInt());
            prisonModel.setTitle(source.readString());
            prisonModel.setHint(source.readString());
            prisonModel.setAllTimes(source.readInt());
            prisonModel.setFinishTime(source.readInt());
            prisonModel.setIsLoop(source.readInt());
            prisonModel.setAchieveDateList(source.readString());
            prisonModel.setCreateDate(source.readLong());
            prisonModel.setLastDate(source.readLong());
            prisonModel.setTargetDate(source.readLong());
            prisonModel.setTargetType(source.readInt());
            prisonModel.setSync1(source.readString());
            prisonModel.setSync2(source.readString());
            prisonModel.setSync3(source.readString());
            prisonModel.setSync4(source.readString());
            return prisonModel;
        }

        @Override
        public CustomTargetModel[] newArray(int size) {
            return new CustomTargetModel[size];
        }
    };

    /**
     * 从游标构建model数据
     *
     * @param cursor
     * @return
     */
    public CustomTargetModel setModelData(Cursor cursor) {

        if (null == cursor) {
            return null;
        }
        // ID
        int index = -1;
        index = cursor.getColumnIndex(DatabaseHelper.TargetColumns.COLUMN_ID);
        if (index != -1) {
            this.id = cursor.getInt(index);
        }
        // 锁机开始时间戳
        index = cursor.getColumnIndex(DatabaseHelper.TargetColumns.COLUMN_NAME);
        if (index != -1) {
            this.title = cursor.getString(index);
        }
        index = cursor.getColumnIndex(DatabaseHelper.TargetColumns.COLUMN_HINT);
        if (index != -1) {
            this.hint = cursor.getString(index);
        }
        index = cursor.getColumnIndex(DatabaseHelper.TargetColumns.COLUMN_ALL_TIMES);
        if (index != -1) {
            this.allTimes = cursor.getInt(index);
        }
        index = cursor.getColumnIndex(DatabaseHelper.TargetColumns.COLUMN_FINISH_TIMES);
        if (index != -1) {
            this.finishTime = cursor.getInt(index);
        }

        index = cursor.getColumnIndex(DatabaseHelper.TargetColumns.COLUMN_IS_LOOP);
        if (index != -1) {
            this.isLoop = cursor.getInt(index);
        }
        index = cursor.getColumnIndex(DatabaseHelper.TargetColumns.COLUMN_ACHIEVE_DATA_LIST);
        if (index != -1) {
            this.achieveDateList = cursor.getString(index);
        }
        index = cursor.getColumnIndex(DatabaseHelper.TargetColumns.COLUMN_CREATE_DATE);
        if (index != -1) {
            this.createDate = cursor.getLong(index);
        }
        index = cursor.getColumnIndex(DatabaseHelper.TargetColumns.COLUMN_LAST_DATE);
        if (index != -1) {
            this.lastDate = cursor.getLong(index);
        }
        index = cursor.getColumnIndex(DatabaseHelper.TargetColumns.COLUMN_TARGET_DATE);
        if (index != -1) {
            this.targetDate = cursor.getLong(index);
        }
        index = cursor.getColumnIndex(DatabaseHelper.TargetColumns.COLUMN_TARGET_TYPE);
        if (index != -1) {
            this.targetType = cursor.getInt(index);
        }
        index = cursor.getColumnIndex(DatabaseHelper.TargetColumns.COLUMN_TARGET_SYNC1);
        if (index != -1) {
            this.sync1 = cursor.getString(index);
        }
        index = cursor.getColumnIndex(DatabaseHelper.TargetColumns.COLUMN_TARGET_SYNC2);
        if (index != -1) {
            this.sync2 = cursor.getString(index);
        }
        index = cursor.getColumnIndex(DatabaseHelper.TargetColumns.COLUMN_TARGET_SYNC3);
        if (index != -1) {
            this.sync3 = cursor.getString(index);
        }
        index = cursor.getColumnIndex(DatabaseHelper.TargetColumns.COLUMN_TARGET_SYNC4);
        if (index != -1) {
            this.sync4 = cursor.getString(index);
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
//        contentValues.put(DatabaseHelper.EyeDbColumns.COLUMN_ID, this.id);
        contentValues.put(DatabaseHelper.TargetColumns.COLUMN_NAME, this.title);
        contentValues.put(DatabaseHelper.TargetColumns.COLUMN_HINT, this.hint);
        contentValues.put(DatabaseHelper.TargetColumns.COLUMN_ALL_TIMES, this.allTimes);
        contentValues.put(DatabaseHelper.TargetColumns.COLUMN_FINISH_TIMES, this.finishTime);
        contentValues.put(DatabaseHelper.TargetColumns.COLUMN_IS_LOOP, this.isLoop);
        contentValues.put(DatabaseHelper.TargetColumns.COLUMN_ACHIEVE_DATA_LIST, this.achieveDateList);
        contentValues.put(DatabaseHelper.TargetColumns.COLUMN_CREATE_DATE, this.createDate);
        contentValues.put(DatabaseHelper.TargetColumns.COLUMN_LAST_DATE, this.lastDate);
        contentValues.put(DatabaseHelper.TargetColumns.COLUMN_TARGET_DATE, this.targetDate);
        contentValues.put(DatabaseHelper.TargetColumns.COLUMN_TARGET_TYPE, this.targetType);
        contentValues.put(DatabaseHelper.TargetColumns.COLUMN_TARGET_SYNC1, this.sync1);
        contentValues.put(DatabaseHelper.TargetColumns.COLUMN_TARGET_SYNC2, this.sync2);
        contentValues.put(DatabaseHelper.TargetColumns.COLUMN_TARGET_SYNC3, this.sync3);
        contentValues.put(DatabaseHelper.TargetColumns.COLUMN_TARGET_SYNC4, this.sync4);
        return contentValues;
    }
}
