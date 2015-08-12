library squilder.context;

import 'package:squilder/src/step_interfaces.dart';
import 'package:squilder/src/table_fields.dart';
import 'package:squilder/src/select.dart';

class Context {
  SelectStep select(Iterable<TableField> fields) {
    return new Select().addSelectFields(fields);
  }
}

