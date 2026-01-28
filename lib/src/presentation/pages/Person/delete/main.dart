import 'package:flutter/material.dart';
import './view_model.dart';

class PersonDeletePage extends StatefulWidget {
  const PersonDeletePage({super.key, required this.id});
  final String id;

  @override
  State<PersonDeletePage> createState() => _PersonDeletePageState();
}

class _PersonDeletePageState extends State<PersonDeletePage> {
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
