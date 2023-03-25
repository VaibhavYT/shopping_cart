// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badge;
import 'package:provider/provider.dart';
import 'package:shopping_cart/model/product_model.dart';
import 'package:shopping_cart/screens/cart_screen.dart';
import 'package:shopping_cart/utils/cart_provider.dart';
import 'package:shopping_cart/utils/db_helper.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  DBHelper dbHelper = DBHelper();
  List<String> productName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Chery',
    'Peach',
    'Mixed Fruit Basket',
  ];
  List<String> productUnit = [
    'KG',
    'Dozen',
    'KG',
    'Dozen',
    'KG',
    'KG',
    'KG',
  ];
  List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];
  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg',
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg',
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg',
    'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612',
    'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612',
    'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612',
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612',
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CartScreen()));
            },
            child: Center(
              child: badge.Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return Text(
                      value.getTotalPrice().toString(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                badgeAnimation: const badge.BadgeAnimation.fade(
                  animationDuration: Duration(milliseconds: 300),
                ),
                child: const Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: productName.length,
                  itemBuilder: (context, index) {
                    return Card(
                      // color: Colors.green[100],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image(
                                  height: 100,
                                  width: 100,
                                  image: NetworkImage(
                                      productImage[index].toString()),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productName[index],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        '${productUnit[index]} \$${productPrice[index]}',
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () {
                                            dbHelper
                                                .insert(
                                              Cart(
                                                  id: index,
                                                  productId: index.toString(),
                                                  productName:
                                                      productName[index]
                                                          .toString(),
                                                  initialPrice:
                                                      productPrice[index],
                                                  productPrice:
                                                      productPrice[index],
                                                  quantity: 1,
                                                  unitTag: productUnit[index]
                                                      .toString(),
                                                  image: productImage[index]
                                                      .toString()),
                                            )
                                                .then((value) {
                                              cart.addTotalPrice(double.parse(
                                                  productPrice[index]
                                                      .toString()));
                                              cart.addCounter();
                                              print("Product is added");
                                            }).onError((error, stackTrace) {
                                              print(error.toString());
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            height: 30,
                                            width: 100,
                                            child: const Center(
                                                child: Text(
                                              'Add to Cart',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
