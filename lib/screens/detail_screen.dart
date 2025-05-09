import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/beauty_spot.dart';
import '../services/auth_service.dart';

class DetailScreen extends StatefulWidget {
  final BeautySpot spot;

  const DetailScreen({Key? key, required this.spot}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool isFavorite;

  void _toggleFavorite() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.toggleFavorite(widget.spot.name);
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authService = Provider.of<AuthService>(context, listen: false);
      setState(() {
        isFavorite = authService.getFavorites().contains(widget.spot.name);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.spot.name),
        backgroundColor: Colors.pink,
        actions: [
          // Kiểm tra xem đã có dữ liệu hay chưa
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: () async {
              await authService.toggleFavorite(widget.spot.name);
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh
            Container(
              width: double.infinity,
              height: 200,
              child: Image.asset(
                widget.spot.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child:
                        Icon(Icons.broken_image, size: 100, color: Colors.grey),
                  );
                },
              ),
            ),
            // Thông tin chi tiết
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.spot.name,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.pink),
                      const SizedBox(width: 8),
                      Expanded(child: Text(widget.spot.address)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.pink),
                      const SizedBox(width: 8),
                      Text(widget.spot.openingHours),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.monetization_on, color: Colors.pink),
                      const SizedBox(width: 8),
                      Text(widget.spot.priceRange),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.pink),
                      const SizedBox(width: 8),
                      Text(widget.spot.phone),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Dịch vụ:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(widget.spot.services,
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  const Text('Mô tả:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(widget.spot.description,
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  // Nút "Xem trên bản đồ" và "Gọi"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            await launch(
                                'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(widget.spot.address)}');
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Không thể mở bản đồ: $e')),
                            );
                          }
                        },
                        icon: const Icon(Icons.map),
                        label: const Text('Xem trên bản đồ'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            await launch('tel:${widget.spot.phone}');
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Không thể gọi: $e')),
                            );
                          }
                        },
                        icon: const Icon(Icons.phone),
                        label: const Text('Gọi'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink),
                      ),
                      IconButton(
                        icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red),
                        onPressed: _toggleFavorite,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
