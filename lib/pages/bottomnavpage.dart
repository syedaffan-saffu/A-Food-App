import 'dart:io';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajputfoods/main.dart';
import 'package:rajputfoods/pages/cart/cartpage.dart';
import 'package:rajputfoods/pages/homescreen/homescreen.dart';
import 'package:rajputfoods/pages/orders/orderlist.dart';
import 'package:rajputfoods/pages/profile/profile.dart';
import 'package:rajputfoods/utils/providers/providers.dart';
import 'package:rajputfoods/utils/sharedprefs/sharedprefs.dart';
import 'package:rajputfoods/utils/utilspack1.dart';

class PagewithBottomBar extends StatefulWidget {
  const PagewithBottomBar({super.key});

  @override
  State<PagewithBottomBar> createState() => _PagewithBottomBarState();
}

List<GlobalKey<NavigatorState>> keys = [
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>()
];

class _PagewithBottomBarState extends State<PagewithBottomBar> {
  final sharedprefs = SharedprefStoreUser();
  bool _connection = false;
  bool _connectionloading = true;
  int _counter = 0;
  Widget runwidget(Widget widget) {
    return widget;
  }

  // List<Widget> widgets = [
  //   const Homescreen(),
  //   const Cartpage(),
  //   const OrderListPage(),
  //   const ProfilePage(),
  // ];

  static List<Widget> widgetsnav = [
    NavigationPage(navkey: keys[0], child: const Homescreen()),
    NavigationPage(navkey: keys[1], child: const Cartpage()),
    NavigationPage(navkey: keys[2], child: const OrderListPage()),
    NavigationPage(navkey: keys[3], child: const ProfilePage()),
  ];
  Future<void> internetcheck() async {
    try {
      setState(() {
        _connectionloading = true;
      });
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          _connection = true;
          _connectionloading = false;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        _connection = false;
        _connectionloading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    internetcheck();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    super.dispose();
    BackButtonInterceptor.remove(myInterceptor);
  }

  Future<bool> myInterceptor(
      bool stopDefaultButtonEvent, RouteInfo info) async {
    final indexprov = Provider.of<TabIndexProvider>(context, listen: false);
    if (indexprov.index == 0) {
      if (keys[0].currentState!.canPop()) {
        print("Home bye "); // Do some stuff.
        return false;
      } else {
        _counter++;

        if (_counter == 1) {
          await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Exit?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _counter = 0;
                        },
                        child: const Text("cancel")),
                    TextButton(
                        onPressed: () {
                          exit(0);
                        },
                        child: const Text("exit")),
                  ],
                );
              });
        } else {
          exit(0);
        }
        return true;
      }
    } else if (keys[1].currentState != null &&
        keys[1].currentState!.canPop() &&
        indexprov.index == 1) {
      print("B bye");

      return false;
    } else if (keys[2].currentState != null &&
        keys[2].currentState!.canPop() &&
        indexprov.index == 2) {
      print("C bye");

      return false;
    } else if (keys[3].currentState != null &&
        keys[3].currentState!.canPop() &&
        indexprov.index == 3) {
      print("D bye");

      return false;
    } else if (rootnavkey.currentState!.canPop()) {
      rootnavkey.currentState!.pop();
      return false;
    } else {
      setState(() {
        indexprov.changeindex(0);
      });
      print("nothing to pop, going to home s");

      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final idprov = Provider.of<UserIdProvider>(context);
    final indexprov = Provider.of<TabIndexProvider>(context);
    return Scaffold(
      body: _connectionloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _connection
              ?
              // IndexedStack(
              //     children: [widgets[indexprov.index]],
              //   )
              NavigatorPopHandler(
                  onPop: () {
                    keys[indexprov.index].currentState!.pop();
                  },
                  child: widgetsnav[indexprov.index])
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning,
                        color: Colors.orangeAccent,
                        size: 50,
                      ),
                      Text(
                        "No Internet Connection",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        useLegacyColorScheme: false,
        backgroundColor: const Color(0xFFE21B1B),
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: const Color(0xFFFFFFFF),
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: [
          BottomNavigationBarItem(
            activeIcon: iconcontainer(Icons.home),
            icon: const Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(
            activeIcon: iconcontainer(Icons.shopping_cart),
            icon: const Icon(Icons.shopping_cart),
            label: "",
          ),
          BottomNavigationBarItem(
            activeIcon: iconcontainer(Icons.fastfood),
            icon: const Icon(Icons.fastfood),
            label: "",
          ),
          BottomNavigationBarItem(
            activeIcon: iconcontainer(Icons.person),
            icon: const Icon(Icons.person),
            label: "",
          ),
        ],
        currentIndex: indexprov.index,
        onTap: (index) {
          indexprov.changeindex(index);
        },
      ),
    );
  }

  Container iconcontainer(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(10)),
      child: Icon(
        icon,
        color: const Color(0xFFE21B1B),
      ),
    );
  }
}

class NavigationPage extends StatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navkey;
  const NavigationPage({super.key, required this.child, required this.navkey});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navkey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => widget.child,
          settings: settings,
        );
      },
    );
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("ChatPage"),
      ),
    );
  }
}
