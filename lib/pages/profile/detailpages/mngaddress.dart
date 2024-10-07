import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajputfoods/pages/cart/detailpages/locationpick.dart';
import 'package:rajputfoods/utils/auth/apiutils.dart';
import 'package:rajputfoods/utils/backenddata/apifunctions/profileapi.dart';
import 'package:rajputfoods/utils/backenddata/models/addressdata.dart';
import 'package:rajputfoods/utils/providers/providers.dart';
import 'package:rajputfoods/utils/utilspack1.dart';
import 'package:rajputfoods/utils/utilspack2.dart';

class ManageAddress extends StatefulWidget {
  const ManageAddress({super.key});

  @override
  State<ManageAddress> createState() => _ManageAddressState();
}

class _ManageAddressState extends State<ManageAddress> {
  List<UserAddresses> _userAddresses = [];
  UserIdProvider? useridprov;

  TextEditingController titlecont = TextEditingController();
  TextEditingController addresscont = TextEditingController();
  List<bool> selected = [
    false,
    false,
    false,
  ];
  bool _editaddress = false;
  bool _disablebtn1 = false;
  bool _deleted = false;
  bool _haserror = false;
  int _selectedindex = 0;
  bool _loading = false;
  bool _disablebtnmain = false;
  bool _issuccess = false;
  bool _fetchloading = true;
  bool _fetchsuccess = false;

  Future<void> _getaddresses(UserIdProvider prov) async {
    final userdata = await Profileapis.fetchuseraddresses(
      Encodedata.decodeid(prov.userid),
    );

    setState(() {
      _userAddresses = userdata.data!;
      _fetchsuccess = userdata.success;
      _fetchloading = false;
    });
  }

  void _deletedsuccess(bool deleted) {
    setState(() {
      _deleted = deleted;
    });
  }

  Future<void> _deleteAddress(int index) async {
    bool barrier = true;
    showDialog(
        barrierDismissible: barrier,
        useRootNavigator: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete Selected Address?"),
            actions: [
              TextButton(
                  onPressed: barrier
                      ? () {
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: const Text("cancel")),
              TextButton(
                  onPressed: () async {
                    barrier = false;

                    await Profileapis.deleteAddress(
                        _userAddresses[index].addressid, _deletedsuccess);
                    if (_deleted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          UtilsPack2.snackBar(
                              "Address Deleted Successfully", 1));
                      Utilspack1.replacenavigateto(context, widget);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          UtilsPack2.snackBar("Failed to delete address", 1));
                    }
                  },
                  child: const Text("delete"))
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      setState(() {
        useridprov = Provider.of<UserIdProvider>(context, listen: false);
      });
      _getaddresses(useridprov!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: PagewithwhiteBG(
            padding:
                const EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Manage Addresses",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                _userAddresses.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Your Addresses:",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 23),
                          ),
                          const Text(
                            "Please select to edit",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Container(
                            height: Utilspack1.contextheight(context) * 0.2,
                            padding: const EdgeInsets.all(10),
                            color: const Color(0xFFEFEFEF),
                            child: _fetchloading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : _fetchsuccess
                                    ? ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: _userAddresses.length,
                                        itemBuilder: (context, index) {
                                          final title =
                                              _userAddresses[index].title;
                                          final address =
                                              _userAddresses[index].useraddress;
                                          return ListTile(
                                            leading:
                                                const Icon(Icons.location_on),
                                            trailing: IconButton(
                                                onPressed: () async {
                                                  await _deleteAddress(index);
                                                },
                                                icon: const Icon(Icons.delete)),
                                            shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    color: Colors.red),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            title: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                      color: selected[index]
                                                          ? const Color(
                                                              0xFFE21B1B)
                                                          : const Color(
                                                              0xFFE2AA55),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Text(
                                                    title,
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            subtitle: Text(
                                              address,
                                              style: selected[index]
                                                  ? const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)
                                                  : null,
                                            ),
                                            selectedColor:
                                                const Color(0xFFE26622),
                                            selected: selected[index],
                                            onTap: () {
                                              setState(() {
                                                selected =
                                                    selected.map((value) {
                                                  return value = false;
                                                }).toList();

                                                _selectedindex = index;
                                                _editaddress = true;
                                                selected[index] = true;
                                                titlecont.text = title;
                                                addresscont.text = address;
                                              });
                                            },
                                          );
                                        })
                                    : const Text("Error Fetching"),
                          )
                        ],
                      )
                    : Container(
                        alignment: Alignment.center,
                        height: Utilspack1.contextheight(context) * 0.2,
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        color: const Color(0xFFEFEFEF),
                        child: const Text("No Previous Addresses Found")),
                Text(
                  _editaddress ? "Edit selected address" : "Add new address",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 20),
                ),
                _editaddress
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _editaddress = false;
                                  for (int i = 0; i < selected.length; i++) {
                                    selected[i] = false;
                                  }
                                  titlecont.clear();
                                  addresscont.clear();
                                });
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [Text("Add New"), Icon(Icons.add)],
                              )),
                          OutlinedButton(
                              onPressed: _disablebtnmain
                                  ? null
                                  : () async {
                                      if (addresscont.text.isNotEmpty &&
                                          titlecont.text.isNotEmpty) {
                                        final body =
                                            '{"address_title" : "${titlecont.text}", "address" : "${addresscont.text}"}';
                                        await makecurrentaddress(
                                            body, useridprov!);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(UtilsPack2.snackBar(
                                                "Plz Fill all fields", 1));
                                      }
                                    },
                              child: _loading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("Use as current"),
                                        Icon(Icons.location_on)
                                      ],
                                    )),
                        ],
                      )
                    : const SizedBox.shrink(),
                TextField(
                  maxLength: 10,
                  controller: titlecont,
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
                  maxLines: 3,
                  maxLength: 150,
                  controller: addresscont,
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
                Center(
                  child: Column(
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
                                addresscont.text =
                                    location!.formattedAddress ?? "";
                              });
                            }));
                          },
                          child: const Text(
                            "Pick Location",
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _disablebtn1
                        ? null
                        : () async {
                            setState(() {
                              _disablebtn1 = true;
                            });
                            if (titlecont.text.isNotEmpty &&
                                addresscont.text.isNotEmpty) {
                              final addressRequest = AddressRequest(
                                  address: addresscont.text,
                                  title: titlecont.text,
                                  userid: useridprov!.userid);
                              if (_userAddresses.isEmpty) {
                                final body =
                                    '{"address_title" : "${titlecont.text}", "address" : "${addresscont.text}"}';
                                await makecurrentaddress(body, useridprov!);
                              } else {
                                await _editAddress(addressRequest);
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  UtilsPack2.snackBar(
                                      "Plz Fill all Fields", 1));
                              setState(() {
                                _disablebtn1 = false;
                              });
                            }
                          },
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
      ),
    );
  }

  Future<void> _editAddress(AddressRequest addressrequest) async {
    setState(() {
      _disablebtn1 = true;
      _loading = true;
    });
    await Profileapis.sendAddressRequest(addressrequest, success, haserror);
    if (_issuccess) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          UtilsPack2.snackBar("Addresses Updated Successfully", 1));
      Utilspack1.replacenavigateto(context, widget);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(UtilsPack2.snackBar("Failed to update", 1));
      setState(() {
        _loading = false;
        _disablebtn1 = false;
      });
    }
  }

  void haserror(bool error) {
    setState(() {
      _haserror = error;
    });
  }

  Future<void> adddefaultaddress(String body, UserIdProvider provider,
      AddressRequest addressrequest) async {
    setState(() {
      _disablebtnmain = true;
      _loading = true;
    });
    await Profileapis.updateprofileinfo(
        Encodedata.decodeid(provider.userid), body, success);

    await Profileapis.sendAddressRequest(addressrequest, success, haserror);
    if (_issuccess) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(UtilsPack2.snackBar("Address Marked as Current", 1));
      Utilspack1.replacenavigateto(context, widget);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(UtilsPack2.snackBar("Failed to update", 1));
      setState(() {
        _loading = false;
        _disablebtnmain = false;
      });
    }
  }

  Future<void> makecurrentaddress(String body, UserIdProvider provider) async {
    setState(() {
      _disablebtnmain = true;
      _loading = true;
    });
    await Profileapis.updateprofileinfo(
        Encodedata.decodeid(provider.userid), body, success);
    if (_issuccess) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(UtilsPack2.snackBar("Address Marked as Current", 1));
      Utilspack1.replacenavigateto(context, widget);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(UtilsPack2.snackBar("Failed to update", 1));
      setState(() {
        _loading = false;
        _disablebtnmain = false;
      });
    }
  }

  void success(bool issuccess) {
    setState(() {
      _issuccess = issuccess;
    });
  }
}
