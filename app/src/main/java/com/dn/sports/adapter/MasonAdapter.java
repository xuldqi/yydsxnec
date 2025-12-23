//package com.dn.sports.adapter;
//
//import android.content.Context;
//import android.view.LayoutInflater;
//import android.view.View;
//import android.view.ViewGroup;
//import android.widget.TextView;
//
//import androidx.recyclerview.widget.RecyclerView;
//
//import com.dn.sports.utils.Utils;
//
//import java.util.List;
//
//public class MasonAdapter extends RecyclerView.Adapter<MasonAdapter.FrameViewHolder>{
//
//    private Context mContext;
//    private int w = 0;
//    private List<MasonModel> mRes;
//    private boolean isDarkMode = true;
//
//    public void setDarkMode(boolean darkMode) {
//        isDarkMode = darkMode;
//    }
//
//    public MasonAdapter(Context context, List<MasonModel> res){
//        mContext = context;
//        mRes = res;
//        w = Utils.getWidth(context)-(int)(mContext.getResources().getDimension(R.dimen.padding_15)*2);
//    }
//
//    @Override
//    public void onBindViewHolder(final MasonAdapter.FrameViewHolder holder, final int position) {
//        holder.title.setText(mRes.get(position).getTitle());
//        holder.layout.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                if(clickListener != null)
//                    clickListener.onClick(mRes.get(position),position);
//            }
//        });
//    }
//
//    @Override
//    public MasonAdapter.FrameViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
//        View view = LayoutInflater.from(mContext).inflate(R.layout.knowledge_list_item , parent , false);
//        MasonAdapter.FrameViewHolder viewHolder = new MasonAdapter.FrameViewHolder(view);
//        return viewHolder;
//    }
//
//    @Override
//    public int getItemCount() {
//        return mRes.size();
//    }
//
//    @Override
//    public long getItemId(int position) {
//        return super.getItemId(position);
//    }
//
//    class FrameViewHolder extends RecyclerView.ViewHolder{
//
//        TextView title;
//        ViewGroup layout;
//
//        public FrameViewHolder(View itemView) {
//            super(itemView);
//            layout = (ViewGroup)itemView.findViewById(R.id.layout);
//            title = (TextView) itemView.findViewById(R.id.knowledge_item_title);
//        }
//    }
//
//    private MasonAdapter.ClickListener clickListener;
//
//    public void setClickListener(MasonAdapter.ClickListener clickListener) {
//        this.clickListener = clickListener;
//    }
//
//    public interface ClickListener{
//        void onClick(MasonAdapter itemModel, int pos);
//    }
//}
//
