import 'package:flutter/foundation.dart';

class TagsModel extends ChangeNotifier {
  final List<String> _tags = [];

  List<String> get tags => List.unmodifiable(_tags);

  void addTag(String tag) {
    if (!_tags.contains(tag)) {
      _tags.add(tag);
      notifyListeners();
    }
  }

  void setTags(List<String> tags) {
    _tags
      ..clear()
      ..addAll(tags.toSet());
    notifyListeners();
  }

  void removeTag(String tag) {
    if (_tags.remove(tag)) {
      notifyListeners();
    }
  }

  void clearTags() {
    _tags.clear();
    notifyListeners();
  }

  void printTags() {
    for (var tag in _tags) {
      debugPrint(tag);
    }
  }
}
