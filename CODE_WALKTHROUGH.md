# CODE WALKTHROUGH - Register & Login Integration

Penjelasan baris per baris untuk memahami bagaimana code bekerja.

---

## BAGIAN 1: INITIALIZATION (Setup di awal)

### Import dan Deklarasi
```dart
import 'package:banuainsight_project/data/services/auth_service.dart';

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  
  // 1️⃣ BUAT INSTANCE AUTHSERVICE
  final AuthService _authService = AuthService();
  
  // 2️⃣ BUAT TEXTEDITING CONTROLLER (untuk capture input)
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  
  // 3️⃣ BUAT LOADING STATE (untuk disable button saat loading)
  bool _isLoading = false;
}
```

**Penjelasan**:
- `AuthService`: Service yang di-buat temanmu. Digunakan untuk komunikasi dengan Firebase.
- `TextEditingController`: Seperti "tempat penampung" input user dari TextField.
- `_isLoading`: Flag untuk tahu apakah sedang proses (loading) atau tidak.

---

### initState() - Inisialisasi
```dart
@override
void initState() {
  super.initState();
  
  // 1️⃣ BUAT INSTANCE DARI SETIAP CONTROLLER
  _usernameController = TextEditingController();
  _emailController = TextEditingController();
  _passwordController = TextEditingController();
  _confirmPasswordController = TextEditingController();
  
  // 2️⃣ INISIALISASI ANIMATION CONTROLLER
  _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );
  
  // ... setup animation offset ...
  
  // 3️⃣ JALANKAN ANIMATION
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _controller.forward();
  });
}
```

**Penjelasan**:
- Buat controller untuk setiap TextField
- Buat animation controller untuk animasi smooth
- `addPostFrameCallback`: Jalankan animation setelah frame pertama selesai (UX best practice)

---

### dispose() - Cleanup
```dart
@override
void dispose() {
  // 1️⃣ DISPOSE SETIAP TEXTEDITING CONTROLLER
  _usernameController.dispose();
  _emailController.dispose();
  _passwordController.dispose();
  _confirmPasswordController.dispose();
  
  // 2️⃣ DISPOSE ANIMATION CONTROLLER
  _controller.dispose();
  
  // 3️⃣ CALL PARENT DISPOSE
  super.dispose();
}
```

**Penjelasan**:
- **PENTING**: Dispose setiap controller untuk hindari memory leak
- Jika tidak di-dispose, memory akan terus bertambah setiap kali page ditampilkan
- Selalu jalankan parent `super.dispose()` terakhir

---

## BAGIAN 2: VALIDASI

### Helper Function: Email Validation
```dart
/// Validasi email format menggunakan regex
bool _isValidEmail(String email) {
  // 1️⃣ REGEX PATTERN: nama@domain.ext
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  
  // 2️⃣ CHECK APAKAH EMAIL SESUAI PATTERN
  return emailRegex.hasMatch(email);
}

// CONTOH:
_isValidEmail('user@gmail.com')      // ✅ true
_isValidEmail('invalid.email')       // ❌ false
_isValidEmail('user@domain')         // ❌ false (no TLD)
```

**Penjelasan Regex Pattern**:
```
^                    = mulai dari awal string
[a-zA-Z0-9._%+-]+   = karakter sebelum @
@                    = harus ada @
[a-zA-Z0-9.-]+      = domain name
\.                   = harus ada titik (.)
[a-zA-Z]{2,}        = minimal 2 huruf TLD (com, id, org, dsb)
$                    = akhir string
```

---

### Helper Function: Error Dialog
```dart
/// Tampilkan error ke user dengan AlertDialog
void _showErrorDialog(String title, String message) {
  // 1️⃣ BUKA DIALOG
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),              // Judul: "Error"
      content: Text(message),          // Pesan: "Email harus diisi"
      actions: [
        TextButton(
          // 2️⃣ TOMBOL OK UNTUK CLOSE DIALOG
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

// CARA PAKAI:
_showErrorDialog('Error', 'Email harus diisi!');
```

**Penjelasan**:
- `showDialog()`: Buka dialog modal
- `AlertDialog`: Widget untuk tampilkan pesan
- `Navigator.pop(context)`: Close dialog ketika user klik OK

---

## BAGIAN 3: HANDLER - _handleRegister()

Ini adalah JANTUNG dari register page. Mari breakdown step by step.

### Step 1: Validasi - Field Tidak Kosong
```dart
Future<void> _handleRegister() async {
  // STEP 1: CEK SEMUA FIELD TIDAK KOSONG
  if (_usernameController.text.isEmpty ||      // ❌ username kosong?
      _emailController.text.isEmpty ||          // ❌ email kosong?
      _passwordController.text.isEmpty ||       // ❌ password kosong?
      _confirmPasswordController.text.isEmpty) {// ❌ confirm kosong?
    
    // JIKA ADA YANG KOSONG: Tampilkan error dan STOP
    _showErrorDialog('Error', 'Semua field harus diisi!');
    return;  // ⛔ HENTI di sini, jangan lanjut
  }
```

**Logika**:
- Gunakan `||` (OR) untuk check apakah SALAH SATU field kosong
- Jika ada yang kosong: tampilkan error dan `return` untuk stop proses
- Jika semua terisi: lanjut ke validasi berikutnya

---

### Step 2: Validasi - Email Format
```dart
  // STEP 2: CEK FORMAT EMAIL VALID
  if (!_isValidEmail(_emailController.text)) {  // ❌ format invalid?
    
    // JIKA INVALID: Tampilkan error dan STOP
    _showErrorDialog('Error', 'Format email tidak valid!');
    return;  // ⛔ HENTI di sini
  }
```

**Logika**:
- Gunakan helper function `_isValidEmail()`
- Tanda `!` = NOT (kebalikan). Jadi `!isValid` = `isInvalid`
- Jika format invalid: tampilkan error dan stop

---

### Step 3: Validasi - Password Length
```dart
  // STEP 3: CEK PASSWORD MINIMAL 6 KARAKTER
  if (_passwordController.text.length < 6) {   // ❌ < 6 karakter?
    
    // JIKA < 6: Tampilkan error dan STOP
    _showErrorDialog('Error', 'Password minimal 6 karakter!');
    return;  // ⛔ HENTI di sini
  }
```

**Logika**:
- `.length` = jumlah karakter
- `< 6` = kurang dari 6
- Jika kurang dari 6: tampilkan error dan stop

---

### Step 4: Validasi - Password Match
```dart
  // STEP 4: CEK PASSWORD == CONFIRM PASSWORD
  if (_passwordController.text != _confirmPasswordController.text) {
    // ❌ tidak sama?
    
    // JIKA TIDAK SAMA: Tampilkan error dan STOP
    _showErrorDialog('Error', 'Password tidak cocok!');
    return;  // ⛔ HENTI di sini
  }
```

**Logika**:
- Bandingkan text dari kedua TextField
- `!=` = tidak sama dengan
- Jika tidak sama: tampilkan error dan stop

---

### Step 5: Jika Validasi Lolos - Registrasi
```dart
  // STEP 5: JIKA SEMUA VALIDASI LOLOS, LANJUT REGISTRASI
  try {
    // 5️⃣a TAMPILKAN LOADING SPINNER
    setState(() {
      _isLoading = true;  // Set flag to true
    });
    // ⏳ Sekarang button disabled, loading spinner tampil
    
    // 5️⃣b PANGGIL AUTHSERVICE.REGISTER()
    var result = await _authService.registerUser(
      _emailController.text,          // Email dari user input
      _passwordController.text,       // Password dari user input
      _usernameController.text,       // Username dari user input
      _usernameController.text,       // Nama (pakai username)
    );
    // ⏳ TUNGGU RESPONSE DARI FIREBASE (1-3 detik)
    // Firebase melakukan:
    // 1. Cek email unique?
    // 2. Hash password?
    // 3. Buat user di FirebaseAuth?
    // 4. Buat document di Firestore?
    // 5. Return UserModel jika berhasil, null jika gagal
```

**Penjelasan**:
- `setState(() { _isLoading = true })`: Set flag loading jadi true
- UI rebuild dengan `_isLoading = true`, button jadi disabled dan loading spinner tampil
- `await`: Tunggu Firebase respond (bisa 1-3 detik)
- `_authService.registerUser()`: Panggil function dari AuthService

---

### Step 6: Handle Response
```dart
    // STEP 6: CHECK RESPONSE DARI FIREBASE
    if (result != null) {
      // ✅ BERHASIL: result bukan null
      
      // 6️⃣a CHECK APAKAH WIDGET MASIH ACTIVE
      if (!mounted) return;
      // Kenapa? Karena user mungkin navigate sebelum async selesai
      
      // 6️⃣b TAMPILKAN SUCCESS DIALOG
      _showSuccessDialog(
        'Sukses',
        'Registrasi berhasil! Silakan login.'
      );
      
      // 6️⃣c NAVIGATE KE LOGIN PAGE
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      // Sekarang user di login page
      
    } else {
      // ❌ GAGAL: result adalah null
      
      // 6️⃣d CHECK WIDGET ACTIVE
      if (!mounted) return;
      
      // 6️⃣e TAMPILKAN ERROR DIALOG
      _showErrorDialog(
        'Error',
        'Registrasi gagal. Silakan coba lagi.'
      );
    }
```

**Penjelasan**:
- `if (result != null)`: Firebase return UserModel jika berhasil
- `if (!mounted) return`: Check widget masih active sebelum setState
- `pushReplacement`: Navigate ke LoginPage dan replace page stack
- Jika gagal: tampilkan error dan user tetap di register page

---

### Step 7: Error Handling
```dart
  } catch (e) {
    // ❌ EXCEPTION TERJADI (network error, firebase error, dsb)
    
    // 7️⃣a CHECK WIDGET ACTIVE
    if (!mounted) return;
    
    // 7️⃣b TAMPILKAN ERROR DIALOG
    _showErrorDialog(
      'Error',
      'Terjadi kesalahan: ${e.toString()}'
      // Tampilkan error message dari exception
    );
```

**Penjelasan**:
- `try-catch`: Capture semua exception yang mungkin terjadi
- Exception bisa: network error, firebase error, invalid parameter, dsb
- `e.toString()`: Konversi exception jadi string untuk tampilkan ke user

---

### Step 8: Cleanup
```dart
  } finally {
    // ✅ SELALU JALANKAN INI (baik try berhasil atau catch)
    
    // 8️⃣a CHECK WIDGET ACTIVE
    if (mounted) {
      
      // 8️⃣b SEMBUNYIKAN LOADING SPINNER
      setState(() {
        _isLoading = false;  // Set flag to false
      });
      // Sekarang button enabled lagi, loading spinner hilang
    }
  }
}
```

**Penjelasan**:
- `finally`: Block yang SELALU jalankan
- Penting untuk cleanup: matikan loading, reset form, dsb
- Jalankan baik proses berhasil (try) atau error (catch)

---

## BAGIAN 4: UI BUILDER

### Button dengan Loading State
```dart
ElevatedButton(
  // 1️⃣ SET ONPRESSED HANDLER
  onPressed: _isLoading ? null : _handleRegister,
  // ⚡ Jika _isLoading = true: button disabled (onPressed = null)
  // ⚡ Jika _isLoading = false: button enabled (onPressed = _handleRegister)
  
  style: ElevatedButton.styleFrom(
    // 2️⃣ UBAH WARNA BASED ON LOADING STATE
    backgroundColor: _isLoading
        ? Colors.grey      // 🔘 Gray saat loading
        : const Color(0xFF4C9A35),  // 🟢 Green saat normal
    padding: const EdgeInsets.symmetric(vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 3,
  ),
  
  // 3️⃣ UBAH CHILD BASED ON LOADING STATE
  child: _isLoading
      ? const SizedBox(
          height: 20,
          width: 20,
          // 🔄 Tampilkan loading spinner saat loading
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2,
          ),
        )
      : const Text(
          'Daftar',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
)
```

**Penjelasan**:
- `onPressed: _isLoading ? null : _handleRegister`: 
  - Jika loading: button disabled (tidak responsive)
  - Jika tidak loading: button bisa diklik
- `backgroundColor: _isLoading ? Colors.grey : Color(...)`:
  - Warna berubah jadi abu-abu saat loading (visual feedback)
- `child: _isLoading ? CircularProgressIndicator : Text`:
  - Tampilkan spinner saat loading
  - Tampilkan teks "Daftar" saat normal

---

## BAGIAN 5: TEXTFIELD dengan CONTROLLER

### TextField untuk Input
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.grey.shade400),
  ),
  
  child: TextField(
    // 1️⃣ ATTACH CONTROLLER
    controller: _emailController,
    // Setiap kali user type, nilai disimpan di controller
    // Akses dengan: _emailController.text
    
    // 2️⃣ SET KEYBOARD TYPE
    keyboardType: TextInputType.emailAddress,
    // Tampilkan email keyboard di mobile (punya @)
    
    // 3️⃣ DECORATION
    decoration: InputDecoration(
      hintText: 'Masukkan Email',
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
    ),
  ),
)

// CARA AKSES INPUT:
String email = _emailController.text;  // Get value
print(email);  // "user@gmail.com"
```

**Penjelasan**:
- `controller: _emailController`: Connect TextField ke controller
- Setiap kali user type: `_emailController.text` otomatis update
- `.text`: Akses nilai string dari controller

---

## SUMMARY: FLOW LENGKAP

```
┌─────────────────────────────────────────────────────────┐
│ 1. USER INPUT (TextField dengan controller)              │
│    Username: "john_doe"                                  │
│    Email: "john@gmail.com"                               │
│    Password: "password123"                               │
│    Confirm: "password123"                                │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│ 2. USER KLIK TOMBOL "DAFTAR"                             │
│    onPressed: _handleRegister() dipanggil                │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│ 3. VALIDASI DILAKUKAN                                    │
│    ✅ All fields filled?                                 │
│    ✅ Email format valid?                                │
│    ✅ Password >= 6 chars?                               │
│    ✅ Password == Confirm?                               │
└────────────────────┬────────────────────────────────────┘
                     │
            ❌ ADA YANG GAGAL?
                     │
    ┌────────────────┼────────────────┐
    ▼                                  ▼
┌──────────┐                    ┌──────────────┐
│ ERROR    │                    │ LANJUT KE    │
│ DIALOG   │                    │ FIREBASE     │
│ TAMPIL   │                    │ (STEP 4)     │
└──────────┘                    └──────┬───────┘
    │                                  │
    └─────────────────┬────────────────┘
                      ▼
            ┌─────────────────┐
            │ STEP 4: CALL    │
            │ AuthService     │
            │ .register()     │
            │ await response  │
            │ (1-3 detik)     │
            └────────┬────────┘
                     │
        ┌────────────┼────────────┐
        ▼                         ▼
    ┌──────┐              ┌──────────────┐
    │ FAIL │              │ SUCCESS      │
    │ null │              │ UserModel    │
    └──┬───┘              └──┬───────────┘
       │                     │
       ▼                     ▼
  ┌─────────────┐    ┌────────────────────┐
  │ ERROR       │    │ SUCCESS DIALOG     │
  │ "Gagal"     │    │ "Registrasi OK!"   │
  └─────────────┘    └────┬───────────────┘
       │                   │
       │                   ▼
       │            ┌──────────────────┐
       │            │ NAVIGATE TO      │
       │            │ LOGIN PAGE       │
       │            └──────────────────┘
       │
       └──────────────────┬──────────────────┐
                          ▼
                ┌─────────────────────┐
                │ FINALLY: MATIKAN    │
                │ LOADING SPINNER     │
                │ _isLoading = false  │
                └─────────────────────┘
```

---

## KEY TAKEAWAYS

1. **TextEditingController**: Capture input, akses dengan `.text`
2. **async/await**: Tunggu Firebase respond sebelum lanjut
3. **Validasi**: Check input SEBELUM kirim ke Firebase
4. **try-catch-finally**: Handle error dan cleanup
5. **setState**: Update UI dengan loading state
6. **Dispose**: Selalu cleanup resource di dispose()

---

**Semoga paham!** 🎉 Baca DOKUMENTASI_AUTENTIKASI.md untuk penjelasan lebih detail.
