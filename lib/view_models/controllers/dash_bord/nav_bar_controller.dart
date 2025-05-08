import 'package:get/get.dart';

// class TabIndexController extends GetxController {
//   final RxInt _tabIndex = 0.obs; //! Initialize the tab index as 0

//   int get tabIndex => _tabIndex.value; //! Get the current tab index

//   set setTabIndex(int newValue) {
//     _tabIndex.value = newValue; //! Update the tab index with a new value
//   }
// }

// class BackButtonController extends GetxController {
//   Rx<DateTime?> currentBackPressTime = Rx<DateTime?>(null);

//   // Check if the back button is pressed for the second time within 2 seconds
//   Future<bool> onBackPressed(int selectedIndex) async {
//     if (selectedIndex == 0) {
//       // Home tab
//       final currentTime = DateTime.now();
//       final isFirstClick = currentBackPressTime.value == null ||
//           currentTime.difference(currentBackPressTime.value!) >
//               Duration(seconds: 2);

//       if (isFirstClick) {
//         // Update the current time of the first press
//         currentBackPressTime.value = currentTime;
//         return false; // Do not close yet, show the snackbar
//       } else {
//         // Close the app on the second press
//         return true; // Close the app
//       }
//     } else {
//       return false; // Not on the home tab, switch to home tab
//     }
//   }
// }

class TabIndexController extends GetxController {
  final RxInt _tabIndex = 0.obs;

  int get tabIndex => _tabIndex.value;

  set setTabIndex(int newValue) {
    _tabIndex.value = newValue;
  }
}

class BackButtonController extends GetxController {
  Rx<DateTime?> lastPressedTime = Rx<DateTime?>(null);

  Future<bool> handleBackPress() async {
    final currentTime = DateTime.now();
    if (lastPressedTime.value == null ||
        currentTime.difference(lastPressedTime.value!) > Duration(seconds: 2)) {
      lastPressedTime.value = currentTime; // Record the first press time
      return false; // Do not close app yet
    } else {
      return true; // Close the app on second press
    }
  }
}
