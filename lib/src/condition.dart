library squilder.condition;

import 'package:squilder/src/serializable.dart';
import 'package:squilder/src/table_fields.dart';
import 'package:squilder/utils.dart' as utils;

part 'condition/and_condition_pair.dart';
part 'condition/or_condition_pair.dart';
part 'condition/equal_field_condition.dart';
part 'condition/equal_object_condition.dart';
part 'condition/like_condition.dart';
part 'condition/generic_condition.dart';
part 'condition/less_field_condition.dart';
part 'condition/less_equal_field_condition.dart';
part 'condition/greater_field_condition.dart';
part 'condition/greater_equal_field_condition.dart';
part 'condition/less_object_condition.dart';
part 'condition/less_equal_object_condition.dart';
part 'condition/greater_object_condition.dart';
part 'condition/greater_equal_object_condition.dart';

abstract class Condition implements Serializable {
  AndConditionPair and(Condition condition) {
    return new AndConditionPair(this, condition);
  }

  OrConditionPair or(Condition condition) {
    return new OrConditionPair(this, condition);
  }

  AndConditionPair andStr(String string, [Iterable params]) {
    return new AndConditionPair(this, new GenericCondition(string, params));
  }

  OrConditionPair orStr(String string, [Iterable params]) {
    return new OrConditionPair(this, new GenericCondition(string, params));
  }
}

