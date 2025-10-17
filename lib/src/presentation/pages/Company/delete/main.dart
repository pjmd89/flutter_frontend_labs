import 'package:flutter/material.dart';
import './view_model.dart';

class CompanyDeletePage extends StatefulWidget {
  const CompanyDeletePage({super.key, required this.id});
  final String id;

  @override
  State<CompanyDeletePage> createState() => _CompanyDeletePageState();
}

class _CompanyDeletePageState extends State<CompanyDeletePage> {
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
