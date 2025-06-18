import 'package:flutter/material.dart';

class CTFWriteup {
  final String title;
  final DateTime date;
  final String ctf;
  final String category;
  final String difficulty;
  final int points;
  final List<String> tags;
  final String author;
  final String content;
  final String filename;

  CTFWriteup({
    required this.title,
    required this.date,
    required this.ctf,
    required this.category,
    required this.difficulty,
    required this.points,
    required this.tags,
    required this.author,
    required this.content,
    required this.filename,
  });

  factory CTFWriteup.fromMarkdown(String markdown, String filename) {
    final lines = markdown.split('\n');
    final metadataEnd = lines.indexOf('---', 1);
    
    if (metadataEnd == -1) {
      throw Exception('Invalid markdown format: missing metadata');
    }

    final metadata = <String, dynamic>{};
    for (int i = 1; i < metadataEnd; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      
      final colonIndex = line.indexOf(':');
      if (colonIndex != -1) {
        final key = line.substring(0, colonIndex).trim();
        final value = line.substring(colonIndex + 1).trim().replaceAll('"', '');
        
        if (key == 'tags') {
          // Parse tags array
          final tagsStr = value.replaceAll('[', '').replaceAll(']', '');
          metadata[key] = tagsStr.split(',').map((e) => e.trim().replaceAll('"', '')).toList();
        } else if (key == 'points') {
          metadata[key] = int.tryParse(value) ?? 0;
        } else {
          metadata[key] = value;
        }
      }
    }

    final content = lines.skip(metadataEnd + 1).join('\n');

    return CTFWriteup(
      title: metadata['title'] ?? 'Untitled',
      date: DateTime.tryParse(metadata['date'] ?? '') ?? DateTime.now(),
      ctf: metadata['ctf'] ?? 'Unknown CTF',
      category: metadata['category'] ?? 'Misc',
      difficulty: metadata['difficulty'] ?? 'Unknown',
      points: metadata['points'] ?? 0,
      tags: List<String>.from(metadata['tags'] ?? []),
      author: metadata['author'] ?? 'Unknown',
      content: content,
      filename: filename,
    );
  }

  String get slug => filename.replaceAll('.md', '').replaceAll('_', '-');
  
  Color get difficultyColor {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return const Color(0xFF4ECDC4); // Mint green
      case 'medium':
        return const Color(0xFFFFB347); // Peach orange
      case 'hard':
        return const Color(0xFFFF6B9D); // Hot pink
      default:
        return const Color(0xFFB19CD9); // Soft lavender
    }
  }

  Color get categoryColor {
    switch (category.toLowerCase()) {
      case 'web':
        return const Color(0xFF87CEEB); // Sky blue
      case 'crypto':
        return const Color(0xFFDDA0DD); // Plum
      case 'pwn':
        return const Color(0xFFFF6B6B); // Coral red
      case 'reverse':
        return const Color(0xFF98D8C8); // Mint
      case 'forensics':
        return const Color(0xFFADD8E6); // Light blue
      case 'misc':
        return const Color(0xFFFFC0CB); // Pink
      default:
        return const Color(0xFFD3D3D3); // Light grey
    }
  }
}