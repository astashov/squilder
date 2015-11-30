part of squilder.condition;

class GreaterEqualFieldCondition<T> extends Object with Condition {
  final TableField<T> fieldOne;
  final TableField<T> fieldTwo;

  GreaterEqualFieldCondition(this.fieldOne, this.fieldTwo);

  String toSql() {
    return "${fieldOne.toSql()} >= ${fieldTwo.toSql()}";
  }
}
