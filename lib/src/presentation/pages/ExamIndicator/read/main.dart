import 'package:flutter/material.dart';
import './view_model.dart';

class ExamIndicatorPage extends StatefulWidget {
  const ExamIndicatorPage({super.key});

  @override
  State<ExamIndicatorPage> createState() => _ExamIndicatorPageState();
}

class _ExamIndicatorPageState extends State<ExamIndicatorPage> {
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
