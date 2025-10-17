import 'package:flutter/material.dart';
import 'package:labs/src/presentation/core/ui/list_errors/backend.dart';
import 'package:labs/src/presentation/core/ui/list_errors/frontend.dart';
class FormatValidator {
  static String? validateFieldIsNotEmpty(BuildContext context, String? str) {
    String? errorValidationMessage;
    if (str == null || str.isEmpty) {
      errorValidationMessage = ListFrontendError(context, "emptyFieldError").errorMessage;
    }
    return errorValidationMessage;
  }
  static String? validateFirstName(BuildContext context, String? str) {
    String? errorValidationMessage;

    if (str == null || str.isEmpty) {
      errorValidationMessage = ListFrontendError(context, "emptyFieldError").errorMessage;
    }
    return errorValidationMessage;
  }

  static String? validateLastName(BuildContext context,String? str) {
    String? errorValidationMessage;

    if (str == null || str.isEmpty) {
      errorValidationMessage = ListFrontendError(context, "emptyFieldError").errorMessage;
    }
    return errorValidationMessage;
  }

  static String? validateUserEmail(BuildContext context, String? str) {
    String? errorValidationMessage;

    if (str == null || str.isEmpty) {
      errorValidationMessage = ListFrontendError(context, "emptyFieldError").errorMessage;
    }

    if (!RegExp(r"^([\w\.]+)@(\w+)\.(.*)$")
        .hasMatch(str!)) {
      errorValidationMessage = ListFrontendError(context, "formatEmailError").errorMessage;
    }
    return errorValidationMessage;
  }

  static String? validateUserCellPhone(BuildContext context, String? str) {
    String? errorValidationMessage;

    if (str == null || str.isEmpty || (str.length < 11 || str.length > 15)) {
      errorValidationMessage = ListBackendError(context, "122").errorMessage;
    }

    return errorValidationMessage;
  }

  static String? validateUserPassword(BuildContext context, String? str) {
    String? errorValidationMessage;

    if (str == null || str.isEmpty) {
      errorValidationMessage = ListFrontendError(context, "emptyFieldError").errorMessage;
    }

    return errorValidationMessage;
  }

  static String? repeatPasswordValidation(BuildContext context, String? password, String? repeatedPassWord) {
    String? errorValidationMessage = ListFrontendError(context, "emptyFieldError").errorMessage;

    if (repeatedPassWord != null && password != null) {
      if (!(repeatedPassWord == password)) {
        errorValidationMessage = ListFrontendError(context, "matchPasswordError").errorMessage;
        return errorValidationMessage;
      }
      return null;
    }

    return errorValidationMessage;
  }


  static String? validateVerifyCodeFormat(BuildContext context, String verifyCodeString){
    String? errorValidationMessage;

    if (verifyCodeString.isEmpty || verifyCodeString.length < 4){
      errorValidationMessage = ListFrontendError(context, "verifyCodeFormat").errorMessage;
    }
    
    return errorValidationMessage;
  }

}