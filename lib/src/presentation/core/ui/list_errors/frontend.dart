import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';

class ListFrontendError{
  String? _errorMessage;

  String get errorMessage => _errorMessage!;
  
  ListFrontendError(BuildContext context, String? errorCode){
    _errorMessage = AppLocalizations.of(context)!.undefinedError;
    _errorMessage = AppLocalizations.of(context)!.undefinedError;
    switch(errorCode){
      case 'formatEmailError':
        _errorMessage = AppLocalizations.of(context)!.formatEmailError;
        break;
      case 'emptyFieldError':
        _errorMessage = AppLocalizations.of(context)!.emptyFieldError;
        break;
      default:
        _errorMessage = AppLocalizations.of(context)!.undefinedError;
        break;
    }
  }
}


