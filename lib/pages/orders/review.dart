import 'dart:io';
import 'package:provider/provider.dart';
import 'package:rajputfoods/pages/intro/bio/biopages/congrats.dart';
import 'package:rajputfoods/utils/backenddata/apifunctions/ordersapi.dart';
import 'package:rajputfoods/utils/backenddata/models/orderrequestdata.dart';
import 'package:rajputfoods/utils/providers/providers.dart';
import 'package:rajputfoods/utils/utilspack1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajputfoods/utils/utilspack2.dart';

class RateFoodScreen extends StatefulWidget {
  final String orderid;
  const RateFoodScreen({super.key, required this.orderid});

  @override
  State<RateFoodScreen> createState() => _RateFoodScreenState();
}

class _RateFoodScreenState extends State<RateFoodScreen> {
  final TextEditingController _controller = TextEditingController();
  double foodRating = 0.0;
  File? image;
  bool _ispicked = false;
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  int maximages = 5;

  bool _loading = false;

  bool _disablebtn = false;

  bool _success = false;

  Future<void> sendReview(OrderReview orderreview) async {
    setState(() {
      _disablebtn = true;
      _loading = true;
    });
    await OrdersApi.sendOrderReview(orderreview, issuccess, haserror);
    if (_success) {
      setState(() {
        _loading = false;
      });
      Utilspack1.replacenavigateto(
          context,
          const CongratsPage(
              title: "Your Review has been Sent",
              btnname: "Continue Ordering",
              navigateto: SizedBox(),
              navigate: false));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(UtilsPack2.snackBar("Couldn't send Review", 1));
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> imgpath() async {
    if (imageFileList.length <= maximages) {
      final rawimg = await imagePicker.pickImage(source: ImageSource.gallery);
      if (rawimg != null) {
        image = File(rawimg.path);
        setState(() {
          _ispicked = true;
          imageFileList.add(rawimg);
        });
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("max images selected")));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final idprovider = Provider.of<UserIdProvider>(context);
    final height = MediaQuery.sizeOf(context).height * 0.915;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
        appBar: null,
        body: SingleChildScrollView(
          child: PagewithRedBG(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              SizedBox(
                height: height * .24,
                width: width,
                child: const Center(
                  child: Text(
                    "Order Complete",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                height: height * .75,
                width: width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFF555555)),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40),
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('What is your rate?',
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                      const SizedBox(
                        height: 30,
                      ),

                      //Rating bar
                      RatingBar.builder(
                        initialRating: 0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        ),
                        onRatingUpdate: (rating) {
                          foodRating = rating;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Please share your opinion\nabout the Food',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: width * .85,
                        height: height * .15,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          maxLength: 200,
                          maxLines: 4,
                          controller: _controller,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: 'Your review',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: height * 0.15,
                        child: Row(
                          children: [
                            Card(
                              shape: const BeveledRectangleBorder(),
                              color: const Color(0xFFEEEEEE),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        style: IconButton.styleFrom(
                                            fixedSize: const Size(50, 50),
                                            backgroundColor: Colors.red),
                                        onPressed: imgpath,
                                        icon: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        )),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      'Add your photos',
                                      style: TextStyle(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: imageFileList.length,
                                    itemBuilder: (context, index) {
                                      return Badge(
                                        backgroundColor: Colors.transparent,
                                        alignment: Alignment.topRight,
                                        largeSize: 50,
                                        padding: EdgeInsets.zero,
                                        label: IconButton(
                                            icon: const Icon(
                                              Icons.cancel,
                                              color: Color(0xFFE21B1B),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                imageFileList.removeAt(index);
                                              });
                                            }),
                                        child: Card(
                                          shape: const BeveledRectangleBorder(),
                                          color: const Color(0xFFEEEEEE),
                                          child: AspectRatio(
                                            aspectRatio: 1 / 1,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                              child: _ispicked
                                                  ? Image.file(
                                                      File(imageFileList[index]
                                                          .path),
                                                      fit: BoxFit.fill,
                                                    )
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      );
                                    })),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                            onPressed: _disablebtn
                                ? () {}
                                : () async {
                                    final orderreview = OrderReview(
                                        comment: _controller.text,
                                        salesid: widget.orderid,
                                        customerId: idprovider.userid,
                                        rating: foodRating.toString());
                                    await sendReview(orderreview);
                                  },
                            child: _loading
                                ? const CircularProgressIndicator(
                                    color: Color(0xFFE21B1B),
                                  )
                                : const Text('Send review')),
                      )
                    ],
                  ),
                ),
              )
            ],
          )),
        ));
  }

  void haserror(bool hasherror) {
    if (hasherror) {
      setState(() {
        _loading = false;
        _disablebtn = false;
      });
    }
  }

  void issuccess(bool success) {
    _success = true;
  }
}
