import 'package:flutter/material.dart';
import './view_model.dart';

class PatientDeletePage extends StatefulWidget {
  const PatientDeletePage({super.key, required this.id});
  final String id;

  @override
  State<PatientDeletePage> createState() => _PatientDeletePageState();
}

class _PatientDeletePageState extends State<PatientDeletePage> {
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
