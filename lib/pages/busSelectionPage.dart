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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                  child: Text(
                    '버스 선택하기',
                    style: TextDatas.title.copyWith(
                      fontSize: 32,
                    )
                  ),
                ),
              ),
              SizedBox(height: 24),
              Obx(
                ()
                {
                  var count = BusDataController.to.busData.length;
                  return Expanded(
                      child: ListView.builder(
                        // clipBehavior: Clip.hardEdge,
                          itemCount: count + 1,
                          itemBuilder: (context, index) {
                            if (index < count) {
                              return MyAnimatedBusButton(
                                title: BusDataController.to.busData[index].name,
                              );
                            }
                            return MyAnimatedAddButton(
                              only: count == 0,
                            );
                          }
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
