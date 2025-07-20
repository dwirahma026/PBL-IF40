import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:parkir/utils/global.colors.dart';
import 'notifications.dart';
import 'booking1.dart';
import 'riwayat.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _Dashboard(),
      const RiwayatPage(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
      body: pages[_current],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _current,
        backgroundColor: Colors.amber,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        onTap: (i) => setState(() => _current = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Center(child: Text('User belum login'));

    final bookingStream =
        FirebaseFirestore.instance
            .collection('bookings')
            .where('user_id', isEqualTo: uid)
            .where('status', isEqualTo: 'aktif')
            .orderBy('created_at', descending: true)
            .limit(1)
            .snapshots();

    return Stack(
      children: [
        _yellowBackground(),
        SafeArea(
          child: Column(
            children: [
              _header(),
              const SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: bookingStream,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snap.hasData && snap.data!.docs.isNotEmpty) {
                      final doc = snap.data!.docs.first;
                      final data = doc.data() as Map<String, dynamic>;
                      DateTime? endDt;

                      final rawEnd = data['end_at'];
                      if (rawEnd is Timestamp) {
                        endDt = rawEnd.toDate();
                      } else if (rawEnd is String && rawEnd.isNotEmpty) {
                        endDt = DateTime.parse(rawEnd);
                      }

                      if (endDt != null && DateTime.now().isAfter(endDt)) {
                        doc.reference.update({
                          'status': 'expired',
                          'status_pembayaran': 'sudah bayar',
                          'update_at': Timestamp.now(),
                        });
                        return _emptyCard(context);
                      }
                      return _qrCard(
                        context,
                        qrData: data['booking_id'] ?? doc.id,
                        lokasi: data['lokasi'] ?? '-',
                        gate: data['gate'] ?? '-',
                        sesi: (data['sesi'] as List?)?.join(', ') ?? '-',
                        onCancel: () async {
                          await doc.reference.update({
                            'status': 'dibatalkan',
                            'status_pembayaran': 'dibatalkan',
                            'updated_at': Timestamp.now(),
                          });
                        },
                      );
                    }
                    return _emptyCard(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _yellowBackground() => Container(
    height: 250,
    width: double.infinity,
    decoration: const BoxDecoration(
      color: Colors.amber,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(100),
        bottomRight: Radius.circular(100),
      ),
    ),
  );

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/images/logo_parkiryukk.png', width: 40),
          StreamBuilder<DocumentSnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
            builder: (context, snap) {
              String uname = 'Username';
              if (snap.hasData && snap.data!.data() != null) {
                final m = snap.data!.data()! as Map<String, dynamic>;
                uname = m['username'] ?? 'Username';
              }
              return Text(
                uname,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Alike',
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          const Icon(Icons.notifications, size: 40),
        ],
      ),
    );
  }
}

Widget _qrCard(
  BuildContext ctx, {
  required String qrData,
  required String lokasi,
  required String gate,
  required String sesi,
  required VoidCallback onCancel,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 30),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
    decoration: BoxDecoration(
      color: const Color(0xFFE0E0E0),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: [
        Image.asset('assets/images/logo_parkiryukk.png', width: 120),
        const SizedBox(height: 20),
        QrImageView(data: qrData, version: QrVersions.auto, size: 200),
        const SizedBox(height: 12),
        Text(
          'Lokasi: $lokasi\nGate: $gate\nSesi: $sesi',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: onCancel,
            child: const Text(
              'Batal Booking',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _emptyCard(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 30),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
    decoration: BoxDecoration(
      color: const Color(0xFFE0E0E0),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: [
        Image.asset('assets/images/logo_parkiryukk.png', width: 150),
        const SizedBox(height: 30),
        const Text(
          'Anda\nSedang\nTidak\nParkir ...',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'Alike',
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Booking1()),
                ),
            child: const Text(
              'Booking Tempat Parkir',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Alike',
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
