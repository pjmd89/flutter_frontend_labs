import 'package:flutter/material.dart';
import './view_model.dart';

class LaboratoryUpdatePage extends StatefulWidget {
  const LaboratoryUpdatePage({super.key, required this.id});
  final String id;

  @override
  State<LaboratoryUpdatePage> createState() => _LaboratoryUpdatePageState();
}

class _LaboratoryUpdatePageState extends State<LaboratoryUpdatePage> {
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
