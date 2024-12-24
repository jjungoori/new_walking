import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:new_walking/Controllers/authController.dart';

// TODO: asyncQueue 적용하기

class UserDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getLeader(String userUid) async {
    return await _firestore.collection('leaders').doc(userUid).get();
  }

  Future<void> addLeader(String leaderUid, String name, String email) async {
    await _firestore.collection('leaders').doc(leaderUid).set({
      'name': name,
      'email': email,
      'buses': [],  // Initialize with an empty list of buses
    });
  }

  Future<List<Map<String, dynamic>>> fetchBusesForLeader(String leaderUid) async {
    DocumentSnapshot leaderDoc = await _firestore.collection('leaders').doc(leaderUid).get();
    if (!leaderDoc.exists) {
      throw Exception("Leader not found");
    }

    List<dynamic> busesList = leaderDoc.get('buses') ?? [];
    busesList.sort((a, b) => (a['index'] as int).compareTo(b['index'] as int));

    List<Map<String, dynamic>> busDatas = [];
    for (var bus in busesList) {
      DocumentSnapshot busDoc = await _firestore.collection('buses').doc(bus['id']).get();
      if (busDoc.exists) {
        busDatas.add({
          'id': bus['id'],
          'data': busDoc.data(),
        });
      }
    }

    return busDatas;
  }

  Future<void> addBusToLeader(String leaderUid, String busId) async {
    DocumentReference leaderRef = _firestore.collection('leaders').doc(leaderUid);
    DocumentSnapshot leaderDoc = await leaderRef.get();
    List<dynamic> currentBuses = leaderDoc.get('buses') ?? [];
    int nextIndex = currentBuses.length;

    Map<String, dynamic> newBus = {
      'id': busId,
      'index': nextIndex,
    };

    await leaderRef.update({
      'buses': FieldValue.arrayUnion([newBus]),
    });
  }

  Future<String> createBus(String leaderUid, String busName, String busDescription) async {
    DocumentReference newBusRef = await _firestore.collection('buses').add({
      'name': busName,
      'description': busDescription,
      'leaders': [leaderUid],
      'ownerId': leaderUid,
    });
    return newBusRef.id;
  }

  Future<String> getLeaderName(String leaderUid) async {
    DocumentSnapshot leaderDoc = await _firestore.collection('leaders').doc(leaderUid).get();
    if (!leaderDoc.exists) {
      throw Exception("Leader not found");
    }
    return leaderDoc.get('name');
  }
}

class CurrentUserDataViewModel extends GetxController {
  static CurrentUserDataViewModel get to => Get.find();

  // Service Layer Instance
  final UserDataService _userDataService = Get.find<UserDataService>();

  // Observables
  var buses = [].obs;
  var selectedBus = {}.obs;
  var isLoading = false.obs;
  var expectedBusCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> checkIfNewUserAndInit() async {
    try {
      isLoading(true);
      User? user = AuthViewModel.to.currentUser.value;
      if (user == null) {
        Get.snackbar("Error", "No logged-in user found");
        return;
      }
      String userUid = user.uid;

      DocumentSnapshot leaderDoc = await _userDataService.getLeader(userUid);
      if (!leaderDoc.exists) {
        addLeader(user.displayName ?? "Anonymous", user.email ?? "No email");
      }
    } catch (e) {
      Get.snackbar("Error-CheckNewUser", e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> addLeader(String name, String email) async {
    try {
      isLoading(true);
      User? user = AuthViewModel.to.currentUser.value;
      if (user == null) {
        Get.snackbar("Error", "No logged-in user found");
        return;
      }
      String leaderUid = user.uid;

      await _userDataService.addLeader(leaderUid, name, email);
    } catch (e) {
      Get.snackbar("Error-AddLeader", e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchBusesForLeader() async {
    try {
      isLoading(true);
      expectedBusCount.value = buses.length + 1;

      User? user = AuthViewModel.to.currentUser.value;
      if (user == null) {
        Get.snackbar("Error", "No logged-in user found");
        return;
      }
      String leaderUid = user.uid;

      var busDatas = await _userDataService.fetchBusesForLeader(leaderUid);
      buses.assignAll(busDatas);
      expectedBusCount.value = buses.length;
    } catch (e) {
      Get.snackbar("Error-FetchBuses", e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> addBus(String busId) async {
    try {
      isLoading(true);
      User? user = AuthViewModel.to.currentUser.value;
      if (user == null) {
        Get.snackbar("Error", "No logged-in user found");
        return;
      }
      String leaderUid = user.uid;

      await _userDataService.addBusToLeader(leaderUid, busId);
      fetchBusesForLeader();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> createBus(String busName, String busDescription) async {
    try {
      isLoading(true);
      User? user = AuthViewModel.to.currentUser.value;
      if (user == null) {
        Get.snackbar("Error", "No logged-in user found");
        return;
      }
      String leaderUid = user.uid;

      String busId = await _userDataService.createBus(leaderUid, busName, busDescription);
      addBus(busId);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}

class CommonUserDataViewModel extends GetxController {
  static CommonUserDataViewModel get to => Get.find();

  // Service Layer Instance
  final UserDataService _userDataService = Get.find<UserDataService>();

  // Observables
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<String> getLeaderName(String leaderUid) async {
    try {
      isLoading(true);
      return await _userDataService.getLeaderName(leaderUid);
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return "";
    } finally {
      isLoading(false);
    }
  }
}