part of squilder.condition;

class LessObjectCondition<T> extends Object with Condition {
  final TableField<T> field;
  final T object;

  LessObjectCondition(this.field, this.object);

  String toSql() {
    return "${field.toSql()} < ${utils.objectToSql(object)}";
  }
}
