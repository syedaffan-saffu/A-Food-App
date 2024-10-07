import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajputfoods/pages/cart/cartcomponents.dart';
import 'package:rajputfoods/pages/cart/confirmorder.dart';
import 'package:rajputfoods/utils/backenddata/models/orderrequestdata.dart';
import 'package:rajputfoods/utils/providers/providers.dart';
import 'package:rajputfoods/utils/utilspack1.dart';

class OrderNowPage extends StatelessWidget {
  final String orderid;
  final String imgurl;
  final String title;
  final String price;
  final String quantity;
  const OrderNowPage(
      {super.key,
      required this.imgurl,
      required this.title,
      required this.price,
      required this.quantity,
      required this.orderid});

  @override
  Widget build(BuildContext context) {
    final idprov = Provider.of<UserIdProvider>(context);
    final int shipping = 50;
    return Scaffold(
        body: PagewithwhiteBG(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            children: [
              SizedBox(
                width: Utilspack1.contextwidth(context) * 0.95,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: Utilspack1.contextwidth(context) * .25,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey)),
                          child: CachedNetworkImage(
                            imageUrl: imgurl,
                            fit: BoxFit.fill,
                            placeholder: (context, url) => const Padding(
                              padding: EdgeInsets.all(20),
                              child: AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: CircularProgressIndicator(
                                      color: Colors.red)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Rs. ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xffEC2578)),
                                ),
                                Text(
                                  price,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xffE21B1B)),
                                ),
                              ],
                            ),
                            const Text(
                              'Special Toppings...',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff646464)),
                            ),
                            Text(
                              'Quantity:  $quantity',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff646464)),
                            )
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomSheet: CheckoutSheet(
          subtotal: _subtotal(quantity, price),
          shipping: 50,
          total: _totalprice(_subtotal(quantity, price)),
          btntext: "Check Out",
          loading: false,
          onTap: () {
            final orderrequest = OrderRequest(
                items: itemdetails(orderid, quantity, price),
                totalPrice: price,
                customerId: idprov.userid,
                totalitems: quantity,
                netPrice: "${_totalprice(_subtotal(quantity, price))}");

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ConfrmOrderPage(
                    subtotal: _subtotal(quantity, price),
                    shipping: shipping,
                    total: _totalprice(_subtotal(quantity, price)),
                    orderRequest: orderrequest)));

            print(
                "total price : ${_totalprice(_subtotal(quantity, price))} total quantities: $quantity Listof items : ${itemdetails(orderid, quantity, price)}");
          },
        ));
  }
}

int _totalprice(int price) {
  final total = price + 50;
  return total;
}

List<Map<String, dynamic>> itemdetails(
    String id, String quantity, String price) {
  return [
    {'item_id': id, 'quantity': quantity, 'unit_price': price}
  ];
}

int _subtotal(String quantity, String price) {
  final int rawprice = int.parse(price) * int.parse(quantity);
  return rawprice;
}
