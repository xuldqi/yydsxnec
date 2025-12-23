package com.dn.sports.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.recyclerview.widget.RecyclerView;

import com.dn.sports.R;
import com.dn.sports.adcoinLogin.model.CoinRecord;
import com.dn.sports.utils.DateUtils;

import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;

public class CoinRecordAdapter extends RecyclerView.Adapter<CoinRecordAdapter.FrameViewHolder>{

    private Context mContext;
    private int w = 0;
    private List<CoinRecord> mRes;
    private SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd",Locale.getDefault());
    private SimpleDateFormat timer = new SimpleDateFormat("HH:mm",Locale.getDefault());


    public CoinRecordAdapter(Context context, List<CoinRecord> res){
        mContext = context;
        mRes = res;
    }

    @Override
    public void onBindViewHolder(final CoinRecordAdapter.FrameViewHolder holder, final int position) {
        holder.title.setText(mRes.get(position).getTaskName());
        holder.coin.setText("+"+mRes.get(position).getReward());
        String date = format.format(mRes.get(position).getCreateTime());
        String hhmm = timer.format(mRes.get(position).getCreateTime());
        if(date.equals(DateUtils.getYMD(0))){
            holder.time.setText("今天 "+hhmm);
        }else if(date.equals(DateUtils.getYMD(-1))){
            holder.time.setText("昨天 " + hhmm);
        }else if(date.equals(DateUtils.getYMD(-2))){
            holder.time.setText("前天 " + hhmm);
        }else{
            holder.time.setText(date + " " + hhmm);
        }
        holder.layout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(clickListener != null)
                    clickListener.onClick(mRes.get(position),position);
            }
        });
    }

    @Override
    public CoinRecordAdapter.FrameViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.listitem_coin_record , parent , false);
        CoinRecordAdapter.FrameViewHolder viewHolder = new CoinRecordAdapter.FrameViewHolder(view);
        return viewHolder;
    }

    @Override
    public int getItemCount() {
        return mRes.size();
    }

    @Override
    public long getItemId(int position) {
        return super.getItemId(position);
    }

    class FrameViewHolder extends RecyclerView.ViewHolder{

        TextView title;
        TextView time;
        TextView coin;
        ViewGroup layout;

        public FrameViewHolder(View itemView) {
            super(itemView);
            layout = (ViewGroup)itemView.findViewById(R.id.layout);
            title = (TextView) itemView.findViewById(R.id.title);
            time = (TextView) itemView.findViewById(R.id.time);
            coin = (TextView) itemView.findViewById(R.id.coin);
        }
    }

    private CoinRecordAdapter.ClickListener clickListener;

    public void setClickListener(CoinRecordAdapter.ClickListener clickListener) {
        this.clickListener = clickListener;
    }

    public interface ClickListener{
        void onClick(CoinRecord itemModel, int pos);
    }
}
