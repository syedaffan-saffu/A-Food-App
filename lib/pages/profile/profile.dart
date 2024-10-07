import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rajputfoods/pages/profile/detailpages/editfields.dart';
import 'package:rajputfoods/pages/profile/detailpages/mngaddress.dart';
import 'package:rajputfoods/utils/auth/apiutils.dart';
import 'package:rajputfoods/utils/backenddata/apifunctions/profileapi.dart';
import 'package:rajputfoods/utils/backenddata/models/profiledata.dart';
import 'package:rajputfoods/utils/providers/providers.dart';
import 'package:rajputfoods/utils/sharedprefs/sharedprefs.dart';
import 'package:rajputfoods/utils/utilspack1.dart';
import 'package:rajputfoods/utils/utilspack2.dart';

final Image _editicon = Image.asset("assets/icons/editIcon.png");

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isuploaded = false;
  bool _isloading = true;
  bool _changedprofile = false;
  bool _updatedprofile = false;

  bool _uploadloading = false;
  final ImagePicker picker = ImagePicker();
  File? imgfile;
  ProfileData? _profileData;
  UserIdProvider? _provider;
  final SharedprefStoreUser prefs = SharedprefStoreUser();

  bool _btndisabled = false;

  Future<void> pickimage() async {
    final imgraw =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 2);
    if (imgraw != null) {
      imgfile = File(imgraw.path);
      setState(() {
        _uploadloading = true;
      });
      await Profileapis.updateProfileImage(
          Encodedata.decodeid(_provider!.userid),
          imgfile!.path,
          updatedsuccess);
      _updatedprofile
          ? {
              setState(() {
                _uploadloading = false;
                _changedprofile = true;
              }),
              ScaffoldMessenger.of(context).showSnackBar(
                  UtilsPack2.snackBar("Profile Updated Successfully", 1))
            }
          : null;
    } else {
      setState(() {
        _changedprofile = false;
      });
    }
  }

  Future<void> getUserData(String userid) async {
    try {
      final result =
          await Profileapis.fetchuserprofile(Encodedata.decodeid(userid));
      setState(() {
        _isuploaded = true;
        _profileData = result.data;
        _isloading = false;
      });

      if (!result.success) {
        print("Exception occurred: result ${result.success}");
      }
    } catch (e) {
      print("Exception occurred: $e");
      setState(() {
        _profileData = null;
        _isuploaded = false;
        _isloading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = Provider.of<UserIdProvider>(context, listen: false);
      getUserData(_provider!.userid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final thisidprovider = Provider.of<UserIdProvider>(context);
    return Scaffold(
      body: PagewithSimpleBG(
          padding: const EdgeInsets.only(top: 50, right: 30, left: 30),
          child: _profileData != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Badge(
                      backgroundColor: Colors.transparent,
                      alignment: Alignment.topLeft,
                      offset: const Offset(-10, -5),
                      largeSize: 40,
                      padding: EdgeInsets.zero,
                      label: IconButton(
                        icon: Image.asset("assets/icons/editIcon.png"),
                        onPressed: pickimage,
                      ),
                      child: ClipOval(
                        child: _changedprofile
                            ? Image.file(
                                imgfile!,
                                height: Utilspack1.contextheight(context) * 0.2,
                                width: Utilspack1.contextheight(context) * 0.2,
                                fit: BoxFit.fill,
                              )
                            : _uploadloading
                                ? SizedBox(
                                    height:
                                        Utilspack1.contextheight(context) * 0.2,
                                    width:
                                        Utilspack1.contextheight(context) * 0.2,
                                    child: const ColoredBox(
                                      color: Color(0xFFDDDDDD),
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ))
                                : _isuploaded
                                    ? CachedNetworkImage(
                                        imageUrl: _profileData!.profileimg!,
                                        placeholder: (context, text) {
                                          return const CircularProgressIndicator(
                                              color: Color(0xFFE21B1B));
                                        },
                                        height:
                                            Utilspack1.contextheight(context) *
                                                0.2,
                                        width:
                                            Utilspack1.contextheight(context) *
                                                0.2,
                                        fit: BoxFit.fill,
                                      )
                                    : SizedBox(
                                        height:
                                            Utilspack1.contextheight(context) *
                                                0.2,
                                        width:
                                            Utilspack1.contextheight(context) *
                                                0.2,
                                        child: const ColoredBox(
                                          color: Color(0xFFDDDDDD),
                                        )),
                      ),
                    ),
                    Utilspack1.sizedBox20,
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: const Color(0xFFFFFFFF),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25)),
                            border: Border.all(
                              color: const Color(0xFFBBBBBB),
                              width: 2,
                            )),
                        child: Column(
                          children: [
                            _ProfileField(
                                title: "Name",
                                body: _profileData!.username,
                                onTap: () {}),
                            const Divider(),
                            _ProfileField(
                                title: "Email",
                                body: _profileData!.email,
                                onTap: () {}),
                            const Divider(),
                            _ProfileField(
                                title: "Phone",
                                body: _profileData!.phone!,
                                onTap: () {
                                  Utilspack1.navigateto(
                                      context,
                                      EditFieldPage(
                                        isphone: true,
                                        text: _profileData!.phone!,
                                      ));
                                }),
                            const Divider(),
                            _ProfileField(
                                title: "Address",
                                isaddress: true,
                                addtitle: _profileData!.addresstitle,
                                body: _profileData!.address!,
                                onTap: () {
                                  Utilspack1.navigateto(
                                      context, const ManageAddress());
                                }),
                            const Spacer(),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _btndisabled
                                    ? () {}
                                    : () {
                                        showDialog(
                                            useRootNavigator: false,
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    "Sure to Logout"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () async {
                                                        await _attemptLogout(
                                                            thisidprovider);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text("Logout")),
                                                  TextButton(
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text("cancel"))
                                                ],
                                              );
                                            });
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
                                        "Logout",
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
                  ],
                )
              : _isloading
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Loading Your Profile"),
                        SizedBox(
                          height: 30,
                        ),
                        CircularProgressIndicator(
                          color: Color(0xFFE21B1B),
                        ),
                      ],
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning,
                          color: Colors.orangeAccent,
                          size: 50,
                        ),
                        Text(
                          "User not found!",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
    );
  }

  void updatedsuccess(bool success) {
    setState(() {
      _updatedprofile = success;
    });
  }

  Future<void> _attemptLogout(UserIdProvider idprov) async {
    setState(() {
      _btndisabled = true;
    });
    await prefs.deleteuser("userid");
    idprov.logout();
  }
}

class _ProfileField extends StatelessWidget {
  final String title;
  final String body;
  final bool? isaddres;
  final String? addtitle;
  final void Function() onTap;

  const _ProfileField({
    required this.title,
    required this.body,
    required this.onTap,
    this.addtitle,
    bool? isaddress,
  }) : isaddres = isaddress ?? false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isaddres!
                        ? !body.contains("*")
                            ? Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFE26622),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  addtitle!,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            : const SizedBox.shrink()
                        : const SizedBox.shrink(),
                    Text(
                      body.length > 40 ? "${body.substring(0, 40)}..." : body,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: false,
                      style: TextStyle(
                          color: body.contains("*", 0)
                              ? const Color(0xFFE21B1B)
                              : Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 55,
            child: IconButton(
              onPressed: onTap,
              icon: _editicon,
            ),
          ),
        ],
      ),
    );
  }
}
