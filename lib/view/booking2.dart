import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'booking3.dart';
import 'package:parkir/utils/global.colors.dart';

class Booking2 extends StatelessWidget {
  final String lokasi;
  const Booking2({super.key, required this.lokasi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
      appBar: AppBar(
        title: Text('Pilih Gate di $lokasi'),
        backgroundColor: Colors.amber,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('parking_gates')
                .where('lokasi', isEqualTo: lokasi)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Tidak ada gate di lokasi ini.'));
          }

          final gates = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pilih Gate:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: gates.length,
                    itemBuilder: (context, index) {
                      final gate = gates[index];
                      final data = gate.data() as Map<String, dynamic>;
                      final totalSlot = data['total_slot'] ?? 0;
                      final totalTerisi = data['total_terisi'] ?? 0;
                      final sisaSlot = totalSlot - totalTerisi;
                      final gatePenuh = sisaSlot <= 0;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: ElevatedButton(
                          onPressed:
                              gatePenuh
                                  ? () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Slot di gate ini sudah penuh. Silakan pilih gate lain.',
                                        ),
                                      ),
                                    );
                                  }
                                  : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => Booking3(
                                              lokasi: lokasi,
                                              gateId: gate.id,
                                              namaGate:
                                                  data['gateName'] ?? 'Gate',
                                              area: data['area'] ?? 'mobil',
                                            ),
                                      ),
                                    );
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                gatePenuh ? Colors.grey : Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${data['gateName']} (${data['area']})',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                gatePenuh
                                    ? 'Penuh'
                                    : 'Sisa Slot: $sisaSlot dari $totalSlot',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: gatePenuh ? Colors.red : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
