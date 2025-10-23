import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import './view_model.dart';
import './user_item.dart';

List<Widget> buildList({
  required BuildContext context,
  required ViewModel viewModel,
}) {
  // Estado: Cargando
  if (viewModel.loading) {
    return [const Center(child: CircularProgressIndicator())];
  }

  // Estado: Error
  if (viewModel.error) {
    return [const Center(child: Text('Error al cargar los usuarios'))];
  }

  // Estado: Sin datos
  if (viewModel.userList == null || viewModel.userList!.isEmpty) {
    return [const Center(child: Text('No hay usuarios disponibles'))];
  }

  // Estado: Con datos
  return viewModel.userList!.map((user) {
    return UserItem(
      user: user,
      onUpdate: (id) async {
        final result = await context.push('/user/update/$id');
        if (result == true) {
          viewModel.getUsers();
        }
      },
      onDelete: (id) async {
        final result = await context.push('/user/delete/$id');
        if (result == true) {
          viewModel.getUsers();
        }
      },
      onViewLabs: (id) {
        // TODO: Implementar navegación a laboratorios
        // context.push('/user/$id/laboratories');
      },
      onViewBilling: (id) {
        // TODO: Implementar navegación a facturación
        // context.push('/user/$id/billing');
      },
    );
  }).toList();
}
