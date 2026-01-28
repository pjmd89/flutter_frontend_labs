import 'package:flutter/material.dart';
import './view_model.dart';

class PersonCreatePage extends StatefulWidget {
  const PersonCreatePage({super.key});

  @override
  State<PersonCreatePage> createState() => _PersonCreatePageState();
}

class _PersonCreatePageState extends State<PersonCreatePage> {
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
