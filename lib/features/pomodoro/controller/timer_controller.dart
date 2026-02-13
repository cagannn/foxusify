import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:foxusify/core/logic/xp_calculator.dart';

// State class for the timer
class TimerState {
  final int initialDuration; // in seconds
  final int currentDuration; // in seconds
  final bool isRunning;
  final bool isFinished;

  TimerState({
    required this.initialDuration,
    required this.currentDuration,
    this.isRunning = false,
    this.isFinished = false,
  });

  TimerState copyWith({
    int? initialDuration,
    int? currentDuration,
    bool? isRunning,
    bool? isFinished,
  }) {
    return TimerState(
      initialDuration: initialDuration ?? this.initialDuration,
      currentDuration: currentDuration ?? this.currentDuration,
      isRunning: isRunning ?? this.isRunning,
      isFinished: isFinished ?? this.isFinished,
    );
  }

  double get progress => initialDuration == 0 ? 0 : currentDuration / initialDuration;
}

// Controller
class TimerController extends StateNotifier<TimerState> {
  Timer? _timer;
  final SupabaseClient _supabase = Supabase.instance.client;

  TimerController()
      : super(TimerState(
          initialDuration: 25 * 60, // Default 25 minutes
          currentDuration: 25 * 60,
        ));

  void setDuration(int minutes) {
    if (state.isRunning) return;
    final seconds = minutes * 60;
    state = state.copyWith(
      initialDuration: seconds,
      currentDuration: seconds,
      isFinished: false,
    );
  }

  void startTimer() {
    if (state.isRunning) return;
    
    state = state.copyWith(isRunning: true, isFinished: false);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.currentDuration > 0) {
        state = state.copyWith(currentDuration: state.currentDuration - 1);
      } else {
        _finishTimer();
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void resetTimer() {
    _timer?.cancel();
    state = state.copyWith(
      currentDuration: state.initialDuration,
      isRunning: false,
      isFinished: false,
    );
  }

  Future<void> _finishTimer() async {
    _timer?.cancel();
    state = state.copyWith(isRunning: false, isFinished: true);

    // Calculate XP
    final focusTime = state.initialDuration; // Total time focused
    final earnedXp = XpCalculator.calculateEarnedXp(focusTime);

    try {
      // Call Supabase RPC to update XP
      await _supabase.rpc('add_xp_to_user', params: {
        'p_xp_amount': earnedXp,
        'p_focus_time': focusTime,
      });
      print('XP Updated successfully!');
    } catch (e) {
      print('Error updating XP: $e');
      // TODO: Handle error (e.g., local storage for sync later)
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// Provider
final timerProvider = StateNotifierProvider<TimerController, TimerState>((ref) {
  return TimerController();
});
