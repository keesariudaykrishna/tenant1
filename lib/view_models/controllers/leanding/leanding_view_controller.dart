import 'package:get/get.dart';

class LandingPageController extends GetxController {
  // Observable variable to track the current tab index
  var currentTabIndex = 0.obs; //! Initialize currentTabIndex as 0

  // Function to move to the next tab
  void nextTab() {
    if (currentTabIndex < 2) {
      //! Check if the current tab index is less than 2
      currentTabIndex++; //! Move to the next tab
    }
  }

  // Function to skip to the last tab
  void skipToPrevious() {
    if (currentTabIndex > 0) {
      //! Check if the current tab index is greater than 0
      currentTabIndex--; //! Move to the previous tab
    }
  }
}
