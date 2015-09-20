library squilder.delete_interfaces;

import 'package:squilder/src/serializable.dart';
import 'package:squilder/src/condition.dart';


abstract class DeleteWhereStep implements DeleteFinalStep {
  DeleteWhereStep where(Condition condition);
}

abstract class DeleteFinalStep implements Serializable {
}
