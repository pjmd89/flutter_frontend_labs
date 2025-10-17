import 'package:flutter/material.dart';
import './view_model.dart';

class ExamTemplateDeletePage extends StatefulWidget {
  const ExamTemplateDeletePage({super.key, required this.id});
  final String id;

  @override
  State<ExamTemplateDeletePage> createState() => _ExamTemplateDeletePageState();
}

class _ExamTemplateDeletePageState extends State<ExamTemplateDeletePage> {
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
