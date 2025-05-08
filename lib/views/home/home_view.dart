import 'package:apartment_rentals/res/app_widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../res/app_widgets/text.dart';
import '../../res/colors.dart';
import '../../res/app_widgets/drawer.dart';
import '../../view_models/controllers/add_appartment/add_appartment_view_model.dart';
import '../../view_models/controllers/home/home_view_model.dart';
import '../add_appartment/add_apartment_view.dart';
import '../details/details_view.dart';
import 'widgets/appartment_card.dart';

//! HomeScreen: Displays the list of apartments and allows search and filtering
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());
  final AddApartmentController addApartmentController =
      Get.put(AddApartmentController());

  @override
  void initState() {
    homeController.fetchApartments();
    super.initState();
    debugPrint('aaaaa');
  }

  @override
  Widget build(BuildContext context) {
    //! Scaffold key for controlling the drawer
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: MyAppBar(
        title: 'Home',
      ),
      drawer: MyDrawer(),
      backgroundColor: kPrimary,
      body: Padding(
        padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 8.h, bottom: 25.h),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              //! Search Field for filtering apartments by a query
              TextField(
                onChanged: (query) {
                  homeController.searchApartmentsByQuery(query);
                },
                cursorColor: kSecondary,
                decoration: InputDecoration(
                  hintText: 'Search for apartments',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0), // Default border color when not focused
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0), // Border color when focused
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              //! Filter Chips to select apartment types
              Obx(
                () => SizedBox(
                  height: 50, // Set height to contain the horizontal list
                  child: ListView(
                    scrollDirection:
                        Axis.horizontal, // Enable horizontal scrolling
                    children: homeController.houseTypesHome.map((type) {
                      final isSelected =
                          homeController.selectedType.value == type;

                      return Padding(
                        padding: const EdgeInsets.only(
                            right: 10.0), // Add spacing between chips
                        child: ChoiceChip(
                          label: AppText.body(type),
                          selected: isSelected,
                          selectedColor:
                              Colors.blue, // Background color when selected
                          onSelected: (selected) {
                            homeController.filterByType(type);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              //! List of filtered apartments
              Expanded(
                child: Obx(() {
                  if (homeController.filteredApartments.isEmpty) {
                    return Center(child: Text('No apartments found.'));
                  }

                  return ListView.builder(
                    itemCount: homeController.filteredApartments.length +
                        1, // Add an extra item for loading indicator
                    itemBuilder: (context, index) {
                      if (index == homeController.filteredApartments.length) {
                        // Show the loading indicator if we're loading more data
                        if (homeController.isLoading.value) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return SizedBox.shrink(); // No more data to load
                        }
                      }

                      final apartment =
                          homeController.filteredApartments[index];

                      // Assuming 'mediaUrls' is a list of strings for each apartment
                      List<dynamic> mediaUrls = apartment['mediaUrls'] ?? [];

                      // Filter to only get image URLs
                      String imageUrl = mediaUrls.firstWhere(
                        (url) =>
                            url.endsWith('.jpg') ||
                            url.endsWith('.jpeg') ||
                            url.endsWith('.png'),
                        orElse: () =>
                            '', // If no image URL, return an empty string
                      );

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: AppartmentCardWidget(
                          isAvailable: apartment['available'],
                          image: imageUrl, // Pass the filtered image URL
                          address: apartment['address'],
                          price: apartment['price'].toString(),
                          bathRooms: apartment['noBath'].toString(),
                          bedRooms: apartment['noBed'].toString(),
                          roomType: apartment['roomType'],
                          onTap: () {
                            Get.to(() => ApartmentDetailsScreen(
                                apartmentId: apartment['uuid']));
                          },
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      // ! floating Action Button
      floatingActionButton: Obx(() {
        if (homeController.userRole.value == "Landlord") {
          return Padding(
            padding: EdgeInsets.only(bottom: 60.h),
            child: SizedBox(
              width: 60.w, // Increase width
              height: 60.h, // Increase height
              child: FloatingActionButton(
                onPressed: () => Get.to(() => AddAppartmentScreen()),
                backgroundColor: kSecondaryLight,
                shape: CircleBorder(),
                child: Icon(
                  Icons.add_home_work_rounded,
                  color: kPrimary,
                  size: 40.spMin, // Increase icon size
                ),
              ),
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      }),
    );
  }
}
