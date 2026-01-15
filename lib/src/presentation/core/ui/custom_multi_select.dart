import 'package:flutter/material.dart';

class CustomMultiSelect<T> extends StatefulWidget {
  final List<T>? items;
  final String Function(T) displayText;
  final String Function(T) getValue;
  final List<String> selectedValues;
  final ValueChanged<List<String>> onChanged;
  final String searchHint;
  final String emptyMessage;

  const CustomMultiSelect({
    super.key,
    required this.items,
    required this.displayText,
    required this.getValue,
    required this.selectedValues,
    required this.onChanged,
    this.searchHint = 'Search',
    this.emptyMessage = 'No data available',
  });

  @override
  State<CustomMultiSelect<T>> createState() => _CustomMultiSelectState<T>();
}

class _CustomMultiSelectState<T> extends State<CustomMultiSelect<T>> {
  late TextEditingController _searchController;
  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_filterItems);
  }

  @override
  void didUpdateWidget(CustomMultiSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _filterItems();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    if (widget.items == null) {
      setState(() {
        _filteredItems = [];
      });
      return;
    }

    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.from(widget.items!);
      } else {
        _filteredItems = widget.items!
            .where((item) =>
                widget.displayText(item).toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _toggleSelection(String value) {
    final newSelection = List<String>.from(widget.selectedValues);
    if (newSelection.contains(value)) {
      newSelection.remove(value);
    } else {
      newSelection.add(value);
    }
    widget.onChanged(newSelection);
  }

  @override
  Widget build(BuildContext context) {
    // Initialize filtered items on first build
    if (_filteredItems.isEmpty && widget.items != null && widget.items!.isNotEmpty) {
      _filteredItems = List.from(widget.items!);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: widget.searchHint,
            prefixIcon: const Icon(Icons.search),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: widget.items == null
              ? const Center(child: CircularProgressIndicator())
              : widget.items!.isEmpty
                  ? Center(child: Text(widget.emptyMessage))
                  : _filteredItems.isEmpty
                      ? Center(child: Text(widget.emptyMessage))
                      : ListView.builder(
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            final value = widget.getValue(item);
                            final isSelected = widget.selectedValues.contains(value);

                            return CheckboxListTile(
                              title: Text(widget.displayText(item)),
                              value: isSelected,
                              onChanged: (_) => _toggleSelection(value),
                            );
                          },
                        ),
        ),
      ],
    );
  }
}
