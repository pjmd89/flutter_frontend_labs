import 'package:flutter/material.dart';
import './view_model.dart';

class ExamIndicatorUpdatePage extends StatefulWidget {
  const ExamIndicatorUpdatePage({super.key, required this.id});
  final String id;

  @override
  State<ExamIndicatorUpdatePage> createState() => _ExamIndicatorUpdatePageState();
}

class _ExamIndicatorUpdatePageState extends State<ExamIndicatorUpdatePage> {
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
