import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';
import 'package:rajputfoods/main.dart';
import 'package:rajputfoods/utils/auth/apiutils.dart';
import 'package:rajputfoods/utils/auth/auth.dart';
import 'package:rajputfoods/utils/providers/providers.dart';
import 'package:rajputfoods/utils/sharedprefs/sharedprefs.dart';
import 'package:rajputfoods/utils/utilspack1.dart';

class OtpPage extends StatefulWidget {
  final String email;
  final Widget navigateto;

  const OtpPage({
    super.key,
    required this.email,
    required this.navigateto,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  SharedprefStoreUser prefs = SharedprefStoreUser();
  bool _isotpvalid = false;
  String otp = "";
  String _userid = "";
  bool disablebtn = false;
  bool clearText = false;
  UserIdProvider? idprovider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    idprovider = Provider.of<UserIdProvider>(context);
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
                  height: Utilspack1.contextheight(context) / 2,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 3.0,
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Enter 4 digit verification code",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w700),
                          ),
                          const Spacer(),
                          Text(
                            "Code send to ${widget.email}.",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF646464),
                              fontSize: 15,
                            ),
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("This code will expire in 5 minutes"),
                              // CounterWidget(),
                            ],
                          ),
                          const Spacer(),
                          OtpTextField(
                            contentPadding: EdgeInsets.zero,
                            numberOfFields: 4,
                            borderColor: const Color(0xFF555555),
                            focusedBorderColor: const Color(0xFFE21B1B),
                            clearText: clearText,
                            showFieldAsBox: true,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                            fieldWidth: 50,
                            onSubmit: (String verificationCode) {
                              setState(() {
                                otp = verificationCode;
                                disablebtn = false;
                              });
                              //set clear text to clear text from all fields
                            },
                          ),
                          const Spacer(
                            flex: 3,
                          ),
                          ///////////////////////////// Button ///////////////////////////////
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: disablebtn ? () {} : _attemptverifyotp,
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  backgroundColor: const Color(0xFFE83636)),
                              child: disablebtn
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

  Future<void> _attemptverifyotp() async {
    setState(() {
      disablebtn = true;
    });

    await ValidateOTP.validate(widget.email, otp, _onvalidationresult, context);
    _isotpvalid
        ? {
            disablebtn = false,
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => widget.navigateto)),
          }
        : setState(() {
            disablebtn = false;
          });
  }

  void _onvalidationresult(bool isValid) {
    setState(() {
      _isotpvalid = isValid;
    });
  }
}
