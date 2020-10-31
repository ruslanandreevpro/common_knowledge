import 'package:common_knowledge/utilities/vocabulary.dart';
import 'package:flutter/material.dart';

class EmailValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return ErrorMessages.emptyTextFieldError;
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return ErrorMessages.emptyTextFieldError;
    }
    if (value.length < 6) {
      return '${ErrorMessages.minLengthTextFieldError} 6 символ(-ов)';
    }
    return null;
  }
}

class NameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return ErrorMessages.emptyTextFieldError;
    }
    if (value.length < 3) {
      return '${ErrorMessages.minLengthTextFieldError} 3 символ(-ов)';
    }
    if (value.length > 50) {
      return '${ErrorMessages.maxLengthTextFieldError} 50 символ(-ов)';
    }
    return null;
  }
}

class FormValidator {
  static bool validate(FormState formState) {
    if (formState.validate()) {
      formState.save();
      return true;
    } else {
      return false;
    }
  }
}

class FirebaseValidator {
  static String validate(String value) {
    switch (value) {
      case 'ERROR_WEAK_PASSWORD':
        return ErrorMessages.errorInvalidEmail;
        break;
      case 'ERROR_INVALID_EMAIL':
        return ErrorMessages.errorInvalidEmail;
        break;
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return ErrorMessages.errorEmailAlreadyInUse;
        break;
      case 'ERROR_WRONG_PASSWORD':
        return ErrorMessages.errorWrongPassword;
        break;
      case 'ERROR_USER_NOT_FOUND':
        return ErrorMessages.errorUserNotFound;
        break;
      case 'ERROR_USER_DISABLED':
        return ErrorMessages.errorUserDisabled;
        break;
      case 'ERROR_TOO_MANY_REQUESTS':
        return ErrorMessages.errorTooManyRequest;
        break;
      case 'ERROR_OPERATION_NOT_ALLOWED':
        return ErrorMessages.errorOperationNotAllowed;
        break;
      default:
        return null;
    }
  }
}
