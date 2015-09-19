library squilder.delete_interfaces;

import 'package:squilder/src/serializable.dart';
import 'package:squilder/src/table_fields.dart';
import 'package:squilder/src/table.dart';
import 'package:squilder/src/condition.dart';


abstract class DeleteWhereStep implements DeleteFinalStep {
  DeleteWhereStep where(Condition condition);
}

abstract class DeleteFinalStep implements Serializable {
}
