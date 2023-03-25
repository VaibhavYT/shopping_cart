import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/model/product_model.dart';
import 'package:shopping_cart/utils/cart_provider.dart';
import 'package:badges/badges.dart' as badge;
import 'package:shopping_cart/utils/db_helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
        centerTitle: true,
        actions: [
          Center(
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
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: cart.getData(),
              builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
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
                                          image: NetworkImage(snapshot
                                              .data![index].image
                                              .toString()),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    snapshot.data![index]
                                                        .productName
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        dbHelper.delete(snapshot
                                                            .data![index].id!);
                                                        cart.removeCounter();
                                                        cart.removeTotalPrice(
                                                            double.parse(snapshot
                                                                .data![index]
                                                                .productPrice
                                                                .toString()));
                                                      },
                                                      child:
                                                          Icon(Icons.delete)),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                snapshot.data![index].unitTag
                                                        .toString() +
                                                    " " +
                                                    "\$" +
                                                    snapshot.data![index]
                                                        .productPrice
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    height: 30,
                                                    width: 100,
                                                    child: const Center(
                                                        child: Text(
                                                      'Added',
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
                          }));
                } else {}
                return Text('');
              }),
          Consumer<CartProvider>(builder: (context, value, child) {
            return Visibility(
              visible: value.getTotalPrice().toStringAsFixed(2)=="0.00"? false:true,
              child: Column(
                children: [
                  ReusableWidget(
                      title: 'SubTotal',
                      value: r'$' + value.getTotalPrice().toStringAsFixed(2))
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
