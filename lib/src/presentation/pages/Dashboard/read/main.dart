import 'package:flutter/material.dart';
import './view_model.dart';

class BashboardPage extends StatefulWidget {
  const BashboardPage({super.key});

  @override
  State<BashboardPage> createState() => _BashboardPageState();
}

class _BashboardPageState extends State<BashboardPage> {
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
