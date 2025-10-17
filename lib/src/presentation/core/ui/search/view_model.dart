import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/infraestructure/utils/search_fields.dart';


class ViewModel extends ChangeNotifier {
  List<SearchInput> _searchInput = [];
  int _split = 10;
  final List<SearchFields?> _fields;
  final PageInfo _pageInfo = PageInfo(
    total: 0,
    page: 1,
    pages: 0,
    split: 10,
  );

  int get split => _split;
  set split(int value) {
    _split = value;
    _pageInfo.split = value;
    notifyListeners();
  }
  String _search = "";
  PageInfo get pageInfo => _pageInfo;
  set pageInfo(PageInfo value) {
    _pageInfo.total = value.total;
    _pageInfo.page = value.page;
    _pageInfo.pages = value.pages;
    _pageInfo.split = value.split;
    notifyListeners();
  }
  List<SearchInput> get searchInputs => _searchInput;

  String get search => _search;
  set search(String value) {
    _search = value;
    if (value.trim() != '') {
      _searchInput = [];
      if(_fields.isNotEmpty) {
        if(_fields.isNotEmpty) {
          for(var field in _fields) {
            _searchInput.add(SearchInput(field: field!.field, value: [ValueInput(value: value, kind: field.kind, operator: field.operator,)]));
          }
        }
        
      }
    } else {
      _searchInput = [];
    }
    notifyListeners();
  }
  ViewModel({List<SearchFields?>? fields}): _fields = fields ?? [];
}