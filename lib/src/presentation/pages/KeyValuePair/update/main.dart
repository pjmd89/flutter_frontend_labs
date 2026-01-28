import 'package:flutter/material.dart';
import './view_model.dart';

class KeyValuePairUpdatePage extends StatefulWidget {
  const KeyValuePairUpdatePage({super.key, required this.id});
  final String id;

  @override
  State<KeyValuePairUpdatePage> createState() => _KeyValuePairUpdatePageState();
}

class _KeyValuePairUpdatePageState extends State<KeyValuePairUpdatePage> {
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
