// lib/data/models/alert_model.dart
import 'package:flutter/material.dart';

enum AlertType { urgent, rappel, info }

class AlertModel {
  final String id;
  final AlertType type;
  final String tag;
  final String message;
  final DateTime timestamp;
  final String? actionLabel;
  final VoidCallback? onAction;

  AlertModel({
    required this.id,
    required this.type,
    required this.tag,
    required this.message,
    required this.timestamp,
    this.actionLabel,
    this.onAction,
  });

  factory AlertModel.fromMap(Map<dynamic, dynamic> map, {String? id}) {
    final m = Map<String, dynamic>.from(map);

    AlertType parseType(String? s) {
      if (s == null) return AlertType.info;
      final normalized = s.toLowerCase();
      if (normalized.contains('urgent')) return AlertType.urgent;
      if (normalized.contains('rappel') || normalized.contains('reminder')) return AlertType.rappel;
      return AlertType.info;
    }

    DateTime parseTimestamp(dynamic v) {
      if (v == null) return DateTime.now();
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      if (v is String) {
        try {
          return DateTime.parse(v);
        } catch (_) {
          return DateTime.now();
        }
      }
      return DateTime.now();
    }

    return AlertModel(
      id: id ?? m['id'] ?? m['alertId'] ?? '',
      type: parseType(m['type'] ?? m['category'] ?? m['niveau']),
      tag: m['tag'] ?? m['title'] ?? m['titre'] ?? '',
      message: m['message'] ?? m['subtitle'] ?? m['body'] ?? '',
      timestamp: parseTimestamp(m['timestamp'] ?? m['time'] ?? m['date']),
      actionLabel: m['actionLabel'] ?? m['action_label'],
      onAction: null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'tag': tag,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'actionLabel': actionLabel,
    };
  }
}