# Class: zabbix_agent::service
#
# This class manages zabbix_agent service
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
class zabbix_agent::service {

  case $zabbix_agent::install {

    package: {
      service { 'zabbix_agent':
        ensure     => $zabbix_agent::manage_service_ensure,
        name       => $zabbix_agent::service,
        enable     => $zabbix_agent::manage_service_enable,
        hasstatus  => $zabbix_agent::service_status,
        pattern    => $zabbix_agent::process,
        noop       => $zabbix_agent::bool_noops,
      }
    }

    source,puppi: {
      service { 'zabbix_agent':
        ensure     => $zabbix_agent::manage_service_ensure,
        name       => $zabbix_agent::service,
        enable     => $zabbix_agent::manage_service_enable,
        hasstatus  => $zabbix_agent::service_status,
        pattern    => $zabbix_agent::process,
        noop       => $zabbix_agent::bool_noops,
        provider   => 'init',
      }
    }

    default: { }

  }

}
