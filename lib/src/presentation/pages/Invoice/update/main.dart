import 'package:flutter/material.dart';
import './view_model.dart';

class InvoiceUpdatePage extends StatefulWidget {
  const InvoiceUpdatePage({super.key, required this.id});
  final String id;

  @override
  State<InvoiceUpdatePage> createState() => _InvoiceUpdatePageState();
}

class _InvoiceUpdatePageState extends State<InvoiceUpdatePage> {
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
