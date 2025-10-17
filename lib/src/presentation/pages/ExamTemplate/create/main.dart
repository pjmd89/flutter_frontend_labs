import 'package:flutter/material.dart';
import './view_model.dart';

class ExamTemplateCreatePage extends StatefulWidget {
  const ExamTemplateCreatePage({super.key});

  @override
  State<ExamTemplateCreatePage> createState() => _ExamTemplateCreatePageState();
}

class _ExamTemplateCreatePageState extends State<ExamTemplateCreatePage> {
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
