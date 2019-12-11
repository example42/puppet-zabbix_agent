# Class: zabbix_agent::dependencies
#
# This class installs zabbix_agent prerequisites
#
# == Variables
#
# Refer to zabbix_agent class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It's automatically included by default in zabbix_agent by the parameter
# dependency_class. You may provide an alternative class name to
# provide the same resources (eventually not using Example42 modules)
#
class zabbix_agent::dependencies {

  if $zabbix_agent::install != 'package' {

    case $::kernel {
      'Linux': {
        file { "/etc/init.d/${zabbix_agent::service}":
          ensure  => file,
          mode    => '0755',
          owner   => 'root',
          group   => 'root',
          content => template($zabbix_agent::init_script_template),
          before  => Class['zabbix_agent::service'],
        }
      }
      default: {
      }
    }
  }
}
