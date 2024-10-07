import 'package:flutter/material.dart';
import 'package:rajputfoods/utils/utilspack1.dart';
import 'package:rajputfoods/pages/profile/login.dart';

class Intropage2 extends StatelessWidget {
  const Intropage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: PagewithSimpleBG(
        intro: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: Utilspack1.contextheight(context) / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Utilspack1.contextheight(context) / 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "Foodie is Where Your Comfort Food Resides",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          wordSpacing: 0.5,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      Utilspack1.sizedBox30,
                      const Text(
                        "Enjoy a fast and smooth food delivery at your doorstep",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF646464),
                          fontSize: 13,
                        ),
                      ),
                      Utilspack1.sizedBox30,
                      Utilspack1.sizedBox20,
                      SizedBox(
                        width: Utilspack1.contextwidth(context) / 2.8,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const Login()));
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              backgroundColor: const Color(0xFFE83636)),
                          child: const Text(
                            "Next",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
