import 'package:flutter/material.dart';
import './view_model.dart';

class KeyValuePairDeletePage extends StatefulWidget {
  const KeyValuePairDeletePage({super.key, required this.id});
  final String id;

  @override
  State<KeyValuePairDeletePage> createState() => _KeyValuePairDeletePageState();
}

class _KeyValuePairDeletePageState extends State<KeyValuePairDeletePage> {
  late ViewModel viewModel;
  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = ViewModel(context: context);
  }
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(listenable: viewModel, builder:  (context, child) {
      return Placeholder();
    });
  }
}
