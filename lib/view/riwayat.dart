import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Padding(
      padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
      child: Stack(
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
                      ),
                      StreamBuilder<DocumentSnapshot>(
                        stream:
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                        builder: (context, snap) {
                          final uname =
                              snap.hasData
                                  ? (snap.data!.data() as Map)['username'] ??
                                      'Username'
                                  : 'Username';
                          return Text(
                            uname,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Alike',
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      Icon(Icons.notifications, size: 40),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(4, 4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/logo_parkiryukk.png',
                          width: 150,
                          height: 150,
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child:
                              userId == null
                                  ? const Center(
                                    child: Text('User belum login'),
                                  )
                                  : StreamBuilder<QuerySnapshot>(
                                    stream:
                                        FirebaseFirestore.instance
                                            .collection('bookings')
                                            .where('user_id', isEqualTo: userId)
                                            .where(
                                              'status_pembayaran',
                                              isEqualTo: 'sudah bayar',
                                            )
                                            .orderBy(
                                              'created_at',
                                              descending: true,
                                            )
                                            .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      final docs = snapshot.data?.docs ?? [];
                                      if (docs.isEmpty) {
                                        return const Center(
                                          child: Text(
                                            'Belum ada riwayat booking.',
                                          ),
                                        );
                                      }
                                      return ListView(
                                        children:
                                            docs.map((doc) {
                                              final data =
                                                  doc.data()
                                                      as Map<String, dynamic>;
                                              return Column(
                                                children: [
                                                  _buildItem(data),
                                                  const Divider(thickness: 1),
                                                ],
                                              );
                                            }).toList(),
                                      );
                                    },
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(Map<String, dynamic> data) {
    final tanggal =
        (data['tanggal_booking'] as String?)?.split('T').first ?? '-';
    final lokasi = data['lokasi'] ?? '-';
    final area = data['area'] ?? '-';
    final harga =
        data['total_harga'] != null ? 'Rp ${data['total_harga']}' : '-';
    final status = data['status_pembayaran'] ?? '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _row('Tanggal', tanggal),
        _row('Tempat', lokasi),
        _row('Kendaraan', area),
        _row('Harga', harga),
        _row('Status', status),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
          const Text(' : '),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
