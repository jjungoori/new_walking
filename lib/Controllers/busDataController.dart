import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:new_walking/Controllers/userDataController.dart';
import 'package:new_walking/modules/asyncQueue.dart';

// asyncQueue 적용 완료

// 실제 로직에 사용되는 변수와 그렇지 않은 변수가 섞여 있어서 Service와 ViewModel을 분리
// Service는 실제 로직을 담당하고, ViewModel은 UI또는 반환에 필요한 변수와 함수를 제공

// 추가적으로
// Service에서는 화면에 관계 없이 공통되는 데이터만을 저장함.
// 데이터를 저장할 수 있다는 걸 알아둬야함.

class StudentData {
  final String name;
  final String busId;

  StudentData({
    required this.name,
    required this.busId,
  });
}

class BusDataService extends GetxService {
  static BusDataService get to => Get.find();

  var targetBusId = ''.obs;
  Rxn<Map<String, dynamic>> busData = Rxn<Map<String, dynamic>>();

  void setTargetBusId(String busId){
    targetBusId.value = busId;
  }

  Future<void> fetchBusData() async {
    try {
      // Firestore 경로: buses
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await FirebaseFirestore.instance
          .collection('buses')
          .doc(targetBusId.value) // 특정 documentID로 접근
          .get();

      if (docSnapshot.exists) {
        busData.value = docSnapshot.data();
        print("Bus data fetched successfully for document ID: ${targetBusId.value}");
        print(busData);
      } else {
        print("No bus found with document ID: ${targetBusId.value}");
      }
    } catch (e) {
      print("Error fetching bus data for document ID ${targetBusId.value}: $e");
    }
  }


  /// 학생 데이터를 Firestore에 추가하는 함수
  Future<void> addStudent(StudentData data) async {
    if (targetBusId.value.isEmpty) {
      print("targetBusId is not set");
      return;
    }

    try {
      // Firestore 경로: buses/{targetBusId}/students/{generatedId}
      await FirebaseFirestore.instance
          .collection('buses')
          .doc(targetBusId.value)
          .collection('students')
          .add({
        'name': data.name,
        'busId': data.busId,
      });

      print("Student added successfully");
    } catch (e) {
      print("Error adding student: $e");
    }
  }
}

class ProcessedBusData {
  // 가공되지 않고 바로 사용되는 데이터
  var busName = '';
  var leaderName = '';
  var leaders = [];
  var description = '';

  // 가공이 필요한 데이터
  var leaderCount = 0;
  var studentCount = 0;
  var ownerId = '';

  ProcessedBusData(busName, leaderName, leaders, description, leaderCount, studentCount, ownerId){
    this.busName = busName;
    this.leaderName = leaderName;
    this.leaders = leaders;
    this.description = description;
    this.leaderCount = leaderCount;
    this.studentCount = studentCount;
    this.ownerId = ownerId;
  }
}

class BusDataViewModel extends GetxController {
  static BusDataViewModel get to => Get.find();
  final BusDataService _busDataService = Get.find();
  get targetBusId => _busDataService.targetBusId.value;

  final AsyncTaskQueue _asyncTaskQueue = AsyncTaskQueue();
  RxBool get isLoading => _asyncTaskQueue.hasTasks;

  Rxn<Map<String, dynamic>> busData = Rxn<Map<String, dynamic>>();

  Rx<ProcessedBusData> processedBusData = ProcessedBusData('Error', '', [], '', 0, 0, '').obs;

  @override
  void onInit() {
    super.onInit();
    // fetchBusesForLeader(); // Fetch buses when the controller initializes
  }

  Future<void> processBusData() async {
    _asyncTaskQueue.executeTask(() async{
      if (busData.value == null) {
        print("Bus data is null");
        return;
      }



      var leaderCount = (busData.value!['leaders'] ?? []).length;
      var studentCount = (busData.value!['students'] ?? []).length;
      var ownerName = await CommonUserDataViewModel.to.getLeaderName(busData.value!['ownerId']);

      processedBusData.value = ProcessedBusData(
        busData.value!['name'],
        ownerName,
        busData.value!['leaders'],
        busData.value!['description'],
        leaderCount,
        studentCount,
        busData.value!['ownerId'],
      );


      print("Processing bus data...");
    });
  }

  Future<void> setTargetBusId(String busId) async {
    _busDataService.setTargetBusId(busId);
    await fetchBusData();
    return;
  }

  Future<void> fetchBusData() async {
    _asyncTaskQueue.executeTask(() async{
      await _busDataService.fetchBusData();
      busData.value = _busDataService.busData.value;
      await processBusData();
    });
  }


  Future<void> addStudent(StudentData studentData) async {
    _asyncTaskQueue.executeTask(() async{
      try {
        await _busDataService.addStudent(studentData);
        print("Student added via ViewModel successfully");
      } catch (e) {
        print("Error adding student via ViewModel: $e");
      }

    });
  }
}
