library squilder.test.support.tables;

import 'package:squilder/squilder.dart';

class OrderTable extends Table {
  String get name => "orders";

  OrderTableFields _f;
  OrderTableFields get f => _f;

  TableField<int> get primaryKey => f.id;

  OrderTable() {
    _f = new OrderTableFields(this);
  }
}

final OrderTable orders = new OrderTable();

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

  TableField<int> get primaryKey => f.id;

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

