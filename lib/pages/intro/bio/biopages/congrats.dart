import 'package:flutter/material.dart';
import 'package:rajputfoods/utils/utilspack1.dart';

class CongratsPage extends StatelessWidget {
  final String title;
  final String btnname;
  final String? userid;
  final Widget navigateto;
  final bool navigate;
  final bool? replace;
  const CongratsPage(
      {super.key,
      required this.title,
      required this.btnname,
      required this.navigateto,
      required this.navigate,
      String? tuserid,
      bool? replacet})
      : replace = replacet ?? false,
        userid = tuserid ?? "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: PagewithSimpleBG(
        intro: true,
        child: Padding(
          padding: EdgeInsets.only(
              top: Utilspack1.contextheight(context) / 3.5,
              left: 30,
              right: 30,
              bottom: 30),
          child: SizedBox(
              height: Utilspack1.contextheight(context) -
                  (Utilspack1.contextheight(context) / 3.5 + 30),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/images/congrats.png",
                    scale: 2,
                  ),
                  Utilspack1.sizedBox15,
                  const Text(
                    "Congrats!",
                    style: TextStyle(
                        color: Color(0xFFE21B1B),
                        fontSize: 28,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 20, height: 1.5),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (userid != "") {}
                        navigate
                            ? replace!
                                ? Utilspack1.replacenavigateto(
                                    context, navigateto)
                                : Utilspack1.navigateto(context, navigateto)
                            : Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          backgroundColor: const Color(0xFFE83636)),
                      child: Text(
                        btnname,
                        style: const TextStyle(
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
