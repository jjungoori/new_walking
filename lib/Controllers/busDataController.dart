import 'package:get/get.dart';

class BusDataController extends GetxService {
  static BusDataController get to => Get.find();
  var busData = [].obs;
  // var busDataLength = 0.obs;

  void setBusData(List data) {
    busData.value = data;
    // busDataLength.value = data.length;
  }

  void addBusData(MyBusData data) {
    busData.add(data);
    // busDataLength.value = busData.length;
  }
}

class MyBusData {
  final String name;

  MyBusData({
    required this.name,
  });
}