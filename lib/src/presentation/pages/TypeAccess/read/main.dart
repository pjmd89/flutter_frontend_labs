import 'package:flutter/material.dart';
import './view_model.dart';

class TypeAccessPage extends StatefulWidget {
  const TypeAccessPage({super.key});

  @override
  State<TypeAccessPage> createState() => _TypeAccessPageState();
}

class _TypeAccessPageState extends State<TypeAccessPage> {
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
