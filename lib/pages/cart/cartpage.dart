import 'package:provider/provider.dart';
import 'package:rajputfoods/pages/cart/cartcomponents.dart';
import 'package:rajputfoods/pages/cart/confirmorder.dart';
import 'package:rajputfoods/utils/backenddata/models/orderrequestdata.dart';
import 'package:rajputfoods/utils/providers/providers.dart';
import 'package:rajputfoods/utils/sharedprefs/sharedprefs.dart';
import 'package:rajputfoods/utils/utilspack1.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:rajputfoods/utils/utilspack2.dart';

class Cartpage extends StatefulWidget {
  const Cartpage({
    super.key,
  });

  @override
  State<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {
  final sharedprefs = SharedprefStoreItem();
  List<Map<String, dynamic>> _cartitems = [];
  bool _isLoading = true;
  bool _hasError = false;
  List prices = [];
  List quantities = [];
  List<Map<String, dynamic>> itemdetails = [];
  int shippingprice(bool isnotempty) {
    if (isnotempty) {
      return 50;
    } else {
      return 0;
    }
  }

  int totalprice(List allprices) {
    List<double> pricelist = [];
    int sum = 0;
    for (int i = 0; i < allprices.length; i++) {
      pricelist.add(double.parse(prices[i]));
    }
    for (double number in pricelist) {
      sum += number.toInt();
    }
    return sum;
  }

  int parsetoint(dynamic value) {
    double raw = double.parse(value);
    return raw.toInt();
  }

  int totalquantity(List quantities) {
    List<int> quantitylist = [];
    int sum = 0;
    for (int i = 0; i < quantities.length; i++) {
      quantitylist.add(int.parse(quantities[i]));
    }
    for (int number in quantitylist) {
      sum += number;
    }
    return sum;
  }

  List<Map<String, dynamic>> mapitems() {
    return _cartitems.map((item) {
      int priceperitem =
          parsetoint(item['price']) * parsetoint(item['quantity']);
      prices.add(priceperitem.toString());
      quantities.add(item['quantity']);

      return {
        'item_id': item['id'],
        'quantity': item['quantity'].toString(),
        'unit_price': item['price'].toString(),
      };
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _fetchitems().then((value) {
      itemdetails = mapitems();
    });
  }

  Future<void> _fetchitems() async {
    try {
      final indexprov = Provider.of<ItemIndexProvider>(context, listen: false);

      final rawlist = await getitemlistasString(context, indexprov);

      final data = jsonDecode(rawlist);
      final List<Map<String, dynamic>> itemList =
          List<Map<String, dynamic>>.from(data);

      setState(() {
        _cartitems = itemList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<String> getitemlistasString(
      BuildContext context, ItemIndexProvider indexprov) async {
    // final int nofrows = await getitemrows(context, sharedprefs, indexprov);
    final itemslist = await sharedprefs.getItemsListJson(); // nofrows
    return itemslist;
  }

  Future<int> getitemrows(BuildContext context, SharedprefStoreItem prefs,
      ItemIndexProvider indexprov) async {
    final int getrowscount = await prefs.getItemsRowCount();
    indexprov.changeindex(getrowscount);
    return getrowscount;
  }

  @override
  Widget build(BuildContext context) {
    final idprovider = Provider.of<UserIdProvider>(context);
    return Scaffold(
        body: PagewithwhiteBG(
          padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
          child: RefreshIndicator(
            onRefresh: () {
              return Utilspack1.replacenavigateto(context, widget);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  " Cart:",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: _cartitems.isEmpty
                      ? Utilspack1.contextheightvbtm(context) - 100
                      : Utilspack1.contextheightvbtm(context) * 0.63,
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _hasError
                          ? const Center(child: Text("Failed to load data"))
                          : _cartitems.isEmpty
                              ? const Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "No Items added to Cart",
                                    style: TextStyle(
                                        fontSize: 20,
                                        height: 2,
                                        fontWeight: FontWeight.w700),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: _cartitems.length,
                                  itemBuilder: (context, index) {
                                    final cartitem = _cartitems[
                                        _cartitems.length - index - 1];
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: CartItemCard(
                                          imgurl: cartitem['imgurl'],
                                          title: cartitem['title'],
                                          price: cartitem['price'],
                                          quantity: cartitem['quantity'],
                                          onpressed: () async {
                                            await sharedprefs.deleteItem(
                                                "${_cartitems.length - index - 1}");
                                            if (mounted) {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                return const Cartpage();
                                              }));
                                            }
                                          }),
                                    );
                                  },
                                ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: _cartitems.isEmpty
            ? null
            : CheckoutSheet(
                subtotal: totalprice(prices),
                shipping: shippingprice(itemdetails.isNotEmpty),
                total:
                    totalprice(prices) + shippingprice(itemdetails.isNotEmpty),
                btntext: "Check Out",
                loading: false,
                onTap: () {
                  final orderrequest = OrderRequest(
                      items: itemdetails,
                      totalPrice: "${totalprice(prices)}",
                      customerId: idprovider.userid,
                      totalitems: totalquantity(quantities).toString(),
                      netPrice: "${totalprice(prices)}");
                  if (itemdetails.isNotEmpty) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ConfrmOrderPage(
                            subtotal: totalprice(prices),
                            shipping: shippingprice(itemdetails.isNotEmpty),
                            total: totalprice(prices) +
                                shippingprice(itemdetails.isNotEmpty),
                            orderRequest: orderrequest)));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        UtilsPack2.snackBar("Your cart is empty", 1));
                  }
                  print(
                      "total price : ${totalprice(prices)} total quantities: ${totalquantity(quantities)} Listof items : $itemdetails");
                },
              ));
  }
}
