import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajputfoods/pages/orders/orderscomps.dart';
import 'package:rajputfoods/utils/auth/apiutils.dart';
import 'package:rajputfoods/utils/backenddata/apifunctions/ordersapi.dart';
import 'package:rajputfoods/utils/backenddata/models/ordersdata.dart';
import 'package:rajputfoods/utils/providers/providers.dart';
import 'package:rajputfoods/utils/utilspack1.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  List<OrderlistData> _orders = [];
  int _orderslisted = 5;
  bool _isLoading = true;
  bool _hasError = false;
  UserIdProvider? _provider;

  String orderstatustostring(String statusid) {
    final Map<String, String> mapid = {
      "0": "Confirmed",
      "1": "Processing",
      "2": "On the Way",
      "3": "Delivered",
      "4": "Cancelled"
    };
    return mapid[statusid]!;
  }

  String pricetoint(String price) {
    double raw = double.parse(price);
    raw = raw + 50;
    return raw.toInt().toString();
  }

  Future<void> _fetchOrdersList(String userid) async {
    try {
      final orderlist =
          await OrdersApi.fetchorderlist(Encodedata.decodeid(userid));
      setState(() {
        _orders = orderlist;
        _isLoading = false;
      });
    } catch (e) {
      print("coudnt get internet $e");
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        setState(() {
          _provider = Provider.of<UserIdProvider>(context, listen: false);
        });
        _fetchOrdersList(_provider!.userid);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final imgapiurl = ApiUtils.imageapiurl(false);
    return Scaffold(
      body: PagewithSimpleBG(
          padding: const EdgeInsets.only(
            top: 40,
            right: 10,
            left: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                " Orders:",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFE21B1B),
                            strokeWidth: 5,
                          ),
                        )
                      : _hasError
                          ? const Center(
                              child: Text(
                                "Internet Connection Error",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            )
                          : _orders.isNotEmpty
                              ? RefreshIndicator(
                                  onRefresh: () {
                                    return Utilspack1.replacenavigateto(
                                        context, widget);
                                  },
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: _orders.length > 5
                                              ? _orderslisted
                                              : _orders.length,
                                          itemBuilder: (context, index) {
                                            final order = _orders[
                                                _orders.length - index - 1];
                                            print(
                                                "current order id: ${_orders.length - index - 1}");
                                            _orderslisted =
                                                _orders.length - index - 1;
                                            return Column(
                                              children: [
                                                OrderCard(
                                                    orderid: order.orderid,
                                                    imgurl:
                                                        "$imgapiurl/${order.image}",
                                                    itemstitle: order.title,
                                                    status: order.status,
                                                    price: pricetoint(
                                                        order.price)),
                                                const SizedBox(height: 5)
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      _orders.length > _orderslisted
                                          ? ElevatedButton(
                                              onPressed: () {
                                                if (_orders.length < 12) {
                                                  setState(() {
                                                    _orderslisted =
                                                        _orders.length;
                                                  });
                                                }
                                              },
                                              child: const Text("Load More"))
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                )
                              : const Center(
                                  child: Text(
                                    "No Orders Yet",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ))
            ],
          )),
    );
  }
}
