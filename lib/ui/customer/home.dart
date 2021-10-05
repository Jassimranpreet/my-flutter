import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hyper_sell/controller.dart';
import 'package:hyper_sell/ui/customer/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _selectedIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  void _onItemTap(int index) {
    if (index == 3) {
      _auth.signOut();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const Controller(type: 0)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: db.collection('product').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              children: snapshot.data!.docs.map((doc) {
                return Card(
                  child: Column(
                    children: [
                      SizedBox(
                          height: 250,
                          child: Image.asset('assets/images/M1.jpg')),
                      ListTile(
                        title: Text(doc.data()['name']),
                        subtitle: Text(doc.data()['description']),
                        trailing: Text("\$ " + doc.data()['price'].toString()),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ProductScreen(productID: doc.id)));
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.blue, textTheme: Theme.of(context).textTheme),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTap,
          backgroundColor: Colors.blueAccent,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined), label: "Search"),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_add_outlined), label: "Fav"),
            BottomNavigationBarItem(
                icon: Icon(Icons.logout_outlined), label: "Log Out")
          ],
        ),
      ),
    );
  }
}
