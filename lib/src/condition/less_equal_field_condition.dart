part of squilder.condition;

class LessEqualFieldCondition<T> extends Object with Condition {
  final TableField<T> fieldOne;
  final TableField<T> fieldTwo;

  LessEqualFieldCondition(this.fieldOne, this.fieldTwo);

  String toSql() {
    return "${fieldOne.toSql()} <= ${fieldTwo.toSql()}";
  }
}
