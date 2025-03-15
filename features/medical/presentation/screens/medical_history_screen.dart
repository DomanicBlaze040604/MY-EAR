import 'package:flutter/material.dart';
import '../../domain/entities/medical_record.dart';
import '../widgets/record_card.dart';
import '../widgets/filter_chip_group.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({Key? key}) : super(key: key);

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  RecordType? _selectedType;
  String? _searchQuery;
  List<MedicalRecord> _records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    try {
      setState(() => _isLoading = true);
      // Implement actual data fetching
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _records = _getMockRecords(); // Replace with actual records
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to load medical records');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: _uploadRecord,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildRecordsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewRecord,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search medical records...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          FilterChipGroup(
            selectedType: _selectedType,
            onSelected: (type) {
              setState(() {
                _selectedType = type;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsList() {
    final filteredRecords = _filterRecords();

    if (filteredRecords.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.medical_services_outlined, size: 64),
            const SizedBox(height: 16),
            Text(
              'No medical records found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _addNewRecord,
              child: const Text('Add New Record'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: filteredRecords.length,
      itemBuilder: (context, index) {
        return RecordCard(
          record: filteredRecords[index],
          onTap: () => _viewRecord(filteredRecords[index]),
        );
      },
    );
  }

  List<MedicalRecord> _filterRecords() {
    return _records.where((record) {
      if (_selectedType != null && record.type != _selectedType) {
        return false;
      }

      if (_searchQuery != null && _searchQuery!.isNotEmpty) {
        final query = _searchQuery!.toLowerCase();
        return record.diagnosis.toLowerCase().contains(query) ||
            record.symptoms.any((s) => s.toLowerCase().contains(query));
      }

      return true;
    }).toList();
  }

  void _viewRecord(MedicalRecord record) {
    Navigator.pushNamed(context, '/medical/record', arguments: record);
  }

  void _addNewRecord() {
    Navigator.pushNamed(context, '/medical/add').then((added) {
      if (added == true) {
        _loadRecords();
      }
    });
  }

  void _uploadRecord() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'png'],
      );

      if (result != null) {
        _showLoadingDialog();

        // Implement actual file upload logic
        await Future.delayed(const Duration(seconds: 2));

        Navigator.pop(context); // Hide loading dialog
        _showSuccess('Record uploaded successfully');
        _loadRecords();
      }
    } catch (e) {
      _showError('Failed to upload record');
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  List<MedicalRecord> _getMockRecords() {
    // Replace with actual data fetching
    return [
      MedicalRecord(
        id: '1',
        userId: 'user1',
        doctorId: 'doctor1',
        date: DateTime.now(),
        diagnosis: 'Hearing Test Results',
        symptoms: ['Difficulty hearing high frequencies'],
        prescriptions: [],
        notes: 'Regular checkup',
        type: RecordType.test,
      ),
      // Add more mock records
    ];
  }
}
