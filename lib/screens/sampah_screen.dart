import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class SampahScreen extends StatefulWidget {
  const SampahScreen({Key? key}) : super(key: key);

  @override
  _SampahScreenState createState() => _SampahScreenState();
}

class _SampahScreenState extends State<SampahScreen> {
  final Location _locationController = Location();
  LatLng? _currentPosition;
  File? _selectedImage;
  bool _showNearestOnly = false;
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _dumpLocations = [
    {
      'id': '1',
      'name': 'TPS Amplas',
      'location': const LatLng(3.5637, 98.6806),
      'address': 'Jl. Amplas, Medan Amplas',
      'type': 'organik',
      'image': 'assets/tps1.jpg',
      'capacity': '10 ton/hari',
      'distance': '1.2 km'
    },
    {
      'id': '2',
      'name': 'TPS Helvetia',
      'location': const LatLng(3.5894, 98.6473),
      'address': 'Jl. Helvetia, Medan Helvetia',
      'type': 'anorganik',
      'image': 'assets/tps2.jpg',
      'capacity': '8 ton/hari',
      'distance': '3.5 km'
    },
    {
      'id': '3',
      'name': 'TPS Padang Bulan',
      'location': const LatLng(3.5749, 98.6647),
      'address': 'Jl. Padang Bulan, Medan Petisah',
      'type': 'B3',
      'image': 'assets/tps3.jpg',
      'capacity': '5 ton/hari',
      'distance': '2.1 km'
    },
    {
      'id': '4',
      'name': 'TPS Belawan',
      'location': const LatLng(3.7750, 98.6831),
      'address': 'Jl. Belawan, Medan Belawan',
      'type': 'organik',
      'image': 'assets/tps4.jpg',
      'capacity': '12 ton/hari',
      'distance': '15.7 km'
    },
    {
      'id': '5',
      'name': 'TPS Medan Johor',
      'location': const LatLng(3.5264, 98.6611),
      'address': 'Jl. Johor, Medan Johor',
      'type': 'anorganik',
      'image': 'assets/tps5.jpg',
      'capacity': '7 ton/hari',
      'distance': '5.3 km'
    },
    {
      'id': '6',
      'name': 'TPS Medan Polonia',
      'location': const LatLng(3.5581, 98.6717),
      'address': 'Jl. Polonia, Medan Polonia',
      'type': 'organik',
      'image': 'assets/tps6.jpg',
      'capacity': '6 ton/hari',
      'distance': '1.8 km'
    },
    {
      'id': '7',
      'name': 'TPS Medan Tembung',
      'location': const LatLng(3.6167, 98.7167),
      'address': 'Jl. Tembung, Medan Tembung',
      'type': 'anorganik',
      'image': 'assets/tps7.jpg',
      'capacity': '9 ton/hari',
      'distance': '7.4 km'
    },
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) {
        print("Service lokasi tidak diaktifkan.");
        setState(() => _isLoading = false);
        return;
      }
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Permission lokasi ditolak.");
        setState(() => _isLoading = false);
        return;
      }
    }

    try {
      final locationData = await _locationController.getLocation();
      print("Lokasi didapat: ${locationData.latitude}, ${locationData.longitude}");

      setState(() {
        _currentPosition = LatLng(locationData.latitude!, locationData.longitude!);
        _isLoading = false;
      });
    } catch (e) {
      print("Gagal ambil lokasi: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _showLocationDetails(Map<String, dynamic> location) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location['name'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  location['address'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _getMarkerColor(location['type']),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Jenis: ${_getTypeName(location['type'])}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Kapasitas: ${location['capacity']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Jarak: ${location['distance']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300],
                    image: DecorationImage(
                      image: AssetImage(location['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('TUTUP'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getMarkerColor(String type) {
    switch (type) {
      case 'organik': return Colors.green;
      case 'anorganik': return Colors.orange;
      case 'B3': return Colors.red;
      default: return Colors.blue;
    }
  }

  String _getTypeName(String type) {
    switch (type) {
      case 'organik': return 'Sampah Organik';
      case 'anorganik': return 'Sampah Anorganik';
      case 'B3': return 'Sampah B3 (Bahan Berbahaya)';
      default: return 'Sampah Umum';
    }
  }

  void _toggleNearestOnly() {
    setState(() {
      _showNearestOnly = !_showNearestOnly;
    });
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cari TPS'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Masukkan nama atau alamat TPS',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cari'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLocationCard(Map<String, dynamic> location) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getMarkerColor(location['type']),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              location['type'] == 'organik' ? 'O' : 
              location['type'] == 'anorganik' ? 'A' : 'B',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          location['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(location['address']),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.directions_walk, size: 16),
                const SizedBox(width: 4),
                Text(location['distance']),
                const Spacer(),
                Text('${location['capacity']}'),
              ],
            ),
          ],
        ),
        onTap: () => _showLocationDetails(location),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLegendItem(Colors.green, 'Organik'),
            const SizedBox(width: 16),
            _buildLegendItem(Colors.orange, 'Anorganik'),
            const SizedBox(width: 16),
            _buildLegendItem(Colors.red, 'B3'),
            const SizedBox(width: 16),
            FilterChip(
              label: Text(_showNearestOnly ? 'Semua TPS' : 'Terdekat'),
              selected: _showNearestOnly,
              onSelected: (selected) {
                setState(() {
                  _showNearestOnly = selected;
                });
              },
              selectedColor: Colors.green[200],
              checkmarkColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getFilteredLocations() {
    List<Map<String, dynamic>> filtered = _dumpLocations;

    // Filter berdasarkan jarak
    if (_showNearestOnly) {
      filtered = filtered.where((loc) => double.parse(loc['distance'].split(' ')[0]) < 5).toList();
    }

    // Filter berdasarkan pencarian
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((loc) =>
          loc['name'].toLowerCase().contains(_searchQuery) ||
          loc['address'].toLowerCase().contains(_searchQuery)).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filteredLocations = _getFilteredLocations();

    return Scaffold(
      appBar: AppBar(
        title: const Text('TPS di Medan'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Mengambil lokasi Anda...'),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildLegend(),
                ),
                Expanded(
                  child: filteredLocations.isEmpty
                      ? const Center(
                          child: Text('Tidak ada TPS yang ditemukan'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: filteredLocations.length,
                          itemBuilder: (context, index) {
                            return _buildLocationCard(filteredLocations[index]);
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          ActionButton(
            onPressed: () {
              // Refresh location
              setState(() {
                _isLoading = true;
              });
              _getUserLocation();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Lokasi',
          ),
          ActionButton(
            onPressed: _pickImage,
            icon: const Icon(Icons.camera_alt),
            tooltip: 'Ambil Foto',
          ),
          ActionButton(
            onPressed: _showSearchDialog,
            icon: const Icon(Icons.search),
            tooltip: 'Cari TPS',
          ),
        ],
      ),
    );
  }
}

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> {
  late bool _open;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
  }

  void _toggle() {
    setState(() {
      _open = !_open;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return AnimatedOpacity(
      opacity: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      child: SizedBox(
        width: 56,
        height: 56,
        child: Center(
          child: Material(
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            elevation: 4,
            child: InkWell(
              onTap: _toggle,
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _open ? 1 : 0,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: FloatingActionButton(
          onPressed: _toggle,
          backgroundColor: Colors.green[700],
          child: const Icon(Icons.menu, color: Colors.white),
        ),
      ),
    );
  }
}

class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final double progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final offset = Offset.fromDirection(
      directionInDegrees * (3.141592653589793 / 180.0),
      progress * maxDistance,
    );
    
    return Positioned(
      right: 4 + offset.dx,
      bottom: 4 + offset.dy,
      child: Transform.rotate(
        angle: (1.0 - progress) * 3.141592653589793 / 2,
        child: child,
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.tooltip,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: Colors.green[600],
      elevation: 4,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: Colors.white,
        tooltip: tooltip,
      ),
    );
  }
}