// import 'package:flutter/material.dart';
// import '../model/ModelCart.dart';
//
// class CartDetailScreen extends StatelessWidget {
//   final Item item;
//
//   const CartDetailScreen({Key? key, required this.item}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(item.name),
//         backgroundColor: Colors.blue[800],
//         elevation: 2,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Card untuk detail item
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 3,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildDetailRow("Name", item.name),
//                     const SizedBox(height: 12),
//                     _buildDetailRow("Price", "Rp ${item.price}"),
//                     const SizedBox(height: 12),
//                     _buildDetailRow("Quantity", item.quantity.toString()),
//                   ],
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             // Tombol Delete
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: () {
//                   Navigator.pop(context, 'delete');
//                 },
//                 icon: const Icon(Icons.delete),
//                 label: const Text("Delete Item", style: TextStyle(fontSize: 16)),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Helper untuk row detail
//   Widget _buildDetailRow(String label, String value) {
//     return Row(
//       children: [
//         Text(
//           "$label: ",
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             style: const TextStyle(fontSize: 16),
//           ),
//         ),
//       ],
//     );
//   }
// }
