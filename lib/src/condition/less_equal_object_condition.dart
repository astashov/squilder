part of squilder.condition;

class LessEqualObjectCondition<T> extends Object with Condition {
  final TableField<T> field;
  final T object;

  LessEqualObjectCondition(this.field, this.object);

  String toSql() {
    return "${field.toSql()} <= ${utils.objectToSql(object)}";
  }
}
