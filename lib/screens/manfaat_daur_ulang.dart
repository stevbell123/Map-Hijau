import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecyclingBenefitsPage extends StatefulWidget {
  const RecyclingBenefitsPage({super.key});

  @override
  State<RecyclingBenefitsPage> createState() => _RecyclingBenefitsPageState();
}

class _RecyclingBenefitsPageState extends State<RecyclingBenefitsPage> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _showBanner = true;

  final List<Map<String, dynamic>> _benefits = [
    {
      'title': 'Hemat Energi',
      'icon': Icons.bolt,
      'color': Colors.amber,
      'facts': [
        'Daur ulang aluminium menghemat 95% energi',
        'Daur ulang kertas menghemat 40% energi',
        'Daur ulang plastik menghemat 70% energi'
      ],
      'detail': 'Proses daur ulang membutuhkan energi lebih sedikit dibanding memproduksi dari bahan mentah.'
    },
    {
      'title': 'Lingkungan Sehat',
      'icon': Icons.eco,
      'color': Colors.green,
      'facts': [
        'Mengurangi polusi udara 74%',
        'Mengurangi polusi air 35%',
        'Mengurangi kebutuhan TPA'
      ],
      'detail': 'Setiap ton kertas daur ulang menyelamatkan 17 pohon dan mengurangi emisi karbon.'
    },
    {
      'title': 'Ekonomi Berkelanjutan',
      'icon': Icons.attach_money,
      'color': Colors.blue,
      'facts': [
        'Menciptakan lapangan kerja',
        'Menghemat biaya produksi',
        'Meningkatkan nilai ekonomi sampah'
      ],
      'detail': 'Industri daur ulang menciptakan 10x lebih banyak pekerjaan per ton dibanding TPA.'
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && _showBanner) {
      setState(() => _showBanner = false);
    } else if (_scrollController.offset <= 100 && !_showBanner) {
      setState(() => _showBanner = true);
    }
  }

  void _showFactSheet(BuildContext context, Map<String, dynamic> benefit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  benefit['title'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              benefit['detail'],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Fakta Menarik:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...benefit['facts'].map<Widget>((fact) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.fact_check, color: Colors.green),
                  const SizedBox(width: 10),
                  Expanded(child: Text(fact)),
                ],
              ),
            )).toList(),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: benefit['color'],
              ),
              child: const Text('MENGERTI', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Manfaat Daur Ulang'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Aksi share
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'tips') {
                _showTipsDialog(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'tips',
                child: Text('Tips Daur Ulang'),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Energi', icon: Icon(Icons.bolt)),
            Tab(text: 'Lingkungan', icon: Icon(Icons.eco)),
            Tab(text: 'Ekonomi', icon: Icon(Icons.attach_money)),
          ],
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: Stack(
        children: [
          // Background Banner
          if (_showBanner)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[700]!, Colors.green[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'DAUR ULANG\nMENYELAMATKAN BUMI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          
          // Konten Utama
          Padding(
            padding: EdgeInsets.only(top: _showBanner ? 180 : 80),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBenefitsTab(0),
                _buildBenefitsTab(1),
                _buildBenefitsTab(2),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showImpactCalculator(context);
        },
        icon: const Icon(Icons.calculate),
        label: const Text('Hitung Dampak'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildBenefitsTab(int index) {
    final benefit = _benefits[index];
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: benefit['color'].withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(benefit['icon'], size: 50, color: benefit['color']),
                const SizedBox(height: 10),
                Text(
                  benefit['title'],
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: benefit['color'],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  benefit['detail'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Fakta Penting:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...benefit['facts'].map<Widget>((fact) => Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: Icon(Icons.check_circle, color: benefit['color']),
            title: Text(fact),
            onTap: () => _showFactSheet(context, benefit),
          ),
        )).toList(),
        const SizedBox(height: 20),
        Image.asset(
          'assets/images/recycling_impact_${index + 1}.jpg',
          height: 200,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  void _showTipsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tips Daur Ulang Efektif'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              ListTile(
                leading: Icon(Icons.check, color: Colors.green),
                title: Text('Cuci kemasan sebelum didaur ulang'),
              ),
              ListTile(
                leading: Icon(Icons.check, color: Colors.green),
                title: Text('Pisahkan berdasarkan jenis material'),
              ),
              ListTile(
                leading: Icon(Icons.check, color: Colors.green),
                title: Text('Gunakan tempat sampah terpisah'),
              ),
              ListTile(
                leading: Icon(Icons.check, color: Colors.green),
                title: Text('Cari bank sampah terdekat'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('TUTUP'),
          ),
        ],
      ),
    );
  }

  void _showImpactCalculator(BuildContext context) {
    int recycledItems = 1;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hitung Dampak Daur Ulang',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text('Berapa banyak barang yang sudah Anda daur ulang?'),
              const SizedBox(height: 10),
              Slider(
                value: recycledItems.toDouble(),
                min: 1,
                max: 100,
                divisions: 99,
                label: recycledItems.toString(),
                onChanged: (value) {
                  setState(() => recycledItems = value.toInt());
                },
              ),
              const SizedBox(height: 20),
              Card(
                color: Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'DAMPAK ANDA:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Anda telah menghemat ${recycledItems * 5} kWh energi',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Mengurangi ${recycledItems * 0.3} kg emisi karbon',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Menyelamatkan ${recycledItems * 0.02} pohon',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                ),
                child: const Text('TERIMA KASIH', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}