package com.dn.sports.adapter;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.recyclerview.widget.RecyclerView;

import com.dn.sports.R;
import com.dn.sports.database.BodyRecordModel;
import com.dn.sports.database.CustomTargetModel;

import java.util.List;

public class CustomTargetAdapter extends RecyclerView.Adapter<CustomTargetAdapter.FrameViewHolder>{

    private Context mContext;
    private int w = 0;
    private List<CustomTargetModel> mRes;


    public CustomTargetAdapter(Context context, List<CustomTargetModel> res){
        mContext = context;
        mRes = res;
    }

    @Override
    public void onBindViewHolder(final CustomTargetAdapter.FrameViewHolder holder, final int position) {

        final CustomTargetModel item = mRes.get(position);
        holder.root.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(clickListener != null)
                    clickListener.onClick(item,position);
            }
        });
        holder.menu.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(clickListener != null)
                    clickListener.onMenuClick(holder.menu,item,position);
            }
        });

        holder.title.setText(""+mRes.get(position).getTitle());

        if(item.getIsLoop() == 0){
            if(item.getAllTimes() == 1){
                if(item.getFinishTime() == 1){
                    holder.title.setTextColor(Color.GRAY);
                }else{
                    holder.title.setTextColor(Color.BLACK);
                }
            }
        }
    }

    @Override
    public CustomTargetAdapter.FrameViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.view_custom_target_item , parent , false);
        CustomTargetAdapter.FrameViewHolder viewHolder = new CustomTargetAdapter.FrameViewHolder(view);
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

        View root;
        TextView title;
        ImageView menu;

        public FrameViewHolder(View itemView) {
            super(itemView);
            root = itemView.findViewById(R.id.root);
            title = (TextView)itemView.findViewById(R.id.title);
            menu = (ImageView) itemView.findViewById(R.id.menu);
        }
    }

    private CustomTargetAdapter.ClickListener clickListener;

    public void setClickListener(CustomTargetAdapter.ClickListener clickListener) {
        this.clickListener = clickListener;
    }

    public interface ClickListener{
        void onClick(CustomTargetModel itemModel, int pos);

        void onMenuClick(View menu,CustomTargetModel itemModel, int pos);
    }


}
