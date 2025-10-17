import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';

class ListBackendError{
  String? _errorMessage;

  String get errorMessage => _errorMessage!;
  
  ListBackendError(BuildContext context, String? errorCode){
    _errorMessage = AppLocalizations.of(context)!.undefinedError;
    switch(errorCode){
      default:
        _errorMessage = AppLocalizations.of(context)!.undefinedError;
        break;
    }
  }
}