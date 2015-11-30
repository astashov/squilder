part of squilder.condition;

class LessFieldCondition<T> extends Object with Condition {
  final TableField<T> fieldOne;
  final TableField<T> fieldTwo;

  LessFieldCondition(this.fieldOne, this.fieldTwo);

  String toSql() {
    return "${fieldOne.toSql()} < ${fieldTwo.toSql()}";
  }
}
