package com.dn.sports.map;

import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.location.LocationManager;
import android.provider.Settings;

public class MapHelper {

        /**
         * 地球半径，单位：公里/千米
         */
        private static final double EARTH_RADIUS = 6378.137;

        /**
         * 经纬度转化成弧度
         * @param d  经度/纬度
         * @return  经纬度转化成的弧度
         */
        private static double radian(double d) {
            return d * Math.PI / 180.0;
        }

        /**
         * 返回两个地理坐标之间的距离
         * @param firsLongitude 第一个坐标的经度
         * @param firstLatitude 第一个坐标的纬度
         * @param secondLongitude 第二个坐标的经度
         * @param secondLatitude  第二个坐标的纬度
         * @return 两个坐标之间的距离，单位：公里/千米
         */
        public static double distance(double firsLongitude, double firstLatitude,
                                      double secondLongitude, double secondLatitude) {
            double firstRadianLongitude = radian(firsLongitude);
            double firstRadianLatitude = radian(firstLatitude);
            double secondRadianLongitude = radian(secondLongitude);
            double secondRadianLatitude = radian(secondLatitude);

            double a = firstRadianLatitude - secondRadianLatitude;
            double b = firstRadianLongitude - secondRadianLongitude;
            double cal = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a / 2), 2)
                    + Math.cos(firstRadianLatitude) * Math.cos(secondRadianLatitude)
                    * Math.pow(Math.sin(b / 2), 2)));
            cal = cal * EARTH_RADIUS;

            return Math.round(cal * 10000d) / 10000d;
        }

        /**
         * 返回两个地理坐标之间的距离
         * @param firstPoint 第一个坐标 例如："23.100919, 113.279868"
         * @param secondPoint 第二个坐标 例如："23.149286, 113.347584"
         * @return 两个坐标之间的距离，单位：公里/千米
         */
        public static double distance(String firstPoint, String secondPoint){
            String[] firstArray = firstPoint.split(",");
            String[] secondArray = secondPoint.split(",");
            double firstLatitude = Double.valueOf(firstArray[0].trim());
            double firstLongitude = Double.valueOf(firstArray[1].trim());
            double secondLatitude = Double.valueOf(secondArray[0].trim());
            double secondLongitude = Double.valueOf(secondArray[1].trim());
            return distance(firstLatitude, firstLongitude, secondLatitude, secondLongitude);
        }

    public static final boolean isGPSPen(final Context context) {
        LocationManager locationManager
                = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
        // 通过GPS卫星定位，定位级别可以精确到街（通过24颗卫星定位，在室外和空旷的地方定位准确、速度快）
        boolean gps = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);
        if (gps) {
            return true;
        }
        return false;
    }

    public static void openGps(Context context) {
        Intent intent = new Intent();
        intent.setAction(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        try {
            context.startActivity(intent);
        } catch (ActivityNotFoundException ex) {

            // The Android SDK doc says that the location settings activity
            // may not be found. In that case show the general settings.

            // General settings activity
            intent.setAction(Settings.ACTION_SETTINGS);
            try {
                context.startActivity(intent);
            } catch (Exception e) {
                Intent myIntent = new Intent(Settings.ACTION_SECURITY_SETTINGS);
                context.startActivity(myIntent);
            }
        }
    }
}
