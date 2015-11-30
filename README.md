# Squilder

A type-safe builder of SQL strings in Dart, heavily inspired by [JOOQ](http://www.jooq.org/).
It's currently super pre-alpha (i.e. I just started), so a lot of things could be missed.
Feel free to add them and send pull requests! :)

## Usage

You have to generate the schema classes first, so squilder could statically type-check your queries.
For that, you have to create a file (e.g. bin/schema_generator.dart) in your project, which will look something like this:

```dart
import 'package:sqljocky/sqljocky.dart';
import 'package:squilder/schema_generator.dart' as generator;

void main() {
  generator.generate(
      dbType: "mysql",
      host: "localhost",
      user: "root",
      password: "pass",
      port: 3306,
      database: "your_db",
      output: "dbschema.dart",
      library: "dbschema");
}
```

The reason why I make you to create your generator file instead of just providing a `pub run` task is because `squilder` doesn't depend on any database pub package (or any package at all).
So, it doesn't have any sqljocky, postgresql, etc dependencies in pubspec.yaml, therefore it cannot import these packages.

When you create a generator script, you put the import of the database driver you use, and then generator can use it and load it via mirrors.

After you created the script, run it with `dart bin/schema_generator.dart`, and it will create a file `dbschema.dart` with all the schema
classes generated from your database.

It will look something like this:

```dart
library dbschema;

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

And then you can import it and use it like this:


```dart
import 'dbschema.dart';
import 'package:squilder/squilder.dart';

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




