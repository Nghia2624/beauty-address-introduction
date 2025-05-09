import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/beauty_spot.dart';
import '../services/auth_service.dart';
import 'detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, auth, _) {
        final history = auth.getHistory();
        final historySpots = beautySpots.where((spot) => history.contains(spot.name)).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Lịch sử xem'),
            actions: [
              // Thêm nút "Xóa tất cả"
              if (historySpots.isNotEmpty) // Chỉ hiển thị nút nếu có lịch sử
                IconButton(
                  icon: const Icon(Icons.delete_forever, color: Color.fromARGB(255, 0, 0, 0)),
                  tooltip: 'Xóa tất cả lịch sử',
                  onPressed: () {
                    _showClearHistoryDialog(context, auth);
                  },
                ),
            ],
          ),
          body: historySpots.isEmpty
              ? const Center(child: Text('Chưa có lịch sử xem'))
              : ListView.builder(
                  itemCount: historySpots.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.asset(historySpots[index].imagePath, width: 50, fit: BoxFit.cover),
                      title: Text(historySpots[index].name),
                      subtitle: Text(historySpots[index].services),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => DetailScreen(spot: historySpots[index])),
                        );
                      },
                    );
                  },
                ),
        );
      },
    );
  }

  // Hiển thị hộp thoại xác nhận xóa lịch sử
  void _showClearHistoryDialog(BuildContext context, AuthService auth) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Xóa lịch sử xem', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Bạn có chắc muốn xóa toàn bộ lịch sử xem?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              await auth.clearHistory();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa toàn bộ lịch sử xem')),
              );
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}