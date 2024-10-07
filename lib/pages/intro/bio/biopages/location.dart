import 'package:flutter/material.dart';
import 'package:rajputfoods/utils/utilspack1.dart';
import 'package:rajputfoods/pages/bottomnavpage.dart';
import 'package:rajputfoods/pages/intro/bio/biopages/congrats.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Set your Location",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                  const Text(
                    "This data will be displayed in your account profile for security",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF646464),
                      fontSize: 15,
                    ),
                  ),
                  Utilspack1.sizedBox30,
                  Image.asset(
                    "assets/images/clrlocation.png",
                    scale: 2,
                  ),
                  Utilspack1.sizedBox30,
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(
                          color: Color(0xFFE21B1B),
                        )),
                    leading: Image.asset(
                      "assets/icons/addicon.png",
                      scale: 1.5,
                    ),
                    title: const Text(
                      "Set your location",
                      style: TextStyle(
                          color: Color(0xFFE21B1B),
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const CongratsPage(
                                  title: "Your Profile Is Ready To Use",
                                  btnname: "Try Order",
                                  navigateto: PagewithBottomBar(),
                                  navigate: true,
                                )));
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
              )),
        ),
      ),
    );
  }
}
