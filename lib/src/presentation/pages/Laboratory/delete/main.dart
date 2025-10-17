import 'package:flutter/material.dart';
import './view_model.dart';

class LaboratoryDeletePage extends StatefulWidget {
  const LaboratoryDeletePage({super.key, required this.id});
  final String id;

  @override
  State<LaboratoryDeletePage> createState() => _LaboratoryDeletePageState();
}

class _LaboratoryDeletePageState extends State<LaboratoryDeletePage> {
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
