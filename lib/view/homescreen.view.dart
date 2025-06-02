import 'package:flutter/material.dart';
import 'package:parkir/utils/global.colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
                        'assets/images/logo parkiryukk.png',
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
                      const Icon(Icons.notifications, size: 30),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.all(100),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Transform.translate(
                        offset: Offset(0, -70),
                        child: Image.asset(
                          'assets/images/logo parkiryukk.png',
                          width: 150,
                          height: 150,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Anda\nSedang\nTidak\nParkir ...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Alike',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                print("Scan");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                ),
                              ),
                              child: const Text(
                                'Pindai Untuk Masuk',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontFamily: 'Alike',
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                print("Booking");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                ),
                              ),
                              child: const Text(
                                'Booking Tempat Parkir',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontFamily: 'Alike',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.amber,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
