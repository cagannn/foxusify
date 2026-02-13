import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foxusify/core/logic/xp_calculator.dart';
import 'package:foxusify/features/pomodoro/controller/timer_controller.dart';

class PomodoroScreen extends ConsumerWidget {
  const PomodoroScreen({super.key});

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final timerController = ref.read(timerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro League'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Navigate to League/Profile
              // For now, we can show a snackbar or placeholder
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('League/Profile feature coming soon!')),
              );
            },
            icon: const Icon(Icons.leaderboard),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Timer Display
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: CircularProgressIndicator(
                    value: timerState.progress,
                    strokeWidth: 20,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      timerState.isRunning ? Colors.orange : Colors.blue,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(timerState.currentDuration),
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      timerState.isRunning ? 'Odaklanıyor...' : 'Hazır mısın?',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),

            // XP Estimate
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text(
                    'Kazanılacak XP: +${XpCalculator.calculateEarnedXp(timerState.initialDuration)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!timerState.isRunning && !timerState.isFinished)
                  ElevatedButton.icon(
                    onPressed: () => timerController.startTimer(),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('BAŞLAT'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                if (timerState.isRunning)
                  ElevatedButton.icon(
                    onPressed: () => timerController.pauseTimer(),
                    icon: const Icon(Icons.pause),
                    label: const Text('DURAKLAT'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: Colors.orange,
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                if (!timerState.isRunning && timerState.isFinished)
                   ElevatedButton.icon(
                    onPressed: () => timerController.resetTimer(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('YENİ SEANS'),
                     style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: Colors.green,
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                const SizedBox(width: 16),
                if(timerState.isRunning || (!timerState.isRunning && !timerState.isFinished && timerState.currentDuration != timerState.initialDuration))
                  OutlinedButton(
                    onPressed: () => timerController.resetTimer(),
                    child: const Text('SIFIRLA'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
