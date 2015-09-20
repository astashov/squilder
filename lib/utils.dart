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

final _camelizeMatcher = new RegExp(r"[\s_-]+");
final _capitalizeMatcher = new RegExp(r"([\s]+|^)(.)");
String _capitalizeMatch(Match match) => match[1] + match[2].toUpperCase();

/// Converts a string that has spaces, underscores or dashes into a camelized string.
///
/// If [capitalizeFirst] is passed, the first letter is also capitalized. If the
/// string contains any whitespace, it's removed.
String camelize(String string, {bool capitalizeFirst: false}) {
  if (string != null && string.isNotEmpty) {
    var words = string.split(_camelizeMatcher).map((word) => word.trim());
    var capitalized = words.map(capitalize);

    if (capitalizeFirst) {
      return capitalized.join("");
    } else {
      return (words.take(1).toList()..addAll(capitalized.skip(1))).join("");
    }
  } else {
    return string;
  }
}

/// Capitalizes the first non-whitespace character in a string.
String capitalize(String string) {
  if (string != null) {
    return string.replaceFirstMapped(_capitalizeMatcher, _capitalizeMatch);
  } else {
    return string;
  }
}

