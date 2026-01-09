// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:pruductservice/providers/cart_provider.dart';
// import 'package:pruductservice/screen/cart_detail_screen.dart';
// import 'package:pruductservice/model/ModelCart.dart';
//
// class CartScreen extends StatefulWidget {
//   const CartScreen({Key? key}) : super(key: key);
//
//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }
//
// class _CartScreenState extends State<CartScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       Provider.of<CartProvider>(context, listen: false).getCart();
//     });
//   }
//
//   Future<bool> _confirmDelete(BuildContext context, String name) async {
//     return await showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Hapus Item"),
//         content: Text("Apakah kamu yakin ingin menghapus '$name'?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text("Batal"),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text("Hapus", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final cartProvider = Provider.of<CartProvider>(context);
//     final ModelCart? cartData = cartProvider.cart;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Shopping Cart'),
//         backgroundColor: Colors.blue[800],
//         elevation: 2,
//       ),
//       body: cartData == null
//           ? const Center(child: CircularProgressIndicator())
//           : cartData.items.isEmpty
//           ? Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const [
//             Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey),
//             SizedBox(height: 20),
//             Text(
//               'Your cart is empty',
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//             ),
//           ],
//         ),
//       )
//           : Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: cartData.items.length,
//               itemBuilder: (context, index) {
//                 final Item item = cartData.items[index];
//
//                 return Card(
//                   elevation: 3,
//                   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   child: ListTile(
//                     onTap: () async {
//                       final result = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => CartDetailScreen(item: item),
//                         ),
//                       );
//
//                       if (result == 'delete') {
//                         await cartProvider.deleteItem(item.id);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text("Item '${item.name}' deleted"),
//                           ),
//                         );
//                       }
//                     },
//                     leading: Container(
//                       width: 50,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         color: Colors.blue[50],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Icon(Icons.shopping_bag, color: Colors.blue),
//                     ),
//                     title: Text(
//                       item.name,
//                       style: const TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                     subtitle: Text(
//                       "Rp ${item.price} x ${item.quantity}",
//                       style: const TextStyle(color: Colors.grey),
//                     ),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       onPressed: () async {
//                         bool confirm = await _confirmDelete(context, item.name);
//                         if (!confirm) return;
//
//                         await cartProvider.deleteItem(item.id);
//
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text("Item '${item.name}' deleted"),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           // TOTAL PRICE
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.2),
//                   spreadRadius: 2,
//                   blurRadius: 8,
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Total Price:',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   "Rp ${cartData.total}",
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
