import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hyper_sell/ui/customer/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key, required this.productID}) : super(key: key);
  final String productID;

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final db = FirebaseFirestore.instance;
  int _cartCount = 0;

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      List<String> productIDs = value.getStringList('products') ?? [];
      _cartCount = productIDs.length;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: db.collection('product').doc(widget.productID).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          Map<String, dynamic>? doc = snapshot.data!.data();
          return Scaffold(
            appBar: AppBar(
              title: Text(doc!['name']),
              actions: [
                IconButton(
                    onPressed: () {
                      SharedPreferences.getInstance().then((value) {
                        List<String> _productIDs =
                            value.getStringList('products') ?? [];
                        _cartCount = _productIDs.length;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CartScreen(productIDs: _productIDs)));
                      });
                    },
                    icon: const Icon(Icons.shopping_basket_outlined)),
                Text(_cartCount.toString())
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset('assets/images/M1.jpg'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Text(
                            doc['name'],
                            textAlign: TextAlign.center,
                          ),
                          flex: 3),
                      Expanded(
                          child: Text("\$ " + doc['price'].toString()),
                          flex: 1),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(doc['description']),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        List<String> productIDs =
                            prefs.getStringList('products') ?? [];

                        if (productIDs.contains(widget.productID)) {
                          Fluttertoast.showToast(
                              msg: "Product Already In Cart",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          productIDs.add(widget.productID);
                          prefs.setStringList('products', productIDs);
                          setState(() {
                            _cartCount++;
                          });
                        }
                      },
                      child: const Text("Add To Cart"),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
