extension StringNullChecker on String? {
  String ifNullOrEmptyReturn(String ifNullValue, {String? ifEmptyValue}) {
    bool valueToBeCheckedIsNull = this == null;
    bool valueToBeCheckedIsEmpty = this != null ? this!.isEmpty : false;
    bool valueToBeCheckedIsNullOrEmpty = this == null || this!.isEmpty;

    if (ifEmptyValue == null) {
      if (valueToBeCheckedIsNullOrEmpty) {
        return ifNullValue;
      } else {
        return this!;
      }
    } else {
      if (valueToBeCheckedIsEmpty) {
        return ifEmptyValue;
      } else if (valueToBeCheckedIsNull) {
        return ifNullValue;
      } else {
        return this!;
      }
    }
  }
}

extension StringEmptyCheckerChecker on String {
  String ifEmptyReturn(String ifEmptyValue) {
    bool valueToBeCheckedIsEmpty = this.isEmpty;
    if (valueToBeCheckedIsEmpty) {
      return ifEmptyValue;
    } else {
      return this;
    }
  }
}

extension IntNullChecker on int? {
  int ifNullReturn(int ifNullValue) {
    bool valueToBeCheckedIsNull = this == null;

    if (valueToBeCheckedIsNull) {
      return ifNullValue;
    } else {
      return this!;
    }
  }
}

extension DateTimeNullChecker on DateTime? {
  DateTime ifNullReturn(DateTime ifNullValue) {
    bool valueToBeCheckedIsNull = this == null;

    if (valueToBeCheckedIsNull) {
      return ifNullValue;
    } else {
      return this!;
    }
  }
}

extension DoubleNullChecker on double? {
  double ifNullReturn(double ifNullValue) {
    bool valueToBeCheckedIsNull = this == null;

    if (valueToBeCheckedIsNull) {
      return ifNullValue;
    } else {
      return this!;
    }
  }
}

extension BoolNullChecker on bool? {
  bool ifNullReturn(bool ifNullValue) {
    bool valueToBeCheckedIsNull = this == null;

    if (valueToBeCheckedIsNull) {
      return ifNullValue;
    } else {
      return this!;
    }
  }
}

extension ListNullChecker on List? {
  List ifNullOrEmptyReturn(List ifNullValue, {List? ifEmptyValue}) {
    bool valueToBeCheckedIsNull = this == null;
    bool valueToBeCheckedIsEmpty = this != null ? this!.isEmpty : false;
    bool valueToBeCheckedIsNullOrEmpty = this == null || this!.isEmpty;

    if (ifEmptyValue == null) {
      if (valueToBeCheckedIsNullOrEmpty) {
        return ifNullValue;
      } else {
        return this!;
      }
    } else {
      if (valueToBeCheckedIsEmpty) {
        return ifEmptyValue;
      } else if (valueToBeCheckedIsNull) {
        return ifNullValue;
      } else {
        return this!;
      }
    }
  }
}

extension ListEmptyCheckerChecker on List {
  List ifEmptyReturn(List ifEmptyValue) {
    bool valueToBeCheckedIsEmpty = this.isEmpty;
    if (valueToBeCheckedIsEmpty) {
      return ifEmptyValue;
    } else {
      return this;
    }
  }
}
