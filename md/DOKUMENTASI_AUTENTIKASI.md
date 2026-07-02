# Dokumentasi Integrasi AuthService - Register & Login

## Daftar Isi
1. [Pengenalan](#pengenalan)
2. [Konsep Utama](#konsep-utama)
3. [Cara Kerja Register Page](#cara-kerja-register-page)
4. [Cara Kerja Login Page](#cara-kerja-login-page)
5. [Alur Validasi](#alur-validasi)
6. [Handling Error](#handling-error)
7. [Tips & Troubleshooting](#tips--troubleshooting)

---

## Pengenalan

Dokumentasi ini menjelaskan bagaimana **AuthService** terintegrasi dengan **Register Page** dan **Login Page** untuk memberikan pengalaman autentikasi yang aman dan user-friendly.

### File-file Penting:
- **Register Page**: `lib/features/login/register_page.dart`
- **Login Page**: `lib/features/login/login_page.dart`
- **AuthService**: `lib/data/services/auth_service.dart`

---

## Konsep Utama

### 1. TextEditingController
TextEditingController adalah widget yang digunakan untuk **capture input dari user**.

```dart
// Inisialisasi di initState()
late TextEditingController _emailController;
late TextEditingController _passwordController;

@override
void initState() {
  super.initState();
  _emailController = TextEditingController();
  _passwordController = TextEditingController();
}

// Gunakan di TextField
TextField(
  controller: _emailController,
  decoration: InputDecoration(hintText: 'Email'),
)

// Akses nilai yang diinput user
String email = _emailController.text;

// Jangan lupa dispose untuk hindari memory leak
@override
void dispose() {
  _emailController.dispose();
  _passwordController.dispose();
  super.dispose();
}
```

### 2. Async/Await dan Future
Async/Await digunakan untuk **menangani operasi yang memakan waktu** (seperti komunikasi dengan Firebase).

```dart
// Fungsi async selalu return Future
Future<void> _handleLogin() async {
  // Menunggu operasi selesai sebelum lanjut baris berikutnya
  var result = await _authService.login(email, password);
  
  if (result != null) {
    // Login berhasil
    Navigator.pushReplacement(...);
  } else {
    // Login gagal
    showErrorDialog(...);
  }
}

// Dipanggil dengan await
await _handleLogin();
```

### 3. setState()
setState() digunakan untuk **update UI** ketika ada perubahan state.

```dart
// Tampilkan loading indicator saat proses login
setState(() {
  _isLoading = true;
});

// Sembunyikan loading indicator setelah selesai
setState(() {
  _isLoading = false;
});

// UI otomatis rebuild dengan nilai _isLoading yang baru
```

---

## Cara Kerja Register Page

### Struktur Dasar

```dart
class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  // 1. AUTH SERVICE
  final AuthService _authService = AuthService();

  // 2. TEXT CONTROLLERS (untuk capture input)
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  // 3. LOADING STATE (untuk disable button saat loading)
  bool _isLoading = false;
}
```

### Step-by-Step Flow

#### Step 1: User Input
User memasukkan username, email, password, dan confirm password di 4 TextField yang berbeda.

```dart
TextField(
  controller: _usernameController,  // Capture ke controller ini
  decoration: InputDecoration(hintText: 'Masukkan Username'),
)
```

#### Step 2: User Klik Tombol Register
User mengklik tombol "Daftar" yang memanggil fungsi `_handleRegister()`.

```dart
ElevatedButton(
  onPressed: _isLoading ? null : _handleRegister,  // Klik → panggil _handleRegister()
  child: _isLoading 
    ? CircularProgressIndicator()  // Tampilkan loading saat proses
    : Text('Daftar'),
)
```

#### Step 3: Validasi Input
Sebelum kirim ke Firebase, semua input divalidasi terlebih dahulu.

```dart
Future<void> _handleRegister() async {
  // VALIDASI 1: Cek semua field tidak kosong
  if (_usernameController.text.isEmpty ||
      _emailController.text.isEmpty ||
      _passwordController.text.isEmpty ||
      _confirmPasswordController.text.isEmpty) {
    _showErrorDialog('Error', 'Semua field harus diisi!');
    return;  // Hentikan proses
  }

  // VALIDASI 2: Cek format email valid
  if (!_isValidEmail(_emailController.text)) {
    _showErrorDialog('Error', 'Format email tidak valid!');
    return;
  }

  // VALIDASI 3: Cek password minimal 6 karakter
  if (_passwordController.text.length < 6) {
    _showErrorDialog('Error', 'Password minimal 6 karakter!');
    return;
  }

  // VALIDASI 4: Cek password sama dengan confirm password
  if (_passwordController.text != _confirmPasswordController.text) {
    _showErrorDialog('Error', 'Password tidak cocok!');
    return;
  }

  // Jika semua validasi lolos, lanjut ke registrasi
  _registerWithFirebase();
}
```

#### Step 4: Call AuthService.register()
Jika validasi lolos, panggil fungsi `AuthService.register()` untuk kirim data ke Firebase.

```dart
try {
  // Tampilkan loading indicator
  setState(() {
    _isLoading = true;
  });

  // Panggil AuthService dengan parameter
  var result = await _authService.registerUser(
    _emailController.text,          // email
    _passwordController.text,       // password
    _usernameController.text,       // username
    _usernameController.text,       // nama (pakai username)
  );

  // Tunggu response dari Firebase
  // (operasi di Firebase bisa butuh 1-3 detik)

} catch (e) {
  // Handle error jika ada exception
  _showErrorDialog('Error', 'Terjadi kesalahan: ${e.toString()}');
} finally {
  // Selalu jalankan ini, baik sukses atau error
  setState(() {
    _isLoading = false;  // Sembunyikan loading
  });
}
```

#### Step 5: Handle Response
Setelah AuthService return result, check apakah registrasi berhasil atau gagal.

```dart
if (result != null) {
  // ✅ BERHASIL: Arahkan ke LoginPage
  if (!mounted) return;  // Cek widget masih active
  _showSuccessDialog('Sukses', 'Registrasi berhasil! Silakan login.');
  
  // Tunggu user close dialog, baru navigate
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
  );
} else {
  // ❌ GAGAL: Tampilkan error
  if (!mounted) return;
  _showErrorDialog('Error', 'Registrasi gagal. Silakan coba lagi.');
}
```

---

## Cara Kerja Login Page

### Struktur Dasar
Register dan Login hampir sama, hanya bedanya:
- Register punya 4 TextField (username, email, password, confirm password)
- Login punya 2 TextField (email, password)

```dart
class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  
  bool _isLoading = false;
}
```

### Flow Login

```dart
Future<void> _handleLogin() async {
  // VALIDASI 1: Cek email dan password tidak kosong
  if (_emailController.text.isEmpty || 
      _passwordController.text.isEmpty) {
    _showErrorDialog('Error', 'Email dan password harus diisi!');
    return;
  }

  // VALIDASI 2: Cek format email valid
  if (!_isValidEmail(_emailController.text)) {
    _showErrorDialog('Error', 'Format email tidak valid!');
    return;
  }

  // VALIDASI 3: Cek password minimal 6 karakter
  if (_passwordController.text.length < 6) {
    _showErrorDialog('Error', 'Password minimal 6 karakter!');
    return;
  }

  // Validasi lolos, lanjut ke Firebase
  try {
    setState(() {
      _isLoading = true;  // Tampilkan loading
    });

    // Panggil AuthService.login()
    var result = await _authService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (result != null) {
      // ✅ LOGIN BERHASIL: Arahkan ke HomePage
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      // ❌ LOGIN GAGAL: Email atau password salah
      if (!mounted) return;
      _showErrorDialog(
        'Error',
        'Email atau password salah. Silakan coba lagi.',
      );
    }
  } catch (e) {
    // Handle exception
    if (!mounted) return;
    _showErrorDialog('Error', 'Terjadi kesalahan: ${e.toString()}');
  } finally {
    // Sembunyikan loading
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
```

---

## Alur Validasi

### 1. Validasi Email
Email harus:
- Tidak kosong
- Format valid (ada @, ada ., ada domain)

```dart
bool _isValidEmail(String email) {
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email);
}

// Contoh email VALID:
// user@gmail.com ✅
// admin123@company.co.id ✅

// Contoh email INVALID:
// usergmail.com ❌ (tidak ada @)
// user@gmail ❌ (tidak ada .)
// @gmail.com ❌ (tidak ada nama user)
```

### 2. Validasi Password
Password harus:
- Tidak kosong
- Minimal 6 karakter
- Di register: harus sama dengan confirm password

```dart
// Validasi panjang password
if (_passwordController.text.length < 6) {
  showError('Password minimal 6 karakter!');
}

// Validasi password match (hanya di register)
if (_passwordController.text != _confirmPasswordController.text) {
  showError('Password tidak cocok!');
}
```

### 3. Validasi Field (Required)
Semua field wajib diisi, tidak boleh kosong.

```dart
if (_emailController.text.isEmpty) {
  showError('Email harus diisi!');
}

if (_passwordController.text.isEmpty) {
  showError('Password harus diisi!');
}
```

---

## Handling Error

### 1. Error dari Validasi (Client-Side)
Error yang terjadi di app (sebelum kirim ke Firebase).

```dart
// Contoh: Email kosong
if (_emailController.text.isEmpty) {
  _showErrorDialog('Error', 'Email harus diisi!');
  return;  // ❌ Jangan lanjut
}

// Contoh: Email format invalid
if (!_isValidEmail(_emailController.text)) {
  _showErrorDialog('Error', 'Format email tidak valid!');
  return;
}
```

### 2. Error dari Firebase (Server-Side)
Error yang terjadi di Firebase (saat kirim data).

```dart
try {
  var result = await _authService.login(email, password);
  
  if (result != null) {
    // ✅ Berhasil
    navigateToHome();
  } else {
    // ❌ Email atau password salah
    showErrorDialog('Email atau password salah');
  }
} catch (e) {
  // ❌ Exception (network error, firebase error, dll)
  showErrorDialog('Terjadi kesalahan: ${e.toString()}');
}
```

### 3. Error Dialog
Menampilkan error kepada user dengan AlertDialog.

```dart
void _showErrorDialog(String title, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),          // Judul (misal: "Error")
      content: Text(message),      // Pesan error
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

// Cara pakai:
_showErrorDialog('Error', 'Email harus diisi!');
```

---

## Tips & Troubleshooting

### ✅ BEST PRACTICES

#### 1. Selalu Dispose Controllers
```dart
@override
void dispose() {
  _emailController.dispose();      // ❌ Jangan lupa
  _passwordController.dispose();
  super.dispose();
}
```

**Kenapa?** Untuk hindari memory leak. Controller yang tidak di-dispose akan tetap menahan memory.

#### 2. Check Widget Mounted Sebelum setState()
```dart
// ❌ SALAH: Bisa error jika user navigate sebelum async selesai
setState(() {
  _isLoading = false;
});

// ✅ BENAR: Cek dulu apakah widget masih active
if (mounted) {
  setState(() {
    _isLoading = false;
  });
}
```

**Kenapa?** User bisa menutup page sebelum async operation selesai, menyebabkan error.

#### 3. Gunakan try-catch-finally
```dart
try {
  // Kode yang mungkin throw exception
  var result = await _authService.login(email, password);
} catch (e) {
  // Handle error
  showErrorDialog('Error: ${e.toString()}');
} finally {
  // Selalu jalankan ini (loading spinner, dsb)
  setState(() => _isLoading = false);
}
```

**Kenapa?** Untuk ensure cleanup code (seperti matikan loading spinner) selalu jalan.

#### 4. Disable Button Saat Loading
```dart
ElevatedButton(
  onPressed: _isLoading ? null : _handleLogin,  // Disable saat loading
  child: _isLoading
    ? CircularProgressIndicator()  // Tampilkan spinner
    : Text('Login'),
)
```

**Kenapa?** Untuk hindari user klik berkali-kali dan mengirim request multiple kali.

---

### ❓ TROUBLESHOOTING

#### Q: Button tetap bisa diklik saat loading?
**A:** Pastikan button onPressed pakai `_isLoading ? null : _handleLogin`:
```dart
// ❌ SALAH
onPressed: _handleLogin,  // Selalu clickable

// ✅ BENAR
onPressed: _isLoading ? null : _handleLogin,  // Disabled saat loading
```

#### Q: Loading spinner tidak hilang?
**A:** Pastikan ada `setState(() => _isLoading = false)` di `finally` block:
```dart
try {
  var result = await _authService.login(email, password);
} finally {
  setState(() => _isLoading = false);  // ❌ Jangan lupa
}
```

#### Q: "Unhandled Exception: setState() called after dispose()"?
**A:** Gunakan `if (mounted)` sebelum setState:
```dart
if (mounted) {
  setState(() => _isLoading = false);
}
```

#### Q: Controller return null atau empty string?
**A:** Pastikan TextField punya `controller` property:
```dart
// ❌ SALAH: Tidak punya controller
TextField(
  decoration: InputDecoration(hintText: 'Email'),
)

// ✅ BENAR: Punya controller
TextField(
  controller: _emailController,
  decoration: InputDecoration(hintText: 'Email'),
)
```

#### Q: Validasi email tidak jalan?
**A:** Pastikan email field pakai `keyboardType: TextInputType.emailAddress` dan validasi lolos semua kondisi:
```dart
// Cek ini dengan order:
// 1. Tidak kosong
if (_emailController.text.isEmpty) return;

// 2. Format valid
if (!_isValidEmail(_emailController.text)) return;

// Baru lanjut proses
```

---

## Contoh Lengkap: Login Flow

```dart
// 1. User input email dan password
// TextField -> controller capture value

// 2. User klik tombol "Masuk"
ElevatedButton(
  onPressed: _handleLogin,  // Trigger function ini
  ...
)

// 3. _handleLogin() jalankan validasi
Future<void> _handleLogin() async {
  // Validasi 1: Cek tidak kosong
  if (email.isEmpty || password.isEmpty) {
    showError('Harus diisi');
    return;
  }

  // Validasi 2: Cek format email
  if (!isValidEmail(email)) {
    showError('Format invalid');
    return;
  }

  // Validasi lolos, tampilkan loading
  setState(() => _isLoading = true);

  try {
    // 4. Kirim ke Firebase via AuthService
    var result = await authService.login(email, password);

    // 5. Firebase return result
    if (result != null) {
      // ✅ Berhasil: Navigate ke HomePage
      navigateToHome();
    } else {
      // ❌ Gagal: Email/password salah
      showError('Email atau password salah');
    }
  } catch (e) {
    // ❌ Exception terjadi
    showError('Error: $e');
  } finally {
    // 6. Sembunyikan loading (baik sukses atau error)
    setState(() => _isLoading = false);
  }
}
```

---

## Summary

| Konsep | Fungsi | Contoh |
|--------|--------|--------|
| **TextEditingController** | Capture input user | `_emailController.text` |
| **async/await** | Tunggu operasi selesai | `await _authService.login(...)` |
| **setState()** | Update UI | `setState(() => _isLoading = true)` |
| **try-catch-finally** | Handle error | Error handling & cleanup |
| **Validasi** | Cek input sebelum kirim | Email format, password length |
| **AlertDialog** | Tampilkan pesan ke user | Error dan success messages |

---

## File Reference

- **Register Page Logic**: `lib/features/login/register_page.dart` (lines ~90-150)
- **Login Page Logic**: `lib/features/login/login_page.dart` (lines ~90-150)
- **AuthService Functions**: `lib/data/services/auth_service.dart`

---

**Terakhir diupdate**: Hari ini  
**Status**: Ready to use ✅
