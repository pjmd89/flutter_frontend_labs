import 'package:flutter/material.dart';
import './view_model.dart';

class ExamTemplateUpdatePage extends StatefulWidget {
  const ExamTemplateUpdatePage({super.key, required this.id});
  final String id;

  @override
  State<ExamTemplateUpdatePage> createState() => _ExamTemplateUpdatePageState();
}

class _ExamTemplateUpdatePageState extends State<ExamTemplateUpdatePage> {
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
