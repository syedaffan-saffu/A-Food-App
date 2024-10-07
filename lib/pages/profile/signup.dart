import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajputfoods/main.dart';
import 'package:rajputfoods/pages/bottomnavpage.dart';
import 'package:rajputfoods/utils/auth/apiutils.dart';
import 'package:rajputfoods/utils/auth/auth.dart';
import 'package:rajputfoods/utils/providers/providers.dart';
import 'package:rajputfoods/utils/sharedprefs/sharedprefs.dart';
import 'package:rajputfoods/utils/utilspack1.dart';
import 'package:rajputfoods/pages/intro/bio/biopages/congrats.dart';
import 'package:rajputfoods/pages/profile/login.dart';
import 'package:rajputfoods/pages/profile/verifyotp.dart';
import 'package:rajputfoods/utils/pageutils/profileutils.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  SharedprefStoreUser prefs = SharedprefStoreUser();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  bool _btndisabled = false;

  bool _signupvalid = false;
  bool _obscure = true;
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
                bottom: 20),
            child: Column(
              children: [
                SizedBox(
                  height: Utilspack1.contextheight(context) * 0.52,
                  child: Card(
                    elevation: 3.0,
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        children: [
                          const Text(
                            "Signup",
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w700),
                          ),
                          const Spacer(),
                          TextField(
                            controller: namecontroller,
                            decoration: ProfileUtils.myinputdec(
                              hint: "Name",
                              icon: Icons.person,
                              ispassfield: false,
                            ),
                          ),
                          Utilspack1.sizedBox15,
                          TextField(
                            controller: emailcontroller,
                            decoration: ProfileUtils.myinputdec(
                              hint: "Email",
                              icon: Icons.email,
                              ispassfield: false,
                            ),
                          ),
                          Utilspack1.sizedBox15,
                          TextField(
                            controller: passcontroller,
                            obscureText: _obscure,
                            decoration: ProfileUtils.myinputdec(
                              hint: "Password",
                              icon: Icons.lock,
                              ispassfield: true,
                              onpressed: () {
                                setState(() {
                                  _obscure = !_obscure;
                                });
                              },
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _btndisabled
                                  ? null
                                  : () async {
                                      await _attemptsignup();
                                    },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  backgroundColor: const Color(0xFFE83636)),
                              child: _btndisabled
                                  ? const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: AspectRatio(
                                        aspectRatio: 1 / 1,
                                        child: CircularProgressIndicator(
                                          color: Color(0xFFFFFFFF),
                                          strokeWidth: 5,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      "Create Account",
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
                const Spacer(),
                const Text(
                  "Already have an Account",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return const Login();
                      }));
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        // color: Color(0xFFE83636),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _attemptsignup() async {
    setState(() {
      _btndisabled = true;
    });

    await AuthSignup.auth(namecontroller.text, emailcontroller.text,
        passcontroller.text, _onvalidationresult, context);
    _signupvalid
        ? {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return OtpPage(
                  email: emailcontroller.text,
                  navigateto: const CongratsPage(
                    replacet: true,
                    btnname: "Try Order",
                    title: "Profile is Ready to use",
                    navigateto: Login(),
                    navigate: true,
                  ));
            }))
          }
        : setState(() {
            _btndisabled = false;
          });
  }

  void _onvalidationresult(bool isValid) {
    setState(() {
      _signupvalid = isValid;
    });
  }
}
