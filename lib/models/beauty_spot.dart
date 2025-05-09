class BeautySpot {
  final String name;
  final String address;
  final String description;
  final String services;
  final String phone;
  final String imagePath;
  final String openingHours;
  final String priceRange;

  BeautySpot({
    required this.name,
    required this.address,
    required this.description,
    required this.services,
    required this.phone,
    required this.imagePath,
    required this.openingHours,
    required this.priceRange,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
        'description': description,
        'services': services,
        'phone': phone,
        'imagePath': imagePath,
        'openingHours': openingHours,
        'priceRange': priceRange,
      };

  static BeautySpot fromJson(Map<String, dynamic> json) => BeautySpot(
        name: json['name'] as String? ?? '',
        address: json['address'] as String? ?? '',
        description: json['description'] as String? ?? '',
        services: json['services'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        imagePath: json['imagePath'] as String? ?? '',
        openingHours: json['openingHours'] as String? ?? '',
        priceRange: json['priceRange'] as String? ?? '',
      );
}

final List<BeautySpot> beautySpots = [
  BeautySpot(
    name: "Spa Hạnh Phúc",
    address: "123 Đường Láng, Hà Nội",
    description: "Spa thư giãn cao cấp",
    services: "Massage, chăm sóc da",
    phone: "0123456789",
    imagePath: "assets/mobi1.jpg",
    openingHours: "8:00 - 20:00",
    priceRange: "200k - 500k",
  ),
  BeautySpot(
    name: "Salon Tóc Xinh",
    address: "45 Nguyễn Trãi, TP.HCM",
    description: "Cắt tóc và nhuộm chuyên nghiệp",
    services: "Tóc, nail",
    phone: "0987654321",
    imagePath: "assets/mobi2.jpg",
    openingHours: "9:00 - 19:00",
    priceRange: "150k - 300k",
  ),
  BeautySpot(
    name: "Spa Bình Yên",
    address: "78 Nguyễn Huệ, Huế",
    description: "Spa thư giãn với không gian yên tĩnh",
    services: "Massage, xông hơi",
    phone: "0912345678",
    imagePath: "assets/mobi3.jpg",
    openingHours: "7:00 - 19:00",
    priceRange: "250k - 600k",
  ),
  BeautySpot(
    name: "Spa Thiên Nhiên",
    address: "56 Lê Lợi, Đà Nẵng",
    description: "Spa sử dụng sản phẩm thiên nhiên",
    services: "Massage, chăm sóc da, tẩy tế bào chết",
    phone: "0935123456",
    imagePath: "assets/mobi4.jpg",
    openingHours: "9:00 - 21:00",
    priceRange: "300k - 700k",
  ),
  BeautySpot(
    name: "Salon Tóc Đẹp",
    address: "12 Trần Phú, Nha Trang",
    description: "Dịch vụ làm tóc chuyên nghiệp",
    services: "Tóc, uốn, nhuộm",
    phone: "0978123456",
    imagePath: "assets/mobi5.jpg",
    openingHours: "8:00 - 18:00",
    priceRange: "100k - 400k",
  ),
  BeautySpot(
    name: "Salon Nail & Hair",
    address: "89 Phạm Văn Đồng, Cần Thơ",
    description: "Dịch vụ làm tóc và nail cao cấp",
    services: "Tóc, nail, gội đầu thư giãn",
    phone: "0945123789",
    imagePath: "assets/mobi6.jpg",
    openingHours: "10:00 - 20:00",
    priceRange: "200k - 450k",
  ),
  BeautySpot(
    name: "Spa Ánh Sáng",
    address: "34 Nguyễn Văn Cừ, Hải Phòng",
    description: "Spa thư giãn với ánh sáng tự nhiên",
    services: "Massage, chăm sóc da, yoga",
    phone: "0923456789",
    imagePath: "assets/mobi7.jpg",
    openingHours: "8:00 - 22:00",
    priceRange: "250k - 550k",
  ),
  BeautySpot(
    name: "Salon Tóc Mới",
    address: "67 Lê Đại Hành, Vinh",
    description: "Dịch vụ làm tóc hiện đại",
    services: "Tóc, uốn, nhuộm, chăm sóc tóc",
    phone: "0967123456",
    imagePath: "assets/mobi8.jpg",
    openingHours: "9:00 - 19:00",
    priceRange: "120k - 350k",
  ),
  BeautySpot(
    name: "Spa Hoa Sen",
    address: "101 Lý Thường Kiệt, Đà Lạt",
    description: "Spa thư giãn với không gian hoa sen",
    services: "Massage, xông hơi, chăm sóc da",
    phone: "0905123456",
    imagePath: "assets/mobi9.jpg",
    openingHours: "7:00 - 20:00",
    priceRange: "200k - 600k",
  ),
  BeautySpot(
    name: "Salon Tóc Sang Trọng",
    address: "23 Nguyễn Thị Minh Khai, Vũng Tàu",
    description: "Dịch vụ làm tóc cao cấp",
    services: "Tóc, nail, uốn, nhuộm",
    phone: "0956123456",
    imagePath: "assets/mobi10.jpg",
    openingHours: "10:00 - 21:00",
    priceRange: "200k - 500k",
  ),
  BeautySpot(
    name: "Spa Tâm An",
    address: "45 Hùng Vương, Quy Nhơn",
    description: "Spa thư giãn với không gian yên bình",
    services: "Massage, chăm sóc da, tẩy tế bào chết",
    phone: "0916123456",
    imagePath: "assets/mobi11.jpg",
    openingHours: "8:00 - 20:00",
    priceRange: "250k - 650k",
  ),
  BeautySpot(
    name: "Salon Tóc Phong Cách",
    address: "78 Nguyễn Đình Chiểu, Biên Hòa",
    description: "Dịch vụ làm tóc phong cách trẻ trung",
    services: "Tóc, uốn, nhuộm, gội đầu",
    phone: "0936123456",
    imagePath: "assets/mobi12.jpg",
    openingHours: "9:00 - 19:00",
    priceRange: "150k - 400k",
  ),
];