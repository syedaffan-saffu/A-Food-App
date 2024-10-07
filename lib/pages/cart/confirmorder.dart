import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajputfoods/pages/cart/cartcomponents.dart';
import 'package:rajputfoods/pages/cart/detailpages/editaddress.dart';
import 'package:rajputfoods/pages/cart/detailpages/editphone.dart';
import 'package:rajputfoods/pages/cart/detailpages/locationpick.dart';
import 'package:rajputfoods/pages/intro/bio/biopages/congrats.dart';
import 'package:rajputfoods/utils/auth/apiutils.dart';
import 'package:rajputfoods/utils/backenddata/apifunctions/ordersapi.dart';
import 'package:rajputfoods/utils/backenddata/apifunctions/profileapi.dart';
import 'package:rajputfoods/utils/backenddata/models/addressdata.dart';
import 'package:rajputfoods/utils/backenddata/models/orderrequestdata.dart';
import 'package:rajputfoods/utils/providers/providers.dart';
import 'package:rajputfoods/utils/sharedprefs/sharedprefs.dart';
import 'package:rajputfoods/utils/utilspack1.dart';
import 'package:rajputfoods/utils/utilspack2.dart';

final Image _editicon = Image.asset("assets/icons/editIcon.png");

class ConfrmOrderPage extends StatefulWidget {
  final int subtotal;
  final int shipping;
  final int total;
  final OrderRequest orderRequest;

  const ConfrmOrderPage({
    super.key,
    required this.subtotal,
    required this.shipping,
    required this.total,
    required this.orderRequest,
  });

  @override
  State<ConfrmOrderPage> createState() => _ConfrmOrderPageState();
}

class _ConfrmOrderPageState extends State<ConfrmOrderPage> {
  SharedprefStoreItem prefs = SharedprefStoreItem();
  TextEditingController phonecont = TextEditingController();
  TextEditingController addtitle = TextEditingController();
  TextEditingController addressfull = TextEditingController();
  UserIdProvider? idprovider;
  bool _locprovided = false;
  bool _phoneprovided = true;
  bool _cloudaddress = false;
  String _orderid = "";
  bool _success = false;
  bool _loading = false;
  bool _disablebtn = false;
  String phone = "";
  bool _fetchsuccess = false;
  bool _fetchloading = false;
  bool _newaddress = false;
  UserAddresses? addresses;
  List<UserAddresses>? _userAddresses;

  String _currenttitle = "";
  String _currentaddress = "";
  Future<UserAddresses> _getAddress(String id) async {
    final userdata = await Profileapis.fetchuserprofile(
      Encodedata.decodeid(id),
    );
    return UserAddresses(
        useraddress: userdata.data!.address!,
        title: userdata.data!.addresstitle!,
        addressid: "");
  }

  Future<void> _getaddresses(UserIdProvider prov) async {
    final userdata = await Profileapis.fetchuseraddresses(
      Encodedata.decodeid(prov.userid),
    );
    setState(() {
      _userAddresses = userdata.data;
    });
  }

  Future<String> _getPhone(String id) async {
    final userdata = await Profileapis.fetchuserprofile(
      Encodedata.decodeid(id),
    );
    return userdata.data!.phone!;
  }

  void changeadd(int slct) {
    setState(() {
      _currenttitle = _userAddresses![slct].title;
      _currentaddress = _userAddresses![slct].useraddress;
      _cloudaddress = false;
      _locprovided = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      setState(() {
        idprovider = Provider.of<UserIdProvider>(context, listen: false);
        _cloudaddress = true;
        _phoneprovided = false;
      });
      _getaddresses(idprovider!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final indexprovider = Provider.of<TabIndexProvider>(context);
    final locprov = Provider.of<LocationProvider>(context);
    return Stack(
      children: [
        Scaffold(
          body: Column(
            children: [
              PagewithSimpleBG(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back_ios),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Confirm Order',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(color: Color(0xFF000000))
                          ],
                          border: Border.all(color: const Color(0xFF000000)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Deliver to"),
                                  TextButton(
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero),
                                      onPressed: () {
                                        indexprovider.changeindex(3);
                                      },
                                      child: const Text(
                                        "Manage Profile",
                                        style:
                                            TextStyle(color: Color(0xFFE21B1B)),
                                      ))
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                  height:
                                      Utilspack1.contextheight(context) * .08,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFEAEA),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.add_location,
                                            color: Colors.orange,
                                          ),
                                          style: IconButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              shape: const CircleBorder()),
                                          onPressed: () {
                                            Utilspack1.navigateto(context,
                                                PickLocationPage(
                                              onNext: (result) {
                                                final location = [
                                                  result!.geometry.location.lat
                                                      .toString(),
                                                  result.geometry.location.lng
                                                      .toString(),
                                                  result.formattedAddress ??
                                                      "*Add Address*",
                                                ];
                                                locprov.changedata(location);
                                                print(locprov.data);
                                                setState(() {
                                                  _currenttitle = "current";
                                                  _currentaddress =
                                                      locprov.data[2];
                                                  _locprovided = true;
                                                });
                                              },
                                            ));
                                          },
                                        ),
                                        _locprovided
                                            ? Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      decoration: BoxDecoration(
                                                          color: const Color(
                                                              0xFFE26622),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Text(
                                                        _currenttitle,
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    Text(
                                                      locprov.data[2].length >
                                                              20
                                                          ? "${locprov.data[2].substring(0, 20)}..."
                                                          : locprov.data[2],
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black),
                                                    ),
                                                    _userAddresses!.isEmpty
                                                        ? const SizedBox
                                                            .shrink()
                                                        : SizedBox(
                                                            height: 40,
                                                            child: IconButton(
                                                              onPressed: () {
                                                                Editaddress.dialog(
                                                                    context,
                                                                    _userAddresses!,
                                                                    changeadd);
                                                              },
                                                              icon: _editicon,
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                              )
                                            : _cloudaddress
                                                ? FutureBuilder(
                                                    future: _getAddress(
                                                        idprovider!.userid),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        _currentaddress =
                                                            snapshot.data!
                                                                .useraddress;
                                                        if (snapshot
                                                            .data!.useraddress
                                                            .contains("*")) {
                                                          return TextButton(
                                                              onPressed: () {
                                                                Utilspack1
                                                                    .navigateto(
                                                                        context,
                                                                        AddAddress(
                                                                          onTap:
                                                                              () {
                                                                            if (addtitle.text.isEmpty ||
                                                                                addressfull.text.isEmpty) {
                                                                              ScaffoldMessenger.of(context).showSnackBar(UtilsPack2.snackBar("Plz fill all fields", 1));
                                                                            } else {
                                                                              setState(() {
                                                                                _currenttitle = addtitle.text;
                                                                                _currentaddress = addressfull.text;
                                                                                _cloudaddress = false;
                                                                                _newaddress = true;
                                                                              });
                                                                              Navigator.of(context).pop();
                                                                            }
                                                                          },
                                                                          controller1:
                                                                              addtitle,
                                                                          controller2:
                                                                              addressfull,
                                                                        ));
                                                              },
                                                              child: const Text(
                                                                  "*Add Address*"));
                                                        } else {
                                                          _currenttitle =
                                                              snapshot
                                                                  .data!.title;
                                                          return Expanded(
                                                            child: Row(
                                                              children: [
                                                                _currenttitle !=
                                                                        ""
                                                                    ? Container(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            3),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                const Color(0xFFE26622),
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        child:
                                                                            Text(
                                                                          _currenttitle,
                                                                          style: const TextStyle(
                                                                              fontSize: 12,
                                                                              color: Colors.white),
                                                                        ),
                                                                      )
                                                                    : const SizedBox(
                                                                        width:
                                                                            15,
                                                                      ),
                                                                Text(
                                                                  snapshot.data!.useraddress
                                                                              .length >
                                                                          15
                                                                      ? "${snapshot.data!.useraddress.substring(0, 15)}..."
                                                                      : snapshot
                                                                          .data!
                                                                          .useraddress,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                const Spacer(),
                                                                _userAddresses!
                                                                        .isNotEmpty
                                                                    ? SizedBox(
                                                                        height:
                                                                            40,
                                                                        child:
                                                                            IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            Editaddress.dialog(
                                                                                context,
                                                                                _userAddresses!,
                                                                                changeadd);
                                                                          },
                                                                          icon:
                                                                              _editicon,
                                                                        ),
                                                                      )
                                                                    : const SizedBox
                                                                        .shrink(),
                                                              ],
                                                            ),
                                                          );
                                                        }
                                                      } else {
                                                        return const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 15),
                                                          child: SizedBox(
                                                            height: 30,
                                                            child: AspectRatio(
                                                                aspectRatio:
                                                                    1 / 1,
                                                                child:
                                                                    CircularProgressIndicator()),
                                                          ),
                                                        );
                                                      }
                                                    })
                                                : Expanded(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3),
                                                          decoration: BoxDecoration(
                                                              color: const Color(
                                                                  0xFFE26622),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Text(
                                                            _currenttitle
                                                                .toUpperCase(),
                                                            style: const TextStyle(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        Text(
                                                          _currentaddress
                                                                      .length >
                                                                  20
                                                              ? ": ${_currentaddress.substring(0, 20)}.."
                                                              : ": $_currentaddress",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        const Spacer(),
                                                        _newaddress
                                                            ? const SizedBox
                                                                .shrink()
                                                            : SizedBox(
                                                                height: 40,
                                                                child:
                                                                    IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    Editaddress.dialog(
                                                                        context,
                                                                        _userAddresses!,
                                                                        changeadd);
                                                                  },
                                                                  icon:
                                                                      _editicon,
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                      ],
                                    ),
                                  )),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                  height:
                                      Utilspack1.contextheight(context) * .05,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFEAEA),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Utilspack1.navigateto(
                                                context,
                                                EditPhone(
                                                    text: phone,
                                                    controller: phonecont,
                                                    onTap: () {
                                                      if (phonecont.text
                                                              .isNotEmpty &&
                                                          ValidationUtils
                                                              .isPhoneValid(
                                                                  phonecont
                                                                      .text)) {
                                                        setState(() {
                                                          phone =
                                                              phonecont.text;
                                                          _phoneprovided = true;
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                      } else if (!ValidationUtils
                                                          .isPhoneValid(
                                                              phonecont.text)) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                UtilsPack2.snackBar(
                                                                    "Phone is not Valid",
                                                                    2));
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                UtilsPack2.snackBar(
                                                                    "Plz enter your number",
                                                                    1));
                                                      }
                                                    }));
                                          },
                                          style: IconButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              shape: const CircleBorder()),
                                          icon: const Icon(
                                            Icons.phone,
                                            color: Colors.orange,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        _phoneprovided
                                            ? Text(
                                                phone,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: phone.contains("*")
                                                        ? const Color(
                                                            0xFFE21B1B)
                                                        : Colors.black),
                                              )
                                            : FutureBuilder(
                                                future: _getPhone(
                                                    idprovider!.userid),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    phone = snapshot.data!;
                                                    return Text(
                                                      snapshot.data!,
                                                      style: TextStyle(
                                                          fontSize: snapshot
                                                                  .data!
                                                                  .contains("*")
                                                              ? 15
                                                              : 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: snapshot.data!
                                                                  .contains("*")
                                                              ? const Color(
                                                                  0xFFE21B1B)
                                                              : Colors.black),
                                                    );
                                                  } else {
                                                    return const AspectRatio(
                                                        aspectRatio: 1 / 1,
                                                        child:
                                                            CircularProgressIndicator());
                                                  }
                                                }),
                                      ],
                                    ),
                                  )),
                              const SizedBox(
                                height: 25,
                              ),
                              const Text("Payment Method"),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Cash on delivery'),
                                  Radio(
                                    activeColor: const Color(0xFFE21B1B),
                                    value: true,
                                    groupValue: true,
                                    onChanged: (value) {},
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomSheet: CheckoutSheet(
              subtotal: widget.subtotal,
              shipping: widget.shipping,
              total: widget.total,
              btntext: "Confirm Order",
              loading: _loading,
              onTap: _disablebtn
                  ? () {}
                  : () async {
                      setState(() {
                        _disablebtn = true;
                        _loading = true;
                      });

                      if (!phone.contains("*") &&
                          !_currentaddress.contains("*")) {
                        print("${locprov.data[0]}:::::::::: long");
                        final orderdata = OrderRequest(
                            netPrice: widget.orderRequest.netPrice,
                            items: widget.orderRequest.items,
                            totalPrice: widget.orderRequest.totalPrice,
                            customerId: widget.orderRequest.customerId,
                            totalitems: widget.orderRequest.totalitems,
                            phone: phone,
                            locationtitle: _currenttitle,
                            latitude: locprov.data[0],
                            longitude: locprov.data[1],
                            location: _currentaddress);
                        print(jsonEncode(orderdata));
                        await OrdersApi.sendOrderRequest(
                            orderdata, setorderid, issuccess, haserror);
                        if (_success) {
                          await prefs.deleteItemList();
                          setState(() {
                            _loading = false;
                          });
                          Utilspack1.rootnavigateto(
                                  context,
                                  CongratsPage(
                                      title:
                                          "Your Order Placed Successfully Order ID: $_orderid",
                                      btnname: "View Order",
                                      navigateto: const SizedBox(),
                                      navigate: false))
                              .then((value) {
                            indexprovider.changeindex(2);
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              UtilsPack2.snackBar("Couldn't place order", 1));
                          setState(() {
                            _loading = false;
                            _disablebtn = false;
                          });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            UtilsPack2.snackBar(
                                "Add valid address or phone", 1));
                        setState(() {
                          _loading = false;
                          _disablebtn = false;
                        });
                      }
                    }),
        ),
      ],
    );
  }

  void haserror(bool hasherror) {
    if (hasherror) {
      setState(() {
        _loading = false;
        _disablebtn = false;
      });
    }
  }

  void setorderid(String id) {
    setState(() {
      _orderid = id;
    });
  }

  void issuccess(bool success) {
    setState(() {
      _success = true;
    });
  }
}
