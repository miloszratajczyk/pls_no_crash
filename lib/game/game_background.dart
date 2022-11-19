import 'package:flutter/material.dart';
import 'package:pls_no_crash/game/model/stats.dart';
import 'package:pls_no_crash/game/widgets/default_animated_switcher.dart';

/// Widget displaying under the game
/// shows level number and whether the hard mode is on
class GameBackground extends StatelessWidget {
  const GameBackground({
    Key? key,
    required this.colorScheme,
    required this.level,
    required this.stats,
    required this.hardMode,
  }) : super(key: key);

  final ColorScheme colorScheme;
  final int level;
  final Stats stats;
  final bool hardMode;

  get _defaultDuration => const Duration(seconds: 1);
  get _defaultCurve => Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: AnimatedContainer(
        color: colorScheme.primaryContainer,
        duration: _defaultDuration,
        curve: _defaultCurve,
        child: Center(
          child: AnimatedDefaultTextStyle(
            style: TextStyle(
              color: colorScheme.onPrimaryContainer,
              fontSize: 32,
            ),
            duration: _defaultDuration,
            curve: _defaultCurve,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Level label
                DefaultAnimatedSwitcher(
                  child: Text(
                    level.toString(),
                    key: Key(level.toString()),
                    style: const TextStyle(fontSize: 128),
                  ),
                ),

                // Hard mode label
                AnimatedOpacity(
                  opacity: hardMode ? 1 : 0,
                  duration: _defaultDuration,
                  curve: _defaultCurve,
                  child: const Text(
                    "HARD MODE",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),

                // Highscore lable
                AnimatedOpacity(
                  opacity: (level == stats.highscore) ||
                          (hardMode && level == stats.touchlessHighscore)
                      ? 1
                      : 0,
                  duration: _defaultDuration,
                  curve: _defaultCurve,
                  child: const Text(
                    "HIGHSCORE",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
