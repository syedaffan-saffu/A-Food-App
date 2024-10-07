import 'package:flutter/material.dart';
import 'package:rajputfoods/pages/homescreen/detailpages/itemdetails.dart';
import 'package:rajputfoods/utils/backenddata/apifunctions/itemsapi.dart';
import 'package:rajputfoods/utils/utilspack1.dart';
import 'package:rajputfoods/pages/homescreen/detailpages/exploremenu.dart';
import 'package:rajputfoods/utils/pageutils/homeutils.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  TextEditingController controller = TextEditingController();
  bool isfiedltapped = false;
  String? filtertext;
  bool _fetcherror = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: PagewithSimpleBG(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 50, left: 30, right: 30, bottom: 30),
            child: Column(
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
                  controller: controller,
                  padding: WidgetStateProperty.resolveWith<EdgeInsetsGeometry>(
                      (states) => const EdgeInsets.symmetric(horizontal: 15)),
                  hintText: "Search for food",
                  side: WidgetStateProperty.resolveWith<BorderSide>(
                      (states) => const BorderSide(color: Colors.grey)),
                  leading: const Icon(Icons.search),
                  onChanged: (value) {
                    filtertext = value;
                  },
                  onSubmitted: (value) {
                    setState(() {
                      filtertext = value;
                      isfiedltapped = false;
                      FocusManager.instance.primaryFocus!.unfocus();
                    });
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ExploremenuPage(
                        appliedfilter: true,
                        filtertext: filtertext ?? "",
                        future: Itemsapi.fetchMenuSearched(
                            filtertext ?? "", context, fetcherror),
                      );
                    }));
                  },
                  onTap: () {
                    setState(() {
                      isfiedltapped = true;
                    });
                  },
                  trailing: [
                    isfiedltapped
                        ? TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return ExploremenuPage(
                                  appliedfilter: true,
                                  filtertext: filtertext ?? "",
                                  future: Itemsapi.fetchMenuSearched(
                                      filtertext ?? "", context, fetcherror),
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
                Expanded(
                  child: FutureBuilder(
                    future: Itemsapi.fetchcategories(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, buildindex) => Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    snapshot.data![buildindex].title,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  snapshot.data![buildindex].items.length > 1
                                      ? TextButton(
                                          onPressed: () {
                                            Utilspack1.navigateto(
                                                context,
                                                ExploremenuPage(
                                                    filtertext:
                                                        filtertext ?? "",
                                                    future: Itemsapi
                                                        .fetchMenuFiltered(
                                                            int.parse(snapshot
                                                                .data![
                                                                    buildindex]
                                                                .categoryid),
                                                            context)));
                                          },
                                          child: const Text("Show More"))
                                      : const SizedBox.shrink(),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: List.generate(
                                    snapshot.data![buildindex].items.length,
                                    (index) {
                                  if (snapshot.hasData) {
                                    final thisdata =
                                        snapshot.data![buildindex].items[index];
                                    return ItemCard(
                                      onTap: () {
                                        Utilspack1.navigateto(
                                            context,
                                            Itemdetailspage(
                                              imgurl: thisdata.img,
                                              title: thisdata.title,
                                              price: thisdata.price,
                                              id: thisdata.id,
                                            ));
                                      },
                                      networkimg: true,
                                      price: thisdata.price,
                                      img: thisdata.img,
                                      title: thisdata.title,
                                      categoryid:
                                          snapshot.data![index].categoryid,
                                    );
                                  } else if (snapshot.hasError ||
                                      snapshot.connectionState ==
                                          ConnectionState.none) {
                                    return const Center(
                                        child: Text("Problem Loading Data"));
                                  } else {
                                    return SizedBox(
                                      height: Utilspack1.contextwidth(context) /
                                          2.5,
                                      width: Utilspack1.contextwidth(context) /
                                          2.5,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xFFE21B1B),
                                        ),
                                      ),
                                    );
                                  }
                                }),
                              ),
                              const SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void fetcherror(bool haserror) {
    print("now fetch function run :::::::::::::::: haserror $haserror");
    setState(() {
      _fetcherror = haserror;
    });
  }
}
