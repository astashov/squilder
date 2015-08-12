library squilder.select;

import 'package:squilder/src/table_fields.dart';
import 'package:squilder/src/table.dart';
import 'package:squilder/src/condition.dart';
import 'package:squilder/src/step_interfaces.dart';

class Select implements SelectStep, FromStep, WhereStep, JoinStep, ConditionStep, FinalStep {
  final Iterable<TableField> selectFields;
  final Iterable<Table> fromTables;
  final Condition whereCondition;

  Select({
      Iterable<TableField> selectFields,
      Iterable<Table> fromTables,
      this.whereCondition}) :
      this.selectFields = selectFields != null ? selectFields : [],
      this.fromTables = fromTables != null ? fromTables : [];

  Select update({
      Iterable<TableField> selectFields,
      Iterable<Table> fromTables,
      Condition whereCondition}) {
    return new Select(
        selectFields: selectFields != null ? selectFields : this.selectFields,
        fromTables: fromTables != null ? fromTables : this.fromTables,
        whereCondition: whereCondition != null ? whereCondition : this.whereCondition);
  }

  Select addSelectFields(Iterable<TableField> selectFields) {
    return update(selectFields: []..addAll(this.selectFields)..addAll(selectFields));
  }

  FromStep from(Iterable<Table> tables) {
    return update(fromTables: tables);
  }

  WhereStep where(Condition condition) {
    return update(whereCondition: (whereCondition != null ? whereCondition.and(condition) : condition));
  }

  String toSql() {
    final selectFieldsString = selectFields.map((f) => f.toSql()).join(", ");
    final tablesString = fromTables.map((t) => t.toSql()).join(", ");
    return "SELECT ${selectFieldsString} FROM ${tablesString} WHERE ${whereCondition.toSql()}";
  }
}
