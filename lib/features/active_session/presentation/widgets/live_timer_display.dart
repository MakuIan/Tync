import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tync/core/constants/app_colors.dart';
import 'package:tync/core/constants/app_text_styles.dart';

class LiveTimerDisplay extends StatefulWidget {
  final int targetTime;
  final bool isRunning;
  final bool isCountDown;

  const LiveTimerDisplay({
    super.key,
    required this.targetTime,
    required this.isRunning,
    required this.isCountDown,
  });

  @override
  State<LiveTimerDisplay> createState() => _LiveTimerDisplayState();
}

class _LiveTimerDisplayState extends State<LiveTimerDisplay> {
  late Timer _ticker;
  String _displayText = '00:00';

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => _updateTime(),
    );
    _updateTime();
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  void _updateTime() {
    if (!widget.isRunning && widget.targetTime == 0) {
      if (mounted) setState(() => _displayText = '00:00');
      return;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    int diff;

    if (widget.isCountDown) {
      diff = widget.targetTime - now;
      if (diff < 0) diff = 0;
    } else {
      diff = now - widget.targetTime;
    }
    final duration = Duration(milliseconds: diff);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    String formatted = '$minutes:$seconds';
    if (hours > 0) formatted = '$hours:$minutes:$seconds';
    if (mounted) setState(() => _displayText = formatted);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayText,
      style: AppTextStyles.timerBig.copyWith(
        color: widget.isCountDown && widget.isRunning && _displayText == '00:00'
            ? AppColors.success
            : Colors.black,
      ),
    );
  }
}
