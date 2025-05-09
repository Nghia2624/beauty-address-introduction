import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/beauty_spot.dart';
import '../services/auth_service.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  List<BeautySpot> _filteredSpots = beautySpots;

  // Biến để lưu trữ các tiêu chí lọc
  RangeValues _priceRange = const RangeValues(100, 1000); // Khoảng giá mặc định (100k - 1000k)
  List<String> _selectedServices = []; // Danh sách dịch vụ được chọn
  List<String> _availableServices = [
    'Massage',
    'Chăm sóc da',
    'Tóc',
    'Nail',
    'Xông hơi',
    'Uốn',
    'Nhuộm',
    'Tẩy tế bào chết',
    'Gội đầu thư giãn',
  ]; // Danh sách các dịch vụ có thể chọn

  // Biến tạm thời để lưu trữ trạng thái lọc trong bottom sheet
  RangeValues _tempPriceRange = const RangeValues(100, 1000);
  List<String> _tempSelectedServices = [];
  int _previewCount = 0; // Số lượng kết quả phù hợp với bộ lọc tạm thời

  @override
  void initState() {
    super.initState();
    _availableServices.sort(); // Sắp xếp dịch vụ theo thứ tự bảng chữ cái
    _loadFilterPreferences(); // Tải bộ lọc đã lưu
    _searchController.addListener(_filterSpots);
  }

  // Tải bộ lọc từ SharedPreferences
  Future<void> _loadFilterPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _priceRange = RangeValues(
        prefs.getDouble('priceRangeStart') ?? 100,
        prefs.getDouble('priceRangeEnd') ?? 1000,
      );
      _selectedServices = prefs.getStringList('selectedServices') ?? [];
      _tempPriceRange = _priceRange;
      _tempSelectedServices = List.from(_selectedServices);
    });
    _filterSpots();
  }

  // Lưu bộ lọc vào SharedPreferences
  Future<void> _saveFilterPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('priceRangeStart', _priceRange.start);
    await prefs.setDouble('priceRangeEnd', _priceRange.end);
    await prefs.setStringList('selectedServices', _selectedServices);
  }

  void _filterSpots() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      _filteredSpots = beautySpots.where((spot) {
        // Lọc theo từ khóa tìm kiếm (tên hoặc dịch vụ)
        bool matchesQuery = spot.name.toLowerCase().contains(query) ||
            spot.services.toLowerCase().contains(query);

        // Lọc theo khoảng giá
        bool matchesPrice = _matchesPriceRange(spot.priceRange, _priceRange);

        // Lọc theo dịch vụ
        bool matchesServices = _selectedServices.isEmpty ||
            _selectedServices.any((service) =>
                spot.services.toLowerCase().contains(service.toLowerCase()));

        // Logic "OR": Chỉ cần một trong hai điều kiện (price hoặc services) đúng
        bool matchesFilters = _priceRange == const RangeValues(100, 1000) && _selectedServices.isEmpty
            ? true // Không có bộ lọc nào được áp dụng
            : matchesPrice || matchesServices; // Ít nhất một điều kiện đúng

        return matchesQuery && matchesFilters;
      }).toList();
    });
  }

  // Hàm lọc tạm thời để xem trước kết quả trong bottom sheet
  int _previewFilterSpots(RangeValues tempPriceRange, List<String> tempServices) {
    String query = _searchController.text.toLowerCase();
    return beautySpots.where((spot) {
      // Lọc theo từ khóa tìm kiếm (tên hoặc dịch vụ)
      bool matchesQuery = spot.name.toLowerCase().contains(query) ||
          spot.services.toLowerCase().contains(query);

      // Lọc theo khoảng giá
      bool matchesPrice = _matchesPriceRange(spot.priceRange, tempPriceRange);

      // Lọc theo dịch vụ
      bool matchesServices = tempServices.isEmpty ||
          tempServices.any((service) =>
              spot.services.toLowerCase().contains(service.toLowerCase()));

      // Logic "OR": Chỉ cần một trong hai điều kiện (price hoặc services) đúng
      bool matchesFilters = tempPriceRange == const RangeValues(100, 1000) && tempServices.isEmpty
          ? true // Không có bộ lọc nào được áp dụng
          : matchesPrice || matchesServices; // Ít nhất một điều kiện đúng

      return matchesQuery && matchesFilters;
    }).length;
  }

  // Hàm kiểm tra xem priceRange của spot có nằm trong khoảng giá đã chọn không
  bool _matchesPriceRange(String priceRange, RangeValues range) {
    final rangeSplit = priceRange.split(' - ');
    if (rangeSplit.length != 2) return false;

    final minPrice = double.tryParse(rangeSplit[0].replaceAll('k', '')) ?? 0;
    final maxPrice = double.tryParse(rangeSplit[1].replaceAll('k', '')) ?? 0;

    return minPrice >= range.start && maxPrice <= range.end;
  }

  // Hiển thị bottom sheet để chọn bộ lọc
  void _showFilterDialog() {
    // Khởi tạo giá trị tạm thời từ giá trị hiện tại
    _tempPriceRange = _priceRange;
    _tempSelectedServices = List.from(_selectedServices);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Cập nhật số lượng kết quả xem trước
            _previewCount = _previewFilterSpots(_tempPriceRange, _tempSelectedServices);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Lọc địa điểm',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink,
                          ),
                        ),
                        Text(
                          '$_previewCount kết quả',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Lọc theo giá
                    const Text(
                      'Khoảng giá (k)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    // Các khoảng giá cố định
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('Dưới 200k'),
                          selected: _tempPriceRange == const RangeValues(100, 200),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _tempPriceRange = const RangeValues(100, 200);
                              });
                            }
                          },
                          selectedColor: Colors.pink[100],
                        ),
                        ChoiceChip(
                          label: const Text('200k - 500k'),
                          selected: _tempPriceRange == const RangeValues(200, 500),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _tempPriceRange = const RangeValues(200, 500);
                              });
                            }
                          },
                          selectedColor: Colors.pink[100],
                        ),
                        ChoiceChip(
                          label: const Text('Trên 500k'),
                          selected: _tempPriceRange == const RangeValues(500, 1000),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _tempPriceRange = const RangeValues(500, 1000);
                              });
                            }
                          },
                          selectedColor: Colors.pink[100],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Lọc theo dịch vụ
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Dịch vụ',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _tempSelectedServices = List.from(_availableServices);
                                });
                              },
                              child: const Text('Chọn tất cả', style: TextStyle(color: Colors.pink)),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _tempSelectedServices.clear();
                                });
                              },
                              child: const Text('Bỏ chọn', style: TextStyle(color: Colors.pink)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableServices.map((service) {
                        final isSelected = _tempSelectedServices.contains(service);
                        return FilterChip(
                          label: Text(service),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _tempSelectedServices.add(service);
                              } else {
                                _tempSelectedServices.remove(service);
                              }
                            });
                          },
                          selectedColor: Colors.pink[100],
                          checkmarkColor: Colors.pink,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    // Nút áp dụng bộ lọc
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Đặt lại bộ lọc
                            setState(() {
                              _tempPriceRange = const RangeValues(100, 1000);
                              _tempSelectedServices.clear();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          child: const Text('Đặt lại'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _priceRange = _tempPriceRange;
                              _selectedServices = List.from(_tempSelectedServices);
                            });
                            _saveFilterPreferences();
                            Navigator.pop(context);
                            _filterSpots();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                          ),
                          child: const Text('Áp dụng'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            // Thanh tìm kiếm và nút lọc
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm địa điểm...',
                      prefixIcon: const Icon(Icons.search, color: Colors.pink),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.pink),
                  onPressed: _showFilterDialog,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Danh sách địa điểm
            Expanded(
              child: _filteredSpots.isEmpty
                  ? const Center(child: Text('Không tìm thấy kết quả'))
                  : ListView.builder(
                      itemCount: _filteredSpots.length,
                      itemBuilder: (context, index) {
                        final spot = _filteredSpots[index];
                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: const EdgeInsets.only(bottom: 16),
                          child: InkWell(
                            onTap: () async {
                              // Thêm vào lịch sử khi nhấn vào địa điểm
                              await auth.addToHistory(spot.name);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => DetailScreen(spot: spot)),
                              );
                            },
                            borderRadius: BorderRadius.circular(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Hình ảnh
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                  child: Image.asset(
                                    spot.imagePath,
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 150,
                                        color: Colors.grey[300],
                                        child: Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            color: Colors.grey[600],
                                            size: 50,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                // Thông tin địa điểm
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        spot.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.pink[800],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        spot.services,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on, size: 16, color: Colors.pink[400]),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              spot.address,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.access_time, size: 16, color: Colors.pink[400]),
                                          const SizedBox(width: 4),
                                          Text(
                                            spot.openingHours,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[800],
                                            ),
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
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}