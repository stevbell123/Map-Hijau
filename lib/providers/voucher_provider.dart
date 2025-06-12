import 'package:flutter/material.dart';

class Voucher {
  final String title;
  final String description;
  final String expiryDate;
  final String code;
  final String category;
  final int price;

  Voucher({
    required this.title,
    required this.description,
    required this.expiryDate,
    required this.code,
    required this.category,
    required this.price,
  });

  Voucher copyWith({
    String? title,
    String? description,
    String? expiryDate,
    String? code,
    String? category,
    int? price,
  }) {
    return Voucher(
      title: title ?? this.title,
      description: description ?? this.description,
      expiryDate: expiryDate ?? this.expiryDate,
      code: code ?? this.code,
      category: category ?? this.category,
      price: price ?? this.price,
    );
  }
}

class VoucherProvider with ChangeNotifier {
List<Voucher> _availableVouchers = [
  Voucher(
    title: "Voucher GoFood 50%",
    description: "Diskon 50% untuk pembelian makanan minuman",
    expiryDate: "31 Desember 2023",
    code: "GOFOOD50",
    category: "Makanan",
    price: 500,
  ),
  Voucher(
    title: "Voucher GrabFood 30%",
    description: "Diskon 30% tanpa minimum pembelian",
    expiryDate: "15 Januari 2024",
    code: "GRABFOOD30",
    category: "Makanan",
    price: 400,
  ),
  Voucher(
    title: "Voucher Kopi Kenangan",
    description: "Gratis 1 kopi untuk pembelian ke-3",
    expiryDate: "28 Februari 2024",
    code: "KOPIKENANGAN1",
    category: "Makanan",
    price: 300,
  ),
  Voucher(
    title: "Voucher McD 25%",
    description: "Diskon 25% untuk menu McD pilihan",
    expiryDate: "10 Maret 2024",
    code: "MCD25",
    category: "Makanan",
    price: 600,
  ),
  Voucher(
    title: "Voucher Pizza Hut",
    description: "Potongan Rp 50.000 untuk pembelian minimal Rp 200.000",
    expiryDate: "20 April 2024",
    code: "PIZZA50",
    category: "Makanan",
    price: 800,
  ),
  Voucher(
    title: "Voucher Chatime B1G1",
    description: "Beli 1 gratis 1 minuman Chatime",
    expiryDate: "31 Mei 2024",
    code: "CHATIMEB1G1",
    category: "Makanan",
    price: 550,
  ),
  Voucher(
    title: "Voucher Tokopedia 20k",
    description: "Potongan harga Rp 20.000 untuk belanja online",
    expiryDate: "31 Januari 2024",
    code: "TOKOPEDIA20",
    category: "Belanja",
    price: 1000,
  ),
  Voucher(
    title: "Voucher Shopee Gratis Ongkir",
    description: "Gratis ongkir tanpa minimum belanja",
    expiryDate: "10 Maret 2024",
    code: "SHOPEEFREE",
    category: "Belanja",
    price: 700,
  ),
  Voucher(
    title: "Voucher Lazada 10%",
    description: "Diskon 10% untuk semua produk elektronik",
    expiryDate: "1 April 2024",
    code: "LAZADA10",
    category: "Belanja",
    price: 800,
  ),
  Voucher(
    title: "Voucher Zalora 15%",
    description: "Diskon 15% untuk semua produk fashion",
    expiryDate: "1 Mei 2024",
    code: "ZALORA15",
    category: "Belanja",
    price: 850,
  ),
  Voucher(
    title: "Voucher IKEA 5%",
    description: "Diskon 5% untuk pembelian furniture",
    expiryDate: "30 Juni 2024",
    code: "IKEA5",
    category: "Belanja",
    price: 900,
  ),
  Voucher(
    title: "Voucher Alfamart 10k",
    description: "Potongan Rp 10.000 di semua cabang Alfamart",
    expiryDate: "31 Juli 2024",
    code: "ALFA10",
    category: "Belanja",
    price: 600,
  ),
  Voucher(
    title: "Voucher GoRide 10k",
    description: "Potongan Rp 10.000 untuk perjalanan GoRide",
    expiryDate: "28 Februari 2024",
    code: "GORIDE10",
    category: "Transportasi",
    price: 750,
  ),
  Voucher(
    title: "Voucher Gojek 20%",
    description: "Diskon 20% untuk 3 perjalanan pertama",
    expiryDate: "30 Maret 2024",
    code: "GOJEK20",
    category: "Transportasi",
    price: 600,
  ),
  Voucher(
    title: "Voucher Bluebird Rp 15.000",
    description: "Diskon langsung Rp 15.000 untuk perjalanan taksi",
    expiryDate: "30 April 2024",
    code: "BLUEBIRD15",
    category: "Transportasi",
    price: 850,
  ),
  Voucher(
    title: "Voucher GrabBike 5k",
    description: "Potongan Rp 5.000 untuk pengguna baru",
    expiryDate: "15 Mei 2024",
    code: "GRAB5",
    category: "Transportasi",
    price: 400,
  ),
  Voucher(
    title: "Voucher TransJakarta",
    description: "Gratis naik TransJakarta 1 hari",
    expiryDate: "1 Juni 2024",
    code: "TJFREE1",
    category: "Transportasi",
    price: 300,
  ),
  Voucher(
    title: "Voucher Traveloka Rp 30.000",
    description: "Diskon perjalanan luar kota",
    expiryDate: "31 Agustus 2024",
    code: "TRAVEL30K",
    category: "Transportasi",
    price: 1000,
  ),
  Voucher(
    title: "Tumbler Eksklusif",
    description: "Tumbler ramah lingkungan dengan desain eksklusif",
    expiryDate: "30 Juni 2024",
    code: "TUMBLER123",
    category: "Lainnya",
    price: 1500,
  ),
  Voucher(
    title: "Merch Kaos Daur Ulang",
    description: "Kaos unik dari bahan daur ulang",
    expiryDate: "15 Mei 2024",
    code: "KAOSDAUR",
    category: "Lainnya",
    price: 2000,
  ),
  Voucher(
    title: "Totebag Eco Friendly",
    description: "Totebag stylish yang ramah lingkungan",
    expiryDate: "31 Juli 2024",
    code: "TOTEBAG123",
    category: "Lainnya",
    price: 1000,
  ),
  Voucher(
    title: "Voucher Donasi 10k",
    description: "Donasi ke lingkungan atau komunitas sosial",
    expiryDate: "30 April 2024",
    code: "DONASI10K",
    category: "Lainnya",
    price: 500,
  ),
  Voucher(
    title: "Sticker Ramah Lingkungan",
    description: "Sticker keren bertema eco-lifestyle",
    expiryDate: "10 Juni 2024",
    code: "STIKERECO",
    category: "Lainnya",
    price: 250,
  ),
  Voucher(
    title: "Notebook Daur Ulang",
    description: "Buku catatan dari kertas bekas berkualitas",
    expiryDate: "31 Agustus 2024",
    code: "NOTEBOOKECO",
    category: "Lainnya",
    price: 800,
  ),
];
  List<Voucher> _userVouchers = [];
  
  int _userCoins = 150000;

  List<Voucher> getAvailableVouchersByCategory(String category) {
    return _availableVouchers.where((v) => v.category == category).toList();
  }

  
  List<Voucher> get userVouchers => _userVouchers;

 
  int get userCoins => _userCoins;

  bool redeemVoucher(Voucher voucher) {
    if (_userCoins >= voucher.price) {
      _userCoins -= voucher.price;
      _userVouchers.add(voucher.copyWith());
      notifyListeners();
      return true;
    }
    return false;
  }

  void useVoucher(Voucher voucher) {
    _userVouchers.remove(voucher);
    notifyListeners();
  }

  static Color getCategoryColor(String category) {
    switch (category) {
      case "Makanan":
        return Colors.amber;
      case "Belanja":
        return Colors.amber;
      case "Transportasi":
        return Colors.amber;
      case "Lainnya":
        return Colors.amber;
      default:
        return Colors.amber;
    }
  }

  static IconData getCategoryIcon(String category) {
    switch (category) {
      case "Makanan":
        return Icons.fastfood;
      case "Belanja":
        return Icons.shopping_cart;
      case "Transportasi":
        return Icons.directions_car;
      case "Lainnya":
        return Icons.card_giftcard;
      default:
        return Icons.help_outline;
    }
  }
}