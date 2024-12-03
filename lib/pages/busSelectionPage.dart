import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_walking/Controllers/authController.dart';
import 'package:new_walking/Controllers/busDataController.dart';
import 'package:new_walking/widgets/animations.dart';
import 'package:new_walking/widgets/buttons.dart';

import '../datas.dart';

class BusSelectionPage extends StatefulWidget {
  const BusSelectionPage({super.key});

  @override
  State<BusSelectionPage> createState() => _BusSelectionPageState();
}
class _BusSelectionPageState extends State<BusSelectionPage> {
  final ScrollController _scrollController = ScrollController();
  final Set<int> _alreadyDisplayed = {}; // 이미 표시된 항목의 인덱스를 추적
  int previousBusCount = 0;

  @override
  void initState() {
    super.initState();
    UserDataController.to.fetchBusesForLeader();

    // busData 변경 감지 및 스크롤 동작 추가
    ever(UserDataController.to.buses, (_) {
      if (_scrollController.hasClients && previousBusCount != 0) {
        Future.delayed(Duration(milliseconds: 50), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCirc,
          );
        });
      }
      previousBusCount = UserDataController.to.buses.length;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              KakaoLoginController.to.logout();
              // Get.offAllNamed('/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: DefaultDatas.pagePadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyOpacityRisingWidget(
                startTime: 300,
                child: Padding(
                  padding: DefaultDatas.noRoundPadding,
                  child: Text('버스 선택하기', style: TextDatas.title),
                ),
              ),
              SizedBox(height: 24),
              Obx(() {
                var count = UserDataController.to.buses.length;
                return Expanded(
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),
                    child: ListView.builder(
                      controller: _scrollController, // ScrollController 연결
                      itemCount: count + 1,
                      itemBuilder: (context, index) {
                        if (index < count) {
                          // 애니메이션이 이미 실행되었는지 확인
                          final isDisplayed = _alreadyDisplayed.contains(index);
                          if (!isDisplayed) {
                            _alreadyDisplayed.add(index);
                          }
                          return MyOpacityRisingWidget(
                            child: MyAnimatedBusButton(
                              title: UserDataController.to.buses[index]["name"],
                            ),
                            startTime: 30,
                          );
                          // return MyOpacityRisingWidget(
                          //   child: MyAnimatedBusButton(
                          //     title: BusDataController.to.buses[index]["name"],
                          //   ),
                          //   startTime: isDisplayed ? 0 : index*50,
                          // );
                        }
                        return MyOpacityRisingWidget(
                          child: MyAnimatedAddButton(
                            only: count == 0,
                          ),
                          startTime: 100,
                        );
                      },
                    ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
