import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:new_walking/Controllers/authController.dart';
//
// class BusDataController extends GetxService {
//   static BusDataController get to => Get.find();
//   var busData = [].obs;
//   // var busDataLength = 0.obs;
//
//   void setBusData(List data) {
//     busData.value = data;
//     // busDataLength.value = data.length;
//   }
//
//   void addBusData(MyBusData data) {
//     busData.add(data);
//     // busDataLength.value = busData.length;
//   }
// }
//
// class MyBusData {
//   final String name;
//
//   MyBusData({
//     required this.name,
//   });
// }

class UserDataController extends GetxController {
  static UserDataController get to => Get.find();

  // Firebase Instances
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observables
  var buses = [].obs; // List of buses
  var selectedBus = {}.obs; // Selected bus details
  var isLoading = false.obs; // Loading indicator

  @override
  void onInit() {
    super.onInit();
    // fetchBusesForLeader(); // Fetch buses when the controller initializes
  }

  Future<void> checkIfNewUserAndInit() async {
    try {
      isLoading(true); // Start loading

      // Get the currently logged-in user's UID
      User? user = KakaoLoginController.to.user;
      if (user == null) {
        Get.snackbar("Error", "No logged-in user found");
        return;
      }
      String userUid = user.uid;

      // Check if the user already exists in the 'leaders' collection
      DocumentSnapshot leaderDoc = await _firestore.collection('leaders').doc(userUid).get();

      if (!leaderDoc.exists) {
        // New user, add leader information
        // You can call your addLeader() function or create a new leader document here
        addLeader(user.displayName ?? "Anonymous", user.email ?? "No email");
      } else {
        // Existing user
        // Get.snackbar("Welcome back", "User already exists!");
      }
    } catch (e) {
      Get.snackbar("Error-CheckNewUser", e.toString());
    } finally {
      isLoading(false); // Stop loading
    }
  }

  // Add a new leader
  Future<void> addLeader(String name, String email) async {
    try {
      isLoading(true); // Start loading

      // Get the currently logged-in user's UID
      User? user = KakaoLoginController.to.user;
      if (user == null) {
        Get.snackbar("Error", "No logged-in user found");
        return;
      }
      String leaderUid = user.uid;

      // Create a new leader document in the 'leaders' collection
      await _firestore.collection('leaders').doc(leaderUid).set({
        'name': name,
        'email': email,
        'buses': [],  // Initialize with an empty list of buses
      });

      // Get.snackbar("Success", "Leader added successfully!");
    } catch (e) {
      Get.snackbar("Error-AddLeader", e.toString());
    } finally {
      isLoading(false); // Stop loading
    }
  }

  Future<void> fetchBusesForLeader() async {
    try {
      isLoading(true); // Start loading

      // Get the currently logged-in user's UID
      User? user = KakaoLoginController.to.user;
      if (user == null) {
        Get.snackbar("Error", "No logged-in user found");
        return;
      }
      String leaderUid = user.uid;

      // Get the leader's document
      DocumentSnapshot leaderDoc = await _firestore.collection('leaders').doc(leaderUid).get();

      if (!leaderDoc.exists) {
        Get.snackbar("Error", "Leader not found");
        return;
      }

      // Extract bus IDs from the leader document
      List<dynamic> busIds = leaderDoc.get('buses') ?? [];

      // If there are no buses, return
      if (busIds.isEmpty) {
        // Get.snackbar("Info", "No buses found for this leader.");
        return;
      }

      // Fetch buses in chunks (Firestore has a limit of 10 IDs per query)
      const chunkSize = 10;
      List<Map<String, dynamic>> allBuses = [];

      // Break the busIds into chunks and fetch each chunk
      for (int i = 0; i < busIds.length; i += chunkSize) {
        List<dynamic> chunk = busIds.sublist(i, i + chunkSize > busIds.length ? busIds.length : i + chunkSize);

        QuerySnapshot busSnapshot = await _firestore
            .collection('buses')
            .where(FieldPath.documentId, whereIn: chunk)
            .get();

        allBuses.addAll(busSnapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList());
      }

      // Update the buses list with all the fetched buses
      buses.assignAll(allBuses);
    } catch (e) {
      Get.snackbar("Error-FetchBuses", e.toString());
    } finally {
      isLoading(false); // Stop loading
    }
  }


  // Select a specific bus and fetch its details
  Future<void> fetchBusDetails(String busId) async {
    try {
      isLoading(true); // Start loading

      // Query Firestore for the bus details
      DocumentSnapshot busDoc = await _firestore.collection('buses').doc(busId).get();
      if (!busDoc.exists) {
        Get.snackbar("Error", "Bus not found");
        return;
      }

      // Update the selected bus details
      selectedBus.assignAll(busDoc.data() as Map<String, dynamic>);
    } catch (e) {
      Get.snackbar("Error-fetchBusDetails", e.toString());
    } finally {
      isLoading(false); // Stop loading
    }
  }

  Future<void> addBus(String busId) async {
    try {
      isLoading(true); // Start loading

      // Get the currently logged-in user's UID
      User? user = KakaoLoginController.to.user;
      if (user == null) {
        Get.snackbar("Error", "No logged-in user found");
        return;
      }
      String leaderUid = user.uid;

      // Update the leader's buses field by adding the new bus ID
      DocumentReference leaderRef = _firestore.collection('leaders').doc(leaderUid);

      await leaderRef.update({
        'buses': FieldValue.arrayUnion([busId]),
      });

      // Fetch updated bus list
      fetchBusesForLeader();

      // Get.snackbar("Success", "Bus added successfully!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false); // Stop loading
    }
  }

  Future<void> createBus(String busName, String busDescription) async {
    try {
      isLoading(true); // Start loading

      // Get the currently logged-in user's UID
      User? user = KakaoLoginController.to.user;
      if (user == null) {
        Get.snackbar("Error", "No logged-in user found");
        return;
      }
      String leaderUid = user.uid;

      // Create a new bus document in Firestore
      DocumentReference newBusRef = await _firestore.collection('buses').add({
        'name': busName,
        'description': busDescription,
        'leaders': [leaderUid],
        'ownerId': leaderUid,
      });

      // Update the leader's buses field by adding the new bus ID
      DocumentReference leaderRef = _firestore.collection('leaders').doc(leaderUid);

      await leaderRef.update({
        'buses': FieldValue.arrayUnion([newBusRef.id]),
      });

      // Fetch updated bus list
      fetchBusesForLeader();

      // Get.snackbar("Success", "Bus added successfully!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false); // Stop loading
    }
  }
}
