library squilder.test.select;

import 'package:squilder/squilder.dart';
import 'package:test/test.dart';
import 'support/tables.dart';

void main() {
  group('Select tests', () {
    Select base;
    String baseResponse;
    setUp(() {
      base = select([orders.f.id, orders.f.name]).from([orders]);
      baseResponse = "SELECT `orders`.`id`, `orders`.`name` FROM `orders`";
    });

    test('select from', () {
      expect(base.toSql(), "($baseResponse)");
    });

    test('where', () {
      var sql = base.where(orders.f.id.eqToObj(4));
      expect(sql.toSql(), "($baseResponse WHERE `orders`.`id` = 4)");
    });

    test('inner join', () {
      var sql = base.innerJoin(orderRecipients).on(orderRecipients.f.orderId.eqToField(orders.f.id));
      expect(sql.toSql(), "($baseResponse INNER JOIN `order_recipients` ON `order_recipients`.`order_id` = `orders`.`id`)");
    });

    test('left join', () {
      var sql = base.leftJoin(orderRecipients).on(orderRecipients.f.orderId.eqToField(orders.f.id));
      expect(sql.toSql(), "($baseResponse LEFT JOIN `order_recipients` ON `order_recipients`.`order_id` = `orders`.`id`)");
    });

    test('right join', () {
      var sql = base.rightJoin(orderRecipients).on(orderRecipients.f.orderId.eqToField(orders.f.id));
      expect(sql.toSql(), "($baseResponse RIGHT JOIN `order_recipients` ON `order_recipients`.`order_id` = `orders`.`id`)");
    });

    test('mixed joins', () {
      var sql = base
          .innerJoin(orderRecipients).on(orderRecipients.f.orderId.eqToField(orders.f.id))
          .leftJoin(orders).on(orders.f.id.eqToObj(8));
      expect(sql.toSql(), "($baseResponse INNER JOIN `order_recipients` ON `order_recipients`.`order_id` = `orders`.`id` LEFT JOIN `orders` ON `orders`.`id` = 8)");
    });

    test('order by', () {
      var sql = base.orderBy(orders.f.name, OrderModifier.ASC);
      expect(sql.toSql(), "($baseResponse ORDER BY `orders`.`name` ASC)");
    });

    test('group by', () {
      var sql = base.groupBy([orders.f.name, orders.f.id]);
      expect(sql.toSql(), "($baseResponse GROUP BY `orders`.`name`, `orders`.`id`)");
    });

    test('having', () {
      var sql = base.groupBy([orders.f.name, orders.f.id]).having(cond("foo = ?", ["bar"]));
      expect(sql.toSql(), "($baseResponse GROUP BY `orders`.`name`, `orders`.`id` HAVING foo = 'bar')");
    });

    test('limit and offset', () {
      var sql = base.limit(5).offset(8);
      expect(sql.toSql(), "($baseResponse LIMIT 5 OFFSET 8)");
    });

    test('union', () {
      var sql2 = select(orderRecipients.f.all).from([orderRecipients]).where(cond("foo = 1"));
      var sql = base.union(sql2);
      expect(sql.toSql(), "($baseResponse) UNION ${sql2.toSql()}");
    });
  });
}
