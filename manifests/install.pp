# Class: zabbix_agent::install
#
# This class installs zabbix_agent
#
# == Variables
#
# Refer to zabbix_agent class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It's automatically included by zabbix_agent
#
class zabbix_agent::install {

  case $zabbix_agent::install {

    'package': {

      package { 'zabbix_agent':
        ensure   => $zabbix_agent::manage_package,
        name     => $zabbix_agent::package,
        provider => $zabbix_agent::real_package_provider,
      }
    }

    default: { }

  }

}
