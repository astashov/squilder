part of squilder.condition;

class OrConditionPair extends Object with Condition {
  final Condition one;
  final Condition two;

  OrConditionPair(this.one, this.two);

  String toSql() {
    return "(${one.toSql()} OR ${two.toSql()})";
  }
}

