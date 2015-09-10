# Squilder

A type-safe builder of SQL strings in Dart, heavingly inspired by [JOOQ](http://www.jooq.org/).
It's currently super pre-alpha (i.e. I just started), so a lot of things could be missed.
Feel free to add them and send pull requests! :)

## Usage

You have to create a bunch of classes to get started. Hopefully I can fix it later with automatic code generation
from a database schema, but for now you have to specify them manually. Like this:

```dart
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

final orders = new OrderTable();
```

And then you could use them like this:


```dart
void main() {
  String selectString = select(orders.f.all)
      .from([orders])
      .where(orders.f.id.eqToObj(5).and(orders.f.name.like("%blah%")))
      .toSql();
  print(selectString);

  String insertString = insertInto(orders, [orders.f.name]).values(["New one"]).toSql();
  print(insertString);
}
```

## Contribution

I welcome any contributions, please send me Pull Requests with missing features,
I'll be happy to look through them and merge them.

If you feel altruist, and just want to help, that's great! Have a look at
[Github Issues](https://github.com/astashov/squilder/issues), there should be a plenty of opened issues,
just choose the unassigned ones and hack them!




