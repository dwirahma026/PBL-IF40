import 'package:flutter/material.dart';
import 'package:parkir/utils/global.colors.dart';
import 'package:parkir/view/daftar.view.dart';
import 'package:parkir/view/homescreen.view.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  Future<void> login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password tidak boleh kosong')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Berhasil login')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login gagal: $e')));
    }
  }

  Future<void> _showResetDialog() async {
    final emailCtrl = TextEditingController();
    await showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Reset Password'),
            content: TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Email terdaftar'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final email = emailCtrl.text.trim();
                  if (email.isEmpty) return;
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: email,
                    );
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Link reset dikirim ke email'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Gagal kirim: $e')));
                  }
                },
                child: const Text('Kirim'),
              ),
            ],
          ),
    );
  }

  Widget _inputField(
    String hint,
    TextEditingController c, {
    bool password = false,
  }) {
    return TextField(
      controller: c,
      obscureText: password ? _obscure : false,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: GlobalColors.mainColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        hintStyle: const TextStyle(fontSize: 18, color: Color(0xFF757575)),
        suffixIcon:
            password
                ? IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                )
                : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat Datang',
                            style: TextStyle(
                              color: GlobalColors.textColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Alike',
                            ),
                          ),
                          Text(
                            'Di Parkiryuk!!!',
                            style: TextStyle(
                              color: GlobalColors.textColor,
                              fontSize: 33,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Alike',
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Masukkan Email dan Password yang sudah kamu daftarkan ya!!',
                            style: TextStyle(
                              color: GlobalColors.textColor,
                              fontSize: 14,
                              fontFamily: 'Alike',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/images/logo_parkiryukk.png',
                      width: 80,
                      height: 80,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                _inputField('Email', _emailController),
                const SizedBox(height: 15),
                _inputField('Password', _passwordController, password: true),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontFamily: 'Alike',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterView(),
                          ),
                        ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Daftar',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontFamily: 'Alike',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: GestureDetector(
                    onTap: _showResetDialog,
                    child: const Text(
                      'Lupa Password',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
