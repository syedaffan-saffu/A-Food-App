import 'package:flutter/material.dart';
import 'package:rajputfoods/pages/homescreen/detailpages/itemdetails.dart';
import 'package:rajputfoods/utils/auth/apiutils.dart';
import 'package:rajputfoods/utils/backenddata/models/itemcategorydata.dart';
import 'package:rajputfoods/utils/pageutils/homeutils.dart';
import 'package:rajputfoods/utils/utilspack1.dart';

class Itemcarddata {
  final String id;
  final String img;
  final String title;
  final String price;
  final String categoryid;

  const Itemcarddata(
      {required this.id,
      required this.img,
      required this.title,
      required this.price,
      required this.categoryid});

  factory Itemcarddata.fromJson(Map<String, dynamic> json) {
    return Itemcarddata(
        id: json['id'],
        img: "${ApiUtils.imageapiurl(false)}/${json['image']}",
        title: json['title'],
        price: json['unit_price'],
        categoryid: json['item_category_id']);
  }
  static List<Itemcarddata> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => Itemcarddata.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

class ItemsFutureBuilder extends StatelessWidget {
  final Future<List<Itemcategorydata>> future;

  const ItemsFutureBuilder({
    super.key,
    required this.future,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            height: Utilspack1.contextheight(context) * 0.7,
            child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, bindex) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data![bindex].title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Wrap(
                            runSpacing: 15,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.spaceBetween,
                            children: List.generate(
                                snapshot.data![bindex].items.length, (index) {
                              final itemdata =
                                  snapshot.data![bindex].items[index];
                              return ItemCard(
                                onTap: () {
                                  Utilspack1.navigateto(
                                      context,
                                      Itemdetailspage(
                                          id: itemdata.id,
                                          imgurl: itemdata.img,
                                          title: itemdata.title,
                                          price: itemdata.price));
                                },
                                networkimg: true,
                                price: itemdata.price,
                                img: itemdata.img,
                                title: itemdata.title,
                                categoryid: itemdata.categoryid,
                              );
                            })),
                      ),
                    ],
                  );
                }),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        }
        return const Center(
            child: CircularProgressIndicator(
          color: Color(0xFFE21B1B),
        ));
      },
    );
  }
}
