package com.dn.sports.database;

import android.content.ContentValues;
import android.database.Cursor;
import android.os.Parcel;
import android.os.Parcelable;

import com.dn.sports.fragment.RecordSubFragment;


//@Entity(tableName = "gift_red_count",primaryKeys = ["userId", "giftId"])


//todo db
public class BodyRecordModel implements Parcelable {

    public int id = 0;

    public int type = 0;

    public long time = 0;

    public String unit = "";

    public String data = "0.0";

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public long getTime() {
        return time;
    }

    public void setTime(long time) {
        this.time = time;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(id);
        dest.writeLong(time);
        dest.writeInt(type);
        dest.writeString(data);
        dest.writeString(unit);
    }

    public static final Creator<BodyRecordModel> CREATOR = new Creator<BodyRecordModel>() {

        @Override
        public BodyRecordModel createFromParcel(Parcel source) {
            BodyRecordModel prisonModel = new BodyRecordModel();
            prisonModel.setId(source.readInt());
            prisonModel.setTime(source.readLong());
            prisonModel.setType(source.readInt());
            prisonModel.setData(source.readString());
            prisonModel.setUnit(source.readString());
            return prisonModel;
        }

        @Override
        public BodyRecordModel[] newArray(int size) {
            return new BodyRecordModel[size];
        }
    };

    @Override
    public String toString() {
        return "id:"+id+",date:"+time+",data:"+data+",type:"+type+"，unit:"+unit;
    }

    /**
     * 从游标构建model数据
     *
     * @param cursor
     * @return
     */
    public BodyRecordModel setModelData(Cursor cursor) {

        if (null == cursor) {
            return null;
        }
        // ID
        int index = -1;
        index = cursor.getColumnIndex(DatabaseHelper.BodayRecordColumns.COLUMN_ID);
        if (index != -1) {
            this.id = cursor.getInt(index);
        }
        // 锁机开始时间戳
        index = cursor.getColumnIndex(DatabaseHelper.BodayRecordColumns.COLUMN_TIME);
        if (index != -1) {
            this.time = cursor.getLong(index);
        }
        index = cursor.getColumnIndex(DatabaseHelper.BodayRecordColumns.COLUMN_DATA);
        if (index != -1) {
            this.data = cursor.getString(index);
        }
        index = cursor.getColumnIndex(DatabaseHelper.BodayRecordColumns.COLUMN_UNIT);
        if (index != -1) {
            this.unit = cursor.getString(index);
        }
        index = cursor.getColumnIndex(DatabaseHelper.BodayRecordColumns.COLUMN_TYPE);
        if (index != -1) {
            this.type = cursor.getInt(index);
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
        contentValues.put(DatabaseHelper.BodayRecordColumns.COLUMN_TIME, this.time);
        contentValues.put(DatabaseHelper.BodayRecordColumns.COLUMN_DATA, this.data);
        contentValues.put(DatabaseHelper.BodayRecordColumns.COLUMN_UNIT, this.unit);
        contentValues.put(DatabaseHelper.BodayRecordColumns.COLUMN_TYPE, this.type);
        return contentValues;
    }

    public static String getUnitByType(int type){
        switch (type) {
            case RecordSubFragment.TYPE_HEIGHT:
                return "厘米";
            case RecordSubFragment.TYPE_WEIGHT:
                return "千克";
            case RecordSubFragment.TYPE_DTW:
                return "厘米";
            case RecordSubFragment.TYPE_SBW:
                return "厘米";
            case RecordSubFragment.TYPE_XW:
                return "厘米";
            case RecordSubFragment.TYPE_YW:
                return "厘米";
            case RecordSubFragment.TYPE_TW:
                return "厘米";
            case RecordSubFragment.TYPE_XTW:
                return "厘米";
        }
        return "";
    }
}
