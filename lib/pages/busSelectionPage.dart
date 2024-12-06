import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_walking/Controllers/authController.dart';
import 'package:new_walking/Controllers/busDataController.dart';
import 'package:new_walking/utils.dart';
import 'package:new_walking/widgets/animations.dart';
import 'package:new_walking/widgets/buttons.dart';
import 'package:new_walking/widgets/textFields.dart';

import '../datas.dart';

Future<void> initBusData() async {
  await UserDataController.to.checkIfNewUserAndInit();
  UserDataController.to.fetchBusesForLeader();
}

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

    initBusData();

    // busData 변경 감지 및 스크롤 동작 추가
    ever(UserDataController.to.expectedBusCount, (_) {
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
                var count = UserDataController.to.expectedBusCount.value;
                var busCount = UserDataController.to.buses.length;

                print(UserDataController.to.buses[0]);

                if(UserDataController.to.isLoading.value && count == 0){
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



class MyAnimatedBusButton extends StatelessWidget {
  String title;
  MyAnimatedBusButton({
    super.key,
    required this.title
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
            Row(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      width: constraints.maxWidth < 160 ? constraints.maxWidth : 160,
                      height: constraints.maxWidth < 160 ? constraints.maxWidth : 160,
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
                                          height: 70,
                                          child: MyAnimatedButton(
                                              onPressed: (){
                                                UserDataController.to.createBus(
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
                Expanded(child: SizedBox()),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      width: constraints.maxWidth < 160 ? constraints.maxWidth : 160,
                      height: constraints.maxWidth < 160 ? constraints.maxWidth : 160,
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
