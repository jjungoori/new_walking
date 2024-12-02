import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

class KakaoLoginController extends GetxController {
  static KakaoLoginController get to => Get.find();

  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus(); // 앱 실행 시 로그인 상태 확인
  }

  Future<void> _checkLoginStatus() async {
    print("로그인 상태 확인 중...");
    isLoading.value = true; // 로딩 상태 활성화

    try {
      // Firebase 사용자 확인
      final user = auth.FirebaseAuth.instance.currentUser;

      if (user != null) {
        print("로그인된 사용자: ${user.email ?? user.displayName}");
        isLoggedIn.value = true;
        Get.offAllNamed('/home'); // 홈 화면으로 이동
      } else {
        isLoggedIn.value = false;
      }
    } catch (error) {
      print("로그인 상태 확인 오류: $error");
      isLoggedIn.value = false;
    } finally {
      isLoading.value = false; // 로딩 상태 비활성화
    }
  }

  Future<void> loginWithKakao() async {
    print("카카오 로그인 시도");
    try {
      isLoading.value = true; // 로딩 상태 활성화

      // 카카오 로그인
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();

      // Firebase OAuthProvider를 통해 인증
      var provider = auth.OAuthProvider('oidc.kakao');
      var credential = provider.credential(
        idToken: token.idToken, // OpenID Connect 활성화 필요
        accessToken: token.accessToken,
      );

      // Firebase에 사용자 로그인
      await auth.FirebaseAuth.instance.signInWithCredential(credential);

      // 로그인 성공 시 홈 화면으로 이동
      Get.offAllNamed('/home');
    } catch (error) {
      // 에러 처리
      print(error);
      Get.snackbar(
        '로그인 실패',
        '카카오 계정으로 로그인 중 문제가 발생했습니다: $error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false; // 로딩 상태 비활성화
    }
  }
}
