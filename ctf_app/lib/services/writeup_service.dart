import 'package:flutter/services.dart';
import 'models/ctf_writeup.dart';

class WriteupService {
  static const String _basePath = 'assets/writeups/';
  
  // List of all writeup files - this would be automatically generated in a real scenario
  static const List<String> _writeupFiles = [
    'sample-web-challenge.md',
    // Add more files here as you create them
  ];

  static Future<List<CTFWriteup>> loadAllWriteups() async {
    final List<CTFWriteup> writeups = [];
    
    for (final filename in _writeupFiles) {
      try {
        final String markdown = await rootBundle.loadString('$_basePath$filename');
        final writeup = CTFWriteup.fromMarkdown(markdown, filename);
        writeups.add(writeup);
      } catch (e) {
        print('Error loading writeup $filename: $e');
      }
    }
    
    // Sort by date (newest first)
    writeups.sort((a, b) => b.date.compareTo(a.date));
    
    return writeups;
  }

  static Future<CTFWriteup?> loadWriteup(String filename) async {
    try {
      final String markdown = await rootBundle.loadString('$_basePath$filename');
      return CTFWriteup.fromMarkdown(markdown, filename);
    } catch (e) {
      print('Error loading writeup $filename: $e');
      return null;
    }
  }

  static List<String> getAllCategories(List<CTFWriteup> writeups) {
    final categories = writeups.map((w) => w.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  static List<String> getAllDifficulties(List<CTFWriteup> writeups) {
    final difficulties = writeups.map((w) => w.difficulty).toSet().toList();
    difficulties.sort();
    return ['All', ...difficulties];
  }

  static List<String> getAllTags(List<CTFWriteup> writeups) {
    final tags = <String>{};
    for (final writeup in writeups) {
      tags.addAll(writeup.tags);
    }
    final tagList = tags.toList();
    tagList.sort();
    return tagList;
  }
}