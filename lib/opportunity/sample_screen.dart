import 'package:flutter/material.dart';
import 'package:relatasapp/utils.dart';

class SampleScreen extends StatelessWidget {
  final Widget body;
  final Widget? title;

  const SampleScreen({Key? key, required this.body, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 0.0,
            vertical: 0.0,
          ),
          child: Container(
              height: (mediaQuery.size.height -
                  mediaQuery.padding.top),
              padding: const EdgeInsets.all(20.0),
              decoration: new BoxDecoration(
                color: parseColor("#f5f5f5")
            ),
            child:body
          ),
        ),
      ),
    );
  }
}