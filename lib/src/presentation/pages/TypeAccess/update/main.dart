import 'package:flutter/material.dart';
import './view_model.dart';

class TypeAccessUpdatePage extends StatefulWidget {
  const TypeAccessUpdatePage({super.key, required this.id});
  final String id;

  @override
  State<TypeAccessUpdatePage> createState() => _TypeAccessUpdatePageState();
}

class _TypeAccessUpdatePageState extends State<TypeAccessUpdatePage> {
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
