package com.dn.sports.view;

import android.content.Context;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.HorizontalScrollView;

public class OverHorizontalScrollView extends HorizontalScrollView implements View.OnTouchListener{

    private View inner;
    private Rect mRect = new Rect();
    private int x;
    private boolean isFirst = true;

    public OverHorizontalScrollView(Context context, AttributeSet attributes){
        super(context,attributes);
        init(context);
    }

    private void init(Context context){
        this.setOnTouchListener(this);
        setOverScrollMode(OVER_SCROLL_NEVER);
    }

    @Override
    protected void onFinishInflate() {
        if (getChildCount() > 0) {
            inner = getChildAt(0);
        }
        super.onFinishInflate();
    }

    @Override
    protected void onScrollChanged(int l, int t, int oldl, int oldt) {
        super.onScrollChanged(l, t, oldl, oldt);
    }

    @Override
    public boolean onTouch(View v, MotionEvent event) {
        int cx = (int) event.getX();
        switch (event.getAction()){
            case MotionEvent.ACTION_MOVE:
                int  maxScrollX = inner.getMeasuredWidth()-getMeasuredWidth();
                if(maxScrollX>0){
                    if (getScrollX() == 0 ) {
                        if (mRect.isEmpty()) {
                            mRect.set(inner.getLeft(), inner.getTop(), inner.getRight(), inner.getBottom());
                        }

                        int dx = cx - x;
                        if (isFirst) {
                            dx = 0;
                            isFirst = false;
                        }
                        x = cx;

                        if(Math.abs(dx)<200)
                            inner.layout(inner.getLeft()+dx/3,inner.getTop(),inner.getRight()+dx/3,inner.getBottom());
                    }else if (getScrollX() == maxScrollX) {
                        if (mRect.isEmpty()) {
                            mRect.set(inner.getLeft(), inner.getTop(), inner.getRight(), inner.getBottom());
                        }

                        int dx = cx - x;
                        if (isFirst) {
                            dx = 0;
                            isFirst = false;
                        }
                        x = cx;

                        if(Math.abs(dx)<200)
                            inner.layout(inner.getLeft()+dx/3,inner.getTop(),inner.getRight()+dx/3,inner.getBottom());
                    }
                }
                break;
            case MotionEvent.ACTION_UP:
                if (!mRect.isEmpty()) {
                    Animation animation = new TranslateAnimation(inner.getLeft(), mRect.left, 0,0);
                    animation.setDuration(300);
                    animation.setFillAfter(true);
                    inner.startAnimation(animation);
                    inner.layout(mRect.left, mRect.top, mRect.right, mRect.bottom);
                    mRect.setEmpty();
                    isFirst = true;
                }
                break;
            case MotionEvent.ACTION_DOWN:
                break;
        }
        return false;
    }
}
