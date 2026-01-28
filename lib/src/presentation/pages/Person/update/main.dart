import 'package:flutter/material.dart';
import './view_model.dart';

class PersonUpdatePage extends StatefulWidget {
  const PersonUpdatePage({super.key, required this.id});
  final String id;

  @override
  State<PersonUpdatePage> createState() => _PersonUpdatePageState();
}

class _PersonUpdatePageState extends State<PersonUpdatePage> {
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
