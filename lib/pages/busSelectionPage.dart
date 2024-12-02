import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  void initState() {
    super.initState();

    // busData 변경 감지 및 스크롤 동작 추가
    ever(BusDataController.to.busData, (_) {
      if (_scrollController.hasClients) {
        Future.delayed(Duration(milliseconds: 50), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
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
      appBar: DefaultDatas.appBar,
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
                var count = BusDataController.to.busData.length;
                return Expanded(
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
                            title: BusDataController.to.busData[index].name,
                          ),
                          startTime: isDisplayed ? 0 : index*50,
                        );
                      }
                      return MyOpacityRisingWidget(
                        child: MyAnimatedAddButton(
                          only: count == 0,
                        ),
                        startTime: 100,
                      );
                    },
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
