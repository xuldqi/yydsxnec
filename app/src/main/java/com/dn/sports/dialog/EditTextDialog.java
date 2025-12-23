package com.dn.sports.dialog;

import android.content.Context;
import android.graphics.Color;
import android.os.Handler;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.TextView;

import com.dn.sports.R;
import com.dn.sports.view.WheelPicker;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class EditTextDialog extends BasePopup {

    private EditText editText;
    private View view;

    public EditTextDialog(Context context){
        super(context, ViewGroup.LayoutParams.MATCH_PARENT,ViewGroup.LayoutParams.WRAP_CONTENT);
    }

    @Override
    protected void onDismissDialog() {
    }

    @Override
    protected View createDialogView(Context context, LayoutInflater inflater) {
        view = inflater.inflate(R.layout.dialog_edittext,null);
        editText = view.findViewById(R.id.edit_text);
        view.findViewById(R.id.deny).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismissDialog();
            }
        });
        return view;
    }

    public String getEditTextContent(){
        return editText.getText().toString();
    }

    public void setEditTextContent(String content){
        editText.setText(content);
        editText.setSelection(content.length());
    }

    public void setTitle(String title){
        ((TextView)view.findViewById(R.id.title)).setText(title);
    }

    public void setOkClickListener(View.OnClickListener listener){
        view.findViewById(R.id.auth).setOnClickListener(listener);
    }

    @Override
    public void showDialogAtCenter() {
        super.showDialogAtCenter();

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                editText.setFocusable(true);
                editText.setFocusableInTouchMode(true);
                editText.requestFocus();
                InputMethodManager inputManager =
                        (InputMethodManager) editText.getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
                inputManager.showSoftInput(editText, 0);
            }
        },500);
    }
}
