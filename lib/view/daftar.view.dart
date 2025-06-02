import 'package:flutter/material.dart';
import 'package:parkir/utils/global.colors.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

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

                buildInputField("User Name", usernameController),
                const SizedBox(height: 15),
                buildInputField("Email", emailController),
                const SizedBox(height: 15),
                buildInputField("Nomor Hp", phoneController),
                const SizedBox(height: 15),
                buildInputField(
                  "Password",
                  passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: 70),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      print("Username: ${usernameController.text}");
                      print("Email: ${emailController.text}");
                      print("Nomor Hp: ${phoneController.text}");
                      print("Password: ${passwordController.text}");
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
