// lib/pages/edit_registrant_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/registrant_model.dart';
import '../providers/registration_provider.dart';

class EditRegistrantPage extends StatefulWidget {
  const EditRegistrantPage({super.key});

  @override
  State<EditRegistrantPage> createState() => _EditRegistrantPageState();
}

class _EditRegistrantPageState extends State<EditRegistrantPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateController = TextEditingController();

  bool _initialized = false;
  String _selectedGender = 'Laki-laki';
  String? _selectedProdi;
  DateTime? _selectedDate;
  late String _registrantId;
  late String _originalEmail;

  final List<String> _prodiList = [
    'Teknik Informatika',
    'Sistem Informasi',
    'Teknik Komputer',
    'Data Science',
    'Desain Komunikasi Visual',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      try {
        _registrantId = ModalRoute.of(context)!.settings.arguments as String;
        final registrant = context
            .read<RegistrationProvider>()
            .getById(_registrantId);

        if (registrant != null) {
          _nameController.text = registrant.name;
          _emailController.text = registrant.email;
          _originalEmail = registrant.email;
          _selectedGender = registrant.gender;
          _selectedProdi = registrant.programStudi;
          _selectedDate = registrant.dateOfBirth;
          _dateController.text = registrant.formattedDateOfBirth;
        }
      } catch (e) {
        debugPrint('Error loading registrant: $e');
      }
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2004, 1, 1),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      helpText: 'Pilih Tanggal Lahir',
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<RegistrationProvider>();

    // Check email duplicate only if email changed
    final newEmail = _emailController.text.trim();
    if (newEmail.toLowerCase() != _originalEmail.toLowerCase() &&
        provider.isEmailRegistered(newEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email sudah digunakan oleh pendaftar lain!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final updatedRegistrant = Registrant(
        id: _registrantId,
        name: _nameController.text.trim(),
        email: newEmail,
        gender: _selectedGender,
        programStudi: _selectedProdi!,
        dateOfBirth: _selectedDate!,
        registeredAt: provider.getById(_registrantId)?.registeredAt,
      );

      provider.updateRegistrant(updatedRegistrant);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data berhasil diperbarui!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final registrant = context.read<RegistrationProvider>().getById(
      ModalRoute.of(context)!.settings.arguments as String,
    );

    if (registrant == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Pendaftar')),
        body: const Center(child: Text('Pendaftar tidak ditemukan')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pendaftar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Simpan',
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Text(
                      registrant.name[0].toUpperCase(),
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Edit Data Pendaftar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Terdaftar: ${registrant.formattedRegisteredAt}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Nama
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap *',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama wajib diisi';
                  }
                  if (value.trim().length < 3) {
                    return 'Nama minimal 3 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email wajib diisi';
                  }
                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Gender
              const Text('Jenis Kelamin *', style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Laki-laki'),
                      value: 'Laki-laki',
                      groupValue: _selectedGender,
                      onChanged: (v) => setState(() => _selectedGender = v!),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Perempuan'),
                      value: 'Perempuan',
                      groupValue: _selectedGender,
                      onChanged: (v) => setState(() => _selectedGender = v!),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Prodi
              DropdownButtonFormField<String>(
                value: _selectedProdi,
                decoration: const InputDecoration(
                  labelText: 'Program Studi *',
                  prefixIcon: Icon(Icons.school),
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Pilih Program Studi'),
                items:
                    _prodiList
                        .map(
                          (p) => DropdownMenuItem(value: p, child: Text(p)),
                        )
                        .toList(),
                onChanged: (v) => setState(() => _selectedProdi = v),
                validator: (v) => v == null ? 'Pilih program studi' : null,
              ),
              const SizedBox(height: 16),

              // Tanggal Lahir
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Lahir *',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
                onTap: _pickDate,
                validator:
                    (v) =>
                        (v == null || v.isEmpty)
                            ? 'Tanggal lahir wajib diisi'
                            : null,
              ),
              const SizedBox(height: 32),

              // Save button
              ElevatedButton.icon(
                onPressed: _saveChanges,
                icon: const Icon(Icons.save),
                label: const Text('SIMPAN PERUBAHAN'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}