import 'package:flutter/foundation.dart';

class SearchManager with ChangeNotifier {
  String? _location;
  DateTime? _startDate;
  DateTime? _endDate;
  String? get location => _location;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  void updateSearch(String? loc, DateTime? start, DateTime? end) {
    _location = loc;
    _startDate = start;
    _endDate = end;
    print('SearchManager Updated: $loc, $start, $end');
  }
}
