import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rajputfoods/pages/orders/orderdetails.dart';

class Ordersutils {
  static Widget divider(bool iscompleted) {
    // if (iscompleted) {
    return Center(
      child: SizedBox(
        height: 40,
        child: VerticalDivider(
          color: iscompleted ? Colors.red : Colors.grey[500],
        ),
      ),
    );
  }

  static Widget trackprogress(
    String status,
    bool iscompleted,
    bool isactive,
    String time,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            flex: 2,
            child: Text(
              textAlign: TextAlign.center,
              iscompleted ? time : "-soon-",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: iscompleted || isactive
                      ? const Color(0xFF000000)
                      : const Color(0xFFAAAAAA)),
            )),
        Expanded(
          flex: 1,
          child: Icon(
            Icons.circle,
            color: iscompleted ? Colors.red : Colors.orangeAccent,
            size: isactive ? 26 : 16,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            status,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: iscompleted || isactive
                    ? const Color(0xFF000000)
                    : const Color(0xFFAAAAAA)),
          ),
        )
      ],
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, String> mapid = const {
    "0": "Confirmed",
    "1": "Processing",
    "2": "On the Way",
    "3": "Delivered",
    "4": "Cancelled"
  };
  final String orderid;
  final String itemstitle;
  final String imgurl;
  final String status;
  final String price;
  const OrderCard(
      {super.key,
      required this.orderid,
      required this.imgurl,
      required this.itemstitle,
      required this.status,
      required this.price});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: status == "4"
          ? null
          : () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TrackOrderPage(
                        status: status,
                        titles: itemstitle.split(", "),
                        imgurl: imgurl,
                        orderid: orderid,
                        price: price,
                      )));
            },
      child: Card(
          color: const Color(0xFFFFFFFF),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0xFFCCCCCC), width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: SizedBox(
              height: 80,
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE21B1B),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: imgurl,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        // height: 40,
                        width: double.maxFinite,
                        child: Text(
                          itemstitle.length > 20
                              ? "${itemstitle.substring(0, 20).toUpperCase()} ..."
                              : itemstitle.toUpperCase(),
                          // overflow: TextOverflow.clip,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                      Text(
                        "status: ${mapid[status]}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  )),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Rs.",
                        style: TextStyle(
                          color: Color(0xFFE21B1B),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        price,
                        style: const TextStyle(
                          color: Color(0xFFE21B1B),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

 // Card(
    //   color: const Color(0xFFFFFFFF),
    //   shape: RoundedRectangleBorder(
    //       side: const BorderSide(color: Color(0xFFCCCCCC), width: 2),
    //       borderRadius: BorderRadius.circular(10)),
    //   child: ListTile(
    //     onTap: () {
    //       Navigator.of(context).push(MaterialPageRoute(
    //           builder: (context) => TrackOrderPage(
    //                 imgurl: imgurl,
    //                 orderid: orderid,
    //                 price: price,
    //               )));
    //     },
    //     leading: Container(
    //       width: 50,
    //       height: 50,
    //       padding: EdgeInsets.all(5),
    //       decoration: BoxDecoration(
    //         color: const Color(0xFFE21B1B),
    //         borderRadius: BorderRadius.circular(8),
    //       ),
    //       child: Image.network(
    //         "${ApiUtils.imageapiurl(true)}/$imgurl",
    //         fit: BoxFit.fill,
    //       ),
    //     ),
    //     title: Text(
    //       items,
    //       style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    //     ),
    //     subtitle: Text(
    //       "status: $status",
    //       style: const TextStyle(fontSize: 16),
    //     ),
    //     trailing: Text(
    //       "Rs. $price",
    //       style: const TextStyle(
    //           color: Color(0xFFE21B1B),
    //           fontSize: 14,
    //           fontWeight: FontWeight.w600),
    //     ),
    //   ),
    // );