import 'package:flutter/material.dart';
import 'package:rajputfoods/utils/utilspack1.dart';
import 'package:rajputfoods/pages/intro/bio/biopages/profileimg.dart';

class PayMethodPage extends StatelessWidget {
  const PayMethodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: PagewithSimpleBG(
            child: Padding(
          padding:
              const EdgeInsets.only(top: 100, left: 30, right: 30, bottom: 30),
          child: SizedBox(
            height: Utilspack1.contextheight(context) - 130,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Payment Method",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      wordSpacing: 0.5,
                      letterSpacing: 0.2,
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      height: 1.2),
                ),
                const Text(
                  "This data will be displayed in your account profile for security",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF646464),
                    fontSize: 15,
                  ),
                ),
                Column(
                  children: [
                    TapRegion(
                      onTapInside: (event) {},
                      child: Image.asset(
                        "assets/icons/paypal.png",
                        scale: 2,
                      ),
                    ),
                    Utilspack1.sizedBox15,
                    TapRegion(
                      onTapInside: (event) {},
                      child: Image.asset(
                        "assets/icons/visa.png",
                        scale: 2,
                      ),
                    ),
                    Utilspack1.sizedBox15,
                    TapRegion(
                      onTapInside: (event) {},
                      child: Image.asset(
                        "assets/icons/payoneer.png",
                        scale: 2,
                      ),
                    )
                  ],
                ),
                ///////////////////////////////////////////////////////////////////////////////////////////
                //////////////////////////////////////////////////////////////////////////////////////////
                Utilspack1.sizedBox30,
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const ProfileImgPage();
                      }));
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        backgroundColor: const Color(0xFFE83636)),
                    child: const Text(
                      "Next",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )));
  }
}
