import 'package:flutter/material.dart';
import './view_model.dart';

class EvaluationPackageUpdatePage extends StatefulWidget {
  const EvaluationPackageUpdatePage({super.key, required this.id});
  final String id;

  @override
  State<EvaluationPackageUpdatePage> createState() => _EvaluationPackageUpdatePageState();
}

class _EvaluationPackageUpdatePageState extends State<EvaluationPackageUpdatePage> {
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
