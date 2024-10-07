import 'dart:async';

import 'package:flutter/material.dart';

class ProfileUtils {
  static InputDecoration myinputdec({
    required IconData icon,
    required String hint,
    required bool ispassfield,
    void Function()? onpressed,
  }) {
    return InputDecoration(
      hintStyle: const TextStyle(fontSize: 14),
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: ispassfield
          ? IconButton(
              onPressed: onpressed, icon: const Icon(Icons.remove_red_eye))
          : null,
      enabledBorder:
          const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      focusedBorder:
          const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
    );
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  Timer? _timer;
  int _start = 90;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startTimer();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _start = 90;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _timer!.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formatTime(_start),
      style: const TextStyle(
        color: Color(0xFF646464),
        fontSize: 15,
      ),
    );
  }
}
