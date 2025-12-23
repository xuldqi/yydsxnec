package com.dn.sports.adapter;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.recyclerview.widget.RecyclerView;

import com.dn.sports.R;
import com.dn.sports.database.BodyRecordModel;
import com.dn.sports.utils.DateUtils;

import java.util.List;

public class SetTargetTypeAdapter extends RecyclerView.Adapter<SetTargetTypeAdapter.FrameViewHolder>{

    private Context mContext;
    private int w = 0;
    private List<Integer> mRes;
    private String mTitle;
    private int selectPos = -1;


    public SetTargetTypeAdapter(Context context, List<Integer> res,String title){
        mContext = context;
        mRes = res;
        mTitle = title;
    }

    @Override
    public void onBindViewHolder(final SetTargetTypeAdapter.FrameViewHolder holder, final int position) {
        holder.view.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(clickListener != null)
                    clickListener.onClick(mRes.get(position),position);
            }
        });

        if(selectPos == position){
            holder.view.setBackgroundResource(R.drawable.list_item_f);
        }else {
            holder.view.setBackgroundColor(Color.WHITE);
        }
        if(mRes.get(position) == 0){
            holder.content.setText("自由");
            return;
        }

        float data = mRes.get(position)/1000f;
        holder.content.setText(data+" 公里");
    }

    @Override
    public SetTargetTypeAdapter.FrameViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.view_set_target_type_item , parent , false);
        SetTargetTypeAdapter.FrameViewHolder viewHolder = new SetTargetTypeAdapter.FrameViewHolder(view);
        return viewHolder;
    }

    public void setSelectItem(int pos){
        selectPos = pos;
        notifyDataSetChanged();
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
        TextView content;

        public FrameViewHolder(View itemView) {
            super(itemView);
            view = itemView;
            content = (TextView) itemView.findViewById(R.id.content);
        }
    }

    private SetTargetTypeAdapter.ClickListener clickListener;

    public void setClickListener(SetTargetTypeAdapter.ClickListener clickListener) {
        this.clickListener = clickListener;
    }

    public interface ClickListener{
        void onClick(Integer integer, int pos);
    }


}
