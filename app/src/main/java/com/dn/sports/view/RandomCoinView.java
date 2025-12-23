package com.dn.sports.view;

import android.content.Context;
import android.util.AttributeSet;

import androidx.appcompat.widget.AppCompatTextView;

import com.dn.sports.adcoinLogin.model.RandomCoin;

public class RandomCoinView extends AppCompatTextView {

    public RandomCoinView(Context context){
        super(context);
    }

    public RandomCoinView(Context context, AttributeSet attrs){
        super(context,attrs);
    }

    private RandomCoin randomCoin;

    public RandomCoin getRandomCoin() {
        return randomCoin;
    }

    public void setRandomCoin(RandomCoin randomCoin) {
        this.randomCoin = randomCoin;
        setText(String.valueOf(randomCoin.getAmount()));
    }
}
