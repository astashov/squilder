library squilder.table;

import 'package:squilder/src/serializable.dart';
import 'package:squilder/src/table_fields.dart';
import 'package:squilder/utils.dart' as utils;

abstract class Table implements Serializable {
  String get name;
  TableFields get f;

  String toSql() {
    return "`${utils.escape(name)}`";
  }
}