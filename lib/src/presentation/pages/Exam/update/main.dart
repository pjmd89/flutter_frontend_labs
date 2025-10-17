import 'package:flutter/material.dart';
import './view_model.dart';

class ExamUpdatePage extends StatefulWidget {
  const ExamUpdatePage({super.key, required this.id});
  final String id;

  @override
  State<ExamUpdatePage> createState() => _ExamUpdatePageState();
}

class _ExamUpdatePageState extends State<ExamUpdatePage> {
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
