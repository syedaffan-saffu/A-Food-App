import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rajputfoods/pages/homescreen/detailpages/itemdetails.dart';
import 'package:rajputfoods/pages/orders/orderlist.dart';
import 'package:rajputfoods/pages/orders/orderscomps.dart';
import 'package:rajputfoods/pages/orders/review.dart';
import 'package:rajputfoods/utils/backenddata/apifunctions/ordersapi.dart';
import 'package:rajputfoods/utils/backenddata/models/ordersdata.dart';
import 'package:rajputfoods/utils/utilspack1.dart';
import 'package:rajputfoods/utils/utilspack2.dart';

class TrackOrderPage extends StatefulWidget {
  final String status;
  final String orderid;
  final String imgurl;
  final String price;
  final List<String> titles;
  const TrackOrderPage(
      {super.key,
      required this.orderid,
      required this.imgurl,
      required this.price,
      required this.titles,
      required this.status});

  @override
  State<TrackOrderPage> createState() => _TrackOrderPageState();
}

class _TrackOrderPageState extends State<TrackOrderPage> {
  static const TextStyle _bodystyle = TextStyle(
      fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFF908585));
  List<bool> activestatus = [false, false, false, false];
  List<bool> completedstatus = [false, false, false, false];
  List<OrderItemDetails> itemslist = [];
  bool _isLoading = true;
  bool _isitemsLoading = true;
  Timer? _timer;
  bool _cancelloading = false;

  String amount = '34\$';
  // bool _hasError = false;
  List<String> times = ["", "", "", ""];

  int intparsed(String id) {
    return int.parse(id);
  }

  Future<void> _fetchItemsList() async {
    try {
      final itemslistraw = await OrdersApi.fetchorderitemslist(widget.orderid);
      if (itemslistraw.isNotEmpty) {
        setState(() {
          itemslist = itemslistraw;
          _isitemsLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isitemsLoading = false;
      });
    }
  }

  Future<void> _fetchStatusList() async {
    try {
      final statuslistraw = await OrdersApi.fetchstatuslist(widget.orderid);
      if (statuslistraw.isNotEmpty) {
        final status =
            int.parse(statuslistraw[statuslistraw.length - 1].status);
        setState(() {
          for (int i = 0; i <= status; i++) {
            times[i] = statuslistraw[i].time.substring(11, 16);
            completedstatus[i] = true;
          }
          activestatus[status] = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _fetchStatusList(); // Fetch updates every 10 seconds
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchItemsList();
    _fetchStatusList();
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      body: PagewithSimpleBG(
          padding: const EdgeInsets.only(
            top: 40,
            left: 20,
            right: 20,
          ),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFE21B1B),
                    strokeWidth: 5,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 25),
                      height: (height * 0.95) - 100,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                          color: const Color(0xFFFFFFFF),
                          border: Border.all(
                              color: const Color(0xFF000000).withOpacity(0.25),
                              width: 1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Order Details:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    'Order ID: ${widget.orderid}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      height: 1.4,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              completedstatus[3]
                                  ? ElevatedButton(
                                      onPressed: () {
                                        Utilspack1.navigateto(
                                            context,
                                            RateFoodScreen(
                                              orderid: widget.orderid,
                                            ));
                                      },
                                      child: const Text("Review"))
                                  : ElevatedButton(
                                      onPressed:
                                          completedstatus[1] && activestatus[1]
                                              ? null
                                              : () {
                                                  showDialog(
                                                      useRootNavigator: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          content: _cancelloading
                                                              ? const CircularProgressIndicator()
                                                              : null,
                                                          title: _cancelloading
                                                              ? const Text(
                                                                  "Cancelling your Order")
                                                              : const Text(
                                                                  "Sure to cancel Order?"),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        "No")),
                                                            TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  final cancel =
                                                                      await OrdersApi.cancelorder(
                                                                          widget
                                                                              .orderid);
                                                                  showDialog(
                                                                      useRootNavigator:
                                                                          false,
                                                                      barrierDismissible:
                                                                          false,
                                                                      context:
                                                                          context,
                                                                      builder: (context) => const AlertDialog(
                                                                          title: Text(
                                                                              "Cancelling Order"),
                                                                          content: SizedBox(
                                                                              height: 50,
                                                                              width: 50,
                                                                              child: CircularProgressIndicator())));

                                                                  if (cancel) {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    Utilspack1.replacenavigateto(
                                                                        context,
                                                                        const OrderListPage());
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(UtilsPack2.snackBar(
                                                                            "Order cancelled Successfully",
                                                                            1));
                                                                    // showDialog(
                                                                    //     context:
                                                                    //         context,
                                                                    //     builder:
                                                                    //         (context) {
                                                                    //       return AlertDialog(
                                                                    //         title:
                                                                    //             const Text("Your Order is Cancelled"),
                                                                    //         actions: [
                                                                    //           TextButton(
                                                                    //               onPressed: () {
                                                                    //                 Utilspack1.replacenavigateto(context, const OrderListPage());
                                                                    //               },
                                                                    //               child: const Text("Ok"))
                                                                    //         ],
                                                                    //       );
                                                                    //     });
                                                                  } else {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(UtilsPack2.snackBar(
                                                                            "Can't cancel your order",
                                                                            1));
                                                                  }
                                                                },
                                                                child: _cancelloading
                                                                    ? const CircularProgressIndicator()
                                                                    : const Text(
                                                                        "Yes"))
                                                          ],
                                                        );
                                                      });
                                                },
                                      child: const Text("cancel"))
                            ],
                          ),
                          const Spacer(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: height * .1,
                                width: height * .1,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFE21B1B),
                                    borderRadius: BorderRadius.circular(10)),
                                child: CachedNetworkImage(
                                  imageUrl: widget.imgurl,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) => const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: CircularProgressIndicator(
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Total"),
                                  Text(
                                    'Rs. ${widget.price}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Text(
                                    'Includes Shipping:',
                                    style: TextStyle(
                                      color: Color(0xFFE27722),
                                      fontSize: 11,
                                    ),
                                  ),
                                  const Text(
                                    'Rs. 50',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFE21B1B),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            'Items:',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              height: 1.4,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: height * .2,
                            child: _isitemsLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFE21B1B),
                                      strokeWidth: 5,
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: widget.titles.length,
                                    padding: const EdgeInsets.all(10),
                                    itemBuilder: (context, index) {
                                      final itemlist = itemslist[index];

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 13),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    Utilspack1.navigateto(
                                                        context,
                                                        Itemdetailspage(
                                                            imgurl:
                                                                itemlist.img,
                                                            title: widget
                                                                .titles[index],
                                                            price:
                                                                itemlist.price,
                                                            id: "0"));
                                                  },
                                                  icon: CachedNetworkImage(
                                                    imageUrl: itemlist.img,
                                                    fit: BoxFit.fill,
                                                    height: 30,
                                                    width: 30,
                                                    placeholder:
                                                        (context, url) =>
                                                            const Padding(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child:
                                                          CircularProgressIndicator(
                                                              color:
                                                                  Colors.red),
                                                    ),
                                                  ),
                                                ),
                                                // Image.network(
                                                //   itemlist.img,
                                                //   height: 30,
                                                //   width: 30,
                                                //   fit: BoxFit.fill,
                                                // ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  widget.titles[index].length >
                                                          11
                                                      ? "${widget.titles[index].substring(0, 11)}..."
                                                          .toUpperCase()
                                                      : widget.titles[index]
                                                          .toUpperCase(),
                                                  style: _bodystyle,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              itemlist.quantity,
                                              style: _bodystyle,
                                            ),
                                            Text(
                                              textAlign: TextAlign.right,
                                              'Rs. ${double.parse(itemlist.price).toInt()}',
                                              style: _bodystyle,
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                          ),
                          const Spacer(),
                          const Text(
                            "Status:",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                          const Spacer(),
                          Ordersutils.trackprogress("Confirmed",
                              completedstatus[0], activestatus[0], times[0]),
                          Ordersutils.divider(completedstatus[1]),
                          Ordersutils.trackprogress("Processing",
                              completedstatus[1], activestatus[1], times[1]),
                          Ordersutils.divider(completedstatus[2]),
                          Ordersutils.trackprogress("On the Way",
                              completedstatus[2], activestatus[2], times[2]),
                          Ordersutils.divider(completedstatus[3]),
                          Ordersutils.trackprogress("Delivered",
                              completedstatus[3], activestatus[3], times[3]),
                        ],
                      ),
                    ),
                  ],
                )),
    );
  }
}
