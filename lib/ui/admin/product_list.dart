import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hyper_sell/ui/admin/add.dart';

class ProductList extends StatelessWidget {
  ProductList({Key? key}) : super(key: key);
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product List"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: db.collection('product').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    children: snapshot.data!.docs.map((doc) {
                      return Card(
                        child: Column(
                          children: [
                            SizedBox(
                                height: 100,
                                child: Image.asset('assets/images/M1.jpg')),
                            ListTile(
                              title: Text(doc.data()['name']),
                              subtitle: Text(doc.data()['description']),
                              trailing:
                                  Text("\$ " + doc.data()['price'].toString()),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
            flex: 5,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: SizedBox(
                width: 400,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const AddProduct()));
                    },
                    child: const Text("Add New Product")),
              ),
            ),
            flex: 1,
          )
        ],
      ),
    );
  }
}
