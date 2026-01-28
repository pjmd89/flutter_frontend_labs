import 'package:flutter/material.dart';
import './view_model.dart';

class KeyValuePairPage extends StatefulWidget {
  const KeyValuePairPage({super.key});

  @override
  State<KeyValuePairPage> createState() => _KeyValuePairPageState();
}

class _KeyValuePairPageState extends State<KeyValuePairPage> {
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
