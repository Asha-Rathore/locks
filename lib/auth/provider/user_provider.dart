import 'package:flutter/foundation.dart';
import 'package:locks_hybrid/auth/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _currentUser;

////////////////getters//////////////////

  UserModel? get getCurrentUser => _currentUser;

////////////////setters//////////////////

  void setCurrentUser({dynamic user}) {
    if (user != null) {
      _currentUser = UserModel.fromJson(user);
    } else {
      _currentUser = null;
    }
    notifyListeners();
  }

  void clearCurrentUser() {
    _currentUser = null;
  }
}
