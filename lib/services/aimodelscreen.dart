import 'package:flutter/material.dart';
import 'package:nixieappflutter/widgets/dropdown.dart';
import 'package:nixieappflutter/widgets/text_widget.dart';

class AiModel {
  static Future<void> showModalSheet({required BuildContext context}) async {
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return const Padding(
            padding: EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: TextWidget(
                    label: "Chosen Model",
                    fontSize: 15,
                  ),
                ),
                Flexible(flex: 2, child: DropDown())
              ],
            ),
          );
        });
  }
}
