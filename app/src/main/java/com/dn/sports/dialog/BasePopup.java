package com.dn.sports.dialog;

import android.animation.ValueAnimator;
import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.PopupWindow;

/**
 * ---------------菜单、提示基础------------------
 * */
public abstract class BasePopup {
    protected Context context;
    private View view;
    protected PopupWindow popupWindow;

    BasePopup(Context context) {
        this.context = context;
        view = createDialogView(context, LayoutInflater.from(context));
        view.measure(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED);
        popupWindow = new PopupWindow(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        popupWindow.setContentView(view);
        popupWindow.setFocusable(true);
        popupWindow.setOutsideTouchable(true);
        //进行测量防止获取不到宽高
        popupWindow.getContentView().measure(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED);
        popupWindow.setOnDismissListener(new PopupWindow.OnDismissListener() {
            @Override
            public void onDismiss() {
                onDismissDialog();
                showWhiteAnim();
                if(showCallback != null)
                    showCallback.onDismiss();
            }
        });
    }

    BasePopup(Context context, int w, int h) {
        this.context = context;
        view = createDialogView(context, LayoutInflater.from(context));
        view.measure(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED);
        popupWindow = new PopupWindow(w, h);
        popupWindow.setContentView(view);
        popupWindow.setFocusable(true);
        popupWindow.setOutsideTouchable(true);
        //进行测量防止获取不到宽高
        popupWindow.getContentView().measure(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED);
        popupWindow.setOnDismissListener(new PopupWindow.OnDismissListener() {
            @Override
            public void onDismiss() {
                onDismissDialog();
                showWhiteAnim();
                if(showCallback != null)
                    showCallback.onDismiss();
            }
        });
    }

    protected void measureWH(){
        view.measure(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED);
        popupWindow.getContentView().measure(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED);
    }

    public void setBackBtnDismiss(){
        view.setOnKeyListener(new View.OnKeyListener() {
            @Override
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                if (keyCode == KeyEvent.KEYCODE_BACK) {

                    if(popupWindow.isShowing()){
                        popupWindow.dismiss();
                    }
                    return true;
                }
                return false;
            }
        });
    }

    public void setBackBtnDismissDisenble(){
        popupWindow.setFocusable(false);
        popupWindow.setTouchInterceptor(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                return false;
            }
        });
    }

    public void setOutSideDismiss(){
        //设置一个透明背景
        popupWindow.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        view.setOnTouchListener(new View.OnTouchListener()
        {
            public boolean onTouch(View v, MotionEvent event)
            {
                if (popupWindow.isShowing()){
                    popupWindow.dismiss();
                }
                return false;
            }
        });
    }

    public void setOutsideTouchable(boolean touchable){
        popupWindow.setFocusable(touchable);
        popupWindow.setOutsideTouchable(touchable);
    }

    private ValueAnimator animator;

    private void showBlackAnim(){
        if(animator !=null&&animator.isRunning()){
            animator.cancel();
        }
        animator = ValueAnimator.ofFloat(1.0f, 0.5f);
        animator.setDuration(280);
        animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
            @Override
            public void onAnimationUpdate(ValueAnimator animation) {
                Float value = (float) animation.getAnimatedValue();
                setBackgroundAlpha(value);
            }
        });
        animator.start();
    }

    private void showWhiteAnim(){
        if(animator !=null&&animator.isRunning()){
            animator.cancel();
        }
        animator = ValueAnimator.ofFloat(0.5f, 1f);
        animator.setDuration(280);
        animator.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
            @Override
            public void onAnimationUpdate(ValueAnimator animation) {
                Float value = (float) animation.getAnimatedValue();
                setBackgroundAlpha(value);
            }
        });
        animator.start();
    }

    protected abstract void onDismissDialog();

    public void showDialog() {
        showDialog(0,0,-1);
    }

    public void showDialog(int x,int y) {
        showDialog(x,y,-1);
    }

    public void showDialog(int x,int y,int animationStyle) {
        if (popupWindow.isShowing())
            return;
        if(animationStyle != -1){
            popupWindow.setAnimationStyle(animationStyle);
        }
        showBlackAnim();
        popupWindow.showAtLocation(view, Gravity.NO_GRAVITY, x, y);
        if(showCallback != null)
            showCallback.onShow();
    }

    public void showDialogAtCenter() {
        showDialogAtCenter(-1);
    }

    public void showDialogAtCenter(int animationStyle) {
        if (popupWindow.isShowing())
            return;
        if(animationStyle != -1){
            popupWindow.setAnimationStyle(animationStyle);
        }
        showBlackAnim();
        popupWindow.showAtLocation(view, Gravity.CENTER, 0, 0);
        if(showCallback != null)
            showCallback.onShow();
    }

    public void showDialogAtCenterH(int animationStyle,int y) {
        if (popupWindow.isShowing())
            return;
        if(animationStyle != -1){
            popupWindow.setAnimationStyle(animationStyle);
        }
        showBlackAnim();
        popupWindow.showAtLocation(view, Gravity.CENTER_HORIZONTAL, 0, y);
        if(showCallback != null)
            showCallback.onShow();
    }

    public void showDialogAtCenterWithBackground(int animationStyle) {
        showDialogAtCenter(animationStyle);
    }

    public void showDialogAtBottom() {
        showDialogAtBottom(-1);
    }

    public void showDialogAtBottom(int animationStyle) {
        if (popupWindow.isShowing())
            return;
        if(animationStyle != -1){
            popupWindow.setAnimationStyle(animationStyle);
        }
        showBlackAnim();
        popupWindow.showAtLocation(view, Gravity.BOTTOM, 0, 0);
        if(showCallback != null)
            showCallback.onShow();
    }

    public boolean isShowing() {
        return popupWindow.isShowing();
    }

    public void dismissDialog() {
        popupWindow.dismiss();
    }

    protected abstract View createDialogView(Context context, LayoutInflater inflater);

    protected void setBackgroundAlpha(float bgAlpha) {
        WindowManager.LayoutParams lp = ((Activity) context).getWindow()
                .getAttributes();
        lp.alpha = bgAlpha;
        ((Activity) context).getWindow().setAttributes(lp);
    }

    public int getWidth() {
        return popupWindow.getContentView().getMeasuredWidth();
    }

    public int getHeight() {
        return popupWindow.getContentView().getMeasuredHeight();
    }

    private ShowCallback showCallback;

    public interface ShowCallback{
        void onShow();

        void onDismiss();
    }

    public void setShowCallback(ShowCallback showCallback) {
        this.showCallback = showCallback;
    }

    protected void hideKeyboard(EditText view){
        InputMethodManager imm = (InputMethodManager) context.getSystemService(Context.INPUT_METHOD_SERVICE);
        if(imm != null)
            imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
    }

    protected void setSoftUpPopupwindow(){
        popupWindow.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
    }
}
