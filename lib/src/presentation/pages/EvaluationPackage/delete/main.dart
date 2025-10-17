import 'package:flutter/material.dart';
import './view_model.dart';

class EvaluationPackageDeletePage extends StatefulWidget {
  const EvaluationPackageDeletePage({super.key, required this.id});
  final String id;

  @override
  State<EvaluationPackageDeletePage> createState() => _EvaluationPackageDeletePageState();
}

class _EvaluationPackageDeletePageState extends State<EvaluationPackageDeletePage> {
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
