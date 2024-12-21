import 'package:flutter/material.dart';

import 'datas.dart';

void myShowModalBottomSheet(BuildContext context, Widget child) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        final mediaQuery = MediaQuery.of(context);
        final keyboardHeight = mediaQuery.viewInsets.bottom;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: EdgeInsets.only(bottom: keyboardHeight),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              padding: DefaultDatas.modalPadding,
              decoration: BoxDecoration(
                color: ColorDatas.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: SingleChildScrollView(
                child: child,
              ),
            ),
          ),
        );
      }
  );
}