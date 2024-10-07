import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajputfoods/pages/cart/detailpages/locationpick.dart';
import 'package:rajputfoods/pages/profile/detailpages/mngaddress.dart';
import 'package:rajputfoods/pages/profile/profile.dart';
import 'package:rajputfoods/utils/auth/apiutils.dart';
import 'package:rajputfoods/utils/backenddata/apifunctions/profileapi.dart';
import 'package:rajputfoods/utils/providers/providers.dart';
import 'package:rajputfoods/utils/utilspack1.dart';
import 'package:rajputfoods/utils/utilspack2.dart';

class EditFieldPage extends StatefulWidget {
  final String text;
  final bool isphone;
  final void Function()? onpressed;
  const EditFieldPage(
      {super.key, required this.isphone, required this.text, this.onpressed});

  @override
  State<EditFieldPage> createState() => _EditFieldPageState();
}

class _EditFieldPageState extends State<EditFieldPage> {
  TextEditingController textcontroller = TextEditingController();
  bool _btndisabled = false;

  bool _loading = false;

  bool _issuccess = false;

  @override
  void initState() {
    textcontroller.text = widget.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final idprov = Provider.of<UserIdProvider>(context);
    return Scaffold(
      body: PagewithSimpleBG(
          padding:
              const EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: widget.isphone
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isphone ? "Edit Phone:" : "Edit Address:",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  !widget.isphone
                      ? TextButton(
                          onPressed: () {
                            Utilspack1.navigateto(
                                context, const ManageAddress());
                          },
                          child: const Text("Manage Addresses"))
                      : const SizedBox.shrink()
                ],
              ),
              TextField(
                maxLines: widget.isphone ? 1 : 4,
                maxLength: widget.isphone ? 11 : 150,
                controller: textcontroller,
                keyboardType: widget.isphone ? TextInputType.phone : null,
                onTap: () {
                  if (textcontroller.text == "*Add Address*" ||
                      textcontroller.text == "*Add Phone*") {
                    textcontroller.clear();
                  }
                },
                decoration: InputDecoration(
                    hintText: widget.isphone ? "03XXXXXXXXX" : "Your address",
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF777777),
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF777777),
                        ),
                        borderRadius: BorderRadius.circular(10))),
              ),
              !widget.isphone
                  ? Column(
                      children: [
                        const Text(
                          "OR",
                          style: TextStyle(
                              color: Color(0xFFE2451B),
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Utilspack1.navigateto(context,
                                  PickLocationPage(onNext: (location) {
                                setState(() {
                                  textcontroller.text =
                                      location!.formattedAddress ?? widget.text;
                                });
                              }));
                            },
                            child: const Text(
                              "Pick Location",
                            )),
                      ],
                    )
                  : const SizedBox.shrink(),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _btndisabled
                      ? null
                      : () async {
                          if (textcontroller.text.isNotEmpty) {
                            await updatefield(
                                widget.isphone
                                    ? '{"phone" : "${textcontroller.text}"}'
                                    : '{"address" : "${textcontroller.text}"}',
                                idprov);
                          } else if (widget.isphone &&
                              !ValidationUtils.isPhoneValid(
                                  textcontroller.text)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                UtilsPack2.snackBar("Phone is not Valid", 2));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                UtilsPack2.snackBar("Plz fill the Field", 1));
                          }
                        },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      backgroundColor: const Color(0xFFE83636)),
                  child: _loading
                      ? const AspectRatio(
                          aspectRatio: 1 / 1,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                ),
              ),
            ],
          )),
    );
  }

  Future<void> updatefield(String body, UserIdProvider provider) async {
    setState(() {
      _btndisabled = true;
      _loading = true;
    });
    await Profileapis.updateprofileinfo(
        Encodedata.decodeid(provider.userid), body, success);
    if (_issuccess) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(UtilsPack2.snackBar("Data updated", 1));
      Utilspack1.replacenavigateto(context, const ProfilePage());
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(UtilsPack2.snackBar("Failed to update", 1));
      setState(() {
        _loading = false;
      });
    }
  }

  void success(bool issuccess) {
    setState(() {
      _issuccess = issuccess;
    });
  }
}
