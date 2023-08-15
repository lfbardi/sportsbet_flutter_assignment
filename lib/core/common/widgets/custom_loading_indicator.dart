import 'package:flutter/material.dart';
import 'package:sportsbet_flutter_assignment/core/design_system/kcolors.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: kPrimaryColorLight,
    );
  }
}
