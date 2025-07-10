import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:io' show File, Platform;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(const MaterialApp(home: TempatSampahListScreen()));
}

class TempatSampah {
  final String nama;
  final String lokasi;
  final String assetPath;

  TempatSampah({required this.nama, required this.lokasi, required this.assetPath});
}

final List<TempatSampah> tempatSampahList = [
  TempatSampah(
    nama: 'TPS Tertutup',
    lokasi: 'Jalan Melati No. 1',
    assetPath: 'lib/assets/tps1.jpg',
  ),
  TempatSampah(
    nama: 'Tempat Pengolahan',
    lokasi: 'Jalan Kenanga No. 2',
    assetPath: 'lib/assets/tps2.jpg',
  ),
  TempatSampah(
    nama: 'TPA Taman Terjun',
    lokasi: 'Jalan Mawar No. 3',
    assetPath: 'lib/assets/tps3.jpg',
  ),
];

final List<Map<String, dynamic>> globalLaporanTerkirim = [];

class TempatSampahListScreen extends StatelessWidget {
  const TempatSampahListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        title: const Text('Tempat Sampah Sekitar'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF56B566), // Hijau kiri
                Color(0xFF10A893), // Hijau kanan
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.assignment_outlined),
            tooltip: 'Laporan Terkirim',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LaporanTerkirimScreen()),
              );
            },
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tempatSampahList.length,
        itemBuilder: (context, index) {
          final tempat = tempatSampahList[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.blue.shade800.withOpacity(0.7),
            margin: const EdgeInsets.only(bottom: 22),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SampahScreen(tempatSampah: tempat),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Image.asset(
                      tempat.assetPath,
                      width: double.infinity,
                      height: 170,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: double.infinity,
                        height: 170,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.delete, size: 48, color: Colors.grey),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tempat.nama,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.white70, size: 18),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                tempat.lokasi,
                                style: const TextStyle(color: Colors.white70),
                                overflow: TextOverflow.ellipsis,
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
    );
  }
}

class SampahScreen extends StatefulWidget {
  final TempatSampah tempatSampah;

  const SampahScreen({Key? key, required this.tempatSampah}) : super(key: key);

  @override
  SampahScreenState createState() => SampahScreenState();
}

class SampahScreenState extends State<SampahScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedWasteType;
  final List<dynamic> _pickedImages = [];
  int _currentCarouselIndex = 0;
  bool _isImageLoading = false;
  final ImagePicker _imagePicker = ImagePicker();
  final CarouselController _carouselController = CarouselController();

  final List<String> wasteTypes = [
    'Organik',
    'Plastik',
    'Kertas',
    'Logam',
    'Kaca',
    'B3 (Bahan Berbahaya)',
    'Lainnya'
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    _carouselController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime firstDate = DateTime(today.year, today.month, today.day);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: firstDate,
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _pickImages(ImageSource source) async {
    try {
      setState(() => _isImageLoading = true);
      final hasPermission = await _handleAllAndroidPermissions(source);
      if (!hasPermission) {
        _showSnackbar('Izin akses diperlukan', Colors.red);
        setState(() => _isImageLoading = false);
        return;
      }
      List<XFile>? pickedFiles;
      if (source == ImageSource.camera) {
        final XFile? cameraFile = await _imagePicker.pickImage(source: source);
        if (cameraFile != null) {
          pickedFiles = [cameraFile];
        }
      } else {
        pickedFiles = await _imagePicker.pickMultiImage();
      }
      if (pickedFiles == null || pickedFiles.isEmpty) {
        _showSnackbar('Tidak ada gambar yang dipilih.', Colors.red);
        setState(() => _isImageLoading = false);
        return;
      }
      final validImages = await _processImages(pickedFiles);
      if (validImages.isEmpty) {
        _showSnackbar('Gambar tidak valid atau gagal diproses.', Colors.red);
        setState(() => _isImageLoading = false);
        return;
      }
      setState(() => _pickedImages.addAll(validImages));
    } on PlatformException catch (e) {
      _showSnackbar('Error: ${e.message}', Colors.red);
      debugPrint('PlatformException: $e');
    } catch (e) {
      _showSnackbar('Terjadi kesalahan: $e', Colors.red);
      debugPrint('Error: $e');
    } finally {
      setState(() => _isImageLoading = false);
    }
  }

  /// Permission handler yang benar untuk SEMUA versi Android & iOS
  Future<bool> _handleAllAndroidPermissions(ImageSource source) async {
    if (kIsWeb) return true;
    if (Platform.isAndroid) {
      if (source == ImageSource.camera) {
        final cameraStatus = await Permission.camera.request();
        if (cameraStatus.isGranted) return true;
        if (cameraStatus.isPermanentlyDenied) await openAppSettings();
        return false;
      } else {
        // Android 13+ pakai photos, Android 12- pakai storage. Cek dua-duanya.
        final photosStatus = await Permission.photos.request();
        if (photosStatus.isGranted) return true;
        final storageStatus = await Permission.storage.request();
        if (storageStatus.isGranted) return true;
        if (photosStatus.isPermanentlyDenied || storageStatus.isPermanentlyDenied) {
          await openAppSettings();
        }
        return false;
      }
    } else if (Platform.isIOS) {
      final photosStatus = await Permission.photos.request();
      if (photosStatus.isGranted) return true;
      if (photosStatus.isPermanentlyDenied) await openAppSettings();
      return false;
    }
    return false;
  }

  Future<List<dynamic>> _processImages(List<XFile> xFiles) async {
    final List<dynamic> validImages = [];
    for (var xFile in xFiles) {
      try {
        if (kIsWeb) {
          if (xFile.path.isNotEmpty) validImages.add(xFile);
        } else {
          final file = File(xFile.path);
          if (await file.exists() && await file.length() > 0) {
            validImages.add(file);
          }
        }
      } catch (e) {
        debugPrint('Image validation error: $e');
      }
    }
    return validImages;
  }

  void _removeImage(int index) {
    setState(() {
      _pickedImages.removeAt(index);
      if (_currentCarouselIndex >= _pickedImages.length) {
        _currentCarouselIndex = _pickedImages.length - 1;
      }
    });
  }

  void _submitReport() {
    if (_selectedWasteType == null) {
      _showSnackbar('Pilih jenis sampah terlebih dahulu', Colors.red);
      return;
    }
    if (_pickedImages.isEmpty) {
      _showSnackbar('Tambahkan minimal satu foto', Colors.red);
      return;
    }

    final reportData = {
      'tempatSampah': widget.tempatSampah.nama,
      'lokasi': widget.tempatSampah.lokasi,
      'date': _selectedDate == null
          ? 'Tanpa tanggal'
          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
      'time': _selectedTime?.format(context) ?? 'Tanpa waktu',
      'wasteType': _selectedWasteType,
      'description': _descriptionController.text,
      'imageCount': _pickedImages.length,
      'images': List.from(_pickedImages),
    };

    setState(() {
      globalLaporanTerkirim.add(reportData);
      _selectedDate = null;
      _selectedTime = null;
      _selectedWasteType = null;
      _pickedImages.clear();
      _descriptionController.clear();
    });

    _showSnackbar('Laporan berhasil dikirim!', Colors.green);

    Future.delayed(const Duration(milliseconds: 600), () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LaporanTerkirimScreen()));
    });
  }

  Widget _buildImageCarousel() {
    return Column(
      children: [
        Container(
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.blue.shade800.withOpacity(0.3),
          ),
          child: _pickedImages.isEmpty
              ? _buildEmptyState()
              : CarouselSlider.builder(
                  itemCount: _pickedImages.length,
                  itemBuilder: (context, index, _) {
                    return _buildImageItem(_pickedImages[index], index);
                  },
                  options: CarouselOptions(
                    height: 220,
                    viewportFraction: 0.9,
                    autoPlay: _pickedImages.length > 1,
                    enlargeCenterPage: true,
                    onPageChanged: (index, _) =>
                        setState(() => _currentCarouselIndex = index),
                  ),
                ),
        ),
        if (_pickedImages.length > 1) _buildCarouselIndicator(),
      ],
    );
  }

  Widget _buildImageItem(dynamic image, int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: kIsWeb
              ? Image.network(
                  image.path,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildErrorWidget(),
                )
              : Image.file(
                  image as File,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildErrorWidget(),
                ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _pickedImages.asMap().entries.map((entry) {
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentCarouselIndex == entry.key
                  ? Colors.white
                  : Colors.white.withOpacity(0.4),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return GestureDetector(
      onTap: () => _showImageSourceDialog(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: 50,
              color: Colors.white.withOpacity(0.7),
            ),
            const SizedBox(height: 12),
            Text(
              'Ketuk untuk menambahkan foto',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
            if (_isImageLoading) ...[
              const SizedBox(height: 12),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _showImageSourceDialog() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Sumber Gambar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source != null) {
      await _pickImages(source);
    }
  }

  Widget _buildImageButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: const Text('Kamera'),
            onPressed: () => _pickImages(ImageSource.camera),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade800,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 50),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.photo_library),
            label: const Text('Galeri'),
            onPressed: () => _pickImages(ImageSource.gallery),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 50),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 40),
            SizedBox(height: 8),
            Text('Gagal memuat gambar', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.fixed,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        title: const Text('Lapor Sampah', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF56B566), // Hijau kiri
                Color(0xFF10A893), // Hijau kanan
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.blue.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.tempatSampah.assetPath,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 48,
                      height: 48,
                      color: Colors.grey.shade300,
                      child: Icon(Icons.delete, color: Colors.grey),
                    ),
                  ),
                ),
                title: Text(
                  widget.tempatSampah.nama,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white70, size: 16),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        widget.tempatSampah.lokasi,
                        style: const TextStyle(color: Colors.white70),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                contentPadding: const EdgeInsets.all(8),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade800.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(
                        _selectedDate == null
                            ? 'Pilih Tanggal'
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing:
                          const Icon(Icons.calendar_today, color: Colors.white),
                      onTap: () => _selectDate(context),
                    ),
                  ),
                  Container(
                      height: 40,
                      width: 1,
                      color: Colors.white.withOpacity(0.3)),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        _selectedTime == null
                            ? 'Pilih Waktu'
                            : _selectedTime!.format(context),
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing:
                          const Icon(Icons.access_time, color: Colors.white),
                      onTap: () => _selectTime(context),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Jenis Sampah:',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade800.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedWasteType,
                dropdownColor: Colors.blue.shade800,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                style: const TextStyle(color: Colors.white),
                items: wasteTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedWasteType = value),
                hint: const Text(
                  'Pilih jenis sampah',
                  style: TextStyle(color: Colors.white70),
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Foto Sampah:',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildImageCarousel(),
            const SizedBox(height: 10),
            _buildImageButtons(),
            const SizedBox(height: 20),
            const Text(
              'Deskripsi:',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade800.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _descriptionController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Tambahkan deskripsi...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent.shade400,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Kirim Laporan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LaporanTerkirimScreen extends StatelessWidget {
  const LaporanTerkirimScreen({Key? key}) : super(key: key);

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 40),
            SizedBox(height: 8),
            Text('Gagal memuat gambar', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        title: const Text('Laporan Terkirim'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: globalLaporanTerkirim.isEmpty
            ? Center(
                child: Text(
                  'Belum ada laporan terkirim.',
                  style: TextStyle(color: Colors.white.withOpacity(0.8)),
                ),
              )
            : ListView.builder(
                itemCount: globalLaporanTerkirim.length,
                itemBuilder: (context, index) {
                  final data = globalLaporanTerkirim[index];
                  final images = data['images'] as List;
                  return Card(
                    color: Colors.blue.shade800.withOpacity(0.7),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (data['date'] ?? '') + ' | ' + (data['time'] ?? ''),
                            style: const TextStyle(color: Colors.white70),
                          ),
                          Text(
                            "Lokasi: ${data['tempatSampah']}",
                            style: const TextStyle(color: Colors.white70),
                          ),
                          Text(
                            "Alamat: ${data['lokasi']}",
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          Text(
                            "Jenis: ${data['wasteType']}",
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            data['description'] ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 80,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: images.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 8),
                              itemBuilder: (context, idx) {
                                final img = images[idx];
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: kIsWeb
                                      ? Image.network(img.path, width: 80, height: 80, fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => _buildErrorWidget())
                                      : Image.file(img, width: 80, height: 80, fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => _buildErrorWidget()),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}