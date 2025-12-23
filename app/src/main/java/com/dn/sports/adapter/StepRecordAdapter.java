package com.dn.sports.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.recyclerview.widget.RecyclerView;

import com.dn.sports.R;
import com.dn.sports.adcoinLogin.model.CoinRecord;
import com.dn.sports.database.StepsCountModel;
import com.dn.sports.fragment.StepSubFragment;
import com.dn.sports.utils.DateUtils;
import com.dn.sports.utils.Utils;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

public class StepRecordAdapter extends RecyclerView.Adapter<StepRecordAdapter.FrameViewHolder>{

    private Context mContext;
    private int w = 0;
    private List<StepsCountModel> mRes;


    public StepRecordAdapter(Context context, List<StepsCountModel> res){
        mContext = context;
        mRes = res;
    }

    @Override
    public void onBindViewHolder(final StepRecordAdapter.FrameViewHolder holder, final int position) {
        holder.distance.setText(Utils.getDistanceByStep(mRes.get(position).steps)+"公里");
        int stepType = mRes.get(position).type;
        int stepSubType = mRes.get(position).subType;
        if(stepType == StepSubFragment.TYPE_RUN_INDOOR) {
            holder.type.setText("室内跑步");
        }else if(stepType == StepSubFragment.TYPE_RUN_OUTDOOR){
            holder.type.setText("室外跑步");
        }else if(stepType == StepSubFragment.TYPE_FAST_WALK){
            holder.type.setText("健走");
        }else if(stepType == StepSubFragment.TYPE_ON_FOOT){
            holder.type.setText("徒步");
        }else if(stepType == StepSubFragment.TYPE_MOUNTAIN_CLIMBING){
            holder.type.setText("登山");
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH时mm分");
        holder.time.setText(sdf.format(new Date(mRes.get(position).startTime)));

        long timeNum = mRes.get(position).useTime;
        String text = "";
        int hour = (int)(timeNum/(60*60*1000));
        if(hour > 1) {
            text = hour + "时";
        }
        timeNum = timeNum - 60*60*1000*hour;
        int min = (int)(timeNum/(60*1000));
        if(min > 9) {
            text = text + min + "分";
        }else{
            text = text + "0" + min + "分";
        }
        timeNum = timeNum - 60*1000*min;
        int second = (int)(timeNum/1000);
        if(second > 9) {
            text = text + second+"秒";
        }else{
            text = text + "0" + second+"秒";
        }

        holder.useTime.setText(text);
        holder.kal.setText(Utils.getKalByStep(mRes.get(position).steps)+"千卡");
    }

    @Override
    public StepRecordAdapter.FrameViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.step_count_record_item , parent , false);
        StepRecordAdapter.FrameViewHolder viewHolder = new StepRecordAdapter.FrameViewHolder(view);
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

        TextView type;
        TextView time;
        TextView useTime;
        TextView distance;
        TextView kal;

        public FrameViewHolder(View itemView) {
            super(itemView);
            type = (TextView)itemView.findViewById(R.id.type);
            time = (TextView) itemView.findViewById(R.id.time);
            useTime = (TextView) itemView.findViewById(R.id.count_time);
            distance = (TextView) itemView.findViewById(R.id.distance);
            kal = (TextView) itemView.findViewById(R.id.kal);
        }
    }

    private StepRecordAdapter.ClickListener clickListener;

    public void setClickListener(StepRecordAdapter.ClickListener clickListener) {
        this.clickListener = clickListener;
    }

    public interface ClickListener{
        void onClick(CoinRecord itemModel, int pos);
    }


}
