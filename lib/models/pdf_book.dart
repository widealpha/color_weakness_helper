import 'package:flutter/material.dart';

class PdfBook {
  const PdfBook({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.assetPath,
    required this.description,
    required this.accentColor,
    this.isAvailable = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final String assetPath;
  final String description;
  final Color accentColor;
  final bool isAvailable;

  PdfBook copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? assetPath,
    String? description,
    Color? accentColor,
    bool? isAvailable,
  }) {
    return PdfBook(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      assetPath: assetPath ?? this.assetPath,
      description: description ?? this.description,
      accentColor: accentColor ?? this.accentColor,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
