package com.dn.sports.adcoinLogin;

import android.content.Context;
import android.graphics.Bitmap;
import android.os.AsyncTask;
import android.widget.ImageView;

import com.dn.sports.common.ACache;
import com.dn.sports.utils.Utils;

import java.lang.ref.WeakReference;

public class GetImageSync extends AsyncTask<String, Integer, Bitmap> {

    private WeakReference<ImageView> ref;
    private WeakReference<Context> mCtx;

    public GetImageSync(ImageView view,Context ctx){
        ref = new WeakReference<>(view);
        mCtx = new WeakReference<>(ctx);
    }

    @Override
    protected Bitmap doInBackground(String[] objects) {
        String url = objects[0];
        Context ctx = mCtx.get();
        ACache aCache = ACache.get(ctx);

        Bitmap bp = aCache.getAsBitmap(url);
        if(bp != null){
            return bp;
        }
        bp =  Utils.getURLimage(url);
        aCache.put(url,bp);
        return bp;
    }

    @Override
    protected void onPostExecute(Bitmap o) {
        if(o == null)
            return;
        ImageView image = ref.get();
        image.setImageBitmap(o);
        super.onPostExecute(o);
    }
}
