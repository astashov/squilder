library squilder.adapters.mysql;

import 'dart:async';
import 'dart:mirrors';
import 'package:squilder/src/generator/adapter.dart';
import 'package:squilder/src/generator/generator_config.dart';

class MysqlAdapter extends Adapter {
  final ClassMirror _connectionPool = _library.declarations[const Symbol('ConnectionPool')];

  dynamic _pool;

  MysqlAdapter(GeneratorConfig config) {
    _pool = _connectionPool.newInstance(const Symbol(''), [], {
        const Symbol("host"): config.host,
        const Symbol("port"): config.port,
        const Symbol("user"): config.user,
        const Symbol("password"): config.password,
        const Symbol("db"): config.database}).reflectee;
  }

  Future<Null> close() {
    return _pool.closeConnectionsNow();
  }

  Future<List> query(String sql) async {
    var result = await (await _pool.query(sql)).toList();
    return result;
  }
}

LibraryMirror __library;
LibraryMirror get _library {
  if (__library == null) {
    try {
      __library = currentMirrorSystem().findLibrary(const Symbol('sqljocky'));
    } catch (_) {
      throw "Can't find library 'sqljocky'";
    }
  }
  return __library;
}
