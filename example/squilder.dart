library squilder.example;

import 'package:squilder/squilder.dart';

class OrderTable extends Table {
  String get name => "orders";

  OrderTableFields _f;
  OrderTableFields get f => _f;

  OrderTable() {
    _f = new OrderTableFields(this);
  }
}


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

void main() {
  final orders = new OrderTable();
  final sql = select(orders.f.all).from([orders]).where(orders.f.id.eqToObj(5).and(orders.f.name.like("%blah%"))).toSql();
  var a = select(orders.f.all).where(orders.f.id.eqToObj(5));
  final sql2 = select(orders.f.all).where(orders.f.id.eqToObj(5).and(orders.f.name.like("%blah%"))).toSql();
  print(sql);
  print(sql2);
}
