import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/voucher_provider.dart';

class CoinScreen extends StatelessWidget {
  const CoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Coin Rewards"),
          backgroundColor: const Color(0xFF4CAF50),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Makanan"),
              Tab(text: "Belanja"),
              Tab(text: "Transportasi"),
              Tab(text: "Lainnya"),
            ],
            indicatorColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
        body: Consumer<VoucherProvider>(
          builder: (context, voucherProvider, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildCoinBalance(voucherProvider.userCoins),
                  const SizedBox(height: 20),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildVoucherList(context, "Makanan"),
                        _buildVoucherList(context, "Belanja"),
                        _buildVoucherList(context, "Transportasi"),
                        _buildVoucherList(context, "Lainnya"),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCoinBalance(int coins) {
    return Center(
      child: Column(
        children: [
          const Text(
            "Total Koin Kamu",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.monetization_on,
              size: 50,
              color: Colors.yellow,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "$coins",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherList(BuildContext context, String category) {
    final voucherProvider = Provider.of<VoucherProvider>(
      context,
      listen: false,
    );
    final vouchers = voucherProvider.getAvailableVouchersByCategory(category);

    return ListView.builder(
      itemCount: vouchers.length,
      itemBuilder: (context, index) {
        final voucher = vouchers[index];
        return _buildRewardItem(context, voucher);
      },
    );
  }

  Widget _buildRewardItem(BuildContext context, Voucher voucher) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE8F5E9),
          child: Icon(
            VoucherProvider.getCategoryIcon(voucher.category),
            color: const Color(0xFF4CAF50),
          ),
        ),
        title: Text(
          voucher.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${voucher.price} Koin"),
        trailing: ElevatedButton(
          onPressed: () => _showRedeemDialog(context, voucher),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: const Text("Tukar", style: TextStyle(fontSize: 14)),
        ),
      ),
    );
  }

  void _showRedeemDialog(BuildContext context, Voucher voucher) {
    final voucherProvider = Provider.of<VoucherProvider>(
      context,
      listen: false,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Penukaran"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Anda akan menukarkan ${voucher.price} Koin untuk:"),
              const SizedBox(height: 8),
              Text(
                voucher.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text("Koin Anda: ${voucherProvider.userCoins}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                final success = voucherProvider.redeemVoucher(voucher);
                Navigator.of(context).pop();
                _showResultDialog(context, success, voucher);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
              ),
              child: const Text("Tukar"),
            ),
          ],
        );
      },
    );
  }

  void _showResultDialog(BuildContext context, bool success, Voucher voucher) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(success ? "Penukaran Berhasil!" : "Koin Tidak Cukup"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                success ? Icons.check_circle : Icons.error,
                color: success ? Colors.green : Colors.red,
                size: 50,
              ),
              const SizedBox(height: 16),
              Text(
                success
                    ? "Voucher ${voucher.title} berhasil ditukarkan!"
                    : "Maaf, koin Anda tidak cukup untuk menukar voucher ini.",
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Tutup"),
            ),
          ],
        );
      },
    );
  }
}
