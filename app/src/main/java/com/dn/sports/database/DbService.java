package com.dn.sports.database;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.util.Log;

import java.util.ArrayList;
import java.util.List;

public class DbService {

	private DatabaseHelper databaseHelper;

	public DbService(Context context) {
		databaseHelper = new DatabaseHelper(context);
	}

	/**
	 * 取得可读数据库
	 *
	 */
	private synchronized SQLiteDatabase getReadableDatabase() {
		SQLiteDatabase sdb = databaseHelper.getReadableDatabase();
		return sdb;
	}

	/**
	 * 取得可写数据库
	 *
	 */
	private synchronized SQLiteDatabase getWritableDatabase() {
		SQLiteDatabase sdb = databaseHelper.getReadableDatabase();
		return sdb;
	}


    /**
     * 查询所有数据
     *
     */
    public List<StepsCountModel> findAll() {
        // 实例化数据库的时候，如果数据库满了，使用getWritableDatabase()方法是会出错的。如果只是读取数据可以使用
        SQLiteDatabase sdb = getReadableDatabase();
        if (null == sdb)
            return null;

        List<StepsCountModel> modelList = new ArrayList<StepsCountModel>();
        StringBuffer sb = new StringBuffer();
        sb.append("SELECT * FROM ");
        sb.append(DatabaseHelper.StepCountDbColumns.TB_NAME);
        sb.append(" ORDER BY ");
        sb.append(DatabaseHelper.StepCountDbColumns.COLUMN_TIME);//以日期降序
        sb.append(" ASC");
        // 得到的是游标 它不是把所有找到的内容加载到内存，是用到的时候才加载到内存
        Cursor cursor = sdb.rawQuery(sb.toString(), null);
        while (null != cursor && cursor.moveToNext()) {
            StepsCountModel model = new StepsCountModel().setModelData(cursor);
            Log.i("EyeService","findAll data:"+model.toString());
            modelList.add(model);
        }
        if (null != cursor) {
            // 取得全部的记录数，加载到内存 ，建议采取这样的方法、
            cursor.close();
        }
        return modelList;
    }

	public List<StepsCountModel> findAllByType(int type) {
		// 实例化数据库的时候，如果数据库满了，使用getWritableDatabase()方法是会出错的。如果只是读取数据可以使用
		SQLiteDatabase sdb = getReadableDatabase();
		if (null == sdb)
			return null;

		List<StepsCountModel> modelList = new ArrayList<StepsCountModel>();
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT * FROM ");
		sb.append(DatabaseHelper.StepCountDbColumns.TB_NAME);
		sb.append(" WHERE ");
		sb.append(DatabaseHelper.StepCountDbColumns.COLUMN_TYPE + " = " + type);
		sb.append(" ORDER BY ");
		sb.append(DatabaseHelper.StepCountDbColumns.COLUMN_TIME);//以日期降序
		sb.append(" ASC");
		// 得到的是游标 它不是把所有找到的内容加载到内存，是用到的时候才加载到内存
		Cursor cursor = sdb.rawQuery(sb.toString(), null);
		while (null != cursor && cursor.moveToNext()) {
			StepsCountModel model = new StepsCountModel().setModelData(cursor);
			Log.i("EyeService","findAll data:"+model.toString());
			modelList.add(model);
		}
		if (null != cursor) {
			// 取得全部的记录数，加载到内存 ，建议采取这样的方法、
			cursor.close();
		}
		return modelList;
	}

	public List<BodyRecordModel> findAllBodyRecordByType(int type) {
		// 实例化数据库的时候，如果数据库满了，使用getWritableDatabase()方法是会出错的。如果只是读取数据可以使用
		SQLiteDatabase sdb = getReadableDatabase();
		if (null == sdb)
			return null;

		List<BodyRecordModel> modelList = new ArrayList<BodyRecordModel>();
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT * FROM ");
		sb.append(DatabaseHelper.BodayRecordColumns.TB_NAME);
		sb.append(" WHERE ");
		sb.append(DatabaseHelper.BodayRecordColumns.COLUMN_TYPE + " = " + type);
		sb.append(" ORDER BY ");
		sb.append(DatabaseHelper.BodayRecordColumns.COLUMN_TIME);//以日期降序
		sb.append(" ASC");
		// 得到的是游标 它不是把所有找到的内容加载到内存，是用到的时候才加载到内存
		Cursor cursor = sdb.rawQuery(sb.toString(), null);
		while (null != cursor && cursor.moveToNext()) {
			BodyRecordModel model = new BodyRecordModel().setModelData(cursor);
			Log.i("EyeService","findAll data:"+model.toString());
			modelList.add(model);
		}
		if (null != cursor) {
			// 取得全部的记录数，加载到内存 ，建议采取这样的方法、
			cursor.close();
		}
		return modelList;
	}

	public long deleteBodyRecordById(Integer id) {
		SQLiteDatabase sdb = getWritableDatabase();
		if (null == sdb)
			return 0;
		long count = sdb.delete(DatabaseHelper.BodayRecordColumns.TB_NAME, DatabaseHelper.BodayRecordColumns.COLUMN_ID + " = " + id, null);
		sdb.close();
		return count;
	}

	public List<CustomTargetModel> findAllCustomTarget() {
		// 实例化数据库的时候，如果数据库满了，使用getWritableDatabase()方法是会出错的。如果只是读取数据可以使用
		SQLiteDatabase sdb = getReadableDatabase();
		if (null == sdb)
			return null;

		List<CustomTargetModel> modelList = new ArrayList<CustomTargetModel>();
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT * FROM ");
		sb.append(DatabaseHelper.TargetColumns.TB_NAME);
		sb.append(" ORDER BY ");
		sb.append(DatabaseHelper.TargetColumns.COLUMN_LAST_DATE);//以日期降序
		sb.append(" ASC");
		// 得到的是游标 它不是把所有找到的内容加载到内存，是用到的时候才加载到内存
		Cursor cursor = sdb.rawQuery(sb.toString(), null);
		while (null != cursor && cursor.moveToNext()) {
			CustomTargetModel model = new CustomTargetModel().setModelData(cursor);
			Log.i("EyeService","findAllCustomTarget data:"+model.toString());
			modelList.add(model);
		}
		if (null != cursor) {
			// 取得全部的记录数，加载到内存 ，建议采取这样的方法、
			cursor.close();
		}
		return modelList;
	}

	public BodyRecordModel findLastBodyModel(int type) {
		// 实例化数据库的时候，如果数据库满了，使用getWritableDatabase()方法是会出错的。如果只是读取数据可以使用
		SQLiteDatabase sdb = getReadableDatabase();
		if (null == sdb)
			return null;

		List<CustomTargetModel> modelList = new ArrayList<CustomTargetModel>();
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT * FROM ");
		sb.append(DatabaseHelper.BodayRecordColumns.TB_NAME);
		sb.append(" WHERE ");
		sb.append(DatabaseHelper.BodayRecordColumns.COLUMN_TYPE + " = " + type);
		sb.append(" ORDER BY ");
		sb.append(DatabaseHelper.BodayRecordColumns.COLUMN_TIME);//以日期降序
		sb.append(" DESC");
		// 得到的是游标 它不是把所有找到的内容加载到内存，是用到的时候才加载到内存
		Cursor cursor = sdb.rawQuery(sb.toString(), null);
		while (null != cursor && cursor.moveToNext()) {
			BodyRecordModel model = new BodyRecordModel().setModelData(cursor);
			Log.i("EyeService","findLastBodyModel data:"+model.toString());
			return model;
		}
		if (null != cursor) {
			// 取得全部的记录数，加载到内存 ，建议采取这样的方法、
			cursor.close();
		}
		return null;
	}

    public int findDataNum() {
        // 实例化数据库的时候，如果数据库满了，使用getWritableDatabase()方法是会出错的。如果只是读取数据可以使用
        SQLiteDatabase sdb = getReadableDatabase();
        if (null == sdb)
            return 0;

        int num = 0;
        StringBuffer sb = new StringBuffer();
        sb.append("SELECT * FROM ");
        sb.append(DatabaseHelper.StepCountDbColumns.TB_NAME);
        Cursor cursor = sdb.rawQuery(sb.toString(), null);
        while (null != cursor && cursor.moveToNext()) {
            StepsCountModel model = new StepsCountModel().setModelData(cursor);
            num++;
        }
        if (null != cursor) {
            // 取得全部的记录数，加载到内存 ，建议采取这样的方法、
            cursor.close();
        }
        return num;
    }

	/**
	 * 插入数据
	 */
	public long insert(ContentValues contentValues) {
		SQLiteDatabase sdb = getWritableDatabase();
		if (null == sdb)
			return 0;
		long count = sdb.insert(DatabaseHelper.StepCountDbColumns.TB_NAME, null, contentValues);
		Log.i("----DB----","insert data:"+count);
		sdb.close();
		return count;
	}

	/**
	 * 插入数据
	 */
	public long insertBodyRecord(ContentValues contentValues) {
		SQLiteDatabase sdb = getWritableDatabase();
		if (null == sdb)
			return 0;
		long count = sdb.insert(DatabaseHelper.BodayRecordColumns.TB_NAME, null, contentValues);
		Log.i("----DB----","insertBodyRecord data:"+count);
		sdb.close();
		return count;
	}

	/**
	 * 根据ID更新数据
	 */
	public long updateBodyRecordById(ContentValues contentValues, Integer id) {
		if (null == contentValues) {
			return 0;
		}
		if(null == id){
			return 0;
		}
		SQLiteDatabase sdb = getWritableDatabase();
		Log.i("DbService","updateById："+id);
		if (null == sdb)
			return 0;
		long count = 0;
		try {
			count = sdb.update(DatabaseHelper.BodayRecordColumns.TB_NAME,
					contentValues, DatabaseHelper.BodayRecordColumns.COLUMN_ID + "=?",
					new String[] { String.valueOf(id) });
		} catch (Exception e) {
			e.printStackTrace();
		}
		sdb.close();
		return count;
	}

	/**
	 * 根据ID更新数据
	 */
	public long updateById(ContentValues contentValues, Integer id) {
		if (null == contentValues) {
			return 0;
		}
        if(null == id){
            return 0;
        }
        SQLiteDatabase sdb = getWritableDatabase();
        Log.i("DbService","updateById："+id);
		if (null == sdb)
			return 0;
		long count = 0;
		try {
			count = sdb.update(DatabaseHelper.StepCountDbColumns.TB_NAME,
                    contentValues, DatabaseHelper.StepCountDbColumns.COLUMN_ID + "=?",
					new String[] { String.valueOf(id) });
		} catch (Exception e) {
			e.printStackTrace();
		}
		sdb.close();
		return count;
	}

    public StepsCountModel getPrisonDataByDate(String date){
        SQLiteDatabase sdb = getReadableDatabase();
        if (null == sdb)
            return null;

        StringBuffer sb = new StringBuffer();
        sb.append("SELECT * FROM ");
        sb.append(DatabaseHelper.StepCountDbColumns.TB_NAME);
        sb.append(" WHERE ");
        sb.append(DatabaseHelper.StepCountDbColumns.COLUMN_TIME);
        sb.append(" = ? ");

        Cursor cursor = sdb.rawQuery(sb.toString(),new String[]{String.valueOf(date)});
        while (null != cursor && cursor.moveToNext()) {
            StepsCountModel model = new StepsCountModel().setModelData(cursor);
            Log.i("getEyeByDate","date:"+model.toString());
            return model;
        }
        if (null != cursor) {
            // 取得全部的记录数，加载到内存 ，建议采取这样的方法、
            cursor.close();
        }
        return null;
    }

	/**
	 * 根据id删除数据
	 *
	 */
	public long deleteById(Integer id) {
		SQLiteDatabase sdb = getWritableDatabase();
		if (null == sdb)
			return 0;
		long count = sdb.delete(DatabaseHelper.StepCountDbColumns.TB_NAME, DatabaseHelper.StepCountDbColumns.COLUMN_ID + " = " + id, null);
		sdb.close();
		return count;
	}

	/**
	 * 清空表中数据
	 *
	 */
	public long deleteAll() {
		SQLiteDatabase sdb = getWritableDatabase();
		if (null == sdb)
			return 0;
		long count = sdb.delete(DatabaseHelper.StepCountDbColumns.TB_NAME, null, null);
		sdb.close();
		return count;
	}

	/**
	 * 根据id查询
	 *
	 */
	public StepsCountModel findById(Integer id) {
		// 实例化数据库的时候，如果数据库满了，使用getWritableDatabase()方法是会出错的。如果只是读取数据可以使用
		SQLiteDatabase sdb = getReadableDatabase();
		if (null == sdb)
			return null;
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT *");
		sb.append(" FROM ");
		sb.append(DatabaseHelper.StepCountDbColumns.TB_NAME);
		sb.append(" WHERE ");
		sb.append(DatabaseHelper.StepCountDbColumns.COLUMN_ID + " = " + id);
		// 得到的是游标 它不是把所有找到的内容加载到内存，是用到的时候才加载到内存
		Cursor cursor = sdb.rawQuery(sb.toString(), null);
        StepsCountModel model = null;
		if (null != cursor && cursor.moveToFirst()) {
			model = new StepsCountModel().setModelData(cursor);
		}
		if (null != cursor) {
			// 取得全部的记录数，加载到内存 ，建议采取这样的方法、
			cursor.close();
		}
		// 数据库关闭之后游标是取不到内容的
		sdb.close();
		return model;
	}
}
