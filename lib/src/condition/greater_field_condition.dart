part of squilder.condition;

class GreaterFieldCondition<T> extends Object with Condition {
  final TableField<T> fieldOne;
  final TableField<T> fieldTwo;

  GreaterFieldCondition(this.fieldOne, this.fieldTwo);

  String toSql() {
    return "${fieldOne.toSql()} > ${fieldTwo.toSql()}";
  }
}
