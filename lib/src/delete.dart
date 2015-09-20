library squilder.delete;

import 'package:squilder/src/table.dart';
import 'package:squilder/src/condition.dart';
import 'package:squilder/src/delete_interfaces.dart';

DeleteWhereStep delete(Table table) {
  return new Delete._(table: table);
}

class Delete implements DeleteWhereStep {
  final Table table;
  final Condition whereCondition;

  Delete._({
      this.table,
      this.whereCondition});

  Delete _update({
      Table table,
      Condition whereCondition}) {
    return new Delete._(
        table: table ?? this.table,
        whereCondition: whereCondition ?? this.whereCondition);
  }

  String toSql() {
    var sql = "DELETE FROM ${table.toSql()}";
    if (whereCondition != null) {
      sql += " WHERE ${whereCondition.toSql()}";
    }
    return sql;
  }

  DeleteWhereStep where(Condition condition) {
    return _update(whereCondition: (whereCondition != null ? whereCondition.and(condition) : condition));
  }
}
