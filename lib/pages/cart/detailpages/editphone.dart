import 'package:flutter/material.dart';
import 'package:rajputfoods/utils/utilspack1.dart';

class EditPhone extends StatefulWidget {
  final TextEditingController? controller;
  final String text;
  final void Function() onTap;
  const EditPhone({
    super.key,
    required this.text,
    required this.onTap,
    this.controller,
  });

  @override
  State<EditPhone> createState() => _EditPhoneState();
}

class _EditPhoneState extends State<EditPhone> {
  TextEditingController textcontroller = TextEditingController();

  @override
  void initState() {
    textcontroller.text = widget.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PagewithSimpleBG(
          padding:
              const EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Edit Phone:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              TextField(
                maxLines: 1,
                maxLength: 11,
                controller: widget.controller,
                keyboardType: TextInputType.phone,
                onTap: () {
                  if (widget.controller!.text == "*Add Phone*") {
                    widget.controller!.clear();
                  }
                },
                decoration: InputDecoration(
                    hintText: "03XXXXXXXXX",
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
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onTap,
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      backgroundColor: const Color(0xFFE83636)),
                  child: const Text(
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
}
