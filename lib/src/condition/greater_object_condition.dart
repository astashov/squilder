part of squilder.condition;

class GreaterObjectCondition<T> extends Object with Condition {
  final TableField<T> field;
  final T object;

  GreaterObjectCondition(this.field, this.object);

  String toSql() {
    return "${field.toSql()} > ${utils.objectToSql(object)}";
  }
}
