package com.dn.sports.view;

import android.content.Context;
import android.graphics.Canvas;
import android.view.View;

public class PickRecordDataView extends View {

    private int min = 20;
    private int max = 260;
    private int value = max - min;
    private int w;
    private int h;

    public PickRecordDataView(Context context){
        super(context);
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        this.w = w;
        this.h = h;
    }

    public void updateData(int min,int max){
        this.min = min;
        this.max = max;
        value = max - min;
        invalidate();
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
    }
}
