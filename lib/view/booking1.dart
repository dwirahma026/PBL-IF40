import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parkir/utils/global.colors.dart';
import 'booking2.dart';

class Booking1 extends StatefulWidget {
  const Booking1({Key? key}) : super(key: key);

  @override
  State<Booking1> createState() => _Booking1State();
}

class _Booking1State extends State<Booking1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
      body: Stack(
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
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/logo_parkiryukk.png',
                        width: 40,
                        height: 40,
                      ),
                      const Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Alike',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.notifications, size: 40),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Image.asset(
                        'assets/images/logo_parkiryukk.png',
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(height: 20),
                      StreamBuilder<QuerySnapshot>(
                        stream:
                            FirebaseFirestore.instance
                                .collection('parking_gates')
                                .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Text("Belum ada lokasi tersedia");
                          }

                          List<String> allLokasi =
                              snapshot.data!.docs
                                  .map((doc) => doc['lokasi'] as String)
                                  .toList();

                          List<String> lokasiUnik = allLokasi.toSet().toList();

                          return Column(
                            children:
                                lokasiUnik.map((lokasi) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 15.0,
                                    ),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) =>
                                                      Booking2(lokasi: lokasi),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          lokasi,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.amber,
                                            fontFamily: 'Alike',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
