library squilder.table_fields;

import 'package:squilder/src/serializable.dart';
import 'package:squilder/src/table.dart';
import 'package:squilder/src/condition.dart';

abstract class TableFields {
  Iterable<TableField> get all;
}

class TableField<T> implements Serializable {
  final String name;
  final Table table;
  TableField(this.table, this.name);

  EqualFieldCondition<T> eqToField(TableField<T> field) {
    return new EqualFieldCondition<T>(this, field);
  }

  EqualObjectCondition<T> eqToObj(T obj) {
    return new EqualObjectCondition<T>(this, obj);
  }

  Condition like(String pattern) {
    return new LikeCondition(this, pattern);
  }

  String toSql() {
    return "${table.toSql()}.`${name}`";
  }
}


