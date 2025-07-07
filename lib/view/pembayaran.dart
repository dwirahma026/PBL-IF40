import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkir/utils/global.colors.dart';
import 'barcode.dart';

class PembayaranPage extends StatefulWidget {
  final String bookingId;

  const PembayaranPage({super.key, required this.bookingId});

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  Map<String, dynamic>? bookingData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBookingData();
  }

  Future<void> loadBookingData() async {
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

  Future<void> bayar() async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(widget.bookingId)
        .update({
          'status_pembayaran': 'sudah bayar',
          'status': 'aktif',
          'updated_at': DateTime.now(),
        });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Pembayaran berhasil!')));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BarcodePage(bookingId: widget.bookingId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || bookingData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final sesi = (bookingData!['sesi'] as List<dynamic>?)?.join(', ') ?? '-';

    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
      appBar: AppBar(
        title: const Text('Pembayaran'),
        backgroundColor: Colors.amber,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Lokasi: ${bookingData!['lokasi']}"),
            Text("Gate: ${bookingData!['gate']}"),
            Text("Area: ${bookingData!['area']}"),
            Text("Sesi: $sesi"),
            Text("Total: Rp ${bookingData!['total_harga']}"),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: bayar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.all(15),
                ),
                child: const Text(
                  'Bayar Sekarang',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
