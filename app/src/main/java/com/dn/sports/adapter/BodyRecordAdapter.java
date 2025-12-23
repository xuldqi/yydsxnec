package com.dn.sports.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.recyclerview.widget.RecyclerView;

import com.dn.sports.R;
import com.dn.sports.ormbean.BodyRecord;
import com.dn.sports.utils.DateUtils;

import java.util.List;

public class BodyRecordAdapter extends RecyclerView.Adapter<BodyRecordAdapter.FrameViewHolder>{

    private Context mContext;
    private int w = 0;
     List<BodyRecord> mRes;
    private String mTitle;


    public BodyRecordAdapter(Context context, List<BodyRecord> res,String title){
        mContext = context;
        mRes = res;
        mTitle = title;
    }

    @Override
    public void onBindViewHolder(final BodyRecordAdapter.FrameViewHolder holder, @SuppressLint("RecyclerView") final int position) {
        holder.modify.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(clickListener != null)
                    clickListener.onModifyClick(mRes.get(position),position);
            }
        });
        holder.delete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (clickListener != null)
                    if (position < mRes.size()) {
                        clickListener.onDeleteClick(mRes.get(position), position);
                        mRes.remove(position);
                    }
            }
        });

        holder.time.setText(DateUtils.getDate2String(mRes.get(position).getTime(),"MM月dd日 HH:mm"));

        String showYear = "";
        if (position > 0) {
            String year = DateUtils.getDate2String(mRes.get(position).getTime(), "yyyy年MM月");
            String last = DateUtils.getDate2String(mRes.get(position - 1).getTime(), "yyyy年MM月");
            if (year.equals(last)) {
                showYear = "";
            } else {
                showYear = year;
            }
        } else {
            showYear = DateUtils.getDate2String(mRes.get(position).getTime(), "yyyy年MM月");
        }
        holder.tvDate.setText(showYear);
        if (showYear.isEmpty()) {
            holder. tvDate.setVisibility(View.GONE);
        } else {
            holder. tvDate.setVisibility(View.VISIBLE);
        }

        holder.data.setText(mRes.get(position).getData() + mRes.get(position).getUnit());
    }

    @Override
    public BodyRecordAdapter.FrameViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.view_body_record_item , parent , false);
        BodyRecordAdapter.FrameViewHolder viewHolder = new BodyRecordAdapter.FrameViewHolder(view);
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

        TextView time;
        TextView data;
        TextView modify;
        TextView delete;
        TextView tvDate;



        public FrameViewHolder(View itemView) {
            super(itemView);

            data = (TextView)itemView.findViewById(R.id.data);
            tvDate = (TextView)itemView.findViewById(R.id.tvDate);
            time = (TextView) itemView.findViewById(R.id.time);
            modify = (TextView) itemView.findViewById(R.id.modify);
            delete = (TextView) itemView.findViewById(R.id.delete);
        }
    }

    private BodyRecordAdapter.ClickListener clickListener;

    public void setClickListener(BodyRecordAdapter.ClickListener clickListener) {
        this.clickListener = clickListener;
    }

    public interface ClickListener{
        void onModifyClick(BodyRecord itemModel, int pos);

        void onDeleteClick(BodyRecord itemModel, int pos);
    }


}
