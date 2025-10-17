import 'package:flutter/material.dart';
import './view_model.dart';

class ExamTemplatePage extends StatefulWidget {
  const ExamTemplatePage({super.key});

  @override
  State<ExamTemplatePage> createState() => _ExamTemplatePageState();
}

class _ExamTemplatePageState extends State<ExamTemplatePage> {
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
