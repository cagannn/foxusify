import 'dart:math';

class XpCalculator {
  /// Base XP required for Level 1 to Level 2
  static const int baseXp = 100;

  /// Increase rate per level (10%)
  static const double increaseRate = 1.10;

  /// XP earned per second of focus
  static const double xpPerSecond = 0.1;

  /// Calculate the current level based on total XP using the formula
  /// Total XP = BaseXP * ( (IncreaseRate^Level - 1) / (IncreaseRate - 1) )
  /// This is the formula for the sum of a geometric series.
  /// However, the prompt asked for: "Level 1 = 100 XP, increasing by 10% per level."
  /// Usually this means:
  /// Lvl 1->2: 100 XP
  /// Lvl 2->3: 110 XP
  /// Lvl 3->4: 121 XP
  /// ...
  /// We need to find `n` such that Sum(XP_i for i=1 to n-1) <= TotalXP.
  static int calculateLevel(int totalXp) {
    if (totalXp <= 0) return 1;

    double currentRequiredXp = baseXp.toDouble();
    int level = 1;
    double accumulatedXp = 0;

    // Iterative approach is safer and easier to debug for this scale
    // A closed-form logarithmic solution is possible but prone to precision errors
    while (true) {
      if (totalXp < accumulatedXp + currentRequiredXp) {
        return level;
      }
      accumulatedXp += currentRequiredXp;
      currentRequiredXp *= increaseRate;
      level++;
    }
  }

  /// Calculates XP earned for a given duration in seconds.
  /// Returns nearest integer.
  static int calculateEarnedXp(int seconds) {
    return (seconds * xpPerSecond).round();
  }
}
