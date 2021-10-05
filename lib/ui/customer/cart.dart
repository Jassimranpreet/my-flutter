import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key, required this.productIDs}) : super(key: key);
  final List<String> productIDs;

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final db = FirebaseFirestore.instance;
  List<String> _products = [];

  @override
  void initState() {
    _products = widget.productIDs;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_products.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Cart")),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [Text("Your Cart is Empty")],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Cart"),
          actions: [
            IconButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.remove('products');
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete),
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text("Your Cart"),
            Expanded(
              child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<
                        DocumentSnapshot<Map<String, dynamic>>>(
                      future:
                          db.collection('product').doc(_products[index]).get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          Map<String, dynamic>? doc = snapshot.data!.data();
                          return Card(
                            child: ListTile(
                              leading: Image.asset('assets/images/M1.jpg'),
                              title: Text(doc!['name']),
                              subtitle: Text("\$ " + doc['price'].toString()),
                              trailing: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _products.remove(_products[index]);
                                    });
                                  },
                                  icon: const Icon(Icons.delete_forever)),
                            ),
                          );
                        }
                      },
                    );
                  }),
            ),
          ],
        ),
      );
    }
  }
}
