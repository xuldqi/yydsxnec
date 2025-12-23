package com.dn.sports.utils;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;

public class DateTest {

    public static List<WeekDay> getWeekDay() {
        Calendar calendar = Calendar.getInstance();
        // 获取本周的第一天
        int firstDayOfWeek = calendar.getFirstDayOfWeek();
        List<WeekDay> list = new ArrayList<>();
        for (int i = 0; i < 7; i++) {
            calendar.set(Calendar.DAY_OF_WEEK, firstDayOfWeek + i);
            WeekDay weekDay = new WeekDay();
            // 获取星期的显示名称，例如：周一、星期一、Monday等等
            weekDay.week = calendar.getDisplayName(Calendar.DAY_OF_WEEK, Calendar.SHORT, Locale.CHINA);
            weekDay.day = new SimpleDateFormat("MM-dd").format(calendar.getTime());

            list.add(weekDay);
        }

        return list;
    }

    public static class WeekDay {
        /** 星期的显示名称*/
        public String week;
        /** 对应的日期*/
        public String day;

        @Override
        public String toString() {
            return "WeekDay{" +
                    "week='" + week + '\'' +
                    ", day='" + day + '\'' +
                    '}';
        }
    }
}
