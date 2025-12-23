package com.dn.sports.dialog;

import android.content.Context;
import android.os.Handler;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;

import com.dn.sports.R;

public class TargetStepDialog extends BasePopup {

    private EditText targetSteps;
    private View view;

    public int getCurrentSteps() {
        return Integer.valueOf(targetSteps.getText().toString().toString());
    }

    public TargetStepDialog(Context context){
        super(context, ViewGroup.LayoutParams.MATCH_PARENT,ViewGroup.LayoutParams.WRAP_CONTENT);
    }

    @Override
    protected void onDismissDialog() {
        InputMethodManager inputManager =
                (InputMethodManager) targetSteps.getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
        inputManager.showSoftInput(targetSteps, 1);
    }

    @Override
    protected View createDialogView(Context context, LayoutInflater inflater) {
        view = inflater.inflate(R.layout.dialog_target_steps,null);
        targetSteps = view.findViewById(R.id.target_steps);
        view.findViewById(R.id.deny).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismissDialog();
            }
        });
        return view;
    }

    public void setOkClickListener(View.OnClickListener listener){
        view.findViewById(R.id.auth).setOnClickListener(listener);
    }

    public void setCurrentSteps(int steps){
        String data = steps+"";
        targetSteps.setText(data);
        targetSteps.setSelection(data.length());
    }

    @Override
    public void showDialogAtCenter() {
        super.showDialogAtCenter();

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                targetSteps.setFocusable(true);
                targetSteps.setFocusableInTouchMode(true);
                targetSteps.requestFocus();
                InputMethodManager inputManager =
                        (InputMethodManager) targetSteps.getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
                inputManager.showSoftInput(targetSteps, 0);
            }
        },500);
    }
}
