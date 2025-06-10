import 'package:flutter/material.dart';
import 'package:parkir/utils/global.colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> register(BuildContext context) async {
    try {
      final authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      // Simpan data tambahan ke Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .set({
            'username': _usernameController.text.trim(),
            'email': _emailController.text.trim(),
            'phone': _phoneController.text.trim(),
          });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Pendaftaran berhasil')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
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
                            'Mulai',
                            style: TextStyle(
                              color: GlobalColors.textColor,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Alike',
                            ),
                          ),
                          Text(
                            'Bergabung!!',
                            style: TextStyle(
                              color: GlobalColors.textColor,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Alike',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Masukkan datamu untuk membuat akun baru.',
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
                const SizedBox(height: 40),

                buildInputField('User Name', _usernameController),
                const SizedBox(height: 15),
                buildInputField('Email', _emailController),
                const SizedBox(height: 15),
                buildInputField('Nomor Hp', _phoneController),
                const SizedBox(height: 15),
                buildInputField(
                  'Password',
                  _passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: 70),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      register(context);
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Colors.black, width: 20),
        ),
      ),
    );
  }
}
