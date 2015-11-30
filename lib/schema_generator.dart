library squilder.schema_generator;

import 'dart:io';
import 'dart:async';
import 'package:squilder/utils.dart';
import 'package:squilder/src/generator/generator_config.dart';
import 'package:dapter/dapter.dart';

class _Field {
  final String name;
  final String type;
  final bool isNull;
  final String key;
  final dynamic defaultValue;
  final String extra;
  _Field(this.name, this.type, this.isNull, this.key, this.defaultValue, this.extra);

  String toString() {
    return "<_Field name: $name, type: $type, isNull: $isNull, key: $key, defaultValue: $defaultValue, extra: $extra>";
  }

  String get dartType {
    if (type.startsWith(new RegExp(r"(tiny|small|medium|big)?int"))) {
      return "int";
    } else if (type.startsWith(new RegExp(r"(tiny|small|medium|big)?blob"))) {
      return "List<int>";
    } else if (type.startsWith("varchar") || type.startsWith(new RegExp(r"(tiny|small|medium|big)?text")) || type.startsWith("char")) {
      return "String";
    } else if (type.startsWith("date") || type.startsWith("timestamp")) {
      return "DateTime";
    } else if (type.startsWith("decimal")) {
      return "double"; // for now
    } else if (type.startsWith("float") || type.startsWith("double")) {
      return "double";
    } else {
      throw "Unknown type $type";
    }
  }

  String get camelizedName => camelize(name);
}

String _generateCodeForFieldDeclarations(Iterable<_Field> fields, {int shift: 2}) {
  return fields.map((field) {
    return """TableField<${field.dartType}> _${field.camelizedName};
${" " * shift}TableField<${field.dartType}> get ${field.camelizedName} => _${field.camelizedName};""";
  }).join("\n\n${" " * shift}");
}

String sqlValueToDart(Object value) {
  if (value is num) {
    return "$value";
  } else if (value == "NULL" || value == null) {
    return "null";
  } else {
    return "\"$value\"";
  }
}

String _generateCodeForFieldInitializations(Iterable<_Field> fields, {int shift: 2}) {
  return fields.map((field) {
    return """_${field.camelizedName} = new TableField<${field.dartType}>(table, "${field.name}", ${sqlValueToDart(field.defaultValue)});""";
  }).join("\n${" " * shift}");
}

String _generateCodeForTable(String tableName, Iterable<_Field> fields) {
  var tableClass = "${camelize(tableName, capitalizeFirst: true)}Table";
  var fieldsClass = "${tableClass}Fields";
  var tableNameVar = camelize(tableName);
  var primaryKeyField = fields.firstWhere((f) => f.name == "id", orElse: () => fields.first);
  var allFields = fields.map((f) => f.camelizedName).join(", ");
  return """class $tableClass extends Table {
  String get name => "$tableName";

  $fieldsClass _f;
  $fieldsClass get f => _f;

  TableField<${primaryKeyField.dartType}> get primaryKey => f.${primaryKeyField.camelizedName};

  $tableClass() {
    _f = new $fieldsClass(this);
  }
}

final $tableClass $tableNameVar = new $tableClass();

class $fieldsClass extends TableFields {
  ${_generateCodeForFieldDeclarations(fields, shift: 2)}

  Iterable<TableField> get all => [$allFields];

  $fieldsClass($tableClass table) {
    ${_generateCodeForFieldInitializations(fields, shift: 4)};
  }
}""";
}

Future<Null> generate({
    String dbType: "mysql",
    String host: "localhost",
    String user: "root",
    String password,
    int port: 3306,
    String database,
    String output: "dbschema.dart",
    String library: "dbschema"}) async {
  var config = new GeneratorConfig.fromArgs(dbType, host, user, password, port, database, output, library);

  Adapter db = new Adapter.build(config.adapterConfig);
  var tableNames = (await db.query("SHOW TABLES")).map((r) => r[0]);
  var code = new StringBuffer();
  code.write("""library ${config.library};

import 'package:squilder/squilder.dart';

""");
  for (var tableName in tableNames) {
    var results = await db.query("DESCRIBE $tableName");
    var fields = results.map((result) {
      return new _Field(result[0], result[1].toString(), result[2] == "YES", result[3], result[4], result[5].toString());
    });
    code.writeln(_generateCodeForTable(tableName, fields));
  }
  new File(config.output).writeAsStringSync(code.toString());
  db.close();
}
