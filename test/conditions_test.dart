library squilder.test.conditions;

import 'package:squilder/squilder.dart';
import 'package:test/test.dart';
import 'support/tables.dart';

void main() {
  group('Conditions tests', () {
    test('equal object', () {
      var cond = new EqualObjectCondition(orders.f.id, "blah");
      expect(cond.toSql(), "`orders`.`id` = 'blah'");
    });

    test('equal field', () {
      var cond = new EqualFieldCondition(orders.f.id, orders.f.name);
      expect(cond.toSql(), "`orders`.`id` = `orders`.`name`");
    });

    test('generic', () {
      var cond = new GenericCondition("foo = bar");
      expect(cond.toSql(), "foo = bar");
    });

    test('greater equal field condition', () {
      var cond = new GreaterEqualFieldCondition(orders.f.id, orders.f.name);
      expect(cond.toSql(), "`orders`.`id` >= `orders`.`name`");
    });

    test('greater field condition', () {
      var cond = new GreaterFieldCondition(orders.f.id, orders.f.name);
      expect(cond.toSql(), "`orders`.`id` > `orders`.`name`");
    });

    test('less field condition', () {
      var cond = new LessFieldCondition(orders.f.id, orders.f.name);
      expect(cond.toSql(), "`orders`.`id` < `orders`.`name`");
    });

    test('less equal field condition', () {
      var cond = new LessEqualFieldCondition(orders.f.id, orders.f.name);
      expect(cond.toSql(), "`orders`.`id` <= `orders`.`name`");
    });

    test('greater equal object condition', () {
      var cond = new GreaterEqualObjectCondition(orders.f.id, "blah");
      expect(cond.toSql(), "`orders`.`id` >= 'blah'");
    });

    test('greater object condition', () {
      var cond = new GreaterObjectCondition(orders.f.id, "blah");
      expect(cond.toSql(), "`orders`.`id` > 'blah'");
    });

    test('less object condition', () {
      var cond = new LessObjectCondition(orders.f.id, "blah");
      expect(cond.toSql(), "`orders`.`id` < 'blah'");
    });

    test('less equal object condition', () {
      var cond = new LessEqualObjectCondition(orders.f.id, "blah");
      expect(cond.toSql(), "`orders`.`id` <= 'blah'");
    });

    test('and condition', () {
      var cond = new AndConditionPair(
          new EqualObjectCondition(orders.f.id, "blah"),
          new EqualFieldCondition(orders.f.id, orders.f.name));

      expect(cond.toSql(), "(`orders`.`id` = 'blah' AND `orders`.`id` = `orders`.`name`)");
    });

    test('or condition', () {
      var cond = new OrConditionPair(
          new EqualObjectCondition(orders.f.id, "blah"),
          new EqualFieldCondition(orders.f.id, orders.f.name));

      expect(cond.toSql(), "(`orders`.`id` = 'blah' OR `orders`.`id` = `orders`.`name`)");
    });

    test('like condition', () {
      var cond = new LikeCondition(orders.f.name, "%FO'O%");
      expect(cond.toSql(), "`orders`.`name` LIKE '%FO\\'O%'");
    });
  });
}
