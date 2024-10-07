import 'package:flutter/material.dart';
import 'package:rajputfoods/main.dart';

class Utilspack1 {
  static SizedBox sizedBox30 = const SizedBox(
    height: 30,
  );
  static SizedBox sizedBox20 = const SizedBox(
    height: 20,
  );
  static SizedBox sizedBox15 = const SizedBox(
    height: 15,
  );
  static SizedBox sizedBox100 = const SizedBox(
    height: 100,
  );

  static double contextheight(context) {
    return MediaQuery.sizeOf(context).height;
  }

  static double contextwidth(context) {
    return MediaQuery.sizeOf(context).width;
  }

  static double contextheightvbtm(context) {
    return MediaQuery.sizeOf(context).height * 0.914;
  }

  static Route slidingRoute(Widget nextpage) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => nextpage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  static Future<dynamic> navigateto(
    BuildContext context,
    Widget widget,
  ) {
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => widget));
  }

  static Future<dynamic> keynavigateto(
    BuildContext context,
    Widget widget,
    GlobalKey<NavigatorState> key,
  ) {
    return key.currentState!
        .push(MaterialPageRoute(builder: (context) => widget));
  }

  static Future<dynamic> replacenavigateto(
      BuildContext context, Widget widget) {
    return Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => widget));
  }

  static Future<dynamic> rootnavigateto(BuildContext context, Widget widget) {
    return rootnavkey.currentState!
        .push(MaterialPageRoute(builder: (context) => widget));
  }

  static Future<dynamic> rootnavigatereplaceto(
      BuildContext context, Widget widget) {
    return rootnavkey.currentState!
        .pushReplacement(MaterialPageRoute(builder: (context) => widget));
  }
}

class ValidationUtils {
  static bool isEmailValid(String email) {
    // Regular expression for a simple email validation
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  static bool isPassValid(String pass) {
    return pass.length > 7;
  }

  static bool isCnfPassValid(String pass, String cnfpass) {
    return cnfpass == pass;
  }

  static bool isfieldEmpty(String field) {
    return field.isEmpty;
  }

  static bool isPhoneValid(String phone) {
    return phone.length == 11;
  }

  static bool isNameValid(String name) {
    return name.length > 2;
  }
}

class CustomIcons {
  CustomIcons._();

  static const _kFontFam = 'CustomIcons';
  static const String? _kFontPkg = null;

  static const IconData country =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}

class PagewithSimpleBG extends StatelessWidget {
  const PagewithSimpleBG({
    super.key,
    required this.child,
    this.padding,
    bool? intro,
  }) : intro = intro ?? false;
  final Widget child;
  final bool? intro;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return Container(
            padding: padding,
            height: intro!
                ? Utilspack1.contextheight(context) * 1
                : Utilspack1.contextheight(context) * 0.914,
            width: Utilspack1.contextwidth(context),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/backoverlay.png"),
                fit: BoxFit.fill,
                opacity: 0.1,
              ),
            ),
            child: child,
          );
        } else {
          return Container(
            padding: padding,
            height: intro!
                ? Utilspack1.contextheight(context) * 1
                : Utilspack1.contextheight(context) * 0.914,
            width: Utilspack1.contextwidth(context),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/backoverlay.png"),
                fit: BoxFit.fill,
                opacity: 0.1,
              ),
            ),
            child: child,
          );
        }
      },
    );
  }
}

class PagewithColoredBG extends StatelessWidget {
  final Widget child;
  const PagewithColoredBG({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Utilspack1.contextheight(context),
      width: Utilspack1.contextwidth(context),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              "assets/images/backg.png",
            ),
            fit: BoxFit.fill),
      ),
      child: child,
    );
  }
}

class PagewithwhiteBG extends StatelessWidget {
  const PagewithwhiteBG({super.key, required this.child, this.padding});
  final Widget child;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return Container(
            padding: padding,
            height: Utilspack1.contextheight(context) * 0.914,
            width: Utilspack1.contextwidth(context),
            color: const Color(0xFFFBFBFB),
            child: child,
          );
        } else {
          return Container(
            padding: padding,
            height: Utilspack1.contextheight(context) * 0.914,
            width: Utilspack1.contextwidth(context),
            color: const Color(0xFFFBFBFB),
            child: child,
          );
        }
      },
    );
  }
}

class PagewithRedBG extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const PagewithRedBG({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      height: Utilspack1.contextheight(context) * 0.914,
      width: Utilspack1.contextwidth(context),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              "assets/images/redbg.png",
            ),
            fit: BoxFit.fill),
      ),
      child: child,
    );
  }
}
