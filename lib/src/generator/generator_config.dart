library squilder.generator.generator_config;

import 'package:dapter/dapter.dart';

class GeneratorConfig {
  final AdapterConfig adapterConfig;
  final String output;
  final String library;

  GeneratorConfig(this.adapterConfig, this.output, this.library);

  factory GeneratorConfig.fromArgs(String dbType, String host, String user, String password, int port, String database, String output, String library) {
    var adapterConfig = new AdapterConfig(dbType: dbType, host: host, user: user, password: password, port: port, database: database);

    return new GeneratorConfig(adapterConfig, output, library);
  }
}
