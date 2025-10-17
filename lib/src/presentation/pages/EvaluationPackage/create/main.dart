import 'package:flutter/material.dart';
import './view_model.dart';

class EvaluationPackageCreatePage extends StatefulWidget {
  const EvaluationPackageCreatePage({super.key});

  @override
  State<EvaluationPackageCreatePage> createState() => _EvaluationPackageCreatePageState();
}

class _EvaluationPackageCreatePageState extends State<EvaluationPackageCreatePage> {
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
