package com.dn.sports.view;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.util.AttributeSet;
import android.view.View;

import com.dn.sports.R;
import com.dn.sports.common.EyeLog;
import com.dn.sports.utils.DateUtils;

import java.util.ArrayList;
import java.util.List;

public class SunLineChartView extends View {

    private int height = 0;
    private int width = 0;
    private Paint linePaint;
    private Paint textPaint;
    private Paint pathPaint;
    private int itemNum = 30;
    private float itemW;
    private float itemW2;
    private float itemH;
    private List<Integer> datas;
    private List<String> dates;
    private int min;
    private int max;
   // private Path path=new Path();
    private int dataMax;

    public SunLineChartView(Context context) {
        this(context, null);
    }

    public SunLineChartView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context);
        //path.setFillType(Path.FillType.EVEN_ODD);
    }

    private void init(Context context) {
        linePaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        linePaint.setColor(context.getResources().getColor(R.color.app_common_color));
        linePaint.setStrokeWidth(2);
        linePaint.setStyle(Paint.Style.FILL);
        linePaint.setAntiAlias(true);

        textPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        textPaint.setTextAlign(Paint.Align.CENTER);
        textPaint.setColor(Color.GRAY);
        textPaint.setTextSize(26);

        pathPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        pathPaint.setStrokeWidth(2);
        pathPaint.setStyle(Paint.Style.FILL);
        pathPaint.setAntiAlias(true);
        pathPaint.setColor(context.getResources().getColor(R.color.app_common_color));

        dates = new ArrayList<>();
        for(int m = 0;m<30;m++){
            dates.add(DateUtils.getMD(m-29));
        }
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        height = h;
        width = w -30;

        itemW = (float)width/(float)itemNum;
        itemW2 = itemW/2;
        EyeLog.logi("height:"+height+",width:"+width);
        EyeLog.logi("itemW:"+itemW+",itemW2:"+itemW2);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        if(datas == null)
            return;
        if(max == 0 && min == 0) {
            for(int i = 0;i<datas.size();i++){
                if((i+1)%5 == 0) {
                    canvas.drawText(dates.get(i), itemW * i + itemW2, height-20, textPaint);
                }
            }
            canvas.drawLine(itemW2,height-50,width,height-50,textPaint);
            return;
        }
        textPaint.setTextSize(24);
        for(int i = 0;i<datas.size();i++){
            if((i+1)%5 == 0) {
                canvas.drawText(dates.get(i), itemW * i + itemW2, max*itemH + 30, textPaint);
            }
            if(i > datas.size()-2){
                break;
            }
            //path.reset();
            canvas.drawLine(itemW*i+itemW2,(max -datas.get(i))*itemH,itemW*(i+1)+itemW2,(max - datas.get(i+1))*itemH,linePaint);
//            path.moveTo(itemW*i+itemW2,max*itemH);
//            path.lineTo(itemW*(i+1)+itemW2,max*itemH);
//            path.lineTo(itemW*(i+1)+itemW2,(max - datas.get(i+1))*itemH);
//            path.lineTo(itemW*i+itemW2,(max - datas.get(i))*itemH);
//            path.close();
//            canvas.drawPath(path, pathPaint);

            if(datas.get(i) != 0) {
                canvas.drawCircle(itemW * i + itemW2, (max - datas.get(i)) * itemH, 5, pathPaint);
            }
            if(datas.get(i+1) != 0) {
                canvas.drawCircle(itemW * (i + 1) + itemW2, (max - datas.get(i + 1)) * itemH, 5, pathPaint);
            }
        }
        canvas.drawLine(itemW2,(max-dataMax)*itemH,width - itemW2,(max-dataMax)*itemH,textPaint);
        canvas.drawText(dataMax+"步",itemW2*3,(max-dataMax)*itemH-5,textPaint);
        canvas.drawLine(itemW2,max*itemH,width,max*itemH,textPaint);
        //textPaint.setTextSize(50);
        //canvas.drawText("最近30天的步数记录",width/2,100,textPaint);
    }

    public void setData(List<Integer> datas,int max,int min){
        int m = max;
        this.min = min;
        this.max = max;
        this.datas = datas;
        if(max == 0 && min == 0){
            invalidate();
            return;
        }
        itemH = ((float)height-100)/(float)m;
        EyeLog.logi("itemH:"+itemH+",min:"+min+",max:"+max);

        for(int i = 0;i<datas.size();i++) {
            if(dataMax < datas.get(i)){
                dataMax = datas.get(i);
            }
        }

        int a = dataMax%100;
        dataMax = dataMax + 100 - a;
        invalidate();
    }
}
