import 'dart:developer';

extension StringExtension on String? {
  String? capitalizeFirstLetter() {
    log("capital");
    return "${this?[0].toUpperCase()}${this?.substring(1).toLowerCase()}";
  }

  List splitName() {
    String? _firstName, _lastName;
    List _splitNameList, _nameList = [];
    if (this != null) {
      _splitNameList = this?.split(" ") ?? [];
      _firstName = _splitNameList[0];
      _splitNameList.removeAt(0);
      _lastName = _splitNameList.join(" ");
      _nameList.add(_firstName);
      _nameList.add(_lastName);
    } else {
      _nameList.add("");
      _nameList.add("");
    }

    return _nameList;
  }

  bool get checkNullEmptyText {
    return (this ?? "").isNotEmpty;
  }
}
