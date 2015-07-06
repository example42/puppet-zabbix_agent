# Class: zabbix_agent::config
#
# This class manages zabbix_agent configuration
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
class zabbix_agent::config {

  file { 'zabbix_agent.conf':
    ensure  => $zabbix_agent::manage_file,
    path    => $zabbix_agent::real_config_file,
    mode    => $zabbix_agent::config_file_mode,
    owner   => $zabbix_agent::config_file_owner,
    group   => $zabbix_agent::config_file_group,
    source  => $zabbix_agent::manage_file_source,
    content => $zabbix_agent::manage_file_content,
    replace => $zabbix_agent::manage_file_replace,
    notify  => $zabbix_agent::manage_service_autorestart,
    audit   => $zabbix_agent::manage_audit,
    noop    => $zabbix_agent::noops,
  }

  # The whole zabbix_agent configuration directory can be recursively overriden
  if $zabbix_agent::source_dir != '' {
    file { 'zabbix_agent.dir':
      ensure  => directory,
      path    => $zabbix_agent::real_config_dir,
      source  => $zabbix_agent::source_dir,
      recurse => true,
      purge   => $zabbix_agent::bool_source_dir_purge,
      force   => $zabbix_agent::bool_source_dir_purge,
      replace => $zabbix_agent::manage_file_replace,
      notify  => $zabbix_agent::manage_service_autorestart,
      audit   => $zabbix_agent::manage_audit,
      noop    => $zabbix_agent::noops,
    }
  }

}
