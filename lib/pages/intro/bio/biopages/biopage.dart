import 'package:flutter/material.dart';
import 'package:rajputfoods/utils/utilspack1.dart';
import 'package:rajputfoods/pages/intro/bio/biopages/paymethod.dart';

import 'package:rajputfoods/utils/pageutils/profileutils.dart';

class Biopage extends StatefulWidget {
  const Biopage({super.key});

  @override
  State<Biopage> createState() => _BiopageState();
}

class _BiopageState extends State<Biopage> {
  String? selectedcountry;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: SingleChildScrollView(
          child: PagewithSimpleBG(
              child: Padding(
            padding: const EdgeInsets.only(
                top: 100, left: 30, right: 30, bottom: 30),
            child: Column(
              children: [
                SizedBox(
                  height: (Utilspack1.contextheight(context) / 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Fill in your bio to get started",
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            decoration: ProfileUtils.myinputdec(
                                    hint: "Full Name",
                                    icon: Icons.person,
                                    ispassfield: false,
                                    onpressed: () {})
                                .copyWith(
                                    fillColor: const Color(0xFFFFFFFF),
                                    filled: true),
                          ),
                          Utilspack1.sizedBox15,
                          DropdownButtonHideUnderline(
                            child: DropdownButtonFormField(
                              menuMaxHeight: 300,
                              hint: const Text(
                                "Country",
                                style: TextStyle(fontSize: 14),
                              ),
                              value: selectedcountry,
                              isExpanded: true,
                              dropdownColor: const Color(0xFFFFFFFF),
                              items: List.generate(8, (index) {
                                return DropdownMenuItem(
                                  value: 'dummy $index',
                                  child: Text("dummy $index"),
                                );
                              }),
                              onChanged: (value) {
                                setState(() {
                                  selectedcountry = value;
                                });
                              },
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xFFFFFFFF),
                                  prefixIcon: Icon(CustomIcons.country),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey))),
                            ),
                          ),
                          Utilspack1.sizedBox15,
                          TextField(
                            keyboardType: TextInputType.phone,
                            decoration: ProfileUtils.myinputdec(
                              hint: "Mobile Number",
                              icon: Icons.phone,
                              ispassfield: false,
                              onpressed: () {},
                            ).copyWith(
                                fillColor: const Color(0xFFFFFFFF),
                                filled: true),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ///////////////////////////////////////////////////////////////////////////////////////////
                //////////////////////////////////////////////////////////////////////////////////////////
                SizedBox(
                  height: (Utilspack1.contextheight(context) / 2) - 130,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const PayMethodPage()));
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
              ],
            ),
          )),
        ));
  }
}
