# 📝 WhyNote – Aplikasi Catatan Minimalis & Responsif

WhyNote adalah aplikasi catatan sederhana berbasis Flutter yang dirancang dengan UI modern, responsif, dan nyaman digunakan untuk menulis catatan pendek hingga panjang. Data disimpan secara lokal menggunakan Hive.

## 📸 Preview

```md
<img src="assets/preview/whynote-preview.png" width="300" />
```

## 🚀 Fitur

- Tambah, edit, dan hapus catatan
- Tampilan form expand & collapse
- Scroll otomatis untuk catatan panjang
- Dialog konfirmasi penghapusan dengan ilustrasi
- Mode seleksi dan hapus massal
- UI dark theme elegan
- Responsif untuk berbagai ukuran layar (flutter_screenutil)

## 🛠️ Teknologi yang Digunakan

- Flutter
- Hive (local storage)
- flutter_screenutil (responsive layout)
- Montserrat & Poppins (custom font)
- Struktur folder terorganisir (models, screens, services, widgets)

## ⚙️ Cara Menjalankan Proyek

1. Clone repositori:

   ```bash
   git clone https://github.com/username/whynote.git
   cd whynote
   ```

2. Jalankan perintah berikut:

   ```bash
   flutter pub get
   ```

3. Generate adapter Hive:

   ```bash
   flutter pub run build_runner build
   ```

4. Jalankan aplikasi:
   ```bash
   flutter run
   ```

## 📁 Struktur Folder

```
lib/
├── models/
│   └── note_model.dart
├── screens/
│   ├── home_screen.dart
│   ├── new_note_screen.dart
│   └── detail_screen.dart
├── services/
│   └── note_service.dart
├── widgets/
│   └── note_item.dart
└── main.dart
```

## 📝 Catatan

- Data hanya disimpan secara lokal (offline).
- Kamu bisa menambahkan fitur cloud sync (Firebase, Supabase, dsb) di masa mendatang.

## 📄 License

MIT License
