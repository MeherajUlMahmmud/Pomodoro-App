class PomodoroSession {
  final String id;
  final String type; // 'work', 'short_break', 'long_break'
  final int duration; // in minutes
  final DateTime startTime;
  final DateTime? endTime;
  final bool isCompleted;
  final String? taskName;
  final String? notes;

  PomodoroSession({
    required this.id,
    required this.type,
    required this.duration,
    required this.startTime,
    this.endTime,
    this.isCompleted = false,
    this.taskName,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'duration': duration,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'isCompleted': isCompleted,
      'taskName': taskName,
      'notes': notes,
    };
  }

  factory PomodoroSession.fromJson(Map<String, dynamic> json) {
    return PomodoroSession(
      id: json['id'],
      type: json['type'],
      duration: json['duration'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      isCompleted: json['isCompleted'] ?? false,
      taskName: json['taskName'],
      notes: json['notes'],
    );
  }

  PomodoroSession copyWith({
    String? id,
    String? type,
    int? duration,
    DateTime? startTime,
    DateTime? endTime,
    bool? isCompleted,
    String? taskName,
    String? notes,
  }) {
    return PomodoroSession(
      id: id ?? this.id,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isCompleted: isCompleted ?? this.isCompleted,
      taskName: taskName ?? this.taskName,
      notes: notes ?? this.notes,
    );
  }

  Duration get actualDuration {
    if (endTime != null) {
      return endTime!.difference(startTime);
    }
    return Duration.zero;
  }

  bool get isWorkSession => type == 'work';
  bool get isBreakSession => type == 'short_break' || type == 'long_break';
}
