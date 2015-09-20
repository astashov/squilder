library squilder.update;

import 'package:squilder/src/table_fields.dart';
import 'package:squilder/src/table.dart';
import 'package:squilder/src/condition.dart';
import 'package:squilder/src/update_interfaces.dart';

UpdateSetFirstStep update(Table table) {
  return new Update._(table: table);
}

class Update implements UpdateSetFirstStep, UpdateSetMoreStep {
  final Table table;
  final Iterable<Condition> sets;
  final Condition whereCondition;

  Update._({
      this.table,
      this.whereCondition,
      this.sets});

  Update _update({
      Table table,
      Condition whereCondition,
      Iterable<Condition> sets}) {
    return new Update._(
        table: table ?? this.table,
        whereCondition: whereCondition ?? this.whereCondition,
        sets: sets ?? this.sets);
  }

  String toSql() {
    var sql = "UPDATE ${table.toSql()} SET ";
    sql += sets.map((c) => c.toSql()).join(", ");
    if (whereCondition != null) {
      sql += " WHERE (${whereCondition.toSql()})";
    }
    return sql;
  }

  UpdateSetMoreStep setField(TableField field, TableField anotherField) {
    var condition = new EqualFieldCondition(field, anotherField);
    return _update(sets: []..addAll(this.sets ?? [])..add(condition));
  }

  UpdateSetMoreStep setObj(TableField field, Object object){
    var condition = new EqualObjectCondition(field, object);
    return _update(sets: []..addAll(this.sets ?? [])..add(condition));
  }

  UpdateWhereStep where(Condition condition) {
    return _update(whereCondition: (whereCondition != null ? whereCondition.and(condition) : condition));
  }
}
