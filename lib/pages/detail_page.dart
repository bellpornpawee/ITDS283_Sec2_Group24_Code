import 'dart:io';
import 'package:flutter/material.dart';
import 'chat.dart'; 
import 'chatbot.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const DetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = product['imageUrl']; // If the image is fetched from the network
    final String? imagePath = product['imagePath']; // If the image is stored locally

    Widget imageWidget;
    if (imagePath != null && imagePath.isNotEmpty) {
      imageWidget = Image.file(File(imagePath), fit: BoxFit.cover);
    } else if (imageUrl != null && imageUrl.isNotEmpty) {
      imageWidget = Image.network(imageUrl, fit: BoxFit.cover);
    } else {
      imageWidget = Container(
        height: 200,
        color: Colors.grey[300],
        child: const Center(child: Text('No image')),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF0F1F3D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Text(
            product['name'] ?? 'No Name',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // Navigate to the chatbot page when the three-dot icon is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChatWithAdminPage(), // Chatbot page
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.purpleAccent,
                    child: Text('A', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'] ?? '',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(product['type'] ?? ''),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 16),

              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageWidget,
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                product['description'] ?? '',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),

              // Location
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 18),
                  const SizedBox(width: 4),
                  Text(product['location'] ?? ''),
                ],
              ),
              const SizedBox(height: 12),

              // Subtitle (replacing Extra note)
              Text(
                product['subtitle'] ?? 'No additional information provided.',
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 24),

              // Chat Button
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(item: product),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.purple),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text(
                    'Chat',
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
