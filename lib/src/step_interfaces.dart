library squilder.step_interfaces;

import 'package:squilder/src/table.dart';
import 'package:squilder/src/condition.dart';
import 'package:squilder/src/serializable.dart';

abstract class SelectStep {
  SelectStep from(Iterable<Table> tables);
}

abstract class FromStep extends JoinStep {
  WhereStep where(Condition condition);
}

abstract class WhereStep implements Serializable {
}

abstract class JoinStep extends WhereStep {
}

abstract class ConditionStep {
}

abstract class FinalStep {
}
