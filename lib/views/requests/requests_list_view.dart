// import 'package:apartment_rentals/res/app_widgets/app_bar.dart';
// import 'package:apartment_rentals/res/app_widgets/text.dart';
// import 'package:apartment_rentals/res/colors.dart';
// import 'package:apartment_rentals/view_models/services/user_session.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'user_request_view.dart';

// class RequestsPage extends StatelessWidget {
//   const RequestsPage({super.key});

//   Future<Map<String, dynamic>> fetchRenterDetails(String renterId) async {
//     try {
//       final DatabaseReference userDatabase = FirebaseDatabase.instance
//           .ref('user'); // Assuming 'user' is the path for users in Firebase.

//       final renterSnapshot = await userDatabase.child(renterId).get();

//       if (renterSnapshot.exists) {
//         // Manually convert the Map<Object?, Object?> to Map<String, dynamic>
//         final renterData = Map<String, dynamic>.from(
//             renterSnapshot.value as Map<Object?, Object?>);
//         return renterData;
//       } else {
//         return {};
//       }
//     } catch (e) {
//       // print('Error fetching renter details: $e');
//       return {}; // Return an empty map in case of error
//     }
//   }

//   Future<Map<String, dynamic>> fetchApartmentDetails(String apartmentId) async {
//     try {
//       final DatabaseReference apartmentDatabase = FirebaseDatabase.instance.ref(
//           'apartments'); // Assuming 'apartments' is the path for apartments in Firebase.

//       final apartmentSnapshot =
//           await apartmentDatabase.child(apartmentId).get();

//       if (apartmentSnapshot.exists) {
//         // Manually convert the Map<Object?, Object?> to Map<String, dynamic>
//         final apartmentData = Map<String, dynamic>.from(
//             apartmentSnapshot.value as Map<Object?, Object?>);
//         return apartmentData;
//       } else {
//         return {};
//       }
//     } catch (e) {
//       // print('Error fetching apartment details: $e');
//       return {}; // Return an empty map in case of error
//     }
//   }

//   // Fetch Renter Details
//   Future<List<Map<String, dynamic>>> fetchDetails(
//       String renterId, String apartmentId) async {
//     try {
//       final renterDetails = await fetchRenterDetails(renterId);
//       final apartmentDetails = await fetchApartmentDetails(apartmentId);
//       return [renterDetails, apartmentDetails];
//     } catch (e) {
//       // print('Error fetching details: $e');
//       return [{}, {}]; // Return empty maps in case of error
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final DatabaseReference requestDatabase =
//         FirebaseDatabase.instance.ref('request');

//     return Scaffold(
//       appBar: MyAppBar(title: 'Requests'),
//       body: StreamBuilder(
//         stream: requestDatabase.onValue,
//         builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
//             final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

//             // Filter requests where ownerId matches current user's ID
//             final List<Map<dynamic, dynamic>> filteredRequests = data.entries
//                 .map((entry) =>
//                     {'key': entry.key, ...entry.value as Map<dynamic, dynamic>})
//                 .where((request) =>
//                     request['ownerId'] == SessionController().userId)
//                 .toList();

//             if (filteredRequests.isEmpty) {
//               return const Center(child: Text('No matching requests found.'));
//             }

//             return ListView.builder(
//               itemCount: filteredRequests.length,
//               itemBuilder: (context, index) {
//                 final request = filteredRequests[index];

//                 return FutureBuilder<List<Map<String, dynamic>>>(
//                   future: fetchDetails(
//                       request['renterId'], request['appartmentId']),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     }

//                     if (snapshot.hasError) {
//                       return ListTile(
//                         title: Text('Error fetching details.'),
//                         subtitle: Text('${snapshot.error}'),
//                       );
//                     }

//                     if (snapshot.hasData) {
//                       final renterData = snapshot.data![0];
//                       final apartmentData = snapshot.data![1];

//                       // print('Renter Data: $renterData');
//                       // print('Apartment Data: $apartmentData');

//                       final String name = renterData['name'];
//                       final String phone = renterData['phone'];
//                       final String profilePic = renterData['profilePic'];
//                       // print(request['key']);
//                       return GestureDetector(
//                         onTap: () => Get.to(
//                             () => UserRequestScreen(
//                                   requestId: request['key'],
//                                 ),
//                             arguments: {
//                               'renterData': renterData,
//                               'apartmentData': apartmentData,
//                             }),
//                         child: Card(
//                           elevation: 5,
//                           margin: const EdgeInsets.all(10),
//                           child: ListTile(
//                               leading: CircleAvatar(
//                                 backgroundColor: kSecondaryLight3,
//                                 radius:
//                                     25, // Set the radius to your desired size
//                                 child: ClipOval(
//                                   // This ensures the image is clipped into a circle
//                                   child: profilePic.isNotEmpty
//                                       ? Image.network(
//                                           profilePic,
//                                           fit: BoxFit
//                                               .cover, // Make sure the image is scaled correctly
//                                           width:
//                                               50, // Set the width and height to ensure a circular shape
//                                           height: 50,
//                                         )
//                                       : const Icon(Icons.person,
//                                           size:
//                                               30), // Fallback if no profilePic
//                                 ),
//                               ),
//                               subtitle: AppText.body(phone),
//                               title: AppText.bodyBold(name),
//                               trailing: Icon(Icons.arrow_forward_ios_rounded)),
//                         ),
//                       );
//                     }

//                     return const ListTile(
//                       title: Text('No details found.'),
//                     );
//                   },
//                 );
//               },
//             );
//           }

//           return const Center(child: Text('No requests found.'));
//         },
//       ),
//     );
//   }
// }

import 'package:apartment_rentals/res/app_widgets/text.dart';
import 'package:apartment_rentals/res/colors.dart';
import 'package:apartment_rentals/view_models/services/user_session.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'user_request_details_view.dart';

enum RequestStatus {
  pending,
  accepted,
  canceled,
  declined,
}

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  Future<Map<String, dynamic>> fetchRenterDetails(String renterId) async {
    final userDatabase = FirebaseDatabase.instance.ref('user');
    final renterSnapshot = await userDatabase.child(renterId).get();

    if (renterSnapshot.exists) {
      return Map<String, dynamic>.from(
          renterSnapshot.value as Map<Object?, Object?>);
    }
    return {};
  }

  Future<Map<String, dynamic>> fetchApartmentDetails(String apartmentId) async {
    final apartmentDatabase = FirebaseDatabase.instance.ref('apartments');
    final apartmentSnapshot = await apartmentDatabase.child(apartmentId).get();

    if (apartmentSnapshot.exists) {
      return Map<String, dynamic>.from(
          apartmentSnapshot.value as Map<Object?, Object?>);
    }
    return {};
  }

  Future<List<Map<String, dynamic>>> fetchDetails(
      String renterId, String apartmentId) async {
    final renterDetails = await fetchRenterDetails(renterId);
    final apartmentDetails = await fetchApartmentDetails(apartmentId);
    return [renterDetails, apartmentDetails];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: RequestStatus.values.length, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Requests',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.spMin),
          ),
          bottom: TabBar(
            labelColor: kSecondary2,
            dividerColor: kSecondaryLight,
            indicatorColor: kSecondaryLight2,
            // isScrollable: true,
            // labelPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            // indicatorPadding: const EdgeInsets.symmetric(horizontal: 8.0),
            tabs: RequestStatus.values
                .map((status) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Tab(text: status.name.capitalizeFirst),
                    ))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: RequestStatus.values
              .map((status) => RequestListView(status: status))
              .toList(),
        ),
      ),
    );
  }
}

class RequestListView extends StatelessWidget {
  final RequestStatus status;

  const RequestListView({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final DatabaseReference requestDatabase =
        FirebaseDatabase.instance.ref('request');

    return StreamBuilder(
      stream: requestDatabase.onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

          // Filter requests based on status and ownerId
          final List<Map<dynamic, dynamic>> filteredRequests = data.entries
              .map((entry) =>
                  {'key': entry.key, ...entry.value as Map<dynamic, dynamic>})
              .where((request) =>
                  request['ownerId'] == SessionController().userId &&
                  request['requestStatus'] == status.name)
              .toList();

          if (filteredRequests.isEmpty) {
            return Center(child: Text('No ${status.name} requests found.'));
          }

          return ListView.builder(
            itemCount: filteredRequests.length,
            itemBuilder: (context, index) {
              final request = filteredRequests[index];

              return FutureBuilder<List<Map<String, dynamic>>>(
                future: RequestsPage()
                    .fetchDetails(request['renterId'], request['appartmentId']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return ListTile(
                      title: Text('Error fetching details.'),
                      subtitle: Text('${snapshot.error}'),
                    );
                  }

                  if (snapshot.hasData) {
                    final renterData = snapshot.data![0];
                    final apartmentData = snapshot.data![1];

                    final String name = renterData['name'] ?? 'Unknown';
                    final String phone = renterData['phone'] ?? 'Unknown';
                    final String profilePic = renterData['profilePic'] ?? '';

                    return GestureDetector(
                      onTap: () => Get.to(
                          () => UserRequestScreen(
                                requestId: request['key'],
                                requestStatus: status.name,
                              ),
                          arguments: {
                            'renterData': renterData,
                            'apartmentData': apartmentData,
                            'requestData': request,
                          }),
                      child: Card(
                        elevation: 5,
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: kSecondaryLight3,
                            radius: 25,
                            child: profilePic.isNotEmpty
                                ? ClipOval(
                                    child: Image.network(
                                      profilePic,
                                      fit: BoxFit.cover,
                                      width: 50,
                                      height: 50,
                                    ),
                                  )
                                : const Icon(Icons.person, size: 30),
                          ),
                          subtitle: AppText.body(phone),
                          title: AppText.bodyBold(name),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded),
                        ),
                      ),
                    );
                  }

                  return const ListTile(
                    title: Text('No details found.'),
                  );
                },
              );
            },
          );
        }

        return const Center(child: Text('No requests found.'));
      },
    );
  }
}
