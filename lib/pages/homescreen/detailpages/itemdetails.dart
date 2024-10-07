import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rajputfoods/pages/cart/ordernow.dart';
import 'package:rajputfoods/utils/sharedprefs/sharedprefs.dart';
import 'package:rajputfoods/utils/utilspack1.dart';

class Itemdetailspage extends StatefulWidget {
  final String id;
  final String imgurl;
  final String title;
  // final String category;
  final String price;
  const Itemdetailspage(
      {super.key,
      required this.imgurl,
      required this.title,
      // required this.category,
      required this.price,
      required this.id});

  @override
  State<Itemdetailspage> createState() => _ItemdetailspageState();
}

class _ItemdetailspageState extends State<Itemdetailspage> {
  final SharedprefStoreItem sharedprefs = SharedprefStoreItem();
  int _quantity = 1;
  String? selectedtopping;
  static const String description =
      "The perfect and delicious diet, packed with wholesome nutrients which not only fulfils your tummy but also the taste";

  bool _itemstoreloading = false;

  int _parsetoint(String pprice) {
    double price = double.parse(pprice);
    return price.toInt();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CachedNetworkImage(
            imageUrl: widget.imgurl,
            height: Utilspack1.contextheight(context) * 0.33,
            width: Utilspack1.contextwidth(context),
            fit: BoxFit.fill,
          ),
          // Container(
          //   alignment: Alignment.center,
          //   color: const Color(0xFFFFBABA),
          //   height: Utilspack1.contextheight(context) / 3,
          //   padding: const EdgeInsets.all(30),
          //   child: CachedNetworkImage(
          //     imageUrl: widget.imgurl,
          //     fit: BoxFit.fill,
          //     placeholder: (context, url) => const Padding(
          //       padding: EdgeInsets.all(30),
          //       child: AspectRatio(
          //           aspectRatio: 1 / 1,
          //           child: CircularProgressIndicator(color: Colors.red)),
          //     ),
          //   ),
          // ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title.toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Text("Rs. ${_parsetoint(widget.price)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                  const Text(description),
                  // DropdownButtonHideUnderline(
                  //     child: DropdownButton2(
                  //   isExpanded: true,
                  //   hint: const Text("Topping"),
                  //   onChanged: (value) {
                  //     setState(() {
                  //       selectedtopping = value;
                  //     });
                  //   },
                  //   value: selectedtopping,
                  //   items: const [
                  //     DropdownMenuItem(
                  //       value: "cheese",
                  //       child: Text("cheese"),
                  //     ),
                  //     DropdownMenuItem(
                  //       value: "spices",
                  //       child: Text("spices"),
                  //     ),
                  //   ],
                  //   buttonStyleData: ButtonStyleData(
                  //       decoration: BoxDecoration(
                  //           border: Border.all(color: Colors.grey))),
                  //   dropdownStyleData: const DropdownStyleData(elevation: 1),
                  // )),
                  widget.id == "0"
                      ? const SizedBox.shrink()
                      : const Text("Quantity:",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                  widget.id == "0"
                      ? const SizedBox.shrink()
                      : Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: const Color(0xFFE18888).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                              "Total Rs. ${_parsetoint(widget.price) * _quantity}",
                              style: const TextStyle(
                                  color: Color(0xFFE23B3B),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15)),
                        ),
                  widget.id == "0"
                      ? const SizedBox.shrink()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  if (_quantity > 1) {
                                    setState(() {
                                      _quantity--;
                                    });
                                  }
                                },
                                icon: const Icon(Icons.remove)),
                            Align(
                                alignment: Alignment.center,
                                child: Text(
                                  _quantity.toString(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                )),
                            IconButton(
                                onPressed: () {
                                  if (_quantity < 50) {
                                    setState(() {
                                      _quantity++;
                                    });
                                  }
                                },
                                icon: const Icon(Icons.add)),
                          ],
                        ),
                  widget.id == "0"
                      ? const SizedBox.shrink()
                      : SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      _itemstoreloading = true;
                                    });
                                    final json =
                                        '{"id": "${widget.id}", "quantity" : "$_quantity", "imgurl" : "${widget.imgurl}", "price" : "${widget.price}", "title" : "${widget.title}"}';
                                    await sharedprefs.storeItem(
                                        context, json, _isorderstored);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF27B1B)),
                                  child: _itemstoreloading
                                      ? const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(
                                            color: Color(0xFFFFFFFF),
                                            strokeWidth: 5,
                                          ),
                                        )
                                      : const Text("Add to Cart"),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    final parseprice =
                                        _parsetoint(widget.price).toString();

                                    Utilspack1.navigateto(
                                      context,
                                      OrderNowPage(
                                          imgurl: widget.imgurl,
                                          title: widget.title,
                                          price: parseprice,
                                          quantity: _quantity.toString(),
                                          orderid: widget.id),
                                    );
                                  },
                                  child: const Text("Order Now"),
                                ),
                              )
                            ],
                          ),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _isorderstored(bool status) {
    setState(() {
      _itemstoreloading = false;
    });
  }
}
