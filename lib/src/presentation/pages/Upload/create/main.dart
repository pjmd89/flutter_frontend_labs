import 'package:flutter/material.dart';
import './view_model.dart';

class UploadCreatePage extends StatefulWidget {
  const UploadCreatePage({super.key});

  @override
  State<UploadCreatePage> createState() => _UploadCreatePageState();
}

class _UploadCreatePageState extends State<UploadCreatePage> {
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
