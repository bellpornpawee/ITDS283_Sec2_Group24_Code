import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'chat.dart';
import 'chatbot.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  List<String> allLocations = [];
  List<String> filteredLocations = [];
  Map<String, bool> selectedLocations = {};

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLocationsFromDB();
    searchController.addListener(_filterLocations);
  }

  Future<void> _loadLocationsFromDB() async {
    final List<Map<String, dynamic>> rows =
        await DatabaseHelper.instance.queryAllRows();

    final Set<String> locations = rows
        .map((row) => row['location']?.toString() ?? '')
        .where((loc) => loc.isNotEmpty)
        .toSet();

    setState(() {
      allLocations = locations.toList();
      filteredLocations = allLocations;
      selectedLocations = {
        for (var loc in allLocations) loc: false,
      };
    });
  }

  void _filterLocations() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredLocations = allLocations
          .where((loc) => loc.toLowerCase().contains(query))
          .toList();
    });
  }

  void _clearSelection() {
    setState(() {
      searchController.clear();
      selectedLocations.updateAll((key, value) => false);
      filteredLocations = allLocations;
    });
  }

  void _submit() {
    final selected = selectedLocations.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationDetailPage(locations: selected),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, '/homepage'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () => Navigator.pushNamed(context, '/upload'),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => Navigator.pushNamed(context, '/chat'),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF0F1F3D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.location_on, size: 100),
            const SizedBox(height: 16),
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search Location',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredLocations.length,
                itemBuilder: (context, index) {
                  final loc = filteredLocations[index];
                  return CheckboxListTile(
                    title: Text(loc),
                    value: selectedLocations[loc] ?? false,
                    onChanged: (val) {
                      setState(() {
                        selectedLocations[loc] = val!;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: _submit,
                  child: const Text('Submit'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: _clearSelection,
                  child: const Text('Clear'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LocationDetailPage extends StatefulWidget {
  final List<String> locations;

  const LocationDetailPage({super.key, required this.locations});

  @override
  _LocationDetailPageState createState() => _LocationDetailPageState();
}

class _LocationDetailPageState extends State<LocationDetailPage> {
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    List<Map<String, dynamic>> allProducts = await DatabaseHelper.instance.queryAllRows();

    setState(() {
      products = allProducts.where((product) {
        return widget.locations.contains(product['location']);
      }).toList();
    });
  }

  void _navigateToChatPage(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(item: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Details', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatWithAdminPage(),
                ),
              );
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF0F1F3D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
              title: Text(product['name']),
              subtitle: Text('Location: ${product['location']}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(product: product),
                  ),
                );
              },
              trailing: IconButton(
                icon: const Icon(Icons.chat),
                onPressed: () => _navigateToChatPage(product),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({super.key, required this.product});

  void _navigateToChatPage(BuildContext context, Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(item: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () => _navigateToChatPage(context, product),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF0F1F3D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product['name'],
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text('Location: ${product['location']}'),
            const SizedBox(height: 8),
            Text('Description: ${product['description']}'),
          ],
        ),
      ),
    );
  }
}
