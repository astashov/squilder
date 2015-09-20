library squilder.adapter;

import 'dart:async';

abstract class Adapter {
  Future<List> query(String sql);
  Future<Null> close();
}
