import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rajputfoods/utils/utilspack1.dart';

class SpecialDealsCard extends StatelessWidget {
  const SpecialDealsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Utilspack1.contextheight(context) / 6,
      width: Utilspack1.contextwidth(context) - 60,
      child: Card(
        color: const Color(0xFFE21B1B),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: (Utilspack1.contextwidth(context) - 60) / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Special Deals for December",
                      style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w600),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        onPressed: () {},
                        child: const Text(
                          "Buy Now",
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFE21B1B),
                              fontWeight: FontWeight.w600),
                        )),
                  ],
                ),
              ),
              Image.asset("assets/images/icecream.png")
            ],
          ),
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final bool networkimg;
  final String price;
  final String img;
  final String title;
  final String categoryid;
  final void Function()? onTap;
  const ItemCard(
      {super.key,
      required this.price,
      required this.img,
      required this.title,
      required this.categoryid,
      required this.networkimg,
      this.onTap});

  int parsetoint(String price) {
    double raw = double.parse(price);
    return raw.toInt();
  }

  @override
  Widget build(BuildContext context) {
    final double cardconstraints = Utilspack1.contextwidth(context) / 2.5;
    return SizedBox(
      width: cardconstraints,
      height: cardconstraints,
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 0,
          color: const Color(0xFFFFEAEA),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                networkimg
                    ? CachedNetworkImage(
                        imageUrl: img,
                        height: cardconstraints / 2,
                        width: cardconstraints / 1.8,
                        fit: BoxFit.fill,
                        errorWidget: (context, url, error) {
                          return const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error,
                                color: Colors.orangeAccent,
                              ),
                              Text(
                                "Can't load Image",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          );
                        },
                        placeholder: (context, url) {
                          return const AspectRatio(
                            aspectRatio: 1 / 1,
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(
                                color: Colors.red,
                              ),
                            ),
                          );
                        },
                      )
                    : Image.asset(
                        img,
                        height: cardconstraints / 2,
                        width: cardconstraints / 1.8,
                        fit: BoxFit.fill,
                      ),
                Text(
                  textAlign: TextAlign.center,
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: title.length < 14 ? 16 : 12),
                ),
                Text(
                  "Rs. ${parsetoint(price)}",
                  style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFFE21B1B),
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
