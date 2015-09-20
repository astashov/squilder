library squilder.generator.generator_config;

enum DbType { mysql, postgresql }

class GeneratorConfig {
  final DbType dbType;
  final String host;
  final String user;
  final String password;
  final int port;
  final String database;
  final String output;
  final String library;

  GeneratorConfig(this.dbType, this.host, this.user, this.password, this.port, this.database, this.output, this.library);

  factory GeneratorConfig.fromArgs(String dbType, String host, String user, String password, int port, String database, String output, String library) {
    if (database == null) {
      throw "You must specify the 'database' option with the database name\n";
    }

    DbType type;
    if (dbType == "mysql") {
      type = DbType.mysql;
    } else if (dbType == "postgresql") {
      type = DbType.postgresql;
    } else {
      throw "Unknown database type $dbType";
    }

    return new GeneratorConfig(
        type,
        host,
        user,
        password,
        port,
        database,
        output,
        library);
  }
}
