import 'package:flutter/material.dart';
import 'package:rajputfoods/utils/backenddata/apifunctions/itemsapi.dart';
import 'package:rajputfoods/utils/backenddata/models/itemcarddata.dart';
import 'package:rajputfoods/utils/backenddata/models/itemcategorydata.dart';
import 'package:rajputfoods/utils/utilspack1.dart';

class ExploremenuPage extends StatefulWidget {
  final Future<List<Itemcategorydata>> future;
  final bool? appliedfilter;
  final String? filtertext;
  const ExploremenuPage({
    super.key,
    required this.future,
    this.appliedfilter,
    this.filtertext,
  });

  static const List<String> imgs = [
    "assets/images/burger.png",
    "assets/images/roll.png",
    "assets/images/desert1.png",
    "assets/images/desert2.png"
  ];

  @override
  State<ExploremenuPage> createState() => _ExploremenuPageState();
}

class _ExploremenuPageState extends State<ExploremenuPage> {
  TextEditingController searchcontroller = TextEditingController();
  bool? appliedfilter;
  bool isfiedltapped = false;
  String? filtertext;
  bool _fetcherror = false;

  @override
  void initState() {
    appliedfilter = widget.appliedfilter ?? false;

    filtertext = widget.filtertext ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: PagewithSimpleBG(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 50, left: 30, right: 30, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Find Your Favourite Food",
                    style: TextStyle(
                      wordSpacing: 0.5,
                      letterSpacing: 0.2,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SearchBar(
                    padding:
                        WidgetStateProperty.resolveWith<EdgeInsetsGeometry>(
                            (states) =>
                                const EdgeInsets.symmetric(horizontal: 15)),
                    hintText: "Search for food",
                    side: WidgetStateProperty.resolveWith<BorderSide>(
                        (states) => const BorderSide(color: Colors.grey)),
                    leading: const Icon(Icons.search),
                    onChanged: (value) {
                      filtertext = value;
                    },
                    onSubmitted: (value) {
                      // setState(() {
                      //   filtertext = value;
                      //   isfiedltapped = false;
                      //   FocusManager.instance.primaryFocus!.unfocus();
                      // });
                      // Navigator.of(context).pushReplacement(
                      //     MaterialPageRoute(builder: (context) {
                      //   return ExploremenuPage(
                      //     appliedfilter: true,
                      //     filtertext: filtertext,
                      //     future:
                      //         Itemsapi.fetchMenuSearched(filtertext!, context),
                      //   );
                      // }));
                    },
                    onTap: () {
                      if (!isfiedltapped) {
                        setState(() {
                          isfiedltapped = true;
                        });
                      }
                    },
                    trailing: [
                      isfiedltapped
                          ? TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
                                  return ExploremenuPage(
                                    appliedfilter: true,
                                    filtertext: filtertext,
                                    future: Itemsapi.fetchMenuSearched(
                                        filtertext!, context, fetcherror),
                                  );
                                }));
                              },
                              child: const Text(
                                "Search",
                                style: TextStyle(color: Color(0xFFE21B1B)),
                              ))
                          : const SizedBox.shrink()
                    ],
                    elevation:
                        WidgetStateProperty.resolveWith<double>((states) => 0),
                    backgroundColor: WidgetStateColor.resolveWith((states) {
                      return const Color(0xFFFFFFFF);
                    }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  filtertext == ""
                      ? const SizedBox.shrink()
                      : Text(
                          'You searched for "${widget.filtertext!}"',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: ItemsFutureBuilder(
                        future: widget.future,
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void fetcherror(bool haserror) {
    setState(() {
      _fetcherror = haserror;
    });
  }
}
