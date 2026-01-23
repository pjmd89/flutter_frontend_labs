import 'package:flutter/material.dart';
import './view_model.dart';

class UploadDeletePage extends StatefulWidget {
  const UploadDeletePage({super.key, required this.id});
  final String id;

  @override
  State<UploadDeletePage> createState() => _UploadDeletePageState();
}

class _UploadDeletePageState extends State<UploadDeletePage> {
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
