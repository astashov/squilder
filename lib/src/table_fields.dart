library squilder.table_fields;

import 'package:squilder/src/serializable.dart';
import 'package:squilder/src/table.dart';
import 'package:squilder/src/condition.dart';
import 'package:squilder/utils.dart' as utils;

abstract class TableFields {
  Iterable<TableField> get all;
}

class TableField<T> implements Serializable {
  final String name;
  final Table table;
  final String defaultValue;
  TableField(this.table, this.name, [this.defaultValue]);

  EqualFieldCondition<T> eqToField(TableField<T> field) {
    return new EqualFieldCondition<T>(this, field);
  }

  EqualObjectCondition<T> eqToObj(T obj) {
    return new EqualObjectCondition<T>(this, obj);
  }

  LessFieldCondition<T> ltField(TableField<T> field) {
    return new LessFieldCondition<T>(this, field);
  }

  LessObjectCondition<T> ltObj(T obj) {
    return new LessObjectCondition<T>(this, obj);
  }

  LessEqualFieldCondition<T> lteField(TableField<T> field) {
    return new LessEqualFieldCondition<T>(this, field);
  }

  LessEqualObjectCondition<T> lteObj(T obj) {
    return new LessEqualObjectCondition<T>(this, obj);
  }

  GreaterFieldCondition<T> gtField(TableField<T> field) {
    return new GreaterFieldCondition<T>(this, field);
  }

  GreaterObjectCondition<T> gtObj(T obj) {
    return new GreaterObjectCondition<T>(this, obj);
  }

  GreaterEqualFieldCondition<T> gteField(TableField<T> field) {
    return new GreaterEqualFieldCondition<T>(this, field);
  }

  GreaterEqualObjectCondition<T> gteObj(T obj) {
    return new GreaterEqualObjectCondition<T>(this, obj);
  }

  Condition like(String pattern) {
    return new LikeCondition(this, pattern);
  }

  String toSql() {
    return "${table.toSql()}.`${utils.escape(name)}`";
  }

  bool operator ==(other) {
    return other is TableField && other.name == name && other.table == table;
  }

  int get hashCode => name.hashCode ^ table.hashCode;
}


