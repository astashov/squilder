library squilder.utils;

String escape(String sql) {
  return sql;
}

String objectToSql(Object object) {
  if (object is num) {
    return escape(object.toString());
  } else {
    return "'${escape(object.toString())}'";
  }
}

