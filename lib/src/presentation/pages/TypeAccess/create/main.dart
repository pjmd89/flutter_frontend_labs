import 'package:flutter/material.dart';
import './view_model.dart';

class TypeAccessCreatePage extends StatefulWidget {
  const TypeAccessCreatePage({super.key});

  @override
  State<TypeAccessCreatePage> createState() => _TypeAccessCreatePageState();
}

class _TypeAccessCreatePageState extends State<TypeAccessCreatePage> {
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
