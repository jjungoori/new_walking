import 'package:flutter/material.dart';

import '../datas.dart';
import 'buttons.dart';

class MyAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  MyAlertDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorDatas.background,
      shape: RoundedRectangleBorder(borderRadius: DefaultDatas.borderRadius),
      child: Padding(
        padding: DefaultDatas.modalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: DefaultDatas.noRoundPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextDatas.title,
                  ),
                  SizedBox(height: 16),
                  Text(
                    content,
                    style: TextDatas.description,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: MyAnimatedButton(
                    onPressed: onCancel,
                    color: ColorDatas.backgroundSoft,
                    child: Center(
                      child: Text(
                        "취소",
                        style: TextStyle(
                          color: ColorDatas.onBackgroundSoft,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: MyAnimatedButton(
                    onPressed: onConfirm,
                    color: ColorDatas.secondary,
                    child: Center(
                      child: Text(
                        "확인",
                        style: TextStyle(
                          color: ColorDatas.onPrimaryTitle,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
