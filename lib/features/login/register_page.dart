import 'package:flutter/material.dart';
import 'package:banuainsight_project/features/login/login_page.dart';
import 'package:banuainsight_project/data/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _controller;
  late Animation<Offset> _formOffset;
  late Animation<Offset> _logoOffset;
  late Animation<double> _logoScale;

  // Auth Service
  final AuthService _authService = AuthService();

  // Text Controllers untuk capture input dari user
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  // Loading state untuk tombol
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize TextEditingControllers
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    // Initialize Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _formOffset = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOutQuart),
          ),
        );

    _logoOffset = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic),
          ),
        );

    _logoScale = Tween<double>(begin: 1.18, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    // Start animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    // Dispose TextEditingControllers untuk avoid memory leak
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    // Dispose Animation Controller
    _controller.dispose();
    super.dispose();
  }

  /// Fungsi untuk handle proses registrasi dengan validasi
  /// Validasi yang dilakukan:
  /// 1. Semua field harus terisi (required)
  /// 2. Email harus valid format
  /// 3. Password dan confirm password harus sama
  /// 4. Password minimal 6 karakter
  Future<void> _handleRegister() async {
    // Validasi 1: Cek semua field tidak kosong
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showErrorDialog('Error', 'Semua field harus diisi!');
      return;
    }

    // Validasi 2: Cek format email
    if (!_isValidEmail(_emailController.text)) {
      _showErrorDialog('Error', 'Format email tidak valid!');
      return;
    }

    // Validasi 3: Cek password minimal 6 karakter
    if (_passwordController.text.length < 6) {
      _showErrorDialog('Error', 'Password minimal 6 karakter!');
      return;
    }

    // Validasi 4: Cek password dan confirm password sama
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog('Error', 'Password tidak cocok!');
      return;
    }

    // Jika semua validasi lolos, lanjut ke proses registrasi
    try {
      setState(() {
        _isLoading = true;
      });

      // Panggil AuthService untuk registrasi
      var result = await _authService.registerUser(
        _emailController.text,
        _passwordController.text,
        _usernameController.text,
        _usernameController.text, // Menggunakan username sebagai nama
      );

      if (result != null) {
        // Registrasi berhasil, arahkan ke login page
        if (!mounted) return;
        _showSuccessDialog('Sukses', 'Registrasi berhasil! Silakan login.');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        // Registrasi gagal
        if (!mounted) return;
        _showErrorDialog('Error', 'Registrasi gagal. Silakan coba lagi.');
      }
    } catch (e) {
      // Handle exception saat registrasi
      if (!mounted) return;
      _showErrorDialog('Error', 'Terjadi kesalahan: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Helper function untuk validasi email menggunakan regex
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Helper function untuk menampilkan error dialog
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Helper function untuk menampilkan success dialog
  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5), // Light gray background
      body: Stack(
        children: [
          // Header / Logo Section
          Align(
            alignment: Alignment.topCenter,
            child: SlideTransition(
              position: _logoOffset,
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScaleTransition(
                      scale: _logoScale,
                      child: Hero(
                        tag: 'logo_image',
                        child: Image.asset(
                          'assets/img/Logo_banua.png',
                          height: 260,
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(
                        0,
                        -50,
                      ), // Atur nilai ini untuk mendekatkan/menjauhkan teks
                      child: Column(
                        children: [
                          const Text(
                            "BANUA",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:
                                  36, // Disesuaikan ukuran font saat muncul agar pas dgn logo yg membesar
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 51, 96, 33),
                              height: 1.1,
                            ),
                          ),
                          const Text(
                            "-INSIGHT-",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: Color.fromARGB(255, 230, 141, 58),
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Form Section
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _formOffset,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.55,
                decoration: const BoxDecoration(
                  color: Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 40,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Daftar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF386B33), // Green text
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Username Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: 'Masukkan Username',
                            prefixIcon: null,
                            suffixIcon: const Icon(
                              Icons.person_outline,
                              color: Color.fromARGB(221, 101, 101, 101),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Email Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Example@gmail.com',
                            prefixIcon: null,
                            suffixIcon: const Icon(
                              Icons.email_outlined,
                              color: Color.fromARGB(221, 101, 101, 101),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Password Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Masukkan Password',
                            suffixIcon: const Icon(
                              Icons.visibility_outlined,
                              color: Color.fromARGB(221, 101, 101, 101),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Confirm Password Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: TextField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Konfirmasi Password',
                            suffixIcon: const Icon(
                              Icons.visibility_outlined,
                              color: Color.fromARGB(221, 101, 101, 101),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Remember Me
                      const SizedBox(height: 15),
                      // Register Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isLoading
                              ? Colors.grey
                              : const Color(0xFF4C9A35),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Daftar',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      const SizedBox(height: 25),
                      // Sign Up Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('sudah punya akun? '),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'klik disini',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
