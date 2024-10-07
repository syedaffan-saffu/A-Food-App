import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rajputfoods/utils/auth/auth.dart';
import 'package:rajputfoods/utils/utilspack1.dart';
import 'package:rajputfoods/pages/profile/verifyotp.dart';
import 'package:rajputfoods/utils/pageutils/profileutils.dart';
import 'package:rajputfoods/pages/profile/resetpass.dart';

class ForgetPassPage extends StatefulWidget {
  const ForgetPassPage({super.key});

  @override
  State<ForgetPassPage> createState() => _ForgetPassPageState();
}

class _ForgetPassPageState extends State<ForgetPassPage> {
  TextEditingController emailcontroller = TextEditingController();
  // bool _selected1 = false;
  // bool _selected2 = false;
  bool _hasotpsent = false;
  bool _btndisabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        child: PagewithColoredBG(
          child: Padding(
            padding: EdgeInsets.only(
              left: Utilspack1.contextwidth(context) / 13,
              right: Utilspack1.contextwidth(context) / 13,
              top: Utilspack1.contextheight(context) / 2.9,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: Utilspack1.contextheight(context) / 1.85,
                  child: Card(
                    elevation: 3.0,
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Forget Password?",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w700),
                          ),
                          const Spacer(),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              "Enter your email below to reset password",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF646464),
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const Spacer(),
                          TextField(
                            controller: emailcontroller,
                            decoration: ProfileUtils.myinputdec(
                                hint: "Email",
                                icon: Icons.person,
                                ispassfield: false,
                                onpressed: () {}),
                          ),
                          // ListTile(
                          //   selected: _selected1,
                          //   selectedColor: const Color(0xFF000000),
                          //   selectedTileColor: const Color(0xFFFFEAEA),
                          //   splashColor: const Color(0x00FFFFFF),
                          //   onTap: () {
                          //     setState(() {
                          //       _selected1 = !_selected1;
                          //       _selected2 = false;
                          //     });
                          //   },
                          //   tileColor: const Color(0xFFEDEDED),
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(8)),
                          //   title: const Text(
                          //     "Via SMS",
                          //   ),
                          //   leading: const Icon(Icons.sms),
                          // ),
                          // const Spacer(),
                          // ListTile(
                          //   selected: _selected2,
                          //   selectedTileColor: const Color(0xFFFFEAEA),
                          //   selectedColor: const Color(0xFF000000),
                          //   splashColor: const Color(0x00FFFFFF),
                          //   onTap: () {
                          //     setState(() {
                          //       _selected2 = !_selected2;
                          //       _selected1 = false;
                          //     });
                          //   },
                          //   tileColor: const Color(0xFFEDEDED),
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(8)),
                          //   title: const Text("Via Email"),
                          //   leading: const Icon(Icons.email),
                          // ),
                          const Spacer(
                            flex: 3,
                          ),
                          ///////////////////////////////// button /////////////////////////////////////
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _btndisabled ? () {} : _attemptsendotp,
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  backgroundColor: const Color(0xFFE83636)),
                              child: _btndisabled
                                  ? const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        color: Color(0xFFFFFFFF),
                                        strokeWidth: 5,
                                      ),
                                    )
                                  : const Text(
                                      "Continue",
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _attemptsendotp() async {
    setState(() {
      _btndisabled = true;
    });

    await ForgetPass.authenticate(
        emailcontroller.text, _onvalidationresult, context);
    _hasotpsent
        ? {
            setState(() {
              _btndisabled = false;
            }),
            if (FocusManager.instance.primaryFocus != null)
              {FocusManager.instance.primaryFocus!.unfocus()},
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => OtpPage(
                      email: emailcontroller.text,
                      navigateto: ResetPassPage(
                        email: emailcontroller.text,
                      ),
                    )))
          }
        : setState(() {
            _btndisabled = false;
          });
  }

  void _onvalidationresult(bool otpsent) {
    setState(() {
      _hasotpsent = otpsent;
    });
  }
}
