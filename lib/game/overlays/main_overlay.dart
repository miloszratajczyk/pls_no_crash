import 'package:flutter/material.dart';
import 'package:pls_no_crash/game/widgets/default_animated_switcher.dart';

class MainOverlay extends StatelessWidget {
  const MainOverlay({
    required this.hardMode,
    required this.colorScheme,
    required this.onPausePressed,
    required this.onHardModePressed,
    Key? key,
  }) : super(key: key);

  final bool hardMode;
  final ColorScheme colorScheme;
  final Function() onPausePressed;
  final Function() onHardModePressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onPausePressed,
                child: DefaultAnimatedSwitcher(
                  child: Icon(
                    Icons.pause_circle_outline,
                    key: Key(colorScheme.toString()),
                    size: 32,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onHardModePressed,
                child: DefaultAnimatedSwitcher(
                  child: Icon(
                    hardMode
                        ? Icons.swipe_outlined
                        : Icons.do_not_touch_outlined,
                    // Animated switcher uses key to know when to rebuild
                    // That's why I provided colorScheme and hardmode
                    key: Key(colorScheme.toString() + hardMode.toString()),
                    size: 32,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
