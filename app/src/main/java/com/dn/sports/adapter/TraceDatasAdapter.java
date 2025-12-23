package com.dn.sports.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.recyclerview.widget.RecyclerView;

import com.dn.sports.R;
import com.dn.sports.database.BodyRecordModel;
import com.dn.sports.map.TraceItemModel;
import com.dn.sports.utils.DateUtils;

import java.text.NumberFormat;
import java.util.List;

public class TraceDatasAdapter extends RecyclerView.Adapter<TraceDatasAdapter.FrameViewHolder>{

    private Context mContext;
    private int w = 0;
    private List<TraceItemModel> mRes;
    private NumberFormat nf = NumberFormat.getNumberInstance();


    public TraceDatasAdapter(Context context, List<TraceItemModel> res){
        mContext = context;
        mRes = res;
        nf.setMaximumFractionDigits(2);
    }

    @Override
    public void onBindViewHolder(final TraceDatasAdapter.FrameViewHolder holder, final int position) {
        holder.view.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(clickListener != null)
                    clickListener.onClick(mRes.get(position),position);
            }
        });
        holder.delete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(clickListener != null)
                    clickListener.onDeleteClick(mRes.get(position),position);
                mRes.remove(position);
            }
        });

        holder.time.setText(DateUtils.getDate2String(mRes.get(position).getTime(),"yyyy年MM月dd日 HH时mm分"));

        float sportDistance = mRes.get(position).getDistance();
        if(sportDistance <1000){
            holder.data.setText("里程："+nf.format(sportDistance)+"米");
        }else{
            holder.data.setText("里程："+nf.format(sportDistance/1000)+"km");
        }
    }

    @Override
    public TraceDatasAdapter.FrameViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.view_trace_item , parent , false);
        TraceDatasAdapter.FrameViewHolder viewHolder = new TraceDatasAdapter.FrameViewHolder(view);
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

        View view;
        TextView time;
        TextView data;
        TextView delete;

        public FrameViewHolder(View itemView) {
            super(itemView);
            view = itemView.findViewById(R.id.root);
            data = (TextView)itemView.findViewById(R.id.data);
            time = (TextView) itemView.findViewById(R.id.time);
            delete = (TextView) itemView.findViewById(R.id.delete);
        }
    }

    private TraceDatasAdapter.ClickListener clickListener;

    public void setClickListener(TraceDatasAdapter.ClickListener clickListener) {
        this.clickListener = clickListener;
    }

    public interface ClickListener{
        void onClick(TraceItemModel itemModel, int pos);

        void onDeleteClick(TraceItemModel itemModel, int pos);
    }


}
