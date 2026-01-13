// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(appName) => "Welcome to ${appName}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Already have an account?",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("Turbo Template"),
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "confirmPassword": MessageLookupByLibrary.simpleMessage("Confirm password"),
    "createAccount": MessageLookupByLibrary.simpleMessage("Create account"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "done": MessageLookupByLibrary.simpleMessage("Done"),
    "dontHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account?",
    ),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "error": MessageLookupByLibrary.simpleMessage("Error"),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot password?"),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
    "logIn": MessageLookupByLibrary.simpleMessage("Log in"),
    "logOut": MessageLookupByLibrary.simpleMessage("Log out"),
    "next": MessageLookupByLibrary.simpleMessage("Next"),
    "noInternetConnection": MessageLookupByLibrary.simpleMessage(
      "No internet connection",
    ),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "resetPassword": MessageLookupByLibrary.simpleMessage("Reset password"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "signUp": MessageLookupByLibrary.simpleMessage("Sign up"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "Something went wrong",
    ),
    "somethingWentWrongPleaseTryAgainLater":
        MessageLookupByLibrary.simpleMessage(
          "Something went wrong. Please try again later.",
        ),
    "success": MessageLookupByLibrary.simpleMessage("Success"),
    "welcomeToApp": m0,
  };
}
