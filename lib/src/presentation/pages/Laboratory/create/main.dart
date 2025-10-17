import 'package:flutter/material.dart';
import './view_model.dart';

class LaboratoryCreatePage extends StatefulWidget {
  const LaboratoryCreatePage({super.key});

  @override
  State<LaboratoryCreatePage> createState() => _LaboratoryCreatePageState();
}

class _LaboratoryCreatePageState extends State<LaboratoryCreatePage> {
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
