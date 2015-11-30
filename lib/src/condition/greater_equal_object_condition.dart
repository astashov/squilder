part of squilder.condition;

class GreaterEqualObjectCondition<T> extends Object with Condition {
  final TableField<T> field;
  final T object;

  GreaterEqualObjectCondition(this.field, this.object);

  String toSql() {
    return "${field.toSql()} >= ${utils.objectToSql(object)}";
  }
}
