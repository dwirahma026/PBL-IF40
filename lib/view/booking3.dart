import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkir/utils/global.colors.dart';
import 'pembayaran.dart';
import 'package:uuid/uuid.dart';

class Booking3 extends StatefulWidget {
  final String lokasi;
  final String gateId;
  final String namaGate;
  final String area;

  const Booking3({
    super.key,
    required this.lokasi,
    required this.gateId,
    required this.namaGate,
    required this.area,
  });

  @override
  State<Booking3> createState() => _Booking3State();
}

class _Booking3State extends State<Booking3> {
  final List<String> sesiTersedia = [
    '10:00 - 14:00',
    '14:00 - 18:00',
    '18:00 - 22:00',
  ];

  final List<String> sesiDipilih = [];

  int get totalHarga => sesiDipilih.length * 15000;

  void toggleSesi(String sesi) {
    setState(() {
      sesiDipilih.contains(sesi)
          ? sesiDipilih.remove(sesi)
          : sesiDipilih.add(sesi);
    });
  }

  DateTime _latestEndTime(List<String> list) {
    final now = DateTime.now();
    DateTime latest = now;
    for (final s in list) {
      final endStr = s.split(' - ').last;
      final h = int.parse(endStr.split(':')[0]);
      final m = int.parse(endStr.split(':')[1]);
      final candidate = DateTime(now.year, now.month, now.day, h, m);
      if (candidate.isAfter(latest)) latest = candidate;
    }
    return latest;
  }

  Future<void> simpanBooking() async {
    if (sesiDipilih.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih minimal satu sesi')),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'User tidak login';

      final bookingId = const Uuid().v4();
      final endAt = _latestEndTime(sesiDipilih);

      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .set({
            'booking_id': bookingId,
            'user_id': user.uid,
            'lokasi': widget.lokasi,
            'gate': widget.namaGate,
            'gate_id': widget.gateId,
            'area': widget.area,
            'sesi': sesiDipilih,
            'total_harga': totalHarga,
            'status_pembayaran': 'belum bayar',
            'status': 'pending',
            'end_at': Timestamp.fromDate(endAt),
            'tanggal_booking': DateTime.now().toIso8601String(),
            'created_at': Timestamp.now(),
          });

      await FirebaseFirestore.instance
          .collection('parking_gates')
          .doc(widget.gateId)
          .update({'total_terisi': FieldValue.increment(1)});

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => PembayaranPage(bookingId: bookingId)),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal booking: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
      appBar: AppBar(
        title: const Text('Pilih Sesi'),
        backgroundColor: Colors.amber,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lokasi: ${widget.lokasi}'),
            Text('Gate: ${widget.namaGate}'),
            Text('Area: ${widget.area}'),
            const SizedBox(height: 20),
            const Text(
              'Pilih Sesi:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            ...sesiTersedia.map(
              (s) => CheckboxListTile(
                title: Text(s),
                value: sesiDipilih.contains(s),
                onChanged: (_) => toggleSesi(s),
              ),
            ),
            const SizedBox(height: 20),
            Text('Total Harga: Rp$totalHarga'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: simpanBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text(
                  'Lanjutkan Booking',
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
