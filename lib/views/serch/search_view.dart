// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../view_models/controllers/home/home_view_model.dart';
// import '../../res/app_widgets/app_bar.dart';
// import '../../res/app_widgets/text.dart';
// import '../../res/app_widgets/text_form_field.dart';
// import '../../res/colors.dart';

// class SearchScreen extends StatelessWidget {
//   final HomeController homeController = Get.put(HomeController());
//   final TextEditingController minPriceController = TextEditingController();
//   final TextEditingController maxPriceController = TextEditingController();
//   final TextEditingController locationController = TextEditingController();
//   final TextEditingController searchController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   SearchScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: MyAppBar(
//         title: 'Search',
//         showBackButton: false,
//       ),
//       backgroundColor: kPrimary,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 MyField(
//                   hintText: 'Search',
//                   controller: searchController,
//                   validatorText: '',
//                   prefixIcon: Icon(Icons.search),
//                   onChange: (value) {
//                     homeController.searchApartments(
//                       searchController.text,
//                       minPriceController.text,
//                       maxPriceController.text,
//                       locationController.text,
//                       homeController.selectedType.value,
//                       homeController.selectedBeds.value,
//                     );
//                   },
//                 ),
//                 SizedBox(height: 16),
//                 AppText.bodyBold('Price Range'),
//                 SizedBox(height: 10),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: MyField(
//                         hintText: 'Minimum Price',
//                         controller: minPriceController,
//                         onChange: (value) {
//                           homeController.searchApartments(
//                             searchController.text,
//                             minPriceController.text,
//                             maxPriceController.text,
//                             locationController.text,
//                             homeController.selectedType.value,
//                             homeController.selectedBeds.value,
//                           );
//                         },
//                         validatorText: 'Please enter minimum price',
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: AppText.body('- to -'),
//                     ),
//                     Expanded(
//                       child: MyField(
//                         hintText: 'Maximum Price',
//                         controller: maxPriceController,
//                         onChange: (value) {
//                           homeController.searchApartments(
//                             searchController.text,
//                             minPriceController.text,
//                             maxPriceController.text,
//                             locationController.text,
//                             homeController.selectedType.value,
//                             homeController.selectedBeds.value,
//                           );
//                         },
//                         validatorText: 'Please enter maximum price',
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//                 AppText.bodyBold('Enter Location'),
//                 SizedBox(height: 10),
//                 MyField(
//                   hintText: 'Location',
//                   controller: locationController,
//                   validatorText: 'Please enter location',
//                   onChange: (value) {
//                     homeController.searchApartments(
//                       searchController.text,
//                       minPriceController.text,
//                       maxPriceController.text,
//                       locationController.text,
//                       homeController.selectedType.value,
//                       homeController.selectedBeds.value,
//                     );
//                   },
//                 ),
//                 SizedBox(height: 16),
//                 AppText.bodyBold('Select Type of Apartment'),
//                 SizedBox(height: 10),
//                 // Obx(
//                 //   () => Wrap(
//                 //     spacing: 20,
//                 //     children: houseTypes.map((type) {
//                 //       return ChoiceChip(
//                 //         label: AppText.bodyBold(type),
//                 //         selected: homeController.selectedType.value == type,
//                 //         onSelected: (selected) {
//                 //           homeController.selectedType.value =
//                 //               selected ? type : '';
//                 //           homeController.searchApartments(
//                 //             searchController.text,
//                 //             minPriceController.text,
//                 //             maxPriceController.text,
//                 //             locationController.text,
//                 //             homeController.selectedType.value,
//                 //             homeController.selectedBeds.value,
//                 //           );
//                 //         },
//                 //       );
//                 //     }).toList(),
//                 //   ),
//                 // ),
//                 Obx(
//                   () => SizedBox(
//                     height: 50, // Set height to contain the horizontal list
//                     child: ListView(
//                       scrollDirection:
//                           Axis.horizontal, // Enable horizontal scrolling
//                       children: homeController.houseTypesSearch.map((type) {
//                         final isSelected =
//                             homeController.selectedType.value == type;

//                         return Padding(
//                           padding: const EdgeInsets.only(
//                               right: 10.0), // Add spacing between chips
//                           child: ChoiceChip(
//                             label: AppText.bodyBold(type),
//                             selected: isSelected,
//                             selectedColor:
//                                 Colors.blue, // Background color when selected
//                             onSelected: (selected) {
//                               homeController.selectedType.value =
//                                   selected ? type : '';
//                               homeController.searchApartments(
//                                 searchController.text,
//                                 minPriceController.text,
//                                 maxPriceController.text,
//                                 locationController.text,
//                                 homeController.selectedType.value,
//                                 homeController.selectedBeds.value,
//                               );
//                             },
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),

//                 SizedBox(height: 16),
//                 AppText.bodyBold('Select Number of Beds'),
//                 SizedBox(height: 10),
//                 Obx(
//                   () => Wrap(
//                     spacing: 20,
//                     children: List.generate(6, (index) {
//                       final beds = index == 5 ? '6+' : '${index + 1}';
//                       return ChoiceChip(
//                         label: AppText.bodyBold(beds),
//                         selected: homeController.selectedBeds.value == beds,
//                         onSelected: (selected) {
//                           homeController.selectedBeds.value =
//                               selected ? beds : '';
//                           homeController.searchApartments(
//                             searchController.text,
//                             minPriceController.text,
//                             maxPriceController.text,
//                             locationController.text,
//                             homeController.selectedType.value,
//                             homeController.selectedBeds.value,
//                           );
//                         },
//                       );
//                     }),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 // ElevatedButton(
//                 //   onPressed: () {
//                 //     if (_formKey.currentState!.validate()) {
//                 //       homeController.searchApartments(
//                 //         searchController.text,
//                 //         minPriceController.text,
//                 //         maxPriceController.text,
//                 //         locationController.text,
//                 //         homeController.selectedType.value,
//                 //         homeController.selectedBeds.value,
//                 //       );
//                 //       Get.back();
//                 //     }
//                 //   },
//                 //   child: Text('Search'),
//                 // ),
//                 SizedBox(height: 16),
//                 Divider(
//                   thickness: 2,
//                   color: kSecondaryLight2,
//                 ),
//                 Obx(() {
//                   return ListView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: homeController.filteredApartments.length,
//                     itemBuilder: (context, index) {
//                       final apartment =
//                           homeController.filteredApartments[index];
//                       return ListTile(
//                         title: Text(apartment['address']),
//                         subtitle: Text('Price: \$${apartment['price']}'),
//                         trailing: Text(apartment['roomType']),
//                       );
//                     },
//                   );
//                 }),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:apartment_rentals/res/app_widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../view_models/controllers/home/home_view_model.dart';
import '../../res/app_widgets/app_bar.dart';
import '../../res/app_widgets/text.dart';
import '../../res/app_widgets/text_form_field.dart';
import '../../res/colors.dart';
import 'result_view.dart';

class SearchScreen extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Search',
        showBackButton: false,
      ),
      backgroundColor: kPrimary,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Input Fields
                MyField(
                  hintText: 'Search',
                  controller: searchController,
                  validatorText: '',
                  prefixIcon: Icon(Icons.search),
                  onChange: (value) {
                    homeController.searchApartments(
                      searchController.text,
                      minPriceController.text,
                      maxPriceController.text,
                      locationController.text,
                      homeController.selectedType.value,
                      homeController.selectedBeds.value,
                    );
                  },
                ),
                SizedBox(height: 16),
                AppText.bodyBold('Price Range'),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: MyField(
                        hintText: 'Minimum Price',
                        controller: minPriceController,
                        onChange: (value) {
                          homeController.searchApartments(
                            searchController.text,
                            minPriceController.text,
                            maxPriceController.text,
                            locationController.text,
                            homeController.selectedType.value,
                            homeController.selectedBeds.value,
                          );
                        },
                        validatorText: 'Please enter minimum price',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: AppText.body('- to -'),
                    ),
                    Expanded(
                      child: MyField(
                        hintText: 'Maximum Price',
                        controller: maxPriceController,
                        onChange: (value) {
                          homeController.searchApartments(
                            searchController.text,
                            minPriceController.text,
                            maxPriceController.text,
                            locationController.text,
                            homeController.selectedType.value,
                            homeController.selectedBeds.value,
                          );
                        },
                        validatorText: 'Please enter maximum price',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                AppText.bodyBold('Enter Location'),
                SizedBox(height: 10),
                MyField(
                  hintText: 'Location',
                  controller: locationController,
                  validatorText: 'Please enter location',
                  onChange: (value) {
                    homeController.searchApartments(
                      searchController.text,
                      minPriceController.text,
                      maxPriceController.text,
                      locationController.text,
                      homeController.selectedType.value,
                      homeController.selectedBeds.value,
                    );
                  },
                ),
                SizedBox(height: 16),

                // Apartment Type and Number of Beds (Unchanged)
                AppText.bodyBold('Select Type of Apartment'),
                SizedBox(height: 10),
                Obx(
                  () => SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: homeController.houseTypesSearch.map((type) {
                        final isSelected =
                            homeController.selectedType.value == type;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: ChoiceChip(
                            label: AppText.bodyBold(type),
                            selected: isSelected,
                            selectedColor: Colors.blue,
                            onSelected: (selected) {
                              homeController.selectedType.value =
                                  selected ? type : '';
                              homeController.searchApartments(
                                searchController.text,
                                minPriceController.text,
                                maxPriceController.text,
                                locationController.text,
                                homeController.selectedType.value,
                                homeController.selectedBeds.value,
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                AppText.bodyBold('Select Number of Beds'),
                SizedBox(height: 10),
                Obx(
                  () => Wrap(
                    spacing: 20,
                    children: List.generate(6, (index) {
                      final beds = index == 5 ? '6+' : '${index + 1}';
                      return ChoiceChip(
                        label: AppText.bodyBold(beds),
                        selected: homeController.selectedBeds.value == beds,
                        onSelected: (selected) {
                          homeController.selectedBeds.value =
                              selected ? beds : '';
                          homeController.searchApartments(
                            searchController.text,
                            minPriceController.text,
                            maxPriceController.text,
                            locationController.text,
                            homeController.selectedType.value,
                            homeController.selectedBeds.value,
                          );
                        },
                      );
                    }),
                  ),
                ),
                SizedBox(height: 30.h),

                // Search Button
                Center(
                  child: MyButton(
                      onTap: () {
                        // if (_formKey.currentState!.validate()) {
                        homeController.searchApartments(
                          searchController.text,
                          minPriceController.text,
                          maxPriceController.text,
                          locationController.text,
                          homeController.selectedType.value,
                          homeController.selectedBeds.value,
                        );
                        Get.to(() => SearchResultScreen(
                              apartments:
                                  homeController.filteredApartments.toList(),
                            ));
                        // }
                      },
                      text: 'Filter'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
