import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime? completedAt;
  final bool isCompleted;
  final int estimatedPomodoros;
  final int completedPomodoros;
  final String? category;
  final int priority; // 1 = Low, 2 = Medium, 3 = High

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    this.completedAt,
    this.isCompleted = false,
    this.estimatedPomodoros = 1,
    this.completedPomodoros = 0,
    this.category,
    this.priority = 2,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'isCompleted': isCompleted,
      'estimatedPomodoros': estimatedPomodoros,
      'completedPomodoros': completedPomodoros,
      'category': category,
      'priority': priority,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      isCompleted: json['isCompleted'] ?? false,
      estimatedPomodoros: json['estimatedPomodoros'] ?? 1,
      completedPomodoros: json['completedPomodoros'] ?? 0,
      category: json['category'],
      priority: json['priority'] ?? 2,
    );
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? completedAt,
    bool? isCompleted,
    int? estimatedPomodoros,
    int? completedPomodoros,
    String? category,
    int? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      isCompleted: isCompleted ?? this.isCompleted,
      estimatedPomodoros: estimatedPomodoros ?? this.estimatedPomodoros,
      completedPomodoros: completedPomodoros ?? this.completedPomodoros,
      category: category ?? this.category,
      priority: priority ?? this.priority,
    );
  }

  double get progress {
    if (estimatedPomodoros == 0) return 0.0;
    return (completedPomodoros / estimatedPomodoros).clamp(0.0, 1.0);
  }

  bool get isOverdue {
    if (isCompleted) return false;
    // Consider overdue if not completed within 3 days of creation
    return DateTime.now().difference(createdAt).inDays > 3;
  }

  String get priorityText {
    switch (priority) {
      case 1:
        return 'Low';
      case 2:
        return 'Medium';
      case 3:
        return 'High';
      default:
        return 'Medium';
    }
  }

  Color get priorityColor {
    switch (priority) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}
