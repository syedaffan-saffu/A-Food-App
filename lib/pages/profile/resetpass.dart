import 'package:flutter/material.dart';
import 'package:rajputfoods/utils/auth/auth.dart';
import 'package:rajputfoods/utils/utilspack1.dart';
import 'package:rajputfoods/pages/intro/bio/biopages/congrats.dart';
import 'package:rajputfoods/pages/profile/login.dart';
import 'package:rajputfoods/utils/pageutils/profileutils.dart';

class ResetPassPage extends StatefulWidget {
  final String email;
  const ResetPassPage({
    super.key,
    required this.email,
  });

  @override
  State<ResetPassPage> createState() => _ResetPassPageState();
}

class _ResetPassPageState extends State<ResetPassPage> {
  TextEditingController password = TextEditingController();
  TextEditingController cnfrmpassword = TextEditingController();
  bool _resetpassvalid = false;
  bool _obscure1 = true;
  bool _obscure2 = true;
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
                            "Reset your password here",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w700),
                          ),
                          const Spacer(),
                          const Text(
                            "Enter your new password and then confirm new password",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF646464),
                              fontSize: 15,
                            ),
                          ),
                          const Spacer(
                            flex: 2,
                          ),
                          TextField(
                            controller: password,
                            obscureText: _obscure1,
                            decoration: ProfileUtils.myinputdec(
                              hint: "Enter new password",
                              icon: Icons.lock,
                              ispassfield: true,
                              onpressed: () {
                                setState(() {
                                  _obscure1 = !_obscure1;
                                });
                              },
                            ),
                          ),
                          const Spacer(),
                          TextField(
                            controller: cnfrmpassword,
                            obscureText: _obscure2,
                            decoration: ProfileUtils.myinputdec(
                              hint: "Confirm new password",
                              icon: Icons.lock,
                              ispassfield: true,
                              onpressed: () {
                                setState(() {
                                  _obscure2 = !_obscure2;
                                });
                              },
                            ),
                          ),
                          const Spacer(
                            flex: 2,
                          ),
                          ///////////////////////////////// button /////////////////////////////////////
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed:
                                  _btndisabled ? () {} : _attemptresetpass,
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  backgroundColor: const Color(0xFFE83636)),
                              child: _btndisabled
                                  ? const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
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

  Future<void> _attemptresetpass() async {
    setState(() {
      _btndisabled = true;
    });

    await ResetPass.reset(widget.email, password.text, cnfrmpassword.text,
        _onvalidationresult, context);
    _resetpassvalid
        ? {
            setState(() {
              _btndisabled = false;
            }),
            if (FocusManager.instance.primaryFocus != null)
              {FocusManager.instance.primaryFocus!.unfocus()},
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CongratsPage(
                      title: "Password Reset Successfully",
                      btnname: "Try Login",
                      navigateto: Login(),
                      navigate: true,
                    )))
          }
        : setState(() {
            _btndisabled = false;
          });
  }

  void _onvalidationresult(bool isValid) {
    setState(() {
      _resetpassvalid = isValid;
    });
  }
}
