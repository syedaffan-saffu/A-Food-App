import 'package:rajputfoods/utils/backenddata/models/itemcarddata.dart';

class Itemcategorydata {
  final List<Itemcarddata> items;
  final String title;
  final String categoryid;

  const Itemcategorydata({
    required this.items,
    required this.title,
    required this.categoryid,
  });

  factory Itemcategorydata.fromJson(Map<String, dynamic> json) {
    return Itemcategorydata(
      items: Itemcarddata.fromJsonList(json['items'] as List<dynamic>),
      //  (json['items'] as List<dynamic>)
      //     .map((item) => Itemcarddata.fromJson(item as Map<String, dynamic>))
      //     .toList(),
      title: json['category'],
      categoryid: json['category_id'],
    );
  }
  static List<Itemcategorydata> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => Itemcategorydata.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}




// class ItemSearchdata {
//   final String title;
//   final String categoryid;

//   const ItemSearchdata({
//     required this.title,
//     required this.categoryid,
//   });

//   factory ItemSearchdata.fromJson(Map<String, dynamic> json) {
//     return ItemSearchdata(
//       title: json['title'],
//       categoryid: json['id'],
//     );
//   }
//   static List<Itemcategorydata> fromJsonList(List<dynamic> jsonList) {
//     return jsonList
//         .map((json) => Itemcategorydata.fromJson(json as Map<String, dynamic>))
//         .toList();
//   }
// }
