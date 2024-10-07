import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rajputfoods/utils/utilspack1.dart';

class CheckoutSheet extends StatelessWidget {
  final int subtotal;
  final int shipping;
  final int total;
  final void Function() onTap;
  final String btntext;
  final bool loading;
  const CheckoutSheet(
      {super.key,
      required this.subtotal,
      required this.shipping,
      required this.total,
      required this.onTap,
      required this.btntext,
      required this.loading});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFEAEA),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      ),
      height: Utilspack1.contextheightvbtm(context) * .25,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text('Subtotal'), Text('Rs. $subtotal')],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text('Delivery'), Text("Rs. $shipping")],
          ),
          const Spacer(
            flex: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff646464)),
              ),
              Text(
                'Rs. $total',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff646464)),
              )
            ],
          ),
          const Spacer(
            flex: 3,
          ),
          InkWell(
            onTap: onTap,
            child: Container(
              height: Utilspack1.contextheightvbtm(context) * 0.06,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: const Color(0xFFE21B1B),
              ),
              child: Center(
                child: loading
                    ? const CircularProgressIndicator(
                        color: Color(0xFFFFFFFF),
                      )
                    : Text(
                        btntext,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final String imgurl;
  final String title;
  final String price;
  final String quantity;
  final void Function() onpressed;
  const CartItemCard(
      {super.key,
      required this.imgurl,
      required this.title,
      required this.price,
      required this.quantity,
      required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Utilspack1.contextwidth(context) * 0.9,
      child: Card(
        elevation: 4,
        shadowColor: const Color(0xFFFFEEEE),
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0xFFE21B1B), width: 0.5),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: Utilspack1.contextwidth(context) * .25,
                height: Utilspack1.contextwidth(context) * .25,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFDDDDDD))),
                child: CachedNetworkImage(
                  imageUrl: imgurl,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => const Padding(
                    padding: EdgeInsets.all(20),
                    child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: CircularProgressIndicator(color: Colors.red)),
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
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
              IconButton(onPressed: onpressed, icon: const Icon(Icons.delete))
            ],
          ),
        ),
      ),
    );
  }
}
