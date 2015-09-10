// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library squilder.test;

import 'package:squilder/squilder.dart';
import 'package:test/test.dart';


class OrderTable extends Table {
  String get name => "orders";

  OrderTableFields _f;
  OrderTableFields get f => _f;

  OrderTable() {
    _f = new OrderTableFields(this);
  }
}

final orders = new OrderTable();

class OrderTableFields extends TableFields {
  TableField<int> _id;
  TableField<int> get id => _id;

  TableField<String> _name;
  TableField<String> get name => _name;

  Iterable<TableField> get all => [id, name];

  OrderTableFields(Table table) {
    _id = new TableField<int>(table, "id");
    _name = new TableField<String>(table, "name");
  }
}

class OrderRecipientsTable extends Table {
  String get name => "order_recipients";

  OrderRecipientsFields _f;
  OrderRecipientsFields get f => _f;

  OrderRecipientsTable() {
    _f = new OrderRecipientsFields(this);
  }
}

final orderRecipients = new OrderRecipientsTable();

class OrderRecipientsFields extends TableFields {
  TableField<int> _id;
  TableField<int> get id => _id;

  TableField<String> _name;
  TableField<String> get name => _name;

  TableField<int> _orderId;
  TableField<int> get orderId => _orderId;

  Iterable<TableField> get all => [id, name, orderId];

  OrderRecipientsFields(Table table) {
    _id = new TableField<int>(table, "id");
    _name = new TableField<String>(table, "name");
    _orderId = new TableField<int>(table, "order_id");
  }
}

void main() {
  group('A group of tests', () {

    setUp(() {

    });

    test('select Test', () {
      String sql = select(orders.f.all)
          .from([orders])
          .innerJoin(orderRecipients).on(orders.f.id.eqToField(orderRecipients.f.orderId))
          .where(orders.f.id.eqToObj(5).and(orders.f.name.like("%blah%")))
          .union(select(orders.f.all).from([orders]).where(orders.f.id.eqToObj(6)))
          .toSql();
      print(sql);
      expect(true, isTrue);
    });

    test('insertInto Test', () {
      String sql = insertInto(orderRecipients, [orderRecipients.f.name, orderRecipients.f.orderId])
          .values(["new", 5])
          .onDuplicateKeyUpdate()
          .setObj(orderRecipients.f.name, "default")
          .setObj(orderRecipients.f.orderId, 6)
          .toSql();
      print(sql);
      expect(true, isTrue);
    });
  });
}
