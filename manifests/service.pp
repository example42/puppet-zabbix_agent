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

  service { 'zabbix_agent':
    ensure     => $zabbix_agent::manage_service_ensure,
    name       => $zabbix_agent::service,
    enable     => $zabbix_agent::manage_service_enable,
    hasstatus  => $zabbix_agent::service_status,
    pattern    => $zabbix_agent::process,
    provider   => $zabbix_agent::service_provider,
  }

}
