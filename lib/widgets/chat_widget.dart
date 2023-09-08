import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:nixieappflutter/widgets/text_widget.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.chatIndex, required this.msg});
  final String msg;
  final int chatIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: chatIndex == 0 ? Colors.white : Colors.white70,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(4)),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    chatIndex == 0
                        ? const Icon(
                            Icons.person,
                            color: Colors.deepPurple,
                            size: 30,
                          )
                        : const Icon(
                            Icons.android,
                            color: Colors.black,
                            size: 30,
                          ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: chatIndex == 0
                          ? TextWidget(label: msg)
                          : AnimatedTextKit(
                              isRepeatingAnimation: false,
                              repeatForever: false,
                              displayFullTextOnTap: true,
                              totalRepeatCount: 1,
                              animatedTexts: [
                                TyperAnimatedText(
                                  msg.trim(),
                                ),
                              ],
                            ),
                    ),
                    chatIndex == 0
                        ? const SizedBox.shrink()
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.thumb_up_alt_outlined,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.thumb_down_alt_outlined,
                                color: Colors.black,
                              ),
                            ],
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
