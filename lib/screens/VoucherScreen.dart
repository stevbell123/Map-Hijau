import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/voucher_provider.dart';

class VoucherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final voucherProvider = Provider.of<VoucherProvider>(context);
    final vouchers = voucherProvider.userVouchers;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Voucher Saya"),
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
      ),
      body: vouchers.isEmpty
          ? const Center(
              child: Text(
                "Anda belum memiliki voucher",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vouchers.length,
              itemBuilder: (context, index) {
                return _buildVoucherCard(context, vouchers[index]);
              },
            ),
    );
  }

  Widget _buildVoucherCard(BuildContext context, Voucher voucher) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              voucher.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              voucher.description,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            Text(
              "Berlaku hingga: ${voucher.expiryDate}",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Kode Voucher: ${voucher.code}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showVoucherDialog(context, voucher);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Gunakan",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showVoucherDialog(BuildContext context, Voucher voucher) {
    final voucherProvider = Provider.of<VoucherProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Gunakan Voucher"),
          content: Text("Apakah Anda yakin ingin menggunakan voucher ${voucher.title}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                voucherProvider.useVoucher(voucher);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Voucher ${voucher.title} berhasil digunakan!"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text("Gunakan", style: TextStyle(color: Colors.blue.shade900)),
            ),
          ],
        );
      },
    );
  }
}