# 📋 Registrasi Event — Flutter App

Aplikasi pendaftaran event berbasis Flutter menggunakan **Provider** sebagai state management. Dibangun sebagai tugas mata kuliah dengan implementasi multi-step form, validasi real-time, pencarian, filter, dan fitur edit data pendaftar.

---

## 🗂️ Struktur Proyek

```
lib/
├── main.dart
├── models/
│   └── registrant_model.dart
├── providers/
│   └── registration_provider.dart
└── pages/
    ├── registration_page.dart       # Multi-step form pendaftaran
    ├── registrant_list_page.dart    # Daftar + search + filter
    ├── registrant_detail_page.dart  # Detail pendaftar
    └── edit_registrant_page.dart    # Edit data pendaftar
```

---

## ✅ Fitur Wajib

| # | Fitur | Keterangan |
|---|-------|------------|
| 1 | **5+ field input berbeda** | TextFormField (nama, email, password, tanggal lahir), Radio (gender), Dropdown (prodi), Checkbox (T&C), DatePicker |
| 2 | **Validasi real-time** | `autovalidateMode: AutovalidateMode.onUserInteraction` di setiap step |
| 3 | **2+ jenis input non-TextField** | RadioListTile, DropdownButtonFormField, CheckboxListTile, DatePicker |
| 4 | **Provider** | `RegistrationProvider` extends `ChangeNotifier`, di-inject via `ChangeNotifierProvider` di `main.dart` |
| 5 | **Halaman list pendaftar** | `RegistrantListPage` menampilkan semua pendaftar dengan nama, prodi, dan email |
| 6 | **Error handling** | try-catch pada `updateRegistrant()` di provider, `getById()`, dan `didChangeDependencies()` |
| 7 | **Reset form** | Form di-reset setelah submit berhasil via `_resetForm()` yang clear semua controller & state |

---

## 🌟 Fitur Bonus (+20)

### 1. Multi-Step Form dengan Stepper (+10)

Form pendaftaran dibagi menjadi **3 langkah**:

```
Step 1: Data Pribadi   → Nama, Email, Password
Step 2: Data Akademik  → Gender, Program Studi, Tanggal Lahir
Step 3: Konfirmasi     → Ringkasan data + persetujuan T&C
```

- Setiap step memiliki `GlobalKey<FormState>` tersendiri
- Validasi hanya berjalan pada step yang aktif
- Pengguna dapat kembali ke step sebelumnya dengan tap atau tombol "Kembali"
- Step yang sudah selesai ditandai dengan ikon ✅ (`StepState.complete`)

### 2. Edit Data Pendaftar (+5)

- Tombol edit (ikon pensil 🖊️) tersedia di setiap item pada halaman list
- Form edit di-pre-fill dengan data existing pendaftar
- Validasi duplikasi email hanya aktif jika email **diubah** dari nilai semula
- Perubahan disimpan via `provider.updateRegistrant()` dengan try-catch

### 3. Search & Filter Pendaftar (+5)

- **Search bar** real-time — mencari berdasarkan nama atau email (case-insensitive)
- **Filter chip** horizontal — menyaring berdasarkan Program Studi
- Search dan filter dapat dikombinasikan secara bersamaan
- Tampilan fallback khusus jika hasil pencarian kosong

---

## 🧭 Navigasi & Routes

| Route | Halaman |
|-------|---------|
| `/` | `RegistrationPage` — Form pendaftaran (Stepper) |
| `/list` | `RegistrantListPage` — Daftar + search + filter |
| `/detail` | `RegistrantDetailPage` — Detail pendaftar |
| `/edit` | `EditRegistrantPage` — Edit data pendaftar |

---

## 🚀 Cara Menjalankan

**Prasyarat:** Flutter SDK ≥ 3.x, Dart ≥ 3.x

```bash
# 1. Clone repository
git clone https://github.com/<username>/NIM_NamaLengkap_Tugas5.git
cd NIM_NamaLengkap_Tugas5

# 2. Install dependencies
flutter pub get

# 3. Jalankan aplikasi
flutter run
```

**Dependency yang digunakan:**

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
```

---

## 📸 Screenshots

<img width="1302" height="881" alt="image" src="https://github.com/user-attachments/assets/df138b28-7d72-4851-9fc9-47686cffe1e5" />

<img width="1297" height="989" alt="image" src="https://github.com/user-attachments/assets/7bd26f51-6415-408a-b057-b597681dff37" />

<img width="1297" height="976" alt="Screenshot 2026-03-05 131540" src="https://github.com/user-attachments/assets/68c79c8b-fd2e-4011-a119-023b0cd06e6b" />

<img width="1293" height="986" alt="Screenshot 2026-03-05 131557" src="https://github.com/user-attachments/assets/447c7729-4c71-419f-9e6e-6f5fd1fb1347" />

---

## 👤 Identitas

| | |
|---|---|
| **NIM** | `2409116106` |
| **Nama** | `Muhammad Arifin Alqi. AB` |
| **Kelas** | `Sistem Informasi C` |
| **Mata Kuliah** | Pemrograman Mobile |
| **Tugas** | Tugas 5 — Form & State Management |
