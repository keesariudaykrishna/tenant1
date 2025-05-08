// import 'package:apartment_rentals/res/app_widgets/app_bar.dart';
// import 'package:apartment_rentals/res/app_widgets/text.dart';
// import 'package:apartment_rentals/res/colors.dart';
// import 'package:apartment_rentals/view_models/services/user_session.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'my_request_detiails_view.dart';

// class MyRequestListScreen extends StatelessWidget {
//   const MyRequestListScreen({super.key});

// // ! fetch Renter Details
//   Future<Map<String, dynamic>> fetchRenterDetails(String ownerId) async {
//     try {
//       final DatabaseReference userDatabase = FirebaseDatabase.instance
//           .ref('user'); // Assuming 'user' is the path for users in Firebase.

//       final renterSnapshot = await userDatabase.child(ownerId).get();

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

// // ! fetch Apartment Details
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

//   // !Fetch Renter Details
//   Future<List<Map<String, dynamic>>> fetchDetails(
//       String ownerId, String apartmentId) async {
//     try {
//       final ownerDetails = await fetchRenterDetails(ownerId);
//       final apartmentDetails = await fetchApartmentDetails(apartmentId);
//       return [ownerDetails, apartmentDetails];
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
//       appBar: MyAppBar(title: 'My Requests'),
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

//             //! Filter requests sender where matches current user's ID
//             final List<Map<dynamic, dynamic>> filteredRequests = data.entries
//                 .map((entry) =>
//                     {'key': entry.key, ...entry.value as Map<dynamic, dynamic>})
//                 .where((request) =>
//                     request['renterId'] == SessionController().userId)
//                 .toList();

//             if (filteredRequests.isEmpty) {
//               return const Center(child: Text('No matching requests found.'));
//             }

//             return ListView.builder(
//               itemCount: filteredRequests.length,
//               itemBuilder: (context, index) {
//                 final request = filteredRequests[index];

//                 return FutureBuilder<List<Map<String, dynamic>>>(
//                   future:
//                       fetchDetails(request['ownerId'], request['appartmentId']),
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
//                       final ownerData = snapshot.data![0];
//                       final apartmentData = snapshot.data![1];

//                       // print('Renter Data: $renterData');
//                       // print('Apartment Data: $apartmentData');

//                       final String name = ownerData['name'] ?? '';
//                       final String phone = ownerData['phone'] ?? '';
//                       final String profilePic = ownerData['profilePic'] ?? '';
//                       // print(request['key']);
//                       return GestureDetector(
//                         onTap: () => Get.to(
//                             () => MyRequestDetailsScreen(
//                                   requestId: request['key'],
//                                 ),
//                             arguments: {
//                               'ownerData': ownerData,
//                               'apartmentData': apartmentData,
//                             }),
//                         child: Card(
//                           elevation: 5,
//                           margin: const EdgeInsets.all(10),
//                           child: ListTile(
//                               leading: CircleAvatar(
//                                 backgroundColor: kSecondaryLight3,
//                                 radius: 25,
//                                 child: ClipOval(
//                                   child: profilePic.isNotEmpty
//                                       ? Image.network(
//                                           profilePic,
//                                           fit: BoxFit.cover,
//                                           width: 50,
//                                           height: 50,
//                                         )
//                                       : const Icon(Icons.person, size: 30),
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

import 'package:apartment_rentals/res/colors.dart';
import 'package:apartment_rentals/view_models/services/user_session.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'my_request_detiails_view.dart';

enum RequestStatus {
  pending,
  accepted,
  canceled,
  declined,
}

class MyRequestTabScreen extends StatelessWidget {
  const MyRequestTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: RequestStatus.values.length, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'My Requests',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.spMin),
          ),
          bottom: TabBar(
            labelColor: kSecondary2,
            dividerColor: kSecondaryLight,
            indicatorColor: kSecondaryLight2,
            tabs: RequestStatus.values
                .map((status) => Tab(text: status.name.capitalizeFirst))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: RequestStatus.values
              .map((status) => RequestListPage(status: status))
              .toList(),
        ),
      ),
    );
  }
}

class RequestListPage extends StatelessWidget {
  final RequestStatus status;

  const RequestListPage({super.key, required this.status});
//! fetch Renter Details
  Future<Map<String, dynamic>> fetchRenterDetails(String ownerId) async {
    try {
      final DatabaseReference userDatabase =
          FirebaseDatabase.instance.ref('user');
      final renterSnapshot = await userDatabase.child(ownerId).get();

      if (renterSnapshot.exists) {
        final renterData = Map<String, dynamic>.from(
            renterSnapshot.value as Map<Object?, Object?>);
        return renterData;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

// ! fetch Apartment Details
  Future<Map<String, dynamic>> fetchApartmentDetails(String apartmentId) async {
    try {
      final DatabaseReference apartmentDatabase =
          FirebaseDatabase.instance.ref('apartments');
      final apartmentSnapshot =
          await apartmentDatabase.child(apartmentId).get();

      if (apartmentSnapshot.exists) {
        final apartmentData = Map<String, dynamic>.from(
            apartmentSnapshot.value as Map<Object?, Object?>);
        return apartmentData;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

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

          //! Filter requests by status and current user
          final filteredRequests = data.entries
              .map((entry) =>
                  {'key': entry.key, ...entry.value as Map<dynamic, dynamic>})
              .where((request) =>
                  request['renterId'] == SessionController().userId &&
                  request['requestStatus'] == status.name)
              .toList();

          if (filteredRequests.isEmpty) {
            return Center(child: Text('No ${status.name} requests found.'));
          }

          return ListView.builder(
            itemCount: filteredRequests.length,
            itemBuilder: (context, index) {
              final request = filteredRequests[index];

              return FutureBuilder<Map<String, dynamic>>(
                future: fetchRenterDetails(request['ownerId']),
                builder: (context, ownerSnapshot) {
                  if (ownerSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const ListTile(
                      title: CircularProgressIndicator(),
                    );
                  }

                  if (ownerSnapshot.hasError) {
                    return ListTile(
                      title: Text('Error: ${ownerSnapshot.error}'),
                    );
                  }

                  if (ownerSnapshot.hasData) {
                    final ownerData = ownerSnapshot.data!;

                    return FutureBuilder<Map<String, dynamic>>(
                      future: fetchApartmentDetails(request['appartmentId']),
                      builder: (context, apartmentSnapshot) {
                        if (apartmentSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const ListTile(
                            title: CircularProgressIndicator(),
                          );
                        }

                        if (apartmentSnapshot.hasError) {
                          return ListTile(
                            title: Text('Error: ${apartmentSnapshot.error}'),
                          );
                        }

                        if (apartmentSnapshot.hasData) {
                          final apartmentData = apartmentSnapshot.data!;

                          final String name = ownerData['name'] ?? 'Unknown';
                          final String phone = ownerData['phone'] ?? 'Unknown';
                          final String profilePic =
                              ownerData['profilePic'] ?? '';

                          return Card(
                            margin: const EdgeInsets.all(8),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                child: profilePic.isNotEmpty
                                    ? Hero(
                                        tag: 'profileImage',
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: profilePic,
                                            fit: BoxFit.cover,
                                            width: 50,
                                            height: 50,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      )
                                    : const Icon(Icons.person, size: 30),
                              ),
                              title: Hero(tag: 'name', child: Text(name)),
                              subtitle: Hero(tag: 'phone', child: Text(phone)),
                              trailing:
                                  const Icon(Icons.arrow_forward_ios_rounded),
                              onTap: () {
                                Get.to(
                                  () => MyRequestDetailsScreen(
                                    requestId: request['key'],
                                  ),
                                  arguments: {
                                    'ownerData': ownerData,
                                    'apartmentData': apartmentData,
                                    'requestData': request,
                                  },
                                );
                              },
                            ),
                          );
                        }

                        return const ListTile(
                          title: Text('No apartment details available.'),
                        );
                      },
                    );
                  }

                  return const ListTile(
                    title: Text('No owner details available.'),
                  );
                },
              );
            },
          );
        }

        return Center(child: Text('No ${status.name} requests found.'));
      },
    );
  }
}
