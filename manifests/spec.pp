# Class: zabbix_agent::spec
#
# This class is used only for rpsec-puppet tests
# Can be taken as an example on how to do custom classes but should not
# be modified.
#
# == Usage
#
# This class is not intended to be used directly.
# Use it as reference
#
class zabbix_agent::spec inherits zabbix_agent::config {

  # This just a test to override the arguments of an existing resource
  # Note that you can achieve this same result with just:
  # class { "zabbix_agent": template => "zabbix_agent/spec.erb" }

  File['zabbix_agent.conf'] {
    content => template('zabbix_agent/spec.erb'),
  }

}
