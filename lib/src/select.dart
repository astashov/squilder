library squilder.select;

import 'package:squilder/src/table_fields.dart';
import 'package:squilder/src/table.dart';
import 'package:squilder/src/condition.dart';
import 'package:squilder/src/step_interfaces.dart';
import 'package:squilder/src/serializable.dart';

SelectStep select(Iterable<TableField> fields) {
  return new Select._().select(fields);
}

class Select implements SelectStep, OffsetStep, JoinStep, OnStep {
  final Iterable<TableField> selectFields;
  final Iterable<Table> fromTables;
  final List<_JoinPair> joinPairs;
  final List<_OrderPair> orderPairs;
  final Iterable<TableField> groupFields;
  final Iterable<SelectStep> unionSelects;
  final Condition whereCondition;
  final Condition havingCondition;
  final int limitValue;
  final int offsetValue;

  Select._({
      Iterable<TableField> selectFields,
      Iterable<Table> fromTables,
      List<_JoinPair> joinPairs,
      List<_OrderPair> orderPairs,
      Iterable<TableField> groupFields,
      Iterable<SelectStep> unionSelects,
      this.whereCondition,
      this.havingCondition,
      this.limitValue,
      this.offsetValue}) :
      this.joinPairs = joinPairs != null ? joinPairs : [],
      this.orderPairs = orderPairs != null ? orderPairs : [],
      this.selectFields = selectFields != null ? selectFields : [],
      this.unionSelects = unionSelects != null ? unionSelects : [],
      this.fromTables = fromTables != null ? fromTables : [],
      this.groupFields = groupFields != null ? groupFields : [];

  Select update({
      Iterable<TableField> selectFields,
      Iterable<Table> fromTables,
      List<_JoinPair> joinPairs,
      List<_OrderPair> orderPairs,
      Iterable<TableField> groupFields,
      Iterable<SelectStep> unionSelects,
      Condition whereCondition,
      Condition havingCondition,
      int limitValue,
      int offsetValue}) {
    return new Select._(
        selectFields: selectFields != null ? selectFields : this.selectFields,
        fromTables: fromTables != null ? fromTables : this.fromTables,
        whereCondition: whereCondition != null ? whereCondition : this.whereCondition,
        joinPairs: joinPairs != null ? joinPairs : this.joinPairs,
        orderPairs: orderPairs != null ? orderPairs : this.orderPairs,
        groupFields: groupFields != null ? groupFields : this.groupFields,
        unionSelects: unionSelects != null ? unionSelects : this.unionSelects,
        havingCondition: havingCondition != null ? havingCondition : this.havingCondition,
        limitValue: limitValue != null ? limitValue : this.limitValue,
        offsetValue: offsetValue != null ? offsetValue : this.offsetValue);
  }

  FromStep from(Iterable<Table> tables) {
    return update(fromTables: []..addAll(this.fromTables)..addAll(tables));
  }

  WhereStep where(Condition condition) {
    return update(whereCondition: (whereCondition != null ? whereCondition.and(condition) : condition));
  }

  String toSql() {
    final selectFieldsString = selectFields.map((f) => f.toSql()).join(", ");
    final tablesString = fromTables.map((t) => t.toSql()).join(", ");
    var thisSql = "(SELECT ${selectFieldsString} FROM ${tablesString}" +
      (joinPairs.isNotEmpty ? " ${joinPairs.map((t) => t.toSql()).join(", ")}" : "") +
      (whereCondition != null ? " WHERE ${whereCondition.toSql()}" : "") +
      (groupFields.isNotEmpty ? " GROUP BY ${groupFields.map((f) => f.toSql()).join(', ')}" : "") +
      (havingCondition != null ? " HAVING ${havingCondition.toSql()}" : "") +
      (orderPairs.isNotEmpty ? " ORDER BY ${orderPairs.map((op) => op.toSql()).join(', ')}" : "") +
      (limitValue != null ? " LIMIT $limitValue}" : "") +
      (offsetValue != null ? " OFFSET $offsetValue}" : "") + ")";
    var sqls = [thisSql]..addAll(unionSelects.map((us) => us.toSql()));
    return sqls.join(" UNION ");
  }

  SelectStep select(Iterable<TableField> fields) {
    return update(selectFields: []..addAll(this.selectFields)..addAll(fields));
  }

  OnStep innerJoin(Table table) {
    return _join(JoinType.innerJoin, table);
  }

  OnStep leftJoin(Table table) {
    return _join(JoinType.leftJoin, table);
  }

  OnStep rightJoin(Table table) {
    return _join(JoinType.rightJoin, table);
  }

  OnStep _join(JoinType type, Table table) {
    var joinPair = new _JoinPair(type, table, null);
    var newJoinPairs = []..addAll(joinPairs)..add(joinPair);
    return update(joinPairs: newJoinPairs);
  }

  JoinStep on(Condition condition) {
    var joinPair = joinPairs.last.update(condition: condition);
    var newJoinPairs = []..addAll(joinPairs);
    newJoinPairs[newJoinPairs.length - 1] = joinPair;
    return update(joinPairs: newJoinPairs);
  }

  OrderByStep union(SelectStep select) {
    return update(unionSelects: []..addAll(unionSelects)..add(select));
  }

  OffsetStep limit(int number){
    return update(limitValue: number);
  }

  OrderByStep orderBy(TableField field, OrderModifier modifier) {
    return update(orderPairs: []..addAll(orderPairs)..add(new _OrderPair(field, modifier)));
  }

  HavingStep having(Condition condition){
    return update(havingCondition: condition);
  }

  GroupByStep groupBy(Iterable<TableField> fields){
    return update(groupFields: []..addAll(groupFields)..addAll(fields));
  }

  UnionStep offset(int offset){
    return update(offsetValue: offset);
  }
}

class _JoinPair {
  final JoinType type;
  final Table table;
  final Condition condition;

  _JoinPair(this.type, this.table, this.condition);

  _JoinPair update({JoinType type, Table table, Condition condition}) {
    return new _JoinPair(
        type != null ? type : this.type,
        table != null ? table : this.table,
        condition != null ? condition : this.condition);
  }

  String toSql() {
    return "${type.toSql()} ${table.toSql()} ON ${condition.toSql()}";
  }
}

class _OrderPair implements Serializable {
  final TableField field;
  final OrderModifier modifier;

  _OrderPair(this.field, this.modifier);

  String toSql() {
    return "${field.toSql()} ${modifier.toSql()}";
  }
}
