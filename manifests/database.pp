# == Class: rsyslog::database
#
# Full description of class role here.
#
# === Parameters
#
# [*backend*]  - Which backend server to use (mysql|pgsql)
# [*server*]   - Server hostname
# [*database*] - Database name
# [*username*] - Database username
# [*password*] - Database password
#
# === Variables
#
# === Examples
#
#  class { 'rsyslog::database':
#    backend  => 'mysql',
#    server   => 'localhost',
#    database => 'mydb',
#    username => 'myuser',
#    password => 'mypass',
#  }
#
class rsyslog::database (
  $backend,
  $server,
  $database,
  $username,
  $password
) inherits rsyslog {

  $db_module = "om${backend}"
  $db_conf = "${backend}.conf"

  case $backend {
    mysql: { $db_package = $rsyslog::mysql_package_name }
    pgsql: { $db_package = $rsyslog::pgsql_package_name }
    default: { fail("Unsupported backend: ${backend}. Only MySQL (mysql) and PostgreSQL (pgsql) are supported.") }
  }

  package { $db_package:
    ensure => $rsyslog::package_status,
    before => Rsyslog::Snippet[$db_conf],
  }

  rsyslog::snippet { $db_conf:
    ensure    => present,
    file_mode => '0600',
    content   => template("${module_name}/database.conf.erb"),
  }

}
