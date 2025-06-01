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

  void removeTag(String tag) {
    if (_tags.remove(tag)) {
      notifyListeners();
    }
  }

  void clearTags() {
    _tags.clear();
    notifyListeners();
  }
}
