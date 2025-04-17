// import 'package:flutter/material.dart';

// import 'homepage.dart'; // Import HomePage model (Product class)


// class DetailPage extends StatelessWidget {
//   final Map<String, dynamic> product;

//   const DetailPage({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(product['name']),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network(product['imageUrl']),
//             SizedBox(height: 16),
//             Text(
//               product['name'],
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(product['details']),
//           ],
//         ),
//       ),
//     );
//   }
// }