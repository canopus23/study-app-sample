import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUsageMeter extends StatefulWidget {
  const AppUsageMeter({Key? key}) : super(key: key);

  @override
  _AppUsageMeterState createState() => _AppUsageMeterState();
}

class _AppUsageMeterState extends State<AppUsageMeter> {
  Duration targetUsage = Duration.zero;
  int _targetSetByUser = 0;
  double _progress = 0.0;
  DateTime? _startTime;
  final TextEditingController _targetController = TextEditingController();
  final FocusNode _targetFocusNode = FocusNode();
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _loadStartTime();
    _progress = _targetSetByUser > 0 ? _calculateProgress() : 0.0;

    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      updateProgress();
    });
  }

  void _loadStartTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? startTimeString = prefs.getString('startTime');
    _startTime = startTimeString != null ? DateTime.parse(startTimeString) : null;
  }

  void _saveStartTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _startTime = DateTime.now(); // Update _startTime when the target is set
    prefs.setString('startTime', _startTime!.toIso8601String());
  }

  double _calculateProgress() {
    if (_startTime == null || _targetSetByUser <= 0) {
      return 0.0;
    }

    Duration elapsedTime = DateTime.now().difference(_startTime!);
    return elapsedTime.inMinutes / _targetSetByUser;
  }

  void updateProgress() {
    setState(() {
      _progress = _targetSetByUser > 0 ? _calculateProgress() : 0.0;
    });
  }

  void _resetAppUsage() {
    setState(() {
      _targetSetByUser = 0;
      _progress = 0.0;
      _startTime = null;
      _saveStartTime(); // Save start time when the target is set
      _targetController.clear();
    });
  }

  void _confirmTarget() {
    _setTarget();
  }

  void _setTarget() {
    setState(() {
      _targetSetByUser = int.tryParse(_targetController.text) ?? 0;
      _saveStartTime(); // Save start time when the target is set
      _progress = _calculateProgress();
      _targetController.clear();
    });
    // Additional action on confirmation if needed
    print('Target Confirmed: $_targetSetByUser');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkAppUsage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          bool isUsedEnough = snapshot.data ?? false;

          return Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Container(
              height: 120,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "App Usage",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        _targetSetByUser > 0
                            ? (isUsedEnough ? "Target Achieved" : "Not Used Enough")
                            : "Set your Target",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _targetSetByUser > 0
                              ? (isUsedEnough ? Colors.green : Colors.red)
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 190,
                        height: 34,
                        child: TextField(
                          controller: _targetController,
                          focusNode: _targetFocusNode,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(3),
                          ],
                          decoration: InputDecoration(
                            labelText: "Set Target (min)",
                            labelStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[400] ?? Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  onPressed: _setTarget,
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                                    minimumSize: MaterialStateProperty.all<Size>(Size(36, 36)),
                                  ),
                                  child: Text('Set'),
                                ),
                                TextButton(
                                  onPressed: _resetAppUsage,
                                  child: Text('Reset'),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            _targetFocusNode.requestFocus();
                          },
                          onEditingComplete: () async {
                            _setTarget();
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Target: ${_targetSetByUser} min",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<bool> checkAppUsage() async {
    double actualUsage = _calculateProgress();
    bool isUsedEnough = actualUsage >= 1.0;
    return isUsedEnough;
  }

  @override
  void dispose() {
    _timer.cancel();
    _targetController.dispose();
    _targetFocusNode.dispose();
    super.dispose();
  }
}
