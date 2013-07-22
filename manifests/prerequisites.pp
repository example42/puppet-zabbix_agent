# Class: zabbix_agent::prerequisites
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
# It's automatically included by zabbix_agent if the parameter
# install_prerequisites is set to true
# Note: This class may contain resources available on the
# Example42 modules set
#
class zabbix_agent::prerequisites {

  if $zabbix_agent::install != 'package' {

  case $::kernel {
    file { "/etc/init.d/zabbix_agent":
      ensure  => present,
      mode    => 0755,
      owner   => 'root',
      group   => 'root',
      content => template($zabbix_agent::init_script_template),
      before  => Class['zabbix_agent::service'],
    }
  }

}
