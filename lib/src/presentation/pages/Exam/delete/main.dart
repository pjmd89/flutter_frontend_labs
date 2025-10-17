import 'package:flutter/material.dart';
import './view_model.dart';

class ExamDeletePage extends StatefulWidget {
  const ExamDeletePage({super.key, required this.id});
  final String id;

  @override
  State<ExamDeletePage> createState() => _ExamDeletePageState();
}

class _ExamDeletePageState extends State<ExamDeletePage> {
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
