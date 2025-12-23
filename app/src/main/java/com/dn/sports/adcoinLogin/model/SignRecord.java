package com.dn.sports.adcoinLogin.model;

import androidx.annotation.NonNull;

import java.util.Date;

public class SignRecord {
    private int id;

    private String userId;

    private Date date;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    @NonNull
    @Override
    public String toString() {
        return date.toString();
    }
}
