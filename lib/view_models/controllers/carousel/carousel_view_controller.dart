import 'package:get/get.dart';

class CarouselControllers extends GetxController {
  // Observable variable to track the current index
  var currentIndex = 0.obs;

  // Function to update the current index
  void updateIndex(int index) {
    currentIndex.value = index;
  }
}
