import 'package:flutter/material.dart';

import 'skee_button.dart';
import 'skee_text.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback ontap;
  const CustomErrorWidget({
    super.key,
    required this.errorMessage,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SkeeText.title(
          errorMessage,
          color: Colors.white,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        SkeeButton.text(
          "Try again",
          fontsize: 14,
          ontap: ontap,
        )
      ],
    );
  }
}
