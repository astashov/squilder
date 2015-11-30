library squilder.table;

import 'package:squilder/src/serializable.dart';
import 'package:squilder/src/table_fields.dart';
import 'package:squilder/utils.dart' as utils;

abstract class Table implements Serializable {
  String get name;
  TableFields get f;

  TableField get primaryKey;

  String toSql() {
    return "`${utils.escape(name)}`";
  }

  bool operator ==(other) {
    return other is Table && other.name == name;
  }

  int get hashCode => name.hashCode;
}