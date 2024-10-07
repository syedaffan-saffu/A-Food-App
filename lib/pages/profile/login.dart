import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:rajputfoods/pages/bottomnavpage.dart';
import 'package:rajputfoods/pages/intro/bio/biopages/congrats.dart';
import 'package:rajputfoods/utils/auth/apiutils.dart';
import 'package:rajputfoods/utils/auth/auth.dart';
import 'package:rajputfoods/utils/providers/providers.dart';
import 'package:rajputfoods/utils/sharedprefs/sharedprefs.dart';
import 'package:rajputfoods/utils/utilspack1.dart';
import 'package:rajputfoods/pages/profile/forgetpass.dart';
import 'package:rajputfoods/utils/pageutils/profileutils.dart';
import 'package:rajputfoods/pages/profile/signup.dart';
import 'package:rajputfoods/utils/utilspack2.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  bool _obscure = true;
  bool _loginvalid = false;
  bool _btndisabled = false;
  SharedprefStoreUser prefs = SharedprefStoreUser();
  String _userid = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final idprov = Provider.of<UserIdProvider>(context);
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
                  height: Utilspack1.contextheight(context) * 0.54,
                  child: Card(
                    elevation: 3.0,
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w700),
                          ),
                          const Spacer(
                            flex: 2,
                          ),
                          TextField(
                            controller: emailcontroller,
                            decoration: ProfileUtils.myinputdec(
                                hint: "Email",
                                icon: Icons.person,
                                ispassfield: false,
                                onpressed: () {}),
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
                          Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                              child: const Text(
                                "Forget Password?",
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xFF000000)),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgetPassPage()));
                              },
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _btndisabled
                                  ? () {}
                                  : () async {
                                      await _attemptLogin(idprov);
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
                                          color: Colors.white,
                                          strokeWidth: 5,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                            ),
                          ),
                          const Text(
                            "Or",
                            style:
                                TextStyle(color: Color(0xFFE83636), height: 2),
                          ),
                          SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton(
                                  onPressed: () async {
                                    await _attemptSocialLogin(idprov);
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                            "assets/icons/gicon.png"),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      const Text("Sign in with Google"),
                                    ],
                                  ),
                                ),
                                // IconButton(
                                //   onPressed: () {},
                                //   icon: Image.asset("assets/icons/fbicon.png"),
                                // )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  "Don't Have an Account",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const SignUp();
                      }));
                    },
                    child: const Text(
                      "Register",
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

  Future<void> _attemptSocialLogin(UserIdProvider idprov) async {
    setState(() {
      _btndisabled = true;
    });
    final user = await _signInWithGoogle();
    if (user != null) {
      await AuthSignup.socialauth(user.displayName!, user.email!,
          _onvalidationresult, _getuserid, context);
      _loginvalid
          ? {
              await prefs.storeid(_userid),
              idprov.setid(_userid),
              setState(() {
                _btndisabled = false;
              }),
              if (FocusManager.instance.primaryFocus != null)
                {FocusManager.instance.primaryFocus!.unfocus()},
              Utilspack1.rootnavigatereplaceto(
                  context,
                  const CongratsPage(
                      replacet: true,
                      title: "Your profile is ready to use",
                      btnname: "Try Order",
                      navigateto: PagewithBottomBar(),
                      navigate: true))
            }
          : setState(() {
              _btndisabled = false;
            });
    } else {
      setState(() {
        _btndisabled = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          UtilsPack2.snackBar("failed to sign in with google", 1));
    }
  }

  Future<void> _attemptLogin(UserIdProvider idprov) async {
    setState(() {
      _btndisabled = true;
    });

    await AuthLogin.auth(emailcontroller.text, passcontroller.text,
        _onvalidationresult, _getuserid, context);
    _loginvalid
        ? {
            await prefs.storeid(_userid),
            idprov.setid(_userid),
            setState(() {
              _btndisabled = false;
            }),
            if (FocusManager.instance.primaryFocus != null)
              {FocusManager.instance.primaryFocus!.unfocus()},
            Utilspack1.replacenavigateto(context, const PagewithBottomBar())
          }
        : setState(() {
            _btndisabled = false;
          });
  }

  void _getuserid(String id) {
    String encoded = Encodedata.encodeid(id);
    setState(() {
      _userid = encoded;
    });
  }

  void _onvalidationresult(bool isValid) {
    setState(() {
      _loginvalid = isValid;
    });
  }
}
