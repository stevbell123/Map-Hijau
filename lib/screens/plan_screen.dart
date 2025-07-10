import 'package:flutter/material.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  List<WastePlan> plans = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.blue.shade800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Rencana Sampah',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: plans.isEmpty ? _buildEmptyState() : _buildPlanList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPlanDialog(),
        backgroundColor: Colors.green,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          'Buat Rencana',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.event_note,
                size: 80,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Rencana kamu masih belum ada nih, mau buat dulu?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showAddPlanDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              icon: Icon(Icons.add, color: Colors.white),
              label: Text(
                'Buat Rencana Pertama',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 8,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getWasteTypeIcon(plan.wasteType),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    plan.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        plan.description,
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.schedule, color: Colors.white70, size: 16),
                          SizedBox(width: 4),
                          Text(
                            '${plan.scheduledDate.day}/${plan.scheduledDate.month}/${plan.scheduledDate.year} - ${plan.scheduledTime.format(context)}',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: Colors.white),
                    onSelected: (value) {
                      if (value == 'complete') {
                        _completePlan(index);
                      } else if (value == 'edit') {
                        _showEditPlanDialog(index);
                      } else if (value == 'delete') {
                        _deletePlan(index);
                      }
                    },
                    itemBuilder:
                        (context) => [
                          if (!plan.isCompleted)
                            PopupMenuItem(
                              value: 'complete',
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green),
                                  SizedBox(width: 8),
                                  Text('Selesai'),
                                ],
                              ),
                            ),
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Hapus'),
                              ],
                            ),
                          ),
                        ],
                  ),
                ),
                if (!plan.isCompleted)
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Status Rencana',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: plan.isCompleted,
                                  onChanged: (bool? value) {
                                    if (value == true) {
                                      _completePlan(index);
                                    }
                                  },
                                  activeColor: Colors.white,
                                  checkColor: Colors.green,
                                  side: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                Text(
                                  'Selesai',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Centang kotak di atas untuk menandai rencana selesai',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                if (plan.isCompleted)
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Rencana Selesai!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddPlanDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AddEditPlanDialog(
            onPlanSaved: (plan) {
              setState(() {
                plans.add(plan);
              });
            },
          ),
    );
  }

  void _showEditPlanDialog(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AddEditPlanDialog(
            existingPlan: plans[index],
            onPlanSaved: (plan) {
              setState(() {
                plans[index] = plan;
              });
            },
          ),
    );
  }

  void _completePlan(int index) {
    setState(() {
      plans[index].isCompleted = true;
    });
    _showCompletionDialog(plans[index].title);
  }

  void _deletePlan(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Hapus Rencana'),
            content: Text('Apakah Anda yakin ingin menghapus rencana ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    plans.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void _showCompletionDialog(String planTitle) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.celebration, color: Colors.green),
                SizedBox(width: 8),
                Text('Selamat!'),
              ],
            ),
            content: Text(
              'Rencana "$planTitle" telah selesai! Sering-Sering buang sampah ya.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  IconData _getWasteTypeIcon(String wasteType) {
    switch (wasteType) {
      case 'Organik':
        return Icons.eco;
      case 'Anorganik':
        return Icons.delete;
      case 'Kertas':
        return Icons.description;
      case 'Plastik':
        return Icons.local_drink;
      case 'Logam':
        return Icons.build;
      default:
        return Icons.delete_outline;
    }
  }
}

class AddEditPlanDialog extends StatefulWidget {
  final Function(WastePlan) onPlanSaved;
  final WastePlan? existingPlan;

  const AddEditPlanDialog({
    super.key,
    required this.onPlanSaved,
    this.existingPlan,
  });

  @override
  _AddEditPlanDialogState createState() => _AddEditPlanDialogState();
}

class _AddEditPlanDialogState extends State<AddEditPlanDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedWasteType = 'Organik';
  double _estimatedAmount = 1.0;

  final List<String> _wasteTypes = [
    'Organik',
    'Anorganik',
    'Kertas',
    'Plastik',
    'Logam',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingPlan != null) {
      _titleController.text = widget.existingPlan!.title;
      _descriptionController.text = widget.existingPlan!.description;
      _selectedDate = widget.existingPlan!.scheduledDate;
      _selectedTime = widget.existingPlan!.scheduledTime;
      _selectedWasteType = widget.existingPlan!.wasteType;
      _estimatedAmount = widget.existingPlan!.estimatedAmount;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingPlan != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.blue.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Edit Rencana' : 'Buat Rencana Baru',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _titleController,
                label: 'Judul Rencana',
                icon: Icons.title,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Deskripsi',
                icon: Icons.description,
                maxLines: 3,
              ),
              SizedBox(height: 16),
              _buildDropdown(),
              SizedBox(height: 16),
              _buildDateTimePicker(),
              SizedBox(height: 16),
              _buildAmountSlider(),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Batal',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _savePlan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      isEditing ? 'Simpan Perubahan' : 'Buat Rencana',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.green, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipe Sampah',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(15),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedWasteType,
              isExpanded: true,
              dropdownColor: Colors.blue.shade800,
              style: TextStyle(color: Colors.white),
              icon: Icon(Icons.arrow_drop_down, color: Colors.white70),
              items:
                  _wasteTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Row(
                        children: [
                          Icon(
                            _getWasteTypeIcon(type),
                            color: Colors.white70,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(type),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedWasteType = newValue!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jadwal',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Card(
                color: Colors.white.withOpacity(0.1),
                child: ListTile(
                  leading: Icon(Icons.calendar_today, color: Colors.white70),
                  title: Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }
                  },
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Card(
                color: Colors.white.withOpacity(0.1),
                child: ListTile(
                  leading: Icon(Icons.access_time, color: Colors.white70),
                  title: Text(
                    _selectedTime.format(context),
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime,
                    );
                    if (time != null) {
                      setState(() {
                        _selectedTime = time;
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmountSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Estimasi Jumlah (kg)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                '${_estimatedAmount.toStringAsFixed(1)} kg',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          'Perkiraan berat sampah dalam kilogram',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.green,
            inactiveTrackColor: Colors.white.withOpacity(0.3),
            thumbColor: Colors.green,
            overlayColor: Colors.green.withOpacity(0.2),
          ),
          child: Slider(
            value: _estimatedAmount,
            min: 0.1,
            max: 10.0,
            divisions: 99,
            onChanged: (value) {
              setState(() {
                _estimatedAmount = value;
              });
            },
          ),
        ),
      ],
    );
  }

  void _savePlan() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Judul rencana tidak boleh kosong')),
      );
      return;
    }

    final plan = WastePlan(
      title: _titleController.text,
      description: _descriptionController.text,
      wasteType: _selectedWasteType,
      scheduledDate: _selectedDate,
      scheduledTime: _selectedTime,
      estimatedAmount: _estimatedAmount,
      isCompleted: widget.existingPlan?.isCompleted ?? false,
    );

    widget.onPlanSaved(plan);
    Navigator.pop(context);
  }

  IconData _getWasteTypeIcon(String wasteType) {
    switch (wasteType) {
      case 'Organik':
        return Icons.eco;
      case 'Anorganik':
        return Icons.delete;
      case 'Kertas':
        return Icons.description;
      case 'Plastik':
        return Icons.local_drink;
      case 'Logam':
        return Icons.build;
      default:
        return Icons.delete_outline;
    }
  }
}

class WastePlan {
  String title;
  String description;
  String wasteType;
  DateTime scheduledDate;
  TimeOfDay scheduledTime;
  double estimatedAmount;
  bool isCompleted;

  WastePlan({
    required this.title,
    required this.description,
    required this.wasteType,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.estimatedAmount,
    this.isCompleted = false,
  });
}