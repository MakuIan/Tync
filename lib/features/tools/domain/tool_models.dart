class CounterModel {
  final int count;
  CounterModel({this.count = 0});

  factory CounterModel.fromMap(Map<dynamic, dynamic>? map) {
    return CounterModel(count: map?["count"] ?? 0);
  }
}

class StopwatchModel {
  final bool isRunning;
  final int startTime; // timestamp in ms

  StopwatchModel({this.isRunning = false, this.startTime = 0});

  factory StopwatchModel.fromMap(Map<dynamic, dynamic>? map) {
    return StopwatchModel(
      isRunning: map?["isRunning"] ?? false,
      startTime: map?["startTime"] ?? 0,
    );
  }
}

class TimerModel {
  final bool isRunning;
  final int endTime; // Timestap for when the timer ends in ms
  final int originalDuration; //for reset (in ms)

  TimerModel({
    this.isRunning = false,
    this.endTime = 0,
    this.originalDuration = 60000,
  });

  factory TimerModel.fromMap(Map<dynamic, dynamic>? map) {
    return TimerModel(
      isRunning: map?['isRunning'] ?? false,
      endTime: map?['endTime'] ?? 0,
      originalDuration: map?['originalDuration'] ?? 60000,
    );
  }
}
