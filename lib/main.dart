import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/screens/product_list.dart';
import 'package:shopping_cart/utils/cart_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CartProvider(),
        child: Builder(builder: (BuildContext context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const ProductListScreen(),
          );
        }));
  }
}
