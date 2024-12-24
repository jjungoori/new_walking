import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_walking/Controllers/authController.dart';
import 'package:new_walking/Controllers/userDataController.dart';
import 'package:new_walking/utils.dart';
import 'package:new_walking/widgets/alerts.dart';
import 'package:new_walking/widgets/animations.dart';
import 'package:new_walking/widgets/buttons.dart';
import 'package:new_walking/widgets/textFields.dart';

import '../Controllers/busDataController.dart';
import '../datas.dart';

Future<void> initBusData() async {
  await CurrentUserDataViewModel.to.checkIfNewUserAndInit();
  CurrentUserDataViewModel.to.fetchBusesForLeader();
}

class BusSelectionPage extends StatefulWidget {
  const BusSelectionPage({super.key});

  @override
  State<BusSelectionPage> createState() => _BusSelectionPageState();
}
class _BusSelectionPageState extends State<BusSelectionPage> {
  final ScrollController _scrollController = ScrollController();
  // final Set<int> _alreadyDisplayed = {}; // 이미 표시된 항목의 인덱스를 추적
  int previousBusCount = 0;
  var busesCanLoad = false.obs;

  @override
  void initState() {
    super.initState();

    initBusData();

    // busData 변경 감지 및 스크롤 동작 추가
    ever(CurrentUserDataViewModel.to.expectedBusCount, (_) {
      if (_scrollController.hasClients && previousBusCount != 0) {
        Future.delayed(Duration(milliseconds: 50), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCirc,
          );
        });
      }
      previousBusCount = CurrentUserDataViewModel.to.buses.length;
    });

    Future.delayed(Duration(milliseconds: 200), (){
      busesCanLoad.value = true;
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
            onPressed: () async {
              showDialog(context: context, builder: (_){
                return MyAlertDialog(
                    title: "로그아웃",
                    content: "정말 로그아웃 하시겠습니까?",
                    onConfirm: () async{
                      if(await AuthViewModel.to.logout()){
                        Get.offAllNamed("/login");
                      }
                    },
                    onCancel: (){
                      Navigator.pop(context);
                    }
                );
              });
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
                var count = CurrentUserDataViewModel.to.expectedBusCount.value;
                var busCount = CurrentUserDataViewModel.to.buses.length;

                // print(UserDataController.to.buses[0]);

                if((CurrentUserDataViewModel.to.isLoading.value && count == 0) || !busesCanLoad.value){
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: ColorDatas.primary,

                      ),
                    ),
                  );
                }
                return Expanded(
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),
                    child: ListView.builder(
                      controller: _scrollController, // ScrollController 연결
                      itemCount: count + 1,
                      itemBuilder: (context, index) {
                        if (index < count) {
                          if(index > busCount-1){
                            return MyOpacityRisingWidget(
                              child: MyAnimatedBusLoadingButton(),
                              startTime: 30,
                            );
                          }
                          // 애니메이션이 이미 실행되었는지 확인
                          // final isDisplayed = _alreadyDisplayed.contains(index);
                          // if (!isDisplayed) {
                          //   _alreadyDisplayed.add(index);
                          // }
                          return MyOpacityRisingWidget(
                            startTime: 30,
                            child: MyAnimatedBusButton(
                              title: CurrentUserDataViewModel.to.buses[index]["data"]["name"],
                              onPressed: (){
                                BusDataViewModel.to.setTargetBusId(
                                    CurrentUserDataViewModel.to.buses[index]['id']
                                );
                                Get.toNamed("/home");
                                // Get.toNamed("/home");
                              },
                            ),
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



class MyAnimatedBusButton extends StatelessWidget {
  String title;
  final Function onPressed;
  MyAnimatedBusButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: MyAnimatedButton(
        onPressed: (){
          onPressed();
        },
        child: Padding(
          padding: DefaultDatas.buttonPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(
              //   child: Image.asset("assets/images/plusIcon.png"),
              //   width: 24,
              //   height: 24,
              // ),
              // SizedBox(width: 18,),
              Text(title,
                  style: TextDatas.description.copyWith(
                    color: ColorDatas.onPrimaryTitle,
                  )
              )
            ],
          ),
        ),
        color: Colors.white,
        gradient: LinearGradient(
            colors: [
              ColorDatas.primary,
              ColorDatas.secondary
            ],
            end: Alignment.topLeft,
            begin: Alignment.bottomRight
        ),
      ),
    );
  }
}


class MyAnimatedBusLoadingButton extends StatelessWidget {
  MyAnimatedBusLoadingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: MyAnimatedButton(
        onPressed: (){},
        child: Padding(
          padding: DefaultDatas.buttonPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(
              //   child: Image.asset("assets/images/plusIcon.png"),
              //   width: 24,
              //   height: 24,
              // ),
              // SizedBox(width: 18,),
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: ColorDatas.primary,
                ),
              ),
            ],
          ),
        ),
        color: Colors.white,
        gradient: LinearGradient(
            colors: [
              ColorDatas.primary,
              ColorDatas.secondary
            ],
            end: Alignment.topLeft,
            begin: Alignment.bottomRight
        ),
      ),
    );
  }
}

class MyAnimatedAddButton extends StatelessWidget {

  final bool only;

  MyAnimatedAddButton({
    super.key,
    this.only = false
  });

  final minSize = 140.0;

  @override
  Widget build(BuildContext context) {
    return MyAnimatedButton(
      onPressed: (){
        // Get.bottomSheet(
        //
        // );
        myShowModalBottomSheet(context, Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text("버스 추가하기",
            //   style: TextDatas.title,
            // ),
            // SizedBox(height: 22,),
            AspectRatio(
              aspectRatio: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: max(constraints.maxHeight*0.7, minSize),
                        // height: constraints.maxWidth < minSize ? constraints.maxWidth : minSize,
                        child: AspectRatio(
                            aspectRatio: 1, // 1:1 비율 유지
                            child: MyAnimatedSquareButton(
                              color: ColorDatas.background,
                              shadows: [
                                BoxShadow(
                                  color: ColorDatas.shadow,
                                  offset: Offset(0, 0),
                                  blurRadius: 16,
                                )
                              ],
                              title: Text("내가 만들기",
                                  style: TextDatas.subtitle
                              ),
                              description: SizedBox(),
                              onPressed: (){
                                // UserDataController.to.createBus("busName", "busDescription");
                                Navigator.pop(context);
                                myShowModalBottomSheet(context,
                                  Builder(
                                    builder: (context) {
                                      TextEditingController busNameController = TextEditingController();
                                      TextEditingController busDescriptionController = TextEditingController();
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          MyTextField(
                                            hintText: "버스 이름",
                                            controller: busNameController,
                                          ),
                                          SizedBox(height: 8,),
                                          MyTextField(
                                            hintText: "버스 설명",
                                            controller: busDescriptionController,
                                          ),
                                          SizedBox(height: 16,),
                                          SizedBox(
                                            width: double.infinity,
                                            height: 60,
                                            child: MyAnimatedButton(
                                                onPressed: (){
                                                  CurrentUserDataViewModel.to.createBus(
                                                    busNameController.text,
                                                    busDescriptionController.text
                                                  );
                                                  Navigator.pop(context);
                                                },
                                                child: Center(
                                                  child: Text("버스 만들기!",
                                                    style: TextDatas.description.copyWith(
                                                      color: ColorDatas.onPrimaryTitle,
                                                    ),
                                                  ),
                                                ),
                                                color: ColorDatas.secondary,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  )
                                );
                              },
                            )
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 8,),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: max(constraints.maxHeight*0.7, minSize),
                        child: AspectRatio(
                            aspectRatio: 1, // 1:1 비율 유지
                            child: MyAnimatedSquareButton(
                              color: ColorDatas.background,
                              shadows: [
                                BoxShadow(
                                  color: ColorDatas.shadow,
                                  offset: Offset(0, 0),
                                  blurRadius: 16,
                                )
                              ],
                              title: Text("참여하기",
                                style: TextDatas.subtitle,
                              ),
                              description: SizedBox(),
                              onPressed: (){},
                            )
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),);
        // BusDataController.to.addBusData(MyBusData(name: "Capybara"));
      },
      child: Padding(
        padding: DefaultDatas.buttonPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Image.asset("assets/images/plusIcon.png",
                color: only ? ColorDatas.onPrimaryTitle : ColorDatas.onBackgroundSoft,
              ),
              width: 24,
              height: 24,
            ),
            SizedBox(width: 18,),
            Text("버스 추가하기",
                style: TextDatas.description.copyWith(
                  color: only ? ColorDatas.onPrimaryTitle : ColorDatas.onBackgroundSoft,
                )
            )
          ],
        ),
      ),
      color: only ? ColorDatas.secondary : Colors.transparent,
    );
  }
}
