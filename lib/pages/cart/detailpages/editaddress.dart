import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajputfoods/utils/backenddata/models/addressdata.dart';
import 'package:rajputfoods/utils/providers/providers.dart';
import 'package:rajputfoods/utils/utilspack1.dart';

import 'locationpick.dart';

class Editaddress {
  static Future dialog(BuildContext context, List<UserAddresses> addresses,
      void Function(int) onslct) {
    return showDialog(
      useRootNavigator: false,
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          insetPadding: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Address',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: Utilspack1.contextheight(context) / 3.5,
                  width: double.infinity,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          onslct(index);
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey[400]!,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFE24444),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    addresses[index].title,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ),
                                Text(addresses[index].useraddress),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AddAddress extends StatefulWidget {
  final TextEditingController? controller2;
  final TextEditingController? controller1;

  final void Function() onTap;
  const AddAddress({
    super.key,
    required this.onTap,
    this.controller2,
    this.controller1,
  });

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  TextEditingController textcontroller = TextEditingController();

  @override
  void initState() {
    textcontroller = widget.controller2!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locprov = Provider.of<LocationProvider>(context);
    return Scaffold(
      body: PagewithSimpleBG(
          padding:
              const EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Edit Address:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              TextField(
                maxLength: 10,
                controller: widget.controller1,
                decoration: InputDecoration(
                    hintText: "Title",
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
              TextField(
                maxLines: 4,
                maxLength: 150,
                controller: widget.controller2,
                decoration: InputDecoration(
                    hintText: "Address",
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
              Column(
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
                          final latlong = location!.geometry.location;
                          locprov.changedata([
                            latlong.lat.toString(),
                            latlong.lng.toString(),
                            location.formattedAddress!
                          ]);
                          setState(() {
                            textcontroller.text =
                                location.formattedAddress ?? "";
                          });
                        }));
                      },
                      child: const Text(
                        "Pick Location",
                      ))
                ],
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
