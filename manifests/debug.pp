# = Class: zabbix_agent::debug
#
# Debug class for zabbix_agent
#
class zabbix_agent::debug {

  file { 'debug_zabbix_agent':
    ensure  => $zabbix_agent::manage_file,
    path    => "${settings::vardir}/debug-zabbix_agent",
    mode    => '0640',
    owner   => 'root',
    group   => 'root',
    content => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/ }.to_yaml %>'),
  }

}
