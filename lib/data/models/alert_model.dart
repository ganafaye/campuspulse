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
}