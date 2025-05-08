// import 'package:apartment_rentals/res/app_widgets/app_bar.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import '../../view_models/services/user_session.dart';
// import '../details/details_view.dart';
// import '../home/widgets/appartment_card.dart';

// class MyPropertyScreen extends StatefulWidget {
//   const MyPropertyScreen({super.key});

//   @override
//   State<MyPropertyScreen> createState() => _MyPropertyScreenState();
// }

// class _MyPropertyScreenState extends State<MyPropertyScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final userId =
//         SessionController().userId.toString(); // Fetch current user's ID

//     return Scaffold(
//       appBar: MyAppBar(

//         title: 'My Properties',
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(4.h), // Padding around the body
//         child: Column(
//           children: [
//             StreamBuilder<DatabaseEvent>(
//               // StreamBuilder to listen for changes in Firebase
//               stream: FirebaseDatabase.instance
//                   .ref('apartments')
//                   .onValue, // Stream that listens to 'apartments' in Firebase
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(
//                       child:
//                           CircularProgressIndicator()); // Show loading indicator while data is being fetched
//                 }

//                 if (snapshot.hasError) {
//                   return Center(
//                       child: Text(
//                           'Error: ${snapshot.error}')); // Show error message if there’s an issue
//                 }

//                 if (!snapshot.hasData ||
//                     snapshot.data?.snapshot.value == null) {
//                   return const Center(
//                       child: Text(
//                           'No house available.')); // Show message if no data is found
//                 }

//                 // Get the house data from Firebase
//                 Map<dynamic, dynamic> houseData =
//                     snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

//                 //! Filter the apartments based on the current user's ID
//                 var userApartments = houseData.entries
//                     .where((entry) =>
//                         entry.value['userId'] ==
//                         userId) // Check if the userId matches
//                     .toList();

//                 if (userApartments.isEmpty) {
//                   return const Center(
//                       child: Text(
//                           'No house available.')); // Show message if no apartments for the user
//                 }

//                 return Expanded(
//                   // Make the ListView take the remaining space
//                   child: ListView.builder(
//                     itemCount: userApartments
//                         .length, // Number of apartments the user has
//                     itemBuilder: (context, index) {
//                       final apartment =
//                           userApartments[index].value; // Get apartment data

//                       final address = apartment['address'] ??
//                           'No address'; // Get address or default message
//                       final price = apartment['price'] ??
//                           'No price available'; // Get price or default message
//                       final imageUrl =
//                           apartment['imageUrl'] ?? ''; // Get image URL
//                       final bedRooms =
//                           apartment['noBed'] ?? ''; // Number of bedrooms
//                       final bathRooms =
//                           apartment['noBath'] ?? ''; // Number of bathrooms
//                       final roomType =
//                           apartment['roomType'] ?? ''; // Type of room

//                       final apartmentId =
//                           userApartments[index].key; // Get apartment ID

//                       return AppartmentCardWidget(
//                         image: imageUrl,
//                         address: address,
//                         price: price,
//                         bedRooms: bedRooms,
//                         bathRooms: bathRooms,
//                         roomType: roomType,
//                         onTap: () {
//                           Get.to(() => ApartmentDetailsScreen(
//                               apartmentId:
//                                   apartmentId)); // Navigate to details screen on tap
//                         },
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:apartment_rentals/res/colors.dart';
import 'package:apartment_rentals/views/my_property/first_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyPropertyScreen extends StatefulWidget {
  const MyPropertyScreen({super.key});

  @override
  State<MyPropertyScreen> createState() => _MyPropertyScreenState();
}

class _MyPropertyScreenState extends State<MyPropertyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize the stream and convert it into a broadcast stream
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          // MyAppBar(
          //   title: 'My Properties',
          //   bottom: TabBar(
          //     labelColor: kSecondary2,
          //     dividerColor: kSecondaryLight,
          //     indicatorColor: kSecondaryLight2,
          //     controller: _tabController,
          //     tabs: const [
          //       Tab(text: "Not Rented"),
          //       Tab(text: "Rented"),
          //     ],
          //   ),
          // ),
          AppBar(
        centerTitle: true,
        title: Text(
          'My Properties',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.spMin),
        ),
        bottom: TabBar(
          labelColor: kSecondary2,
          dividerColor: kSecondaryLight,
          indicatorColor: kSecondaryLight2,
          controller: _tabController,
          tabs: const [
            Tab(text: "Not Rented"),
            Tab(text: "Rented"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FirstView(isAvailable: true), // Available properties
          FirstView(isAvailable: false), // Available properties
          // _buildPropertyList(userId, false), // Unavailable properties
        ],
      ),
    );
  }
}
