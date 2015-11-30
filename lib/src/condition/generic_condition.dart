part of squilder.condition;

class GenericCondition extends Object with Condition {
  static final regexp = new RegExp(r"\?");
  final String string;
  final Iterable params;

  GenericCondition(this.string, [this.params]);

  String toSql() {
    var paramsList = (params ?? []).toList();
    var newString = string;
    while (paramsList.isNotEmpty) {
      var param = paramsList.removeAt(0);
      newString = newString.replaceFirst(regexp, "${utils.objectToSql(param)}");
    }
    return newString;
  }
}

GenericCondition cond(String string, [Iterable params]) {
  return new GenericCondition(string, params);
}
