import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajputfoods/utils/utilspack1.dart';
import 'package:rajputfoods/pages/intro/bio/biopages/location.dart';

class ProfileImgPage extends StatefulWidget {
  const ProfileImgPage({super.key});

  @override
  State<ProfileImgPage> createState() => _ProfileImgPageState();
}

class _ProfileImgPageState extends State<ProfileImgPage> {
  bool _imguploaded = false;
  final ImagePicker picker = ImagePicker();
  File? imgfile;

  Future<void> pickimage() async {
    final imgraw = await picker.pickImage(source: ImageSource.gallery);
    imgfile = File(imgraw!.path);
    setState(() {
      _imguploaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: PagewithSimpleBG(
            child: Padding(
          padding:
              const EdgeInsets.only(top: 100, left: 30, right: 30, bottom: 30),
          child: SizedBox(
            height: Utilspack1.contextheight(context) - 130,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Upload your photo profile",
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Card(
                        elevation: 2.0,
                        shadowColor: const Color(0xFF000000),
                        child: _imguploaded
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.file(
                                  excludeFromSemantics: true,
                                  imgfile!,
                                  fit: BoxFit.fill,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 30, horizontal: 50),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Organize your file easily",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const Text(
                                      "This data will be displayed in your account profile for security",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF646464),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: pickimage,
                                      style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          backgroundColor:
                                              const Color(0xFFFFFFFF),
                                          shape: const RoundedRectangleBorder(),
                                          side: const BorderSide(
                                              width: 2,
                                              color: Color(0xFFE21B1B))),
                                      child: const Text(
                                        "Select Photo",
                                        style: TextStyle(
                                            color: Color(0xFFE21B1B),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                      ),
                    ),
                    _imguploaded
                        ? TextButton(
                            onPressed: () {
                              setState(() {
                                _imguploaded = false;
                              });
                            },
                            child: const Text(
                              "Replace or edit Image",
                              style: TextStyle(color: Color(0xFFE83636)),
                            ))
                        : const SizedBox()
                  ],
                ),
                ///////////////////////////////////////////////////////////////////////////////////////////
                //////////////////////////////////////////////////////////////////////////////////////////
                Utilspack1.sizedBox30,
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LocationPage()));
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
        )));
  }
}
