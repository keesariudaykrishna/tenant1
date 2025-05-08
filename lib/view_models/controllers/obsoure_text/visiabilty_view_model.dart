import 'package:get/get.dart';

class VisiablilityController extends GetxController {
  final RxBool _visiablility = false.obs; //! Initialize visibility as false

  bool get visiablility =>
      _visiablility.value; //! Get the current visibility status

  void setVisiablility(bool visiablility) {
    _visiablility.value = visiablility;
  }
}
