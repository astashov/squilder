library squilder.insert_into;

import 'package:squilder/src/table_fields.dart';
import 'package:squilder/src/table.dart';
import 'package:squilder/src/condition.dart';
import 'package:squilder/src/insert_interfaces.dart';
import 'package:squilder/src/serializable.dart';
import 'package:squilder/utils.dart';

InsertSetStep insertInto(Table table, Iterable<TableField> fields) {
  return new InsertInto._(intoTable: table, fields: fields);
}

class InsertInto implements InsertValuesStep, InsertSetStep, InsertOnDuplicateSetStep, InsertOnDuplicateSetMoreStep {
  final Table intoTable;
  final Iterable<TableField> fields;
  final Iterable _values;
  final Iterable<Condition> _onDuplicateKeyUpdate;

  InsertInto._({
      this.intoTable,
      this.fields,
      Iterable values,
      bool onDuplicateKeyIgnore: false,
      Iterable<Condition> onDuplicateKeyUpdate}) :
      this._values = values,
      this._onDuplicateKeyUpdate = onDuplicateKeyUpdate;

  InsertInto _update({
      Table intoTable,
      Iterable<TableField> fields,
      Iterable values,
      Iterable<Condition> onDuplicateKeyUpdate}) {
    return new InsertInto._(
        intoTable: intoTable ?? this.intoTable,
        fields: fields ?? this.fields,
        values: values ?? this._values,
        onDuplicateKeyUpdate: onDuplicateKeyUpdate ?? this._onDuplicateKeyUpdate);
  }

  String toSql() {
    var sql = "INSERT INTO ${intoTable.toSql()} (${this.fields.map((f) => f.toSql()).join(", ")}) ";
    var values = this._values.map((Object v) => v is Serializable ? v.toSql() : objectToSql(v));
    sql += "VALUES (${values.join(", ")})";
    if (_onDuplicateKeyUpdate != null && _onDuplicateKeyUpdate.isNotEmpty) {
      sql += " ON DUPLICATE KEY UPDATE ${_onDuplicateKeyUpdate.map((c) => c.toSql()).join(", ")}";
    }
    return sql;
  }

  InsertOnDuplicateSetMoreStep setField(TableField field, TableField anotherField) {
    var condition = new EqualFieldCondition(field, anotherField);
    return _update(onDuplicateKeyUpdate: []..addAll(this._onDuplicateKeyUpdate)..add(condition));
  }

  InsertOnDuplicateSetMoreStep setObj(TableField field, Object object){
    var condition = new EqualObjectCondition(field, object);
    return _update(onDuplicateKeyUpdate: []..addAll(this._onDuplicateKeyUpdate)..add(condition));
  }

  InsertOnDuplicateSetStep onDuplicateKeyUpdate() {
    return _update(onDuplicateKeyUpdate: []);
  }

  InsertValuesStep values(Iterable values) {
    return _update(values: []..addAll(this._values ?? [])..addAll(values));
  }
}
