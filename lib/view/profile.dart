import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkir/utils/global.colors.dart';
import 'package:parkir/view/splash.view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = '-';
  String email = '-';
  String noHp = '-';

  bool isEditingUsername = false;
  bool isEditingNoHp = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        email = user.email ?? '-';
      });

      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          username = data['username'] ?? '-';
          noHp = data['no_hp'] ?? '-';
          _usernameController.text = username;
          _noHpController.text = noHp;
        });
      }
    }
  }

  Future<void> updateField(String field, String value) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      field: value,
    });

    if (field == 'username') {
      setState(() {
        username = value;
        isEditingUsername = false;
      });
    } else if (field == 'no_hp') {
      setState(() {
        noHp = value;
        isEditingNoHp = false;
      });
    }
  }

  Future<void> resetPassword() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link reset password telah dikirim ke email.'),
        ),
      );
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SplashView()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/logo parkiryukk.png',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Alike',
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Stack(
                      children: [
                        const CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage(
                            'assets/images/avatar.jpeg',
                          ),
                          backgroundColor: Colors.white,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    buildProfileRow("Email", subtitle: email, showArrow: false),
                    isEditingUsername
                        ? buildEditableRow("Username", _usernameController, () {
                          updateField(
                            "username",
                            _usernameController.text.trim(),
                          );
                        })
                        : buildProfileRow(
                          "Username",
                          subtitle: username,
                          onTap: () {
                            setState(() => isEditingUsername = true);
                          },
                        ),
                    isEditingNoHp
                        ? buildEditableRow("Nomor Hp", _noHpController, () {
                          updateField("no_hp", _noHpController.text.trim());
                        })
                        : buildProfileRow(
                          "Nomor Hp",
                          subtitle: noHp,
                          onTap: () {
                            setState(() => isEditingNoHp = true);
                          },
                        ),
                    buildProfileRow(
                      "Password",
                      subtitle: "********",
                      onTap: resetPassword,
                    ),
                    const Divider(thickness: 1),
                    GestureDetector(
                      onTap: logout,
                      child: Row(
                        children: const [
                          Text(
                            "Log Out",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.arrow_right, color: Colors.red, size: 45),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileRow(
    String title, {
    String? subtitle,
    bool showArrow = true,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 18, fontFamily: 'Alike'),
          ),
          subtitle: subtitle != null ? Text(subtitle) : null,
          trailing: showArrow ? const Icon(Icons.arrow_forward_ios) : null,
          contentPadding: EdgeInsets.zero,
          onTap: onTap,
        ),
        const Divider(thickness: 1),
      ],
    );
  }

  Widget buildEditableRow(
    String label,
    TextEditingController controller,
    VoidCallback onSave,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: const TextStyle(fontFamily: 'Alike'),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: onSave,
            ),
          ],
        ),
        const Divider(thickness: 1),
      ],
    );
  }
}
