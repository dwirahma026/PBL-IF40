import 'package:flutter/material.dart';
import 'package:parkir/utils/global.colors.dart';
import 'package:parkir/view/daftar.view.dart';
import 'package:parkir/view/homescreen.view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username dan password tidak boleh kosong')),
      );
      return;
    }

    try {
      final userQuery =
          await FirebaseFirestore.instance
              .collection('users')
              .where('username', isEqualTo: username)
              .limit(1)
              .get();

      if (userQuery.docs.isEmpty) {
        throw 'Username tidak ditemukan';
      }

      final email = userQuery.docs.first['email'];

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Berhasil login')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login gagal: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(50.0),
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
                            'Masukkan Username dan Password yang sudah kamu Daftarkan ya!!',
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
                      'assets/images/logo parkiryukk.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                buildInputField('Username', _usernameController),
                const SizedBox(height: 15),
                buildInputField(
                  'Password',
                  _passwordController,
                  isPassword: true,
                ),
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
                      "Masuk",
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterView(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      "Daftar",
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
                    onTap: () {
                      // halaman lupa password
                    },
                    child: const Text(
                      "Lupa Password",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontFamily: 'Alike',
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

  Widget buildInputField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(
          fontFamily: 'Alike',
          fontSize: 18,
          color: Color.fromARGB(255, 117, 117, 117),
        ),
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
      ),
    );
  }
}
