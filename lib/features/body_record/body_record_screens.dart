import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';

class BodyRecordManageScreen extends StatefulWidget {
  const BodyRecordManageScreen({super.key});
  @override
  State<BodyRecordManageScreen> createState() => _BodyRecordManageScreenState();
}

class _BodyRecordManageScreenState extends State<BodyRecordManageScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['身体概况', '体重', 'BMI', '体脂率', '腰围', '臀围', '胸围'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddRecordSheet() {
    final type = _tabs[_tabController.index];
    if (type == '身体概况') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请切换到具体维度进行记录')));
      return;
    }
    // 简化的添加表单
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('记录$type', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '请输入$type数据',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('保存', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('身体记录', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: Colors.transparent,
          tabs: _tabs.map((e) => Tab(text: e)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((tab) {
          if (tab == '身体概况') {
            return _buildOverviewTab();
          }
          return _buildDetailTab(tab);
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddRecordSheet,
        backgroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add_rounded, color: Colors.grey, size: 32),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildOverviewCard('体重', '65.0 kg', Icons.monitor_weight_rounded),
        const SizedBox(height: 12),
        _buildOverviewCard('BMI', '22.3', Icons.calculate_rounded),
        const SizedBox(height: 12),
        _buildOverviewCard('体脂率', '18.5%', Icons.percent_rounded),
        const SizedBox(height: 12),
        _buildOverviewCard('腰围', '78 cm', Icons.straighten_rounded),
        const SizedBox(height: 12),
        _buildOverviewCard('臀围', '95 cm', Icons.straighten_rounded),
        const SizedBox(height: 12),
        _buildOverviewCard('胸围', '92 cm', Icons.accessibility_new_rounded),
      ],
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(color: Colors.black, fontSize: 16)),
        trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16)),
        onTap: () {
          final idx = _tabs.indexOf(title);
          if (idx != -1) {
            _tabController.animateTo(idx);
          }
        },
      ),
    );
  }

  Widget _buildDetailTab(String type) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 顶部图表区 (模拟)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, minimumSize: const Size(80, 36), elevation: 0),
                    child: const Text('周', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE0E0E0), minimumSize: const Size(80, 36), elevation: 0),
                    child: const Text('月', style: TextStyle(color: Colors.black54)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 150,
                alignment: Alignment.center,
                child: const Text('图表区域', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // 历史列表
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('全部记录', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 16),
              // mock data
              _buildHistoryItem('65.0', '06-15 08:00'),
              const Divider(color: Color(0xFFEEEEEE), height: 1),
              _buildHistoryItem('64.8', '06-10 09:30'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(String val, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(val, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
          Text(time, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}
