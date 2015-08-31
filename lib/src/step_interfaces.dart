library squilder.step_interfaces;

import 'package:squilder/src/table.dart';
import 'package:squilder/src/condition.dart';
import 'package:squilder/src/serializable.dart';
import 'package:squilder/src/table_fields.dart';


class JoinType implements Serializable {
  static const JoinType innerJoin = const JoinType("INNER JOIN");
  static const JoinType leftJoin = const JoinType("LEFT JOIN");
  static const JoinType rightJoin = const JoinType("RIGHT JOIN");
  final String value;

  const JoinType(this.value);

  String toSql() => value;
  String toString() => value;
}

class OrderModifier implements Serializable {
  static const OrderModifier ASC = const OrderModifier("ASC");
  static const OrderModifier DESC = const OrderModifier("DESC");
  final String value;

  const OrderModifier(this.value);

  String toSql() => value;
  String toString() => value;
}

abstract class SelectStep extends FromStep {
  SelectStep select(Iterable<TableField> fields);
}

abstract class FromStep extends JoinStep {
  SelectStep from(Iterable<Table> tables);
}

abstract class JoinStep extends WhereStep {
  OnStep innerJoin(Table table);
  OnStep leftJoin(Table table);
  OnStep rightJoin(Table table);
}

abstract class OnStep {
  JoinStep on(Condition condition);
}

abstract class WhereStep extends GroupByStep {
  WhereStep where(Condition condition);
}

abstract class GroupByStep extends HavingStep {
  GroupByStep groupBy(Iterable<TableField> fields);
}

abstract class HavingStep extends OrderByStep {
  HavingStep having(Condition condition);
}

abstract class OrderByStep extends LimitStep {
  OrderByStep orderBy(TableField field, OrderModifier orderModifier);
}

abstract class LimitStep extends UnionStep {
  OffsetStep limit(int number);
}

abstract class OffsetStep extends UnionStep {
  UnionStep offset(int offset);
}

abstract class UnionStep extends FinalStep {
  OrderByStep union(SelectStep select);
}

abstract class FinalStep implements Serializable {
}
