import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:new_walking/Controllers/authController.dart';
import 'package:new_walking/widgets/buttons.dart';

import '../datas.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorDatas.background,
      appBar: AppBar(),
      body: Padding(
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
                    AuthViewModel.to.isLoading.value ? "로딩중" : "안녕하세요,님",
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
            const BusStatusWidget(),
            const SizedBox(height: 12),
            Row(
              children: [
                Flexible(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: SizedBox(
                      width: 175,
                      height: 175,
                      child: MyAnimatedButton(

                        child: Text("버스 정보",
                          style: TextDatas.description,
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
                      ),
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
                      child: MyAnimatedButton(

                        child: Text("출석 노트",
                          style: TextDatas.description,
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
                      ),
                    ),
                  ),
                ),

              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 175,
              width: double.infinity,
              child: MyAnimatedButton(

                child: Text("모든 기능 보기",
                  style: TextDatas.description,
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
              ),
            )

          ],
        ),
      ),
    );

  }

//call when the page is closed

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
                // "소속 학생: ${BusDataController.to.sortedStudents.length}명",
                "fff",
                style: TextDatas.description.copyWith(
                  color: ColorDatas.onBackgroundSoft,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                // "소속 지도사: ${busStatus['leaders'].length}명",
                "fsdfsdf",
                style: TextDatas.description.copyWith(
                  color: ColorDatas.onBackgroundSoft,
                ),
              ),
              const SizedBox(height: 8),
              FutureBuilder(
                // future: getNameFromUID(busStatus['owner']),
                  future: Future.value("김지수"),
                  builder: (context, snapshot) {
                    return Text(
                      "담당자: ${snapshot.data}",
                      style: TextDatas.description.copyWith(
                        color: ColorDatas.onBackgroundSoft,
                      ),
                    );
                  }
              ),
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
                  // child: PrettyQrView.data(
                  //   data: BusDataController.to.selectedBusID.value!,
                  //   decoration: PrettyQrDecoration(
                  //     shape: PrettyQrSmoothSymbol(),
                  //   ),
                  // ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
