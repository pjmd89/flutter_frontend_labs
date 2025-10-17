import 'package:flutter/material.dart';
import './view_model.dart';

class ExamIndicatorCreatePage extends StatefulWidget {
  const ExamIndicatorCreatePage({super.key});

  @override
  State<ExamIndicatorCreatePage> createState() => _ExamIndicatorCreatePageState();
}

class _ExamIndicatorCreatePageState extends State<ExamIndicatorCreatePage> {
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
