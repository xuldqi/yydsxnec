package com.dn.sports.ormbean;

import org.greenrobot.greendao.annotation.Entity;
import org.greenrobot.greendao.annotation.Id;
import org.greenrobot.greendao.annotation.Generated;

import java.io.Serializable;

@Entity(nameInDb = "body_record_new")
public class BodyRecord implements Serializable {

    final static long serialVersionUID=-1;

    @Id(autoincrement = true)
    Long id;
    int type;
    Long time;
    String unit;
    String data;

    @Generated(hash = 2135122885)
    public BodyRecord(Long id, int type, Long time, String unit, String data) {
        this.id = id;
        this.type = type;
        this.time = time;
        this.unit = unit;
        this.data = data;
    }
    @Generated(hash = 1461212797)
    public BodyRecord() {
    }
    public Long getId() {
        return this.id;
    }
    public void setId(Long id) {
        this.id = id;
    }
    public int getType() {
        return this.type;
    }
    public void setType(int type) {
        this.type = type;
    }
    public Long getTime() {
        return this.time;
    }
    public void setTime(Long time) {
        this.time = time;
    }
    public String getUnit() {
        return this.unit;
    }
    public void setUnit(String unit) {
        this.unit = unit;
    }
    public String getData() {
        return this.data;
    }
    public void setData(String data) {
        this.data = data;
    }


}
