part of squilder.condition;

class AndConditionPair extends Object with Condition {
  final Condition one;
  final Condition two;

  AndConditionPair(this.one, this.two);

  String toSql() {
    return "(${one.toSql()} AND ${two.toSql()})";
  }
}

