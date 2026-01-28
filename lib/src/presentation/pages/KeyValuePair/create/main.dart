import 'package:flutter/material.dart';
import './view_model.dart';

class KeyValuePairCreatePage extends StatefulWidget {
  const KeyValuePairCreatePage({super.key});

  @override
  State<KeyValuePairCreatePage> createState() => _KeyValuePairCreatePageState();
}

class _KeyValuePairCreatePageState extends State<KeyValuePairCreatePage> {
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
