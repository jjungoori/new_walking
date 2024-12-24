import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// TODO: asyncQueue 적용하기

// 실제 로직에 사용되는 변수와 그렇지 않은 변수가 섞여 있어서 Service와 ViewModel을 분리
// Service는 실제 로직을 담당하고, ViewModel은 UI또는 반환에 필요한 변수와 함수를 제공

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<void> loginWithKakao() async {
    kakao.OAuthToken token = await kakao.UserApi.instance.loginWithKakaoAccount();
    var provider = OAuthProvider('oidc.kakao');
    var credential = provider.credential(
      idToken: token.idToken,
      accessToken: token.accessToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await kakao.UserApi.instance.logout();
  }
}

class AuthViewModel extends GetxController {
  static AuthViewModel get to => Get.find();

  final AuthService _authService = Get.find();  // AuthService 의존성 주입

  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final Rx<User?> currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    isLoading.value = true;
    try {
      currentUser.value = await _authService.getCurrentUser();
      isLoggedIn.value = currentUser.value != null;
    } catch (e) {
      print("로그인 상태 확인 오류: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithKakao() async {
    try {
      isLoading.value = true;
      await _authService.loginWithKakao();
      _checkLoginStatus();
    } catch (e) {
      print("로그인 실패: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> logout() async {
    var success = false;
    try {
      isLoading.value = true;
      await _authService.logout();
      currentUser.value = null;
      isLoggedIn.value = false;
      success = true;
    } catch (e) {
      print("로그아웃 실패: $e");
    } finally {
      isLoading.value = false;
      return success;
    }
  }
}
