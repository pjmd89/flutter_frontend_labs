import 'package:flutter/material.dart';
import './view_model.dart';

class TypeAccessDeletePage extends StatefulWidget {
  const TypeAccessDeletePage({super.key, required this.id});
  final String id;

  @override
  State<TypeAccessDeletePage> createState() => _TypeAccessDeletePageState();
}

class _TypeAccessDeletePageState extends State<TypeAccessDeletePage> {
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
