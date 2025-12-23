package com.dn.sports.view;

import android.content.Context;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.ScrollView;

public class OverScrollView extends ScrollView {
    private boolean isCalled;
    private Callback mCallback;
    /** 包含的View */
    private View mView;
    /** 存储正常时的位置 */
    private Rect mRect = new Rect();
    /**  y坐标 */
    private int y;
    private boolean isFirst = true;

    public OverScrollView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    @Override
    protected void onFinishInflate() {
        if (getChildCount() > 0)
            mView = getChildAt(0);
        super.onFinishInflate();
    }

    @Override
    public boolean onTouchEvent(MotionEvent ev) {
        if (mView != null) {
            commonOnTouch(ev);
        }
        return super.onTouchEvent(ev);
    }

//    @Override
//    public boolean onInterceptTouchEvent(MotionEvent ev) {
//        if (ev.getAction() == MotionEvent.ACTION_MOVE) {
//            Log.i("onInterceptTouchEvent","MotionEvent 拦截:"+ev.getAction());
//            return true;
//        }else{
//            Log.i("onInterceptTouchEvent","MotionEvent 不拦截:"+ev.getAction());
//            return false;
//        }
//    }


    private void commonOnTouch(MotionEvent ev) {
        int action = ev.getAction();
        int cy = (int) ev.getY();
        switch (action) {
            case MotionEvent.ACTION_DOWN:
                break;
            case MotionEvent.ACTION_MOVE:
                int dy = cy - y;
                if (isFirst) {
                    dy = 0;
                    isFirst = false;
                }
                y = cy;

                if (isNeedMove()) {
                    if (mRect.isEmpty()) {
                        mRect.set(mView.getLeft(), mView.getTop(),mView.getRight(), mView.getBottom());
                    }

                    Log.i("","-------top-----|"+mView.getTop()+"-----|"+mView.getBottom());

                    if(mView.getTop()>500||mView.getTop()<-500){
                        Log.i("","max----------");
                    }else{
                        if(Math.abs(dy)<400) {
                            int xishu = 5;
                            if(Math.abs(mView.getTop())>100){
                                xishu = Math.abs(mView.getTop())*5/100;
                            }
                            mView.layout(mView.getLeft(), mView.getTop() + 3*dy / xishu, mView.getRight(), mView.getBottom() + 3*dy / xishu);
                        }

                        if (shouldCallBack(dy)) {
                            if (mCallback != null) {
                                if (!isCalled) {
                                    isCalled = true;
                                    resetPosition();
                                    mCallback.callback();
                                }
                            }
                        }
                    }
                }

                break;
            /** 反弹回去 */
            case MotionEvent.ACTION_UP:
                Log.i("OverScrollView","ACTION_UP");
                if (!mRect.isEmpty()) {
                    resetPosition();
                }
                break;

        }
    }

    private boolean shouldCallBack(int dy) {
        if (dy > 0 && mView.getTop() > getHeight() / 2)
            return true;
        return false;
    }

    private void resetPosition() {
        Animation animation = new TranslateAnimation(0, 0, mView.getTop(),
                mRect.top);
        animation.setDuration(200);
        animation.setFillAfter(true);
        mView.startAnimation(animation);
        mView.layout(mRect.left, mRect.top, mRect.right, mRect.bottom);
        mRect.setEmpty();
        isFirst = true;
        isCalled = false;
    }

    public boolean isNeedMove() {
        int offset = mView.getMeasuredHeight() - getHeight();
        int scrollY = getScrollY();
        // 0是顶部，后面那个是底部
        if (scrollY == 0 || scrollY == offset) {
            return true;
        }
        return false;
    }

    public void setCallBack(Callback callback) {
        mCallback = callback;
    }

    public interface Callback {
        void callback();
    }
}
