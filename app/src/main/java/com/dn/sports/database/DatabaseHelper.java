package com.dn.sports.database;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

public class DatabaseHelper extends SQLiteOpenHelper {

    public static final String DB_NAME = "steps.db";
    public static final int DB_VERSION = 2;
    public static final String TABLE_NAME_STEP = "steps_count";
    public static final String TABLE_NAME_TARGET = "target";
    public static final String TABLE_NAME_BODAY_RECORD = "boday_record";

    public DatabaseHelper(Context context){
        super(context,DB_NAME,null,DB_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {

        //todo remove old db

//        createStepCountDatabase(db);
//        createTargetDatabase(db);
//        createBodayRecordDatabase(db);
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
    }

    private void createStepCountDatabase(SQLiteDatabase db){
        StringBuffer textSb = new StringBuffer();
        //创建文本记事表
        textSb.append("CREATE TABLE IF NOT EXISTS ");
        textSb.append(StepCountDbColumns.TB_NAME);
        textSb.append("(");
        textSb.append(StepCountDbColumns.COLUMN_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, ");
        textSb.append(StepCountDbColumns.COLUMN_TIME + " INTEGER DEFAULT 0,");
        textSb.append(StepCountDbColumns.COLUMN_USE_TIME + " INTEGER DEFAULT 0,");
        textSb.append(StepCountDbColumns.COLUMN_STEPS + " INTEGER DEFAULT 0,");
        textSb.append(StepCountDbColumns.COLUMN_TYPE + " INTEGER DEFAULT 0,");
        textSb.append(StepCountDbColumns.COLUMN_SUB_TYPE + " INTEGER DEFAULT 0");
        textSb.append(")");
        db.execSQL(textSb.toString());
    }

    private void createTargetDatabase(SQLiteDatabase db){
        Log.i("PrisonServices","<<<createTargetDatabase SQLiteDatabase>>>");

        StringBuffer textSb = new StringBuffer();
        //创建文本记事表
        textSb.append("CREATE TABLE IF NOT EXISTS ");
        textSb.append(TargetColumns.TB_NAME);
        textSb.append("(");
        textSb.append(TargetColumns.COLUMN_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, ");
        textSb.append(TargetColumns.COLUMN_NAME + " TEXT,");//标题
        textSb.append(TargetColumns.COLUMN_HINT + " TEXT,");//副标题
        textSb.append(TargetColumns.COLUMN_ALL_TIMES + " INTEGER DEFAULT 1,");//限制的完成次数，默认1
        textSb.append(TargetColumns.COLUMN_FINISH_TIMES + " INTEGER DEFAULT 0,");//已完成次数，默认0
        textSb.append(TargetColumns.COLUMN_IS_LOOP + " INTEGER DEFAULT 0,");//是否是无线循环任务
        textSb.append(TargetColumns.COLUMN_ACHIEVE_DATA_LIST + " TEXT,");//完成的循环任务或者多次任务的时间列表
        textSb.append(TargetColumns.COLUMN_CREATE_DATE + " INTEGER DEFAULT 0,");//创建的时间
        textSb.append(TargetColumns.COLUMN_LAST_DATE + " INTEGER DEFAULT 0,");//最后一次完成的时间
        textSb.append(TargetColumns.COLUMN_TARGET_DATE + " INTEGER DEFAULT 0,");//目标日期
        textSb.append(TargetColumns.COLUMN_TARGET_TYPE + " INTEGER DEFAULT 0,");//目标类型，默认0
        textSb.append(TargetColumns.COLUMN_TARGET_SYNC1 + " TEXT,");//备选1
        textSb.append(TargetColumns.COLUMN_TARGET_SYNC2 + " TEXT,");//备选2
        textSb.append(TargetColumns.COLUMN_TARGET_SYNC3 + " TEXT,");//备选3
        textSb.append(TargetColumns.COLUMN_TARGET_SYNC4 + " TEXT");//备选4
        textSb.append(")");
        db.execSQL(textSb.toString());
    }

    private void createBodayRecordDatabase(SQLiteDatabase db){
        Log.i("PrisonServices","<<<createBodayRecordDatabase SQLiteDatabase>>>");

        StringBuffer textSb = new StringBuffer();
        //创建文本记事表
        textSb.append("CREATE TABLE IF NOT EXISTS ");
        textSb.append(BodayRecordColumns.TB_NAME);
        textSb.append("(");
        textSb.append(BodayRecordColumns.COLUMN_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, ");
        textSb.append(BodayRecordColumns.COLUMN_TIME + " INTEGER DEFAULT 0,");
        textSb.append(BodayRecordColumns.COLUMN_TYPE + " INTEGER DEFAULT 0,");
        textSb.append(BodayRecordColumns.COLUMN_DATA + " TEXT,");
        textSb.append(BodayRecordColumns.COLUMN_UNIT + " TEXT");
        textSb.append(")");
        db.execSQL(textSb.toString());
    }

    public interface StepCountDbColumns {
        // table name
        String TB_NAME = DatabaseHelper.TABLE_NAME_STEP;
        // 主键ID
        String COLUMN_ID = "ID";
        String COLUMN_TIME = "start_time";
        String COLUMN_USE_TIME = "use_time";
        String COLUMN_STEPS = "steps_num";
        String COLUMN_TYPE = "type";
        String COLUMN_SUB_TYPE = "sub_type";
    }

    public interface TargetColumns {
        // table name
        String TB_NAME = DatabaseHelper.TABLE_NAME_TARGET;
        // 设置主键ID
        String COLUMN_ID = "ID";
        // 设置主键名称
        String COLUMN_NAME = "target_name";

        String COLUMN_HINT = "target_hint";
        // 设置主键值
        String COLUMN_ALL_TIMES = "target_all_times";

        String COLUMN_FINISH_TIMES = "target_finish_times";

        String COLUMN_IS_LOOP = "is_loop";

        String COLUMN_ACHIEVE_DATA_LIST = "achieve_data_list";

        String COLUMN_CREATE_DATE = "start_time";

        String COLUMN_LAST_DATE = "last_time";

        String COLUMN_TARGET_DATE = "target_time";

        String COLUMN_TARGET_TYPE = "target_type";

        String COLUMN_TARGET_SYNC1 = "target_sync1";

        String COLUMN_TARGET_SYNC2 = "target_sync2";

        String COLUMN_TARGET_SYNC3 = "target_sync3";

        String COLUMN_TARGET_SYNC4 = "target_sync4";
    }

    public interface BodayRecordColumns {
        // table name
        String TB_NAME = DatabaseHelper.TABLE_NAME_BODAY_RECORD;
        // 设置主键ID
        String COLUMN_ID = "ID";

        String COLUMN_TIME = "target_time";

        String COLUMN_TYPE = "target_type";

        String COLUMN_DATA = "data";

        String COLUMN_UNIT = "unit";
    }
}
