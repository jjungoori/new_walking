import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_walking/widgets/buttons.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              MyRootButton(root: "/home",),
              MyRootButton(root: "/widgets",),
              MyRootButton(root: "/splash",),
              MyRootButton(root: "/busSelection",),
              MyRootButton(root: "/login",),
            ],
          ),
        ),
      ),
    );
  }
}

