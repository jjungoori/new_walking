import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:new_walking/Controllers/authController.dart';
import 'package:new_walking/Controllers/busDataController.dart';
import 'package:new_walking/widgets/animations.dart';
import 'package:new_walking/widgets/buttons.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:shimmer/shimmer.dart';

import '../datas.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var minimumLoadingTimeDone = false.obs;

  @override
  void initState(){
    super.initState();
    Future.delayed(Duration(milliseconds: 300), (){
      minimumLoadingTimeDone.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorDatas.background,
      appBar: AppBar(),
      body: Obx((){
        if(BusDataViewModel.to.isLoading.value || !minimumLoadingTimeDone.value){
          return HomePageShimmer();
        }
        else{
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Obx(() => Text(
                        "${BusDataViewModel.to.processedBusData.value.busName}",
                        style: TextDatas.title.copyWith(
                            color: ColorDatas.secondary,
                            fontWeight: FontWeight.w700,
                            fontSize: 40
                        ),
                      )),
                      Padding(
                        child: Text(
                          "선택됨",
                          style: TextDatas.description.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        padding: const EdgeInsets.only(left: 8, bottom: 6),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                MyOpacityRisingWidget(startTime: 0, child: BusStatusWidget()),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Flexible(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: SizedBox(
                          width: 175,
                          height: 175,
                          child: MyOpacityRisingWidget(child: MyAnimatedButton(

                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                              child: Text("버스 정보",
                                style: TextDatas.homeButton,
                              ),
                            ),

                            onPressed: (){},
                            color: ColorDatas.background,
                            shadows: [
                              BoxShadow(
                                color: ColorDatas.shadow,
                                offset: const Offset(0, 4),
                                blurRadius: 16,
                              ),
                            ],
                          ), startTime: 100),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: SizedBox(
                          width: 175,
                          height: 175,
                          child: MyOpacityRisingWidget(child: MyAnimatedButton(

                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                              child: Text("출석 노트",
                                style: TextDatas.homeButton,
                              ),
                            ),

                            onPressed: (){},
                            color: ColorDatas.background,
                            shadows: [
                              BoxShadow(
                                color: ColorDatas.shadow,
                                offset: const Offset(0, 4),
                                blurRadius: 16,
                              ),
                            ],
                          ), startTime: 200)
                        ),
                      ),
                    ),

                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 175,
                  width: double.infinity,
                  child: MyOpacityRisingWidget(child: MyAnimatedButton(

                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                      child: Text("모든 기능 보기",
                        style: TextDatas.homeButton,
                      ),
                    ),

                    onPressed: (){},
                    color: ColorDatas.background,
                    shadows: [
                      BoxShadow(
                        color: ColorDatas.shadow,
                        offset: const Offset(0, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ), startTime: 300)
                )

              ],
            ),
          );
        }
      })
    );

  }
}

class BusStatusDatas{
  final String ownerName;
  final int studentCount;
  final int teacherCount;
  final int waitingTime;

  BusStatusDatas({
    required this.ownerName,
    required this.studentCount,
    required this.teacherCount,
    required this.waitingTime,
  });
}
//
// Stream<BusStatusDatas> getBusStatusStream() async* {
//   while (true) {
//     yield await getBusStatusDatas();
//     await Future.delayed(const Duration(seconds: 10));
//   }
// }
//
// Future<BusStatusDatas> getBusStatusDatas() async {
//   return BusStatusDatas(
//     ownerName: await getNameFromUID(BusDataController.to.owner.value),
//     studentCount: BusDataController.to.students.length,
//     teacherCount: BusDataController.to.leaders.length,
//     waitingTime: 10,
//   );
// }

class BusStatusWidget extends StatelessWidget {
  const BusStatusWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      height: 175,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorDatas.shadow,
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "개요",
                style: TextDatas.subtitle.copyWith(
                  color: ColorDatas.onBackgroundSoft,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "소속 학생: ${BusDataViewModel.to.processedBusData.value.studentCount}명",
                style: TextDatas.description.copyWith(
                  color: ColorDatas.onBackgroundSoft,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "소속 지도사: ${BusDataViewModel.to.processedBusData.value.leaderCount}명",
                style: TextDatas.description.copyWith(
                  color: ColorDatas.onBackgroundSoft,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "담당자: ${BusDataViewModel.to.processedBusData.value!.leaderName}",
                style: TextDatas.description.copyWith(
                  color: ColorDatas.onBackgroundSoft,
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: 30,
                  width: 120,
                  decoration: BoxDecoration(
                    color: ColorDatas.secondary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      '지도사 QR 코드',
                      // "대기시간: ${busStatus['waitingTime']}",
                      style: TextDatas.description.copyWith(
                        color: ColorDatas.onPrimaryTitle,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 80,
                  width: 80,
                  child: PrettyQrView.data(
                    data: BusDataViewModel.to.targetBusId,
                    decoration: PrettyQrDecoration(
                      shape: PrettyQrSmoothSymbol(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomePageShimmer extends StatelessWidget {
  const HomePageShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 150,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 60,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 175,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Flexible(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 175,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}