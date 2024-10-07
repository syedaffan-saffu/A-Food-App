// import 'package:flutter/material.dart';
// import 'package:rajputfoods/utils/backenddata/apifunctions/itemsapi.dart';
// import 'package:rajputfoods/utils/utilspack1.dart';
// import 'package:rajputfoods/pages/homescreen/detailpages/exploremenu.dart';
// import 'package:rajputfoods/utils/utilspack2.dart';

// class FilterPage extends StatefulWidget {
//   const FilterPage({
//     super.key,
//   });

//   @override
//   State<FilterPage> createState() => _FilterPageState();
// }

// class _FilterPageState extends State<FilterPage> {
//   List<String?>? foodlist;
//   String? selectedLocation;
//   String? selectedFood;
//   int? selectedFoodid;
//   int parsetofoodid(String foodid) {
//     int raw = int.parse(foodid);
//     return raw;
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   backgroundColor: Colors.transparent,
//       //   leading: const BackButton(),
//       //   actions: [const Icon(Icons.notifications_active)],
//       // ),
//       body: PagewithSimpleBG(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.only(top: 100, left: 30, right: 30),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Find Your Favourite Food",
//                   style: TextStyle(
//                     wordSpacing: 0.5,
//                     letterSpacing: 0.2,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 30,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 DropdownButtonHideUnderline(
//                   child: DropdownButtonFormField(
//                     menuMaxHeight: 300,
//                     hint: const Text(
//                       "Location",
//                       style: TextStyle(fontSize: 14),
//                     ),
//                     value: selectedLocation,
//                     isExpanded: true,
//                     dropdownColor: const Color(0xFFFFFFFF),
//                     items: const [DropdownMenuItem(child: Text("Hyderabad"))],
//                     onChanged: (value) {
//                       setState(() {
//                         selectedLocation = value;
//                       });
//                     },
//                     decoration: const InputDecoration(
//                         filled: true,
//                         fillColor: Color(0xFFFFFFFF),
//                         prefixIcon: Icon(Icons.location_on),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey)),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey)),
//                         border: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey))),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 DropdownButtonHideUnderline(
//                   child: FutureBuilder(
//                       future: Itemsapi.fetchcategories(),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         } else if (snapshot.hasError) {
//                           return Center(
//                             child: Text('Error: ${snapshot.error}'),
//                           );
//                         } else if (!snapshot.hasData ||
//                             snapshot.data!.isEmpty) {
//                           return const Center(
//                             child: Text('No data available'),
//                           );
//                         } else {
//                           return DropdownButtonFormField(
//                             alignment: Alignment.bottomLeft,
//                             menuMaxHeight: 300,
//                             hint: const Text(
//                               "Food",
//                               style: TextStyle(fontSize: 14),
//                             ),
//                             value: selectedFoodid,
//                             isExpanded: true,
//                             dropdownColor: const Color(0xFFFFFFFF),
//                             items: snapshot.data!
//                                 .map<DropdownMenuItem<int>>((foodItem) {
//                               return DropdownMenuItem<int>(
//                                 value: parsetofoodid(foodItem.categoryid),
//                                 child: Text(foodItem.title),
//                               );
//                             }).toList(),
//                             onChanged: (value) {
//                               selectedFood = snapshot.data!
//                                   .where(
//                                     (element) =>
//                                         parsetofoodid(element.categoryid) ==
//                                         value,
//                                   )
//                                   .first
//                                   .title;
//                               setState(() {
//                                 selectedFoodid = value;
//                               });
//                             },
//                             decoration: const InputDecoration(
//                               filled: true,
//                               fillColor: Color(0xFFFFFFFF),
//                               prefixIcon: Icon(Icons.fastfood_rounded),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(color: Colors.grey),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(color: Colors.grey),
//                               ),
//                               border: OutlineInputBorder(
//                                 borderSide: BorderSide(color: Colors.grey),
//                               ),
//                             ),
//                           );
//                         }
//                       }),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 SizedBox(
//                   height: 50,
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (selectedFood != null) {
//                         Navigator.of(context).pushReplacement(
//                             MaterialPageRoute(builder: (context) {
//                           return ExploremenuPage(
//                             filtertext: selectedFood,
//                             appliedfilter: true,
//                             future: Itemsapi.fetchMenuFiltered(
//                                 selectedFoodid!, context),
//                           );
//                         }));
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                             UtilsPack2.snackBar("Please Select Food", 1));
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5)),
//                         backgroundColor: const Color(0xFFE83636)),
//                     child: const Text(
//                       "Search",
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
