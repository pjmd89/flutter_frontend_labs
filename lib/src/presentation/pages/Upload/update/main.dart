import 'package:flutter/material.dart';
import './view_model.dart';

class UploadUpdatePage extends StatefulWidget {
  const UploadUpdatePage({super.key, required this.id});
  final String id;

  @override
  State<UploadUpdatePage> createState() => _UploadUpdatePageState();
}

class _UploadUpdatePageState extends State<UploadUpdatePage> {
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
