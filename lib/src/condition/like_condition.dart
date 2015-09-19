part of squilder.condition;


class LikeCondition extends Object with Condition {
  final TableField field;
  final String pattern;

  LikeCondition(this.field, this.pattern);

  String toSql() {
    return "${field.toSql()} LIKE ${utils.objectToSql(utils.escape(pattern))}";
  }
}

