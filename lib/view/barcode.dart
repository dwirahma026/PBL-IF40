import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:parkir/utils/global.colors.dart';

class BarcodePage extends StatefulWidget {
  final String bookingId;
  const BarcodePage({super.key, required this.bookingId});

  @override
  State<BarcodePage> createState() => _BarcodePageState();
}

class _BarcodePageState extends State<BarcodePage> {
  Map<String, dynamic>? bookingData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBooking();
  }

  Future<void> loadBooking() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('bookings')
            .doc(widget.bookingId)
            .get();

    if (doc.exists) {
      setState(() {
        bookingData = doc.data();
        isLoading = false;
      });
    }
  }

  Future<void> batalBooking() async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(widget.bookingId)
        .update({
          'status': 'dibatalkan',
          'status_pembayaran': 'dibatalkan',
          'updated_at': Timestamp.now(),
        });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Booking dibatalkan')));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || bookingData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final qrData = bookingData!['booking_id'];
    final lokasi = bookingData!['lokasi'] ?? '-';
    final gate = bookingData!['gate'] ?? '-';
    final sesi = (bookingData!['sesi'] as List?)?.join(', ') ?? '-';

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
                      const SizedBox(height: 40),
                      Image.asset(
                        'assets/images/logo parkiryukk.png',
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(height: 50),
                      QrImageView(
                        data: qrData,
                        version: QrVersions.auto,
                        size: 200,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Lokasi: $lokasi\nGate: $gate\nSesi: $sesi",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 100),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: batalBooking,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.all(15),
                          ),
                          child: const Text(
                            'Batal Booking',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
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
