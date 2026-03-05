// lib/pages/registrant_list_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/registration_provider.dart';

class RegistrantListPage extends StatefulWidget {
  const RegistrantListPage({super.key});

  @override
  State<RegistrantListPage> createState() => _RegistrantListPageState();
}

class _RegistrantListPageState extends State<RegistrantListPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterProdi = 'Semua';

  final List<String> _prodiOptions = [
    'Semua',
    'Informatika',
    'Sistem Informasi',
    'Data Science',
    'Desain Komunikasi Visual',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<RegistrationProvider>(
          builder: (context, provider, _) =>
              Text('Daftar Peserta (${provider.count})'),
        ),
      ),
      body: Column(
        children: [
          // ── Search & Filter Bar ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama atau email...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                isDense: true,
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
            ),
          ),
          // Filter chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _prodiOptions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final prodi = _prodiOptions[index];
                return FilterChip(
                  label: Text(prodi == 'Semua' ? 'Semua' : prodi.split(' ').first),
                  selected: _filterProdi == prodi,
                  onSelected: (_) => setState(() => _filterProdi = prodi),
                );
              },
            ),
          ),
          const Divider(height: 1),

          // ── List ─────────────────────────────────────────────────────────
          Expanded(
            child: Consumer<RegistrationProvider>(
              builder: (context, provider, child) {
                // Apply search + filter
                final filtered = provider.registrants.where((r) {
                  final matchSearch = _searchQuery.isEmpty ||
                      r.name.toLowerCase().contains(_searchQuery) ||
                      r.email.toLowerCase().contains(_searchQuery);
                  final matchProdi = _filterProdi == 'Semua' ||
                      r.programStudi == _filterProdi;
                  return matchSearch && matchProdi;
                }).toList();

                if (provider.registrants.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Belum ada pendaftar',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Daftar sekarang di halaman registrasi!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                if (filtered.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'Tidak ada hasil yang cocok',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final registrant = filtered[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(registrant.name[0].toUpperCase()),
                        ),
                        title: Text(
                          registrant.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${registrant.programStudi} • ${registrant.email}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Edit button
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              tooltip: 'Edit',
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/edit',
                                  arguments: registrant.id,
                                );
                              },
                            ),
                            // Delete button
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: 'Hapus',
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Hapus Pendaftar?'),
                                    content: Text(
                                      'Yakin hapus ${registrant.name}?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text('Batal'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          provider.removeRegistrant(
                                            registrant.id,
                                          );
                                          Navigator.pop(ctx);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        child: const Text('Hapus'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/detail',
                            arguments: registrant.id,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        tooltip: 'Tambah Pendaftar',
        child: const Icon(Icons.add),
      ),
    );
  }
}